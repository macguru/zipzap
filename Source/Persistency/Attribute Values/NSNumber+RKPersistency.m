//
//  NSNumber+RKPersistency.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSNumber+RKPersistency.h"

@implementation NSNumber (RKPersistency)

+ (id<RKPersistency>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistencyContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSNumber.class]);
    
    return propertyList;
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistencyContext *)context
{
    return self;
}

@end
