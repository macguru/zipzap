//
//  RKDOCXParagraphWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphWriter.h"

#import "RKDOCXLinkWriter.h"
#import "RKDOCXListItemWriter.h"
#import "RKDOCXParagraphStyleWriter.h"
#import "RKDOCXPlaceholderWriter.h"
#import "RKDOCXReviewAnnotationWriter.h"
#import "RKDOCXRunWriter.h"
#import "RKDOCXStyleTemplateWriter.h"

NSString *RKDOCXParagraphElementName			= @"w:p";
NSString *RKDOCXParagraphPropertiesElementName	= @"w:pPr";

@implementation RKDOCXParagraphWriter

+ (NSXMLElement *)paragraphElementFromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)paragraphRange usingContext:(RKDOCXConversionContext *)context
{
	NSArray *runElements = [self runElementsFromAttributedString:attributedString inRange:paragraphRange usingContext:context];
	NSArray *propertyElements = [self propertyElementsForAttributes:[attributedString attributesAtIndex:paragraphRange.location effectiveRange:NULL] usingContext:context isDefaultStyle:NO];
	
	return [self paragraphElementWithProperties:propertyElements runElements:runElements];
}

+ (NSXMLElement *)paragraphElementWithProperties:(NSArray *)properties runElements:(NSArray *)runElements
{
	NSMutableArray *paragraphChildren = [NSMutableArray new];
	if (!properties && !runElements)
		return [NSXMLElement elementWithName: RKDOCXParagraphElementName];
	
	if (properties)
		[paragraphChildren addObject: [self paragraphPropertiesElementWithProperties: properties]];
	if (runElements)
		[paragraphChildren addObjectsFromArray: runElements];
	
	return [NSXMLElement elementWithName:RKDOCXParagraphElementName children:(paragraphChildren.count != 0) ? paragraphChildren : nil attributes:nil];
}

+ (NSXMLElement *)paragraphPropertiesElementWithProperties:(NSArray *)properties
{
	if (!properties.count)
		return nil;
	
	return [NSXMLElement elementWithName:RKDOCXParagraphPropertiesElementName children:properties attributes:nil];
}

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	NSMutableArray *properties = [NSMutableArray new];
	
	NSXMLElement *styleReferenceElement = [RKDOCXStyleTemplateWriter paragraphStyleReferenceElementForAttributes:attributes usingContext:context];
	if (styleReferenceElement)
		[properties addObject: styleReferenceElement];
	
	[properties addObjectsFromArray: [RKDOCXListItemWriter propertyElementsForAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle]];
	[properties addObjectsFromArray: [RKDOCXParagraphStyleWriter propertyElementsForAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle]];
	
	if (properties.count > 0)
		return properties;
	
	return nil;
}

