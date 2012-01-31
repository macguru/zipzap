//
//  RKTaggedString.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTaggedString.h"
#import "RKConversion.h"

@interface RKTaggedString ()
{
    NSMutableDictionary *tagPositions;
    NSString *originalString;
}

/*!
 @abstract Appends an excerpt of the original string to a string
 @discussion All characters are escaped for RTF output
 */
- (void)appendOriginalStringRange:(NSRange)range toString:(NSMutableString *)flattenedString;

@end

@implementation RKTaggedString

+ (RKTaggedString *)taggedStringWithString:(NSString *)string
{
    return [[RKTaggedString alloc] initTaggedStringWithString: string];
}

- (id)init
{
    self = [super init];

    if (self) {
        tagPositions = [NSMutableDictionary new];
    }
    
    return self;
}

- (id)initTaggedStringWithString:(NSString *)string
{
    self = [self init];
    
    if (self) {
        originalString = string;
    }
    
    return self;
}

- (NSString *)untaggedString
{
    return originalString;
}

- (void)associateTag:(NSString *)tag atPosition:(NSUInteger)position
{
    if (position > [originalString length]) {
        [NSException raise:NSRangeException format:@"Position %u beyond string bounds of %u.", position, [originalString length]];
    }
    
    NSNumber *mapIndex = [NSNumber numberWithUnsignedInteger:position];
    NSMutableArray *tags = [tagPositions objectForKey:mapIndex];
    
    if (!tags) {
        tags = [NSMutableArray new];
        [tagPositions setObject:tags forKey:mapIndex];
    }
    
    [tags addObject: tag];
}

- (void)appendOriginalStringRange:(NSRange)range toString:(NSMutableString *)flattenedString
{
    NSString *safeOriginalString = [[originalString substringWithRange:range] RTFEscapedString];
    
    [flattenedString appendString:safeOriginalString];
}

- (NSString *)flattenedRTFString
{
    __block NSMutableString *flattened = [NSMutableString new];
    __block NSUInteger lastSourceOffset = 0;
    
    // Iterate over all tag positions
    [[[tagPositions allKeys] sortedArrayUsingSelector:@selector(compare:)] enumerateObjectsUsingBlock:^(NSNumber *mapIndex, NSUInteger idx, BOOL *stop) {
        NSUInteger currentSourceOffset = [mapIndex unsignedIntegerValue];

        // Copy all untagged chars
        [self appendOriginalStringRange:NSMakeRange(lastSourceOffset, currentSourceOffset - lastSourceOffset) toString:flattened];
     
        lastSourceOffset = currentSourceOffset;
        
        // Insert tags
        NSArray *tags = [tagPositions objectForKey:mapIndex];
        
        [tags enumerateObjectsUsingBlock:^(NSString *tag, NSUInteger tagIndex, BOOL *stop) {
            [flattened appendString: tag];
        }];
    }];
    
    // Append remaining string
    if (lastSourceOffset < [originalString length]) {
        [self appendOriginalStringRange:NSMakeRange(lastSourceOffset, [originalString length] - lastSourceOffset) toString:flattened];
    }
        
    return flattened;
}

@end
