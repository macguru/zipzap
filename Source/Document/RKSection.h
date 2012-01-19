//
//  RKSection.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
#import "RKTypes.h"

/*!
 @abstract Representation of an RTF section
 @discussion An RTF section is an area of the document that has own headlines, footers and custom layouting options.
 */
@interface RKSection : NSObject

- (id)initWithContent:(NSAttributedString *)content;

- (NSAttributedString *)headerForPage: (RKPageSelectionMask)pageMask;
- (void)setHeader: (NSAttributedString *)header forPages: (RKPageSelectionMask)pageMask;

- (NSAttributedString *)footerForPage: (RKPageSelectionMask)pageMask;
- (void)setFooter: (NSAttributedString *)header forPages: (RKPageSelectionMask)pageMask;


/*!
 @abstract Content of the section
 */
@property(nonatomic, strong) NSAttributedString *content;

/*!
 @abstract Endnote placement
 */
@property(nonatomic) RKEndnotePlacement endnotePlacement;

/*!
 @abstract Multicolumn layout
 */
@property(nonatomic) NSInteger numbersOfColumns;

/*!
 @abstract Starting page number
 */
@property(nonatomic) NSInteger numberOfFirstPage;

/*!
 @abstract Page number style
 */
@property(nonatomic) RKPageNumberingStyle pageNumberingStyle;

@end
