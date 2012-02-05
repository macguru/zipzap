//
//  RKForegroundColorAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKForegroundColorAttributeWriter.h"
#import "RKForegroundColorAttributeWriterTest.h"

@implementation RKForegroundColorAttributeWriterTest

- (void)testForegroundColorStyle
{
    NSColor *color = [NSColor rtfColorWithRed:1.0 green:0 blue:0];
    RKTaggedString *string = [RKTaggedString taggedStringWithString:@"abcd"];
    RKResourcePool *resources = [RKResourcePool new];
    
    // Tagging defined color
    [RKForegroundColorAttributeWriter addTagsForAttribute:color toTaggedString:string inRange:NSMakeRange(1,2) withAttachmentPolicy:0 resources:resources];
    
    // Tagging default color
    [RKForegroundColorAttributeWriter addTagsForAttribute:nil toTaggedString:string inRange:NSMakeRange(3,1) withAttachmentPolicy:0 resources:resources];
    
    STAssertEqualObjects([string flattenedRTFString],
                         @"a"
                         // Defined color
                         "\\cf2 "
                         "bc"
                         // Default color
                         "\\cf0 "
                         "d",
                         @"Invalid font style"
                         );
    
    // Test resource manager
    NSArray *colors = [resources colors];
    STAssertEquals([colors count], (NSUInteger)3, @"Invalid colors count");
    STAssertEqualObjects([colors objectAtIndex:2], [NSColor rtfColorWithRed:1.0 green:0 blue:0], @"Invalid color");
}

- (void)testForegroundColorStyleCocoaIntegration
{
    NSColor *colorA = [NSColor rtfColorWithRed:1.0 green:0.0 blue:0.0];
    NSColor *colorB = [NSColor rtfColorWithRed:0.0 green:1.0 blue:0.0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"abc"];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:colorA range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:colorB range:NSMakeRange(1, 2)];
    
    [self assertReadingOfAttributedString:attributedString onAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0,3)];
}

@end
