//
//  RKDOCXRunAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRunWriter.h"

#import "RKDOCXFontAttributesWriter.h"
#import "RKDOCXFootnotesWriter.h"
#import "RKDOCXPlaceholderWriter.h"
#import "RKDOCXTextEffectAttributesWriter.h"
#import "RKDOCXImageWriter.h"

// Element names
NSString *RKDOCXRunElementName				= @"w:r";
NSString *RKDOCXRunPropertiesElementName	= @"w:rPr";
NSString *RKDOCXRunTextElementName			= @"w:t";

@implementation RKDOCXRunWriter

+ (NSXMLElement *)runElementForAttributedString:(NSAttributedString *)attributedString attributes:(NSDictionary *)attributes range:(NSRange)range usingContext:(RKDOCXConversionContext *)context
{
	// Check for empty range
	if (!range.length)
		return nil;
	
	// Check for placeholder
	NSXMLElement *placeholderElement = [RKDOCXPlaceholderWriter	placeholder:attributes[RKPlaceholderAttributeName] withRunElementName:RKDOCXRunElementName textElementName:RKDOCXRunTextElementName];
	if (placeholderElement)
		return placeholderElement;
	
	// Check for footnote reference mark (located in the footnote’s content)
	if (attributes[RKDOCXFootnoteReferenceAttributeName])
		return [RKDOCXFootnotesWriter footnoteReferenceMarkWithRunElementName:RKDOCXRunElementName runPropertiesElementName:RKDOCXRunPropertiesElementName];
	
	// Collect all matching attributes
	NSArray *properties = [self propertyElementsForAttributes:attributes usingContext:context];
	
	NSXMLElement *runElement = [self runElementWithProperties: properties];
	
	// Check for image attribute
	NSXMLElement *imageRunElement = [RKDOCXImageWriter runElementWithImageAttachment:attributes[RKImageAttachmentAttributeName] inRunElement:runElement usingContext:context];
	if (imageRunElement)
		return imageRunElement;
	
	// Check for footnote reference
	NSXMLElement *footnoteReferenceRunElement = [RKDOCXFootnotesWriter footnoteReferenceElementForFootnoteString:attributes[RKFootnoteAttributeName] inRunElement:runElement usingContext:context];
	if (footnoteReferenceRunElement)
		return footnoteReferenceRunElement;
	
	NSXMLElement *textElement = [NSXMLElement elementWithName:RKDOCXRunTextElementName stringValue:[attributedString.string substringWithRange:range]];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	[runElement addChild: textElement];
	
	return runElement;
}

+ (NSXMLElement *)runElementWithProperties:(NSArray *)properties
{
	NSXMLElement *runElement = [NSXMLElement elementWithName: RKDOCXRunElementName];
	
	if (properties.count) {
		NSXMLElement *runPropertiesElement = [NSXMLElement elementWithName:RKDOCXRunPropertiesElementName children:properties attributes:nil];
		[runElement addChild: runPropertiesElement];
	}
	
	return runElement;
}

+ (NSMutableArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSMutableArray *properties = [NSMutableArray new];
	
	NSArray *propertyElements = [RKDOCXFontAttributesWriter propertyElementsForAttributes:attributes usingContext:context];
	if (propertyElements)
		[properties addObjectsFromArray: propertyElements];
	
	propertyElements = [RKDOCXTextEffectAttributesWriter propertyElementsForAttributes:attributes usingContext:context];
	if (propertyElements)
		[properties addObjectsFromArray: propertyElements];
	
	return properties;
}

@end
