//
//  RKAdditionalParagraphStyle.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAdditionalParagraphStyle.h"

NSString *RKAdditionalParagraphStyleAttributeName = @"RKAdditionalParagraphStyle";

@implementation RKAdditionalParagraphStyle

- (BOOL)isEqual:(RKAdditionalParagraphStyle *)object
{
	return [object isKindOfClass: RKAdditionalParagraphStyle.class] && (self.keepWithFollowingParagraph == object.keepWithFollowingParagraph) && (self.hyphenationEnabled == object.hyphenationEnabled);
}

- (id)copyWithZone:(NSZone *)zone
{
	RKAdditionalParagraphStyle *newStyle = [RKAdditionalParagraphStyle new];
	newStyle.keepWithFollowingParagraph = self.keepWithFollowingParagraph;
	newStyle.hyphenationEnabled = self.hyphenationEnabled;
	
	return newStyle;
}

- (NSString *)description
{
	return [NSString stringWithFormat: @"RKAdditionalParagraphStyle: ("
											"keepWithFollowingParagraph: %d"
											"hyphenationEnabled: %u"
										")",
			self.keepWithFollowingParagraph,
			self.hyphenationEnabled
			];
}

@end
