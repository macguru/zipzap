//
//  RKDOCXRunAttributeWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 01.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRunAttributeWriter.h"

NSString *testString = @"Hello World";


@interface RKDOCXRunAttributeWriterTest : XCTestCase

@end

@implementation RKDOCXRunAttributeWriterTest

- (void)testRunElementWithoutAttributes
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: testString];
	NSXMLElement *generated = [RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:nil range:NSMakeRange(0, attributedString.length)];
	NSXMLElement *expected = [self.class expectedXMLWithoutRunAttributes];
	
	XCTAssertEqualObjects(generated, expected, @"Generated XML element does not match.");
}

- (void)testRunElementWithInvalidRange
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: testString];
	XCTAssertThrows([RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:nil range:NSMakeRange(attributedString.length, 1)], @"Invalid Range does not throw exception.");
}

- (void)testRunElementWithEmptyRange
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: testString];
	XCTAssertNil([RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:nil range:NSMakeRange(0, attributedString.length)]);
}

- (void)testRunElementWithBoldAttribute
{
	NSFont *boldFont = [NSFontManager.sharedFontManager fontWithFamily:@"Helvetica" traits:NSBoldFontMask weight:0 size:12];
	NSDictionary *attributes = @{NSFontAttributeName: boldFont};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:testString attributes:attributes];
	NSXMLElement *generated = [RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:attributes range:NSMakeRange(0, attributedString.length)];
	NSXMLElement *expected = [self.class expectedXMLWithBoldAttribute];
	
	XCTAssertEqualObjects(generated, expected, @"Generated XML element does not match.");
}

- (void)testRunElementWithItalicAttribute
{
	NSFont *italicFont = [NSFontManager.sharedFontManager fontWithFamily:@"Helvetica" traits:NSItalicFontMask weight:0 size:12];
	NSDictionary *attributes = @{NSFontAttributeName: italicFont};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:testString attributes:attributes];
	NSXMLElement *generated = [RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:attributes range:NSMakeRange(0, attributedString.length)];
	NSXMLElement *expected = [self.class expectedXMLWithItalicAttribute];
	
	XCTAssertEqualObjects(generated, expected, @"Generated XML element does not match.");
}

- (void)testRunElementWithFontSizeAttribute
{
	NSFont *font = [NSFontManager.sharedFontManager fontWithFamily:@"Helvetica" traits:0 weight:0 size:42];
	NSDictionary *attributes = @{NSFontAttributeName: font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:testString attributes:attributes];
	NSXMLElement *generated = [RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:attributes range:NSMakeRange(0, attributedString.length)];
	NSXMLElement *expected = [self.class expectedXMLWithFontSizeAttribute];
	
	XCTAssertEqualObjects(generated, expected, @"Generated XML element does not match.");
}

- (void)testRunElementWithFontNameAttribute
{
	NSFont *font = [NSFont fontWithName:@"Papyrus" size:12];
	NSDictionary *attributes = @{NSFontAttributeName: font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:testString attributes:attributes];
	NSXMLElement *generated = [RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:attributes range:NSMakeRange(0, attributedString.length)];
	NSXMLElement *expected = [self.class expectedXMLWithFontNameAttribute];
	
	XCTAssertEqualObjects(generated, expected, @"Generated XML element does not match.");
}

- (void)testRunElementWithBoldFontNameAttribute
{
	NSFont *font = [NSFontManager.sharedFontManager fontWithFamily:@"Arial" traits:NSBoldFontMask weight:0 size:12];
	NSDictionary *attributes = @{NSFontAttributeName: font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:testString attributes:attributes];
	NSXMLElement *generated = [RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:attributes range:NSMakeRange(0, attributedString.length)];
	NSXMLElement *expected = [self.class expectedXMLWithBoldFontNameAttribute];
	
	XCTAssertEqualObjects(generated, expected, @"Generated XML element does not match.");
}

