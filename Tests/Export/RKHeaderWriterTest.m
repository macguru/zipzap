//
//  RKHeaderWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKHeaderWriterTest.h"
#import "RKBodyWriter.h"
#import "RKResourceManager.h"

@interface RKHeaderWriter ()
+ (NSString *)fontTableFromResourceManager:(RKResourceManager *)resources;
+ (NSString *)colorTableFromResourceManager:(RKResourceManager *)resources;
+ (NSString *)documentMetaDataFromDocument:(RKDocument *)document;
+ (NSString *)documentFormatFromDocument:(RKDocument *)document;
@end

@implementation RKHeaderWriterTest

- (void)testGeneratingFontTable
{
    RKResourceManager *resources = [[RKResourceManager alloc] init];
    
    // Register some fonts
    [resources indexOfFont:[NSFont fontWithName:@"Times-Roman" size:8]];
    [resources indexOfFont:[NSFont fontWithName:@"Helvetica-Oblique" size:8]];
    [resources indexOfFont:[NSFont fontWithName:@"Menlo-Bold" size:8]];
    [resources indexOfFont:[NSFont fontWithName:@"Monaco" size:8]];    
    
    // Generate the header
    STAssertEqualObjects([RKHeaderWriter fontTableFromResourceManager:resources], 
                         @"{\\fonttbl"
                          "\\f0\\fnil\\fcharset0 Times;"
                          "\\f1\\fnil\\fcharset0 Helvetica;"
                          "\\f2\\fnil\\fcharset0 Menlo;"
                          "\\f3\\fnil\\fcharset0 Monaco;"
                          "}",
                         @"Invalid font table generated"
                         );
}

- (void)testGeneratingColorTable
{
    RKResourceManager *resources = [[RKResourceManager alloc] init];
    
    // Register some fonts
    [resources indexOfColor:[NSColor colorWithSRGBRed:0 green:1 blue:0.5 alpha:1]];
    [resources indexOfColor:[NSColor colorWithSRGBRed:0.1 green:0.2 blue:0.3 alpha:1]];
    [resources indexOfColor:[NSColor colorWithSRGBRed:0.3 green:0.5 blue:0.1 alpha:1]];
    
    // Generate the header
    STAssertEqualObjects([RKHeaderWriter colorTableFromResourceManager:resources], 
                         @"{\\colortbl"
                         "\\red0\\green255\\blue127;"
                         "\\red25\\green51\\blue76;"
                         "\\red76\\green127\\blue25;"                         
                         "}",
                         @"Invalid color table generated"
                         );
}

- (void)testGeneratingDocumentInfo
{
    RKDocument *document = [[RKDocument alloc] init];
    NSDictionary *metaData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Title {} \\ ",    NSTitleDocumentAttribute,
                                 @"Company",        NSCompanyDocumentAttribute,
                                 @"Copyright",      NSCopyrightDocumentAttribute,
                                 @"Subject",        NSSubjectDocumentAttribute,
                                 @"Author",         NSAuthorDocumentAttribute,
                                 @"Keywords",       NSKeywordsDocumentAttribute,
                                 @"Comment",        NSCommentDocumentAttribute,
                                 @"Editor",         NSEditorDocumentAttribute,
                                 [NSDate dateWithString:@"2001-02-03 04:05:06 +0100"],  NSCreationTimeDocumentAttribute,
                                 [NSDate dateWithString:@"2006-05-04 03:02:01 +0100"],  NSModificationTimeDocumentAttribute,
                                 @"Manager",        NSManagerDocumentAttribute,
                                 @"Category",       NSCategoryDocumentAttribute,
                                 nil
                                ];

    [document setMetadata:metaData];
    
    STAssertEqualObjects([RKHeaderWriter documentMetaDataFromDocument:document],
                          @"{\\title Title \\{\\} \\\\ }"
                           "{\\company Company}"
                           "{\\copyright Copyright}"
                           "{\\subject Subject}"
                           "{\\author Author}"
                           "{\\keywords Keywords}"
                           "{\\comment Comment}"
                           "{\\editor Editor}"
                           "{\\creatim \\yr2001 \\mo2 \\dy3 \\hr4 \\min5 \\sec6}"
                           "{\\revtim \\yr2006 \\mo5 \\dy4 \\hr3 \\min2 \\sec1}"
                           "{\\manager Manager}"
                           "{\\category Category}",
                          @"Invalid document meta data"
                         );

}


@end
