//
//  RKParagraphStyleWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributeWriter.h"

/*!
 @abstract Writes out all tags required for a paragraph style
 */
@interface RKParagraphStyleWriter : NSObject

+ (void)addTagsForAttributedString:(NSAttributedString *)attributedString
                    toTaggedString:(RKTaggedString *)taggedString 
              withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                         resources:(RKResourcePool *)resources;

@end