+ (NSXMLElement *)expectedXMLWithoutRunAttributes
{
	NSXMLElement *runElement = [NSXMLElement elementWithName: @"w:r"];
	NSXMLElement *textElement = [NSXMLElement elementWithName: @"w:t"];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	[runElement addChild: textElement];
	
	return runElement;
}

+ (NSXMLElement *)expectedXMLWithBoldAttribute
{
	NSXMLElement *runElement = [NSXMLElement elementWithName: @"w:r"];
	NSXMLElement *runProperties = [NSXMLElement elementWithName:@"w:rPr" children:@[[NSXMLElement elementWithName:@"w:b"]] attributes:nil];
	NSXMLElement *textElement = [NSXMLElement elementWithName: @"w:t"];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	[runElement addChild: runProperties];
	[runElement addChild: textElement];
	
	return runElement;
}

+ (NSXMLElement *)expectedXMLWithItalicAttribute
{
	NSXMLElement *runElement = [NSXMLElement elementWithName: @"w:r"];
	NSXMLElement *runProperties = [NSXMLElement elementWithName:@"w:rPr" children:@[[NSXMLElement elementWithName:@"w:i"]] attributes:nil];
	NSXMLElement *textElement = [NSXMLElement elementWithName: @"w:t"];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	[runElement addChild: runProperties];
	[runElement addChild: textElement];
	
	return runElement;
}

+ (NSXMLElement *)expectedXMLWithFontSizeAttribute
{
	NSXMLElement *runElement = [NSXMLElement elementWithName: @"w:r"];
	NSXMLElement *runProperties = [NSXMLElement elementWithName:@"w:rPr" children:@[[NSXMLElement elementWithName:@"w:sz" children:nil attributes:@[[NSXMLElement attributeWithName:@"w:val" stringValue:@"84"]]]] attributes:nil];
	NSXMLElement *textElement = [NSXMLElement elementWithName: @"w:t"];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	[runElement addChild: runProperties];
	[runElement addChild: textElement];
	
	return runElement;
}

+ (NSXMLElement *)expectedXMLWithFontNameAttribute
{
	NSXMLElement *runElement = [NSXMLElement elementWithName: @"w:r"];
	NSXMLElement *runProperties = [NSXMLElement elementWithName:@"w:rPr" children:@[[NSXMLElement elementWithName:@"w:rFonts" children:nil attributes:@[[NSXMLElement attributeWithName:@"w:ascii" stringValue:@"Papyrus"], [NSXMLElement attributeWithName:@"w:cs" stringValue:@"Papyrus"], [NSXMLElement attributeWithName:@"w:eastAsia" stringValue:@"Papyrus"], [NSXMLElement attributeWithName:@"w:hAnsi" stringValue:@"Papyrus"]]]] attributes:nil];
	NSXMLElement *textElement = [NSXMLElement elementWithName: @"w:t"];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	[runElement addChild: runProperties];
	[runElement addChild: textElement];
	
	return runElement;
}

+ (NSXMLElement *)expectedXMLWithBoldFontNameAttribute
{
	NSXMLElement *runElement = [NSXMLElement elementWithName: @"w:r"];
	NSXMLElement *boldProperty = [NSXMLElement elementWithName:@"w:b"];
	NSXMLElement *fontProperty = [NSXMLElement elementWithName:@"w:rFonts" children:nil attributes:@[[NSXMLElement attributeWithName:@"w:ascii" stringValue:@"Arial"], [NSXMLElement attributeWithName:@"w:cs" stringValue:@"Arial"], [NSXMLElement attributeWithName:@"w:eastAsia" stringValue:@"Arial"], [NSXMLElement attributeWithName:@"w:hAnsi" stringValue:@"Arial"]]];
	NSXMLElement *runProperties = [NSXMLElement elementWithName:@"w:rPr" children:@[boldProperty, fontProperty] attributes:nil];
	NSXMLElement *textElement = [NSXMLElement elementWithName: @"w:t"];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	[runElement addChild: runProperties];
	[runElement addChild: textElement];
	
	return runElement;
}

@end
