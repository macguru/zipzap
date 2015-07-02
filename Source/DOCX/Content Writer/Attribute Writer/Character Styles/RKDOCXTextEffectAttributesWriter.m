//
//  RKDOCXTextEffectAttributesWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 07.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXTextEffectAttributesWriter.h"

#import "RKColor.h"

NSString *RKDOCXTextEffectsBaselineAttributeValue			= @"baseline";
NSString *RKDOCXTextEffectsCharacterSpacingElementName		= @"w:spacing";
NSString *RKDOCXTextEffectsColorAutoAttributeValue			= @"auto";
NSString *RKDOCXTextEffectsColorElementName					= @"w:color";
NSString *RKDOCXTextEffectsDoubleStrikethroughElementName	= @"w:dstrike";
NSString *RKDOCXTextEffectsLigatureAttributeName			= @"w14:val";
NSString *RKDOCXTextEffectsLigatureElementName				= @"w14:ligatures";
NSString *RKDOCXTextEffectsLigatureAllAttributeValue		= @"all";
NSString *RKDOCXTextEffectsLigatureDefaultAttributeValue	= @"historicalDiscretional"; // alternatively: standardContextual
NSString *RKDOCXTextEffectsLigatureNoneAttributeValue		= @"none";
NSString *RKDOCXTextEffectsNoUnderlineAttributeValue		= @"none";
NSString *RKDOCXTextEffectsOutlineElementName				= @"w:outline";
NSString *RKDOCXTextEffectsShadowElementName				= @"w:shadow";
NSString *RKDOCXTextEffectsSingleStrikethroughElementName	= @"w:strike";
NSString *RKDOCXTextEffectsSingleUnderlineAttributeValue	= @"single";
NSString *RKDOCXTextEffectsSubscriptAttributeValue			= @"subscript";
NSString *RKDOCXTextEffectsSuperscriptAttributeValue		= @"superscript";
NSString *RKDOCXTextEffectsSuperscriptElementName			= @"w:vertAlign";
NSString *RKDOCXTextEffectsUnderlineColorElementName		= @"w:color";
NSString *RKDOCXTextEffectsUnderlineElementName				= @"w:u";

@implementation RKDOCXTextEffectAttributesWriter

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSMutableArray *properties = [NSMutableArray new];
	
	// Font color (§17.3.2.6)
	NSXMLElement *foregroundColorProperty = [self foregroundColorPropertyForAttributes:attributes usingContext:context];
	if (foregroundColorProperty)
		[properties addObject: foregroundColorProperty];
	
	// Outline (§17.3.2.23)
	NSXMLElement *strokeWidthProperty = [self strokeWidthPropertyForAttributes:attributes usingContext:context];
	if (strokeWidthProperty)
		[properties addObject: strokeWidthProperty];
	
	// Shadow (§17.3.2.31)
	NSXMLElement *shadowProperty = [self shadowPropertyForAttributes:attributes usingContext:context];
	if (shadowProperty)
		[properties addObject: shadowProperty];
	
	// Character Spacing (§17.3.2.35)
	NSXMLElement *spacingProperty = [self spacingPropertyForAttributes:attributes usingContext:context];
	if (spacingProperty)
		[properties addObject: spacingProperty];
	
	// Strikethrough (§17.3.2.9/§17.3.2.37)
	NSXMLElement *strikethroughProperty = [self strikethroughPropertyForAttributes:attributes usingContext:context];
	if (strikethroughProperty)
		[properties addObject: strikethroughProperty];
	
	// Underline (§17.3.2.40)
	NSXMLElement *underlineProperty = [self underlinePropertyForAttributes:attributes usingContext:context];
	if (underlineProperty)
		[properties addObject: underlineProperty];
	
	// Subscript/Superscript (§17.3.2.42)
	NSXMLElement *superscriptProperty = [self superscriptPropertyForAttributes:attributes usingContext:context];
	if (superscriptProperty)
		[properties addObject: superscriptProperty];
	
	// Ligatures (no mention in official standard)
	NSXMLElement *ligatureProperty = [self ligaturePropertyForAttributes:attributes usingContext:context];
	if (ligatureProperty)
		[properties addObject: ligatureProperty];
	
	return properties;
}

+ (NSXMLElement *)foregroundColorPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	RKColor *fontColorAttribute = attributes[RKForegroundColorAttributeName];
	
	if (![self shouldTranslateAttributeWithName:RKForegroundColorAttributeName fromAttributes:attributes usingContext:context])
		return nil;
	
	NSXMLElement *foregroundColorProperty = [NSXMLElement elementWithName:RKDOCXTextEffectsColorElementName];
	
	if (!fontColorAttribute)
		[foregroundColorProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsColorAutoAttributeValue]];
	else
		[foregroundColorProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:fontColorAttribute.hexRepresentation]];
	
	return foregroundColorProperty;
}

+ (NSXMLElement *)strokeWidthPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	if (![self shouldTranslateAttributeWithName:RKStrokeWidthAttributeName fromAttributes:attributes usingContext:context])
		return nil;
	
	NSXMLElement *strokeWidthProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsOutlineElementName];
	
	if (!attributes[RKStrokeWidthAttributeName] || ([attributes[RKStrokeWidthAttributeName] integerValue] <= 0))
		[strokeWidthProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
	
	return strokeWidthProperty;
}

