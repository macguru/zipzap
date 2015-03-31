//
//  XCTestCase+DOCX.m
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import <zipzap/zipzap.h>

@implementation XCTestCase (RKDOCXTest)

- (void)assertGeneratedDOCXData:(NSData *)generated withExpectedData:(NSData *)expected filename:(NSString *)filename
{
	NSArray *generatedEntries = [[ZZArchive archiveWithData: generated] entries];
	NSArray *expectedEntries = [[ZZArchive archiveWithData: expected] entries];
	
	generatedEntries = [generatedEntries sortedArrayUsingComparator:^NSComparisonResult(ZZArchiveEntry *obj1, ZZArchiveEntry *obj2) {
		return [obj1.fileName compare: obj2.fileName];
	}];
	
	expectedEntries = [expectedEntries sortedArrayUsingComparator:^NSComparisonResult(ZZArchiveEntry *obj1, ZZArchiveEntry *obj2) {
		return [obj1.fileName compare: obj2.fileName];
	}];
	
	BOOL success = YES;
	
	for (NSUInteger index = 0; index < generatedEntries.count; index++) {
		success = [[generatedEntries[index] newDataWithError: NULL] isEqual: [expectedEntries[index] newDataWithError: NULL]];
		XCTAssertTrue(success, @"Unexpected DOCX conversion.");
		if (!success)
			break;
	}
	
	if (success)
		return;
	
	NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath: NSTemporaryDirectory()];
	temporaryDirectoryURL = [temporaryDirectoryURL URLByAppendingPathComponent: @"rtfkit-docx-test-verification"];
	
	[NSFileManager.defaultManager createDirectoryAtURL:temporaryDirectoryURL withIntermediateDirectories:YES attributes:nil error:NULL];
	
	[generated writeToURL:[[temporaryDirectoryURL URLByAppendingPathComponent: filename] URLByAppendingPathExtension: @"docx"] atomically:YES];
	[expected writeToURL:[[temporaryDirectoryURL URLByAppendingPathComponent: [filename stringByAppendingString: @"-expected"]] URLByAppendingPathExtension: @"docx"] atomically:YES];
	
	NSLog(@"\n\n-----------------\n\nTest failed. Output written to:\n%@\n\n", temporaryDirectoryURL.path);
	[[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[temporaryDirectoryURL]];
}

- (void)assertDOCX:(NSData *)docx withTestDocument:(NSString *)name
{
	NSURL *url = [[NSBundle bundleForClass: [self class]] URLForResource:name withExtension:@"docx" subdirectory:@"Test Data/docx"];
	
	XCTAssertNotNil(url, @"Cannot build URL");
	
	NSError *error;
	NSData *testContent = [NSData dataWithContentsOfURL:url options:0 error:&error];
	XCTAssertNotNil(testContent, @"Load failed with error: %@", error);
	
	NSLog(@"Testing with file %@", name);
	
	[self assertGeneratedDOCXData:docx withExpectedData:testContent filename:name];
}

@end
