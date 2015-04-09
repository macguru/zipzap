//
//  RKDOCXAttributedStringWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributedStringWriter.h"

#import "RKDOCXRunAttributeWriter.h"
#import "RKDOCXParagraphAttributeWriter.h"

NSString *RKDOCXAttributeWriterParagraphElementName = @"w:p";

@implementation RKDOCXAttributedStringWriter

+ (NSArray *)processAttributedString:(NSAttributedString *)attributedString
{
	NSMutableArray *paragraphs = [NSMutableArray new];
	
	[attributedString.string enumerateSubstringsInRange:NSMakeRange(0, attributedString.length) options:NSStringEnumerationByParagraphs usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		[paragraphs addObject: [self paragraphElementWithProperties:[RKDOCXParagraphAttributeWriter paragraphPropertiesElementWithPropertiesFromAttributedString:attributedString inRange:substringRange] runElements:[self runElementsFromAttributedString:attributedString inRange:substringRange]]];
	}];
	
	return paragraphs;
}

/*!
 @abstract Returns an XML element representing a paragraph including properties and runs.
 @discussion See ISO 29500-1:2012: §17.3.1 (Paragraphs).
 */
+ (NSXMLElement *)paragraphElementWithProperties:(NSXMLElement *)propertiesElement runElements:(NSArray *)runElements
{
	NSParameterAssert(runElements.count);
	
	NSXMLElement *paragraph = [NSXMLElement elementWithName: RKDOCXAttributeWriterParagraphElementName];
	
	if (propertiesElement)
		[paragraph addChild: propertiesElement];
	
	for (NSXMLElement *runElement in runElements) {
		[paragraph addChild: runElement];
	}
	
	return paragraph;
}

+ (NSArray *)runElementsFromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)paragraphRange
{
	NSMutableArray *runElements = [NSMutableArray new];
	
	[attributedString enumerateAttributesInRange:paragraphRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		NSXMLElement *runElement = [RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:attrs range:range];
		[runElements addObject: runElement];
	}];
	
	return runElements;
}

@end
