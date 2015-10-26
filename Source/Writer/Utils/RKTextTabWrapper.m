//
//  RKTextTabWrapper.m
//  RTFKit
//
//  Created by Friedrich Gräter on 21.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextTabWrapper.h"

@implementation RKTextTabWrapper

@synthesize tabAlignment=_tabAlignment, location=_location;

- (id)initWithCTTextTab:(CTTextTabRef)textTab
{
   return [self initWithLocation:CTTextTabGetLocation(textTab) alignment:CTTextTabGetAlignment(textTab)];
}

- (CTTextTabRef)newCTTextTab
{
    return CTTextTabCreate(_tabAlignment, _location, NULL);
}

- (id)initWithNSTextTab:(NSTextTab *)textTab
{
    return [self initWithLocation:textTab.location alignment:RKTextAlignmentToCTTextAlignment(textTab.alignment)];
}

- (NSTextTab *)newNSTextTab
{
	return [[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentFromCTTextAlignment(_tabAlignment) location:_location options:@{}];
}

- (id)initWithLocation:(CGFloat)location alignment:(CTTextAlignment)alignment
{
	self = [self init];
	
	if (self) {
		_location = location;
		_tabAlignment = alignment;
	}
	
	return self;
}

@end
