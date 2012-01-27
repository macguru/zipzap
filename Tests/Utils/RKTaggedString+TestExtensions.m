//
//  RKTaggedString+TestExtensions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#include "RKTaggedString.h"
#include "RKTaggedString+TestExtensions.h"
#import <objc/runtime.h>

@implementation RKTaggedString (TestExtensions)

- (NSDictionary *)_getTagPlacement
{
    return object_getIvar(self, class_getInstanceVariable([self class], "tagPlacement"));
}

@end
