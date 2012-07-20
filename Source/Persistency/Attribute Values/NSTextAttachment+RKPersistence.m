//
//  NSTextAttachment+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSTextAttachment+RKPersistence.h"
#import "RKPersistenceContext.h"
#import "RKPersistenceContext+PrivateStorageAccessors.h"

NSString *NSTextAttachmentFileIndexPersistenceKey = @"fileIdentifier";

@implementation NSTextAttachment (RKPersistence)

+ (id<RKPersistence>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);

    NSTextAttachment *textAttachment = [NSTextAttachment new];
    NSNumber *fileIndexObject = [propertyList objectForKey: NSTextAttachmentFileIndexPersistenceKey];
    
    if (fileIndexObject)
        textAttachment.fileWrapper = [context fileWrapperForIndex: [fileIndexObject unsignedIntegerValue]];
    
    return textAttachment;
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistenceContext *)context
{
    if (self.fileWrapper)
        return [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInteger: [context indexForFileWrapper: self.fileWrapper]] forKey:NSTextAttachmentFileIndexPersistenceKey];
    else
        return [NSDictionary new];
}

@end
