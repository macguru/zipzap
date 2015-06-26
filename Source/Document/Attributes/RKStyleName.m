//
//  RKStyleName.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKStyleName.h"

NSString *RKCharacterStyleNameAttributeName = @"RKCharacterStyleName";
NSString *RKParagraphStyleNameAttributeName = @"RKParagraphStyleName";

NSString *RKDefaultStyleName				= @"RKDefaultStyleName";

@implementation NSMutableAttributedString (RKAttributedStringPredefinedStyleConvenience)

- (void)addPredefinedCharacterStyleAttribute:(NSString *)styleSheetName range:(NSRange)range
{
    [self addAttribute:RKCharacterStyleNameAttributeName value:styleSheetName range:range];
}

- (void)addPredefinedParagraphStyleAttribute:(NSString *)styleSheetName range:(NSRange)range
{
    [self addAttribute:RKParagraphStyleNameAttributeName value:styleSheetName range:range];    
}

- (void)applyPredefinedCharacterStyleAttribute:(NSString *)styleSheetName document:(RKDocument *)document range:(NSRange)range
{
    [self addPredefinedCharacterStyleAttribute:styleSheetName range:range];
    [self addAttributes:(document.characterStyles)[styleSheetName] range:range];
}

- (void)applyPredefinedParagraphStyleAttribute:(NSString *)styleSheetName document:(RKDocument *)document range:(NSRange)range
{
    [self addPredefinedParagraphStyleAttribute:styleSheetName range:range];
    [self addAttributes:(document.paragraphStyles)[styleSheetName] range:range];
}

@end