+ (NSXMLElement *)shadowPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	if (![self shouldTranslateAttributeWithName:RKShadowAttributeName fromAttributes:attributes usingContext:context])
		return nil;
	
	NSXMLElement *shadowProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsShadowElementName];
	
	if (!attributes[RKShadowAttributeName])
		[shadowProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
	
	return shadowProperty;
}

+ (NSXMLElement *)spacingPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	if (![self shouldTranslateAttributeWithName:RKKernAttributeName fromAttributes:attributes usingContext:context])
		return nil;
	
	NSXMLElement *spacingProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsCharacterSpacingElementName];
	
	NSString *spacingValue;
	
	if (!attributes[RKKernAttributeName])
		spacingValue = RKDOCXAttributeWriterOffAttributeValue;
	else
		spacingValue = @(RKPointsToTwips([attributes[RKKernAttributeName] integerValue])).stringValue;
	
	[spacingProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:spacingValue]];
	
	return spacingProperty;
}

+ (NSXMLElement *)strikethroughPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSNumber *strikethroughAttribute = attributes[RKStrikethroughStyleAttributeName];
	
	if (![self shouldTranslateAttributeWithName:RKStrikethroughStyleAttributeName fromAttributes:attributes usingContext:context])
		return nil;
	
	NSXMLElement *strikethroughProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsSingleStrikethroughElementName];
	
	if (!strikethroughAttribute || strikethroughAttribute.unsignedIntegerValue == RKUnderlineStyleNone)
		[strikethroughProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
	
	return strikethroughProperty;
}

+ (NSXMLElement *)underlinePropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSNumber *underlineAttribute = attributes[RKUnderlineStyleAttributeName];
	
	if (![self shouldTranslateAttributeWithName:RKUnderlineStyleAttributeName fromAttributes:attributes usingContext:context])
		return nil;
	
	NSXMLElement *underlineProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsUnderlineElementName];
	
	if (!underlineAttribute || underlineAttribute.unsignedIntegerValue == RKUnderlineStyleNone) {
		[underlineProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsNoUnderlineAttributeValue]];
		return underlineProperty;
	}

	[underlineProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsSingleUnderlineAttributeValue]];
	
	RKColor *underlineColorAttribute = attributes[RKUnderlineColorAttributeName];
	if (underlineColorAttribute) {
		[underlineProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXTextEffectsUnderlineColorElementName stringValue:[attributes[RKUnderlineColorAttributeName] hexRepresentation]]];
	}
	
	return underlineProperty;
}

+ (NSXMLElement *)superscriptPropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSInteger superscriptAttribute = [attributes[RKSuperscriptAttributeName] unsignedIntegerValue];
	
	// String and style attribute are the same
	if (![self shouldTranslateAttributeWithName:RKSuperscriptAttributeName fromAttributes:attributes usingContext:context])
		return nil;
	
	NSXMLElement *superscriptProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsSuperscriptElementName];
	
	// Superscript is set to baseline
	if (superscriptAttribute == 0) {
		[superscriptProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXTextEffectsBaselineAttributeValue]];
		return superscriptProperty;
	}
	
	// Subscript or superscript
	[superscriptProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:(superscriptAttribute < 0) ? RKDOCXTextEffectsSubscriptAttributeValue : RKDOCXTextEffectsSuperscriptAttributeValue]];
	
	return superscriptProperty;
}

+ (NSXMLElement *)ligaturePropertyForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSDictionary *characterStyle = [context cachedStyleFromParagraphStyle:attributes[RKParagraphStyleNameAttributeName] characterStyle:attributes[RKCharacterStyleNameAttributeName]];
	id attributeValue = attributes[RKLigatureAttributeName] ?: @1;
	id styleValue = characterStyle[RKLigatureAttributeName] ?: @1;
	
	if ((attributeValue == styleValue) && context)
		return nil;
	
	NSXMLElement *ligatureProperty = [NSXMLElement elementWithName: RKDOCXTextEffectsLigatureElementName];
	
	NSUInteger ligatureValue = [attributeValue unsignedIntegerValue];
	
	if (attributeValue && ligatureValue == 0)
		[ligatureProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXTextEffectsLigatureAttributeName stringValue:RKDOCXTextEffectsLigatureNoneAttributeValue]];
	else if (ligatureValue == 2)
		[ligatureProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXTextEffectsLigatureAttributeName stringValue:RKDOCXTextEffectsLigatureAllAttributeValue]];
	else
		[ligatureProperty addAttribute: [NSXMLElement attributeWithName:RKDOCXTextEffectsLigatureAttributeName stringValue:RKDOCXTextEffectsLigatureDefaultAttributeValue]];
	
	return ligatureProperty;
}

+ (BOOL)shouldTranslateAttributeWithName:(NSString *)attributeName fromAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSDictionary *characterStyle = [context cachedStyleFromParagraphStyle:attributes[RKParagraphStyleNameAttributeName] characterStyle:attributes[RKCharacterStyleNameAttributeName]];
	id attributeValue = attributes[attributeName];
	id styleValue = characterStyle[attributeName];
	
	// No translation is performed if string attributes and style attributes are the same. (I.e. have the same value or are both set to nil.)
	return !((attributeValue == styleValue) || [attributeValue isEqual: styleValue]);
}

@end
