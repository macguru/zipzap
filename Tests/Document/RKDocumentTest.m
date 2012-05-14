//
//  RKDocumentTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
#import "RKDocumentTest.h"

@implementation RKDocumentTest

- (void)testSimpleDocumentWithSection
{
    NSArray *someArray = [NSArray new];
    RKDocument *document = [RKDocument documentWithSections:someArray];

    STAssertEqualObjects(document.sections, someArray, @"Initialization failure");
}

- (void)testSimpleDocumentWithAttributedString
{
    NSAttributedString *someString = [[NSAttributedString alloc] initWithString:@"Some String"];
    RKDocument *document = [RKDocument documentWithAttributedString:someString];
    RKSection *section = [document.sections objectAtIndex: 0];

    STAssertEquals([document.sections count], (NSUInteger)1, @"Invalid section count after initialization with a single string");

    STAssertEqualObjects(section.content, someString, @"Invalid string used for section initialization");

    // Test assertion on invalid input
    STAssertThrows([RKDocument documentWithAttributedString:nil], @"Expecting exception");
}

@end
