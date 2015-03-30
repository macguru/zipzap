//
//  RKDOCXDocumentContentWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXDocumentContentWriter.h"

// Root element name
NSString *RKDOCXDocumentRootElementName = @"w:document";

// Element names
NSString *RKDOCXDocumentBodyElementName = @"w:body";
NSString *RKDOCXDocumentParagraphElementName = @"w:p";
NSString *RKDOCXDocumentRunElementName = @"w:r";
NSString *RKDOCXDocumentTextElementName = @"w:t";

@implementation RKDOCXDocumentContentWriter

+ (void)buildDocumentUsingContext:(RKDOCXConversionContext *)context
{
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName: RKDOCXDocumentRootElementName];
	
	// Namespace attributes
	NSDictionary *namespaces = @{
								 @"xmlns:wpc": @"http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas",
								 @"xmlns:mo": @"http://schemas.microsoft.com/office/mac/office/2008/main",
								 @"xmlns:mc": @"http://schemas.openxmlformats.org/markup-compatibility/2006",
								 @"xmlns:mv": @"urn:schemas-microsoft-com:mac:vml",
								 @"xmlns:o": @"urn:schemas-microsoft-com:office:office",
								 @"xmlns:r": @"http://schemas.openxmlformats.org/officeDocument/2006/relationships",
								 @"xmlns:m": @"http://schemas.openxmlformats.org/officeDocument/2006/math",
								 @"xmlns:v": @"urn:schemas-microsoft-com:vml",
								 @"xmlns:wp14": @"http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing",
								 @"xmlns:wp": @"http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing",
								 @"xmlns:w10": @"urn:schemas-microsoft-com:office:word",
								 @"xmlns:w": @"http://schemas.openxmlformats.org/wordprocessingml/2006/main",
								 @"xmlns:w14": @"http://schemas.microsoft.com/office/word/2010/wordml",
								 @"xmlns:w15": @"http://schemas.microsoft.com/office/word/2012/wordml",
								 @"xmlns:wpg": @"http://schemas.microsoft.com/office/word/2010/wordprocessingGroup",
								 @"xmlns:wpi": @"http://schemas.microsoft.com/office/word/2010/wordprocessingInk",
								 @"xmlns:wne": @"http://schemas.microsoft.com/office/word/2006/wordml",
								 @"xmlns:wps": @"http://schemas.microsoft.com/office/word/2010/wordprocessingShape",
								 @"mc:Ignorable": @"w14 w15 wp14"
								 };
	for (NSString *key in namespaces)
		[document.rootElement addAttribute: [NSXMLElement attributeWithName:key stringValue:namespaces[key]]];
	
	// Document content
	NSXMLElement *body = [NSXMLElement elementWithName: RKDOCXDocumentBodyElementName];
	[document.rootElement addChild: body];
	
	NSXMLElement *paragraph = [NSXMLElement elementWithName: RKDOCXDocumentParagraphElementName];
	[body addChild: paragraph];
	
	NSXMLElement *run = [NSXMLElement elementWithName: RKDOCXDocumentRunElementName];
	[paragraph addChild: run];
	
	NSString *textContent = [[[[[context document] sections] firstObject] content] string];
	
	NSXMLElement *text = [NSXMLElement elementWithName:RKDOCXDocumentTextElementName stringValue:textContent];
	[text addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	[run addChild: text];
	
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXDocumentFilename];
}

@end
