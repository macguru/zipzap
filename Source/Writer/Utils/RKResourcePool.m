//
//  RKResourcePool.m
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKResourcePool.h"
#import "RKSection.h"
#import "RKConversion.h"

@class RKDocument, RKSection;

@interface RKResourcePool()
{
    NSMutableArray *fonts;
    NSMutableArray *colors;
    NSDictionary *attachmentFileWrappers;

    NSMutableArray *textLists;
    NSMapTable *listItemIndices;
}

@end

@implementation RKResourcePool

@synthesize attachmentFileWrappers, document;

- (id)init
{
    self = [super init];
    
    if (self) {
        fonts = [NSMutableArray new];
        colors = [NSMutableArray new];
        attachmentFileWrappers = [NSMutableDictionary new];
        textLists = [NSMutableArray new];
        listItemIndices = [NSMapTable mapTableWithKeyOptions:NSMapTableObjectPointerPersonality valueOptions:0];
        
        // Adding the two default colors (black is required; white is useful for \cb1
        [self indexOfColor: [NSColor rtfColorWithRed:0 green:0.0 blue:0.0]];
        [self indexOfColor: [NSColor rtfColorWithRed:1.0 green:1.0 blue:1.0]];
    }
        
    return self;
}

- (id)initWithDocument:(RKDocument *)initialDocument
{
    self = [self init];
    
    if (self) {
        document = initialDocument;
    }
    
    return self;
}

#pragma mark - Fonts

- (NSUInteger)indexOfFont:(NSFont *)font
{
    NSAssert(font, @"No font given");
    
    NSString *familyName = [[[NSFontManager sharedFontManager] convertFont:font toNotHaveTrait:NSBoldFontMask|NSItalicFontMask] fontName];
    NSUInteger index = [fonts indexOfObject: familyName];
    
    if (index == NSNotFound) {
        [fonts addObject: familyName];
        index = [fonts count] - 1;
    }
    
    return index;
}

- (NSArray *)fontFamilyNames
{
    return fonts;
}

#pragma mark - Colors

- (NSUInteger)indexOfColor:(NSColor *)color
{
    NSAssert(color, @"No color given");
    
    // Ensure that no alpha is used and that the color is converted to the RGB color space
    NSColor *opaqueColor = [[color colorUsingColorSpaceName: NSCalibratedRGBColorSpace] colorWithAlphaComponent: 1.0];
    NSUInteger index = [colors indexOfObject: opaqueColor];
    
    if (index == NSNotFound) {
        [colors addObject: opaqueColor];
        index = colors.count - 1;
    }
    
    return index;
}

- (NSArray *)colors
{
    return colors;
}

#pragma mark - Style

- (NSUInteger) indexOfParagraphStyle:(NSString *)paragraphStyleName
{
    NSAssert(paragraphStyleName, @"No style name given");
    
    // We only support style names that have been previously registered to the document
    if ([document.paragraphStyles objectForKey: paragraphStyleName] == nil)
        return 0;
    
    return [[document.paragraphStyles allKeys] indexOfObject: paragraphStyleName] + 1;
}

- (NSUInteger) indexOfCharacterStyle:(NSString *)characterStyleName
{
    NSAssert(characterStyleName, @"No style name given");
    
    // We only support style names that have been previously registered to the document
    if ([document.characterStyles objectForKey: characterStyleName] == nil)
        return 0;
    
    return [[document.characterStyles allKeys] indexOfObject: characterStyleName] + document.paragraphStyles.count + 1;
}

#pragma mark - File Wrapper

- (NSString *)registerFileWrapper:(NSFileWrapper *)fileWrapper
{
    NSAssert(fileWrapper, @"No file given");
    
    NSString *originalFilename = (fileWrapper.preferredFilename) ?: (fileWrapper.filename) ?: @"";
    NSString *filename = [NSString stringWithFormat: @"%u.%@", attachmentFileWrappers.count, [originalFilename sanitizedFilenameForRTFD]];
    
    fileWrapper.preferredFilename = filename;

    [attachmentFileWrappers setValue:fileWrapper forKey:filename];
    
    return filename;
}

#pragma mark - Text Lists

- (NSUInteger)indexOfListStyle:(RKListStyle *)textList
{
    NSUInteger listIndex = [textLists indexOfObject: textList];
    
    if (listIndex == NSNotFound) {
        [textLists addObject:textList];
        return textLists.count - 1;
    }
    
    return listIndex;
}

- (NSArray *)textLists
{
    return textLists;
}

- (NSArray *)incrementItemNumbersForListLevel:(NSUInteger)level ofList:(RKListStyle *)textList;
{
    if ([listItemIndices objectForKey:textList] == nil) {
        [listItemIndices setObject:[NSMutableArray new] forKey:textList];
    }

    NSMutableArray *itemNumbers = [listItemIndices objectForKey:textList];
    
    // Truncate nested item numbers, if a higher item number is increased
    if (level + 1 < itemNumbers.count) {
        [itemNumbers removeObjectsInRange:NSMakeRange(level + 1, itemNumbers.count - level - 1)];
    }
    
    if (level >= itemNumbers.count) {
        // Fill with 1 if requested, nested list is deeper nested than the current list length
        for (NSUInteger position = itemNumbers.count; position < level + 1; position ++) {
            [itemNumbers addObject: [NSNumber numberWithUnsignedInteger: [textList startNumberForLevel: position]]];
        }
    }
    else {
        // Increment requested counter
        NSUInteger currentItemNumber = [[itemNumbers objectAtIndex: level] unsignedIntegerValue] + 1;
        [itemNumbers replaceObjectAtIndex:level withObject:[NSNumber numberWithUnsignedInteger:currentItemNumber]];
    }

    return [itemNumbers copy];
}

@end
