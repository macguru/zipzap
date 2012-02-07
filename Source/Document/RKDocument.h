//
//  RKDocument.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTypes.h"

@class RKSection;

/*
 @abstract Representation of an RTF document
 @discussion An RTF document is composed of multiple sections and provides settings for document formatting and meta data.
 */
@interface RKDocument : NSObject

/*!
 @abstract Creates a document based on an array of sections
 */
+ (RKDocument *)documentWithSections:(NSArray *)sections;

/*!
 @abstract Creates a document based on an attributed string. 
 @discussion The section containing the string will be automatically created.
 */
+ (RKDocument *)documentWithAttributedString:(NSAttributedString *)string;

/*!
 @abstract Initializes a document with a single attributed string representing its content
 */
- (id)initWithAttributedString:(NSAttributedString *)string;

/*!
 @abstract Initializes a document with an array of sections
 */
- (id)initWithSections:(NSArray *)array;

/*!
 @abstract Exports the document as RTF with embedded pictures
 */
- (NSData *)RTF;

/*!
 @abstract Exports the document as RTF without pictures
 */
- (NSData *)plainRTF;

/*!
 @abstract Exports the document as RTFD 
 @discussion Creates a file wrapper containing the RTF and all referenced pictures
 */
- (NSFileWrapper *)RTFD;

/*!
 @abstract The sections a document consists of.
 */
@property(nonatomic, strong) NSArray *sections;

/*!
 @abstract Document meta data
 @discussion A dictionary of document meta data. It is allowed to place arbitrary meta properties here. The RTF definition provides the following meta data:

    NSTitleDocumentAttribute
    NSCompanyDocumentAttribute
    NSCopyrightDocumentAttribute
    NSSubjectDocumentAttribute
    NSAuthorDocumentAttribute
    NSKeywordsDocumentAttribute
    NSCommentDocumentAttribute
    NSEditorDocumentAttribute
    NSCreationTimeDocumentAttribute
    NSModificationTimeDocumentAttribute
    NSManagerDocumentAttribute
    NSCategoryDocumentAttribute
*/
@property(nonatomic, strong) NSDictionary *metadata;


#pragma mark - Formatting

/*!
 @abstract Specifies whether hyphenation is enabled in this document.
 */
@property(nonatomic) BOOL hyphenationEnabled;

/*!
 @abstract Page size in points
 */
@property(nonatomic) NSSize pageSize;

/*!
 @abstract Page insets in points
 */
@property(nonatomic) RKPageInsets pageInsets;

/*!
 @abstract Page orientation
 */
@property(nonatomic) RKPageOrientation pageOrientation;

/*!
 @abstract Specifies the placement of footnotes within the document
 */
@property(nonatomic) RKFootnotePlacement footnotePlacement;

/*!
 @abstract Specifies the placement of endnotes within the document
 */
@property(nonatomic) RKEndnotePlacement endnotePlacement;

/*!
 @abstract Specifies the footnote enumeration style
 */
@property(nonatomic) RKFootnoteEnumerationStyle footnoteEnumerationStyle;

/*!
 @abstract Specifies the endnote enumeration style
 */
@property(nonatomic) RKFootnoteEnumerationStyle endnoteEnumerationStyle;

/*!
 @abstract Specifies whether footnote numbering should restart on each page
 */
@property(nonatomic) RKFootnoteEnumerationPolicy footnoteEnumerationPolicy;

/*!
 @abstract Specifies whether endnotes restart on each section
 */
@property(nonatomic) BOOL restartEndnotesOnEachSection;

@end
