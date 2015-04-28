//
//  RKDOCXListWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 24.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"
#import "RKColor.h"

@interface RKDOCXListWriterTest : XCTestCase

@end

@implementation RKDOCXListWriterTest

- (void)testTwoListItems
{
	RKListStyle *listStyle = [RKListStyle listStyleWithLevelFormats:@[@"%d.", @"%*%d."] styles:@[@{RKListStyleMarkerLocationKey: @10, RKListStyleMarkerWidthKey: @20}, @{RKListStyleMarkerLocationKey: @15, RKListStyleMarkerWidthKey: @25}]];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @""];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"First list item: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."] withStyle:listStyle withIndentationLevel:0];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"Second list item: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."] withStyle:listStyle withIndentationLevel:1];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"list"];
}

- (void)testMultipleListStyles
{
	RKListStyle *listStyle = [RKListStyle listStyleWithLevelFormats:@[@"%d.", @"-"] styles:@[@{RKListStyleMarkerLocationKey: @10, RKListStyleMarkerWidthKey: @20}, @{RKListStyleMarkerLocationKey: @15, RKListStyleMarkerWidthKey: @25}]];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @""];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"Ordered list item"] withStyle:listStyle withIndentationLevel:0];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"Unordered list item"] withStyle:listStyle withIndentationLevel:1];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"Second ordered list item"] withStyle:listStyle withIndentationLevel:0];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"multipleliststyles"];
}

- (void)testDifferentStartNumbers
{
	RKListStyle *listStyle = [RKListStyle listStyleWithLevelFormats:@[@"%A.", @"%d.", @"%R."] styles:@[@{RKListStyleMarkerLocationKey: @10, RKListStyleMarkerWidthKey: @20}, @{RKListStyleMarkerLocationKey: @15, RKListStyleMarkerWidthKey: @25}, @{RKListStyleMarkerLocationKey: @20, RKListStyleMarkerWidthKey: @30}] startNumbers:@[@8, @42, @1337]];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @""];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 1"] withStyle:listStyle withIndentationLevel:0];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 2"] withStyle:listStyle withIndentationLevel:0];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 1.1"] withStyle:listStyle withIndentationLevel:1];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 1.2"] withStyle:listStyle withIndentationLevel:1];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 1.1.1"] withStyle:listStyle withIndentationLevel:2];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 1.1.2"] withStyle:listStyle withIndentationLevel:2];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"listswithstartnumbers"];
}

- (void)testListWithRunAttribute
{
	RKListStyle *listStyle = [RKListStyle listStyleWithLevelFormats:@[@"%d)", @"%d)", @"%d)"] styles:@[@{RKListStyleMarkerLocationKey: @10, RKListStyleMarkerWidthKey: @20}, @{RKListStyleMarkerLocationKey: @15, RKListStyleMarkerWidthKey: @25}, @{RKListStyleMarkerLocationKey: @20, RKListStyleMarkerWidthKey: @30}]];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @""];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString:@"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua." attributes:@{RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0 blue:1 alpha:0]}] withStyle:listStyle withIndentationLevel:0];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"bluelist"];
}

- (void)testListWithParagraphAttribute
{
	RKListStyle *listStyle = [RKListStyle listStyleWithLevelFormats:@[@"%d)", @"%d)", @"%d)"] styles:@[@{RKListStyleMarkerLocationKey: @10, RKListStyleMarkerWidthKey: @20}, @{RKListStyleMarkerLocationKey: @15, RKListStyleMarkerWidthKey: @25}, @{RKListStyleMarkerLocationKey: @20, RKListStyleMarkerWidthKey: @30}]];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @""];
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.alignment = RKTextAlignmentCenter;
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString:@"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua." attributes:@{RKParagraphStyleAttributeName: paragraphStyle}] withStyle:listStyle withIndentationLevel:0];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"centeredlist"];
}

@end