+ (NSArray *)runElementsFromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)paragraphRange usingContext:(RKDOCXConversionContext *)context
{
	NSMutableArray *runElements = [NSMutableArray new];
	
	[attributedString enumerateAttribute:RKLinkAttributeName inRange:paragraphRange options:0 usingBlock:^(id linkAttribute, NSRange linkRange, BOOL *stop) {
		__block BOOL foundReviewRuns = NO;
		
		[attributedString enumerateAttribute:RKReviewAnnotationTypeAttributeName inRange:linkRange options:0 usingBlock:^(id reviewModeAttribute, NSRange reviewModeRange, BOOL *stopReviewMode) {
			if ([reviewModeAttribute unsignedIntegerValue]) {
				foundReviewRuns = YES;
				*stopReviewMode = YES;
			}
		}];
		
		// Handling of review runs
		if (foundReviewRuns) {
			[attributedString enumerateAttribute:RKReviewAnnotationTypeAttributeName inRange:linkRange options:0 usingBlock:^(id reviewModeAttribute, NSRange reviewModeRange, BOOL *stopReviewMode) {
				RKReviewAnnotationType reviewMode = RKReviewModeDisabled;
				
				if (reviewModeAttribute)
					reviewMode = [reviewModeAttribute unsignedIntegerValue];
				
				NSXMLElement *reviewElement;
				RKDOCXRunType runType = RKDOCXRunStandardType;
				
				switch (reviewMode) {
					case RKReviewModeDeletion:
						reviewElement = [RKDOCXReviewAnnotationWriter containerElementForDeletedRunsUsingContext: context];
						runType = RKDOCXRunDeletedType;
						break;
						
					case RKReviewModeInsertion:
						reviewElement = [RKDOCXReviewAnnotationWriter containerElementForInsertedRunsUsingContext: context];
						runType = RKDOCXRunInsertedType;
						break;
						
					case RKReviewModeDisabled:
						NSAssert(false, @"Disabled review mode has not been recognized as such.");
						break;
				}
				
				NSDictionary *fieldHyperlinkRuns = [RKDOCXLinkWriter fieldHyperlinkRunElementsForLinkAttribute:linkAttribute runType:runType usingContext:context];
				
				NSMutableArray *reviewChildren = [NSMutableArray new];
				
				// Prepare eventual link
				if (fieldHyperlinkRuns.count)
					[reviewChildren addObjectsFromArray: fieldHyperlinkRuns[RKDOCXFieldLinkFirstPartKey]];
				
				// Add main run content
				[attributedString enumerateAttributesInRange:reviewModeRange options:0 usingBlock:^(NSDictionary *attrs, NSRange runRange, BOOL *stopRun) {
					[reviewChildren addObjectsFromArray: [RKDOCXRunWriter runElementsForAttributedString:attributedString attributes:attrs range:runRange runType:runType usingContext:context]];
				}];
				
				// Close eventual link
				if (fieldHyperlinkRuns.count)
					[reviewChildren addObject: fieldHyperlinkRuns[RKDOCXFieldLinkLastPartKey]];
				
				reviewElement.children = reviewChildren;
				
				[runElements addObject: reviewElement];
			}];
		}
		
		// Handling of normal runs
		else {
			NSXMLElement *linkElement = [RKDOCXLinkWriter linkElementForAttribute:linkAttribute usingContext:context];
			NSMutableArray *linkChildren = [NSMutableArray new];
			
			// If there is a link attribute, add the runs as children to the parent link element.
			[attributedString enumerateAttributesInRange:linkRange options:0 usingBlock:^(NSDictionary *attrs, NSRange runRange, BOOL *stop) {
				NSArray *innerRunElements = [RKDOCXRunWriter runElementsForAttributedString:attributedString attributes:attrs range:runRange runType:RKDOCXRunStandardType usingContext:context];
				
				if (linkElement)
					[linkChildren addObjectsFromArray: innerRunElements];
				else
					[runElements addObjectsFromArray: innerRunElements];
			}];
			
			if (linkElement) {
				linkElement.children = linkChildren;
				[runElements addObject: linkElement];
			}
		}
	}];
	
	return runElements;
}

+ (NSXMLElement *)paragraphElementWithPageBreak
{
	return [NSXMLElement elementWithName:RKDOCXParagraphElementName children:@[[RKDOCXPlaceholderWriter runElementWithSymbolicCharacter: RKDOCXPageBreakCharacter]] attributes:nil];
}

+ (NSXMLElement *)paragraphPropertiesElementForMarkerLocation:(NSUInteger)markerLocation markerWidth:(NSUInteger)markerWidth
{
	return [self paragraphPropertiesElementWithProperties: @[[RKDOCXParagraphStyleWriter tabSettingsForMarkerLocation:markerLocation markerWidth:markerWidth],
															 [RKDOCXParagraphStyleWriter indentationSettingsForMarkerLocation:markerLocation markerWidth:markerWidth]]];
}

+ (NSXMLElement *)paragraphElementForSeparatorElement:(NSXMLElement *)separatorElement usingContext:(RKDOCXConversionContext *)context
{
	NSXMLElement *paragraphPropertiesElement = [self paragraphPropertiesElementWithProperties: [RKDOCXParagraphStyleWriter paragraphPropertiesForSeparatorElementUsingContext:context]];
	NSXMLElement *runElement = [RKDOCXRunWriter runElementForAttributes:nil contentElement:separatorElement usingContext:context];

	return [NSXMLElement elementWithName:RKDOCXParagraphElementName children:@[paragraphPropertiesElement, runElement] attributes:nil];
}

@end
