//
//  RKUnderlineColorAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKUnderlineColorAttributeWriter.h"

@implementation RKUnderlineColorAttributeWriter

+ (void)addTagsForAttribute:(NSColor *)color
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    if (color == nil)
        return;
    
    NSUInteger colorIndex = [resources indexOfColor:color];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\ulc%U ", colorIndex] forPosition:range.location];
    [taggedString registerTag:[NSString stringWithFormat:@"\\ulc0 ", colorIndex] forPosition:(range.location + range.length)];
}

@end
