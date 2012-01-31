//
//  RKAttributedStringWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTaggedString.h"
#import "RKAttributedStringWriter.h"

#import "RKParagraphStyleWriter.h"

@interface RKAttributedStringWriter ()

@end

@implementation RKAttributedStringWriter

NSMutableDictionary *attributeHandlers;

+ (void)registerHandler:(Class)attributeWriter forAttribute:(NSString*)attributeName
{
    if (attributeHandlers == nil)
        attributeHandlers = [NSMutableDictionary new];
    
    [attributeHandlers setValue:attributeWriter forKey:attributeName];
        
    //NSAssert([attributeWriter isSubclassOfClass: [RKAttributeWriter class]], @"Invalid attribute writer registered");
}

+ (NSString *)RTFfromAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[attributedString string]];
    
    [attributeHandlers enumerateKeysAndObjectsUsingBlock:^(NSString *attributeName, id handler, BOOL *stop) {
        [attributedString enumerateAttribute:attributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(Class value, NSRange range, BOOL *stop) {
            [handler addTagsForAttribute:value toTaggedString:taggedString inRange:range withAttachmentPolicy:attachmentPolicy resources:resources];
        }];
    }];
    
    return [taggedString flattenedRTFString];
}

@end
