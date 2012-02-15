//
//  RKTextList.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListItem.h"

NSString *RKTextListItemAttributeName = @"RKTextListItem";

@implementation RKListItem

@synthesize textList, indentationLevel;

- (id)initWithTextList:(RKListStyle *)initialTextList withIndentationLevel:(NSUInteger)initialIndentationLevel
{
    self = [self init];
    
    if (self) {
        textList = initialTextList;
        indentationLevel = initialIndentationLevel;
    }

    return self;
}

+ (RKListItem *)textListItemWithTextList:(RKListStyle *)textList withIndentationLevel:(NSUInteger)indentationLevel
{
    return [[RKListItem alloc] initWithTextList:textList withIndentationLevel:indentationLevel];
}

@end

@implementation NSAttributedString (RKAttributedStringListItemConvenience)

+ (NSAttributedString *)attributedStringWithListItem:(NSAttributedString *)text usingList:(RKListStyle *)textList withIndentationLevel:(NSUInteger)indentationLevel
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString: text];
    RKListItem *listItem = [RKListItem textListItemWithTextList:textList withIndentationLevel:indentationLevel];
    
    // A trailing \n is required since a list item must be a paragraph
    if (![attributedString.string hasSuffix:@"\n"])
        [attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n"]];
    
    [attributedString addAttribute:RKTextListItemAttributeName value:listItem range:NSMakeRange(0, attributedString.length)];
        
    return attributedString;
}

@end

@implementation NSMutableAttributedString (RKMutableAttributedStringAdditions)

- (void)insertListItem:(NSAttributedString *)text usingList:(RKListStyle*)textList withIndentationLevel:(NSUInteger)indentationLevel atIndex:(NSUInteger)location; 
{
    NSAttributedString *listItemString = [NSAttributedString attributedStringWithListItem:text usingList:textList withIndentationLevel:indentationLevel];
    
    [self insertAttributedString:listItemString atIndex:location];
}

- (void)appendListItem:(NSAttributedString *)text usingList:(RKListStyle*)textList withIndentationLevel:(NSUInteger)indentationLevel
{
    [self insertListItem:text usingList:textList withIndentationLevel:indentationLevel atIndex:self.length];
}

@end
