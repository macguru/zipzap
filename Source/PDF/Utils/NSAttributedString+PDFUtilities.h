//
//  NSAttributedString+PDFUtilities.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKTextObject, RKPDFRenderingContext;


/*!
 @abstract The key mapping to the content inside a footnote descriptor
 */
extern NSString *RKFootnoteContentKey;

/*!
 @abstract The key mapping to the enumeration string inside a footnote descriptor
 */
extern NSString *RKFootnoteEnumerationStringKey;

/*!
 @abstract A special attribute that indicates a text object
 @discussion Reference to a RKPDFTextObject
 */
extern NSString *RKTextObjectAttributeName;

/*!
 @abstract A special attribute that indicates the reqirement of a custom text renderer
 @discussion Reference to an Array of RKPDFTextRenderer classes
 */
extern NSString *RKTextRendererAttributeName;

/*!
 @abstract Utility methods for PDF generation
 */
@interface NSAttributedString (PDFUtilities)

/*!
 @abstract Creates a new attributed string from the current string by applying the footnote style using a footnote index.
 */
- (NSAttributedString *)noteWithEnumerationString:(NSString *)enumerationString;

/*!
 @abstract Creates an attributed string containing the given footnotes or endnotes
 @discussion The notes are stored as an array of footnote descriptors (NSDictionary) containing the footnote content (RKFootnoteContentKey) as NSAttributedString in core text representation and the enumeration string of the footnote (RKFootenoteEnumerationStringKey).
 */
+ (NSAttributedString *)noteListWithNotes:(NSArray *)notes;

@end

@interface NSMutableAttributedString (PDFCoreTextConversion)

/*!
 @abstract Sets the given character as text object using custom rendering
 @discussion Specifies a CTRunDelegate such that the handlers of the text object are called during rendering
 */
- (void)addTextObjectAttribute:(RKTextObject *)textObject atIndex:(NSUInteger)index;

/*!
 @abstract Adds a custom text render to an attributed string range respecting the priority of the renderer class
 @discussion The renderer must be a class derived from RKPDFTextRenderer.
 */
- (void)addTextRenderer:(Class)textRender forRange:(NSRange)range;

/*!
 @abstract Adds a local destination attribute to an attributed string and setups the required text renderer
 */
- (void)addLocalDestinationAnchor:(NSString *)anchorName forRange:(NSRange)range;

/*!
 @abstract Adds a local destination link to an attributed string and setups the required text renderer
 */
- (void)addLocalDestinationLinkForAnchor:(NSString *)anchorName forRange:(NSRange)range;

@end
