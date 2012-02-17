//
//  RKHeaderWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKHeaderWriterTest.h"
#import "RKBodyWriter.h"
#import "RKHeaderWriter.h"
#import "RKHeaderWriter+TestExtensions.h"


@implementation RKHeaderWriterTest

- (NSDictionary *)generateCharacterStyle
{
    NSFont *font = [NSFont fontWithName:@"Helvetica-BoldOblique" size:16];
    NSShadow *shadow = [NSShadow new];
    NSNumber *strikethroughStyle = [NSNumber numberWithUnsignedInteger:NSUnderlineStyleSingle];
    NSNumber *strokeWidth = [NSNumber numberWithUnsignedInteger:12];
    NSNumber *superscriptMode = [NSNumber numberWithUnsignedInteger:1];
    NSNumber *underlineStyle = [NSNumber numberWithUnsignedInt:NSUnderlineStyleDouble];
    NSColor *backgroundColor = [NSColor rtfColorWithRed:1.0 green:0.0 blue:0.0];
    NSColor *foregroundColor = [NSColor rtfColorWithRed:0.0 green:1.0 blue:0.0];    
    NSColor *underlineColor = [NSColor rtfColorWithRed:1.0 green:0.0 blue:1.0];
    NSColor *strikethroughColor = [NSColor rtfColorWithRed:0.0 green:1.0 blue:1.0];    
    NSColor *strokeColor = [NSColor rtfColorWithRed:0.1 green:0.2 blue:1.0];
    
    shadow.shadowBlurRadius = 2.0f;
    shadow.shadowColor = [NSColor rtfColorWithRed:0.0 green:0.1 blue:0.0];
    
    return [NSDictionary dictionaryWithObjectsAndKeys: 
            font,                  NSFontAttributeName,
            shadow,                NSShadowAttributeName,
            strikethroughStyle,    NSStrikethroughStyleAttributeName,
            strokeWidth,           NSStrokeWidthAttributeName,
            superscriptMode,       NSSuperscriptAttributeName,
            underlineStyle,        NSUnderlineStyleAttributeName,
            backgroundColor,       NSBackgroundColorAttributeName,
            foregroundColor,       NSForegroundColorAttributeName,
            underlineColor,        NSUnderlineColorAttributeName,
            strikethroughColor,    NSStrikethroughColorAttributeName,
            strokeColor,           NSStrokeColorAttributeName,
            nil 
            ];
}

- (NSDictionary *)generateParagraphStyle
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];    
    
    paragraphStyle.alignment = NSCenterTextAlignment;
    paragraphStyle.firstLineHeadIndent = .0f;
    paragraphStyle.headIndent = .0f;
    paragraphStyle.tailIndent = .0f;
    
    paragraphStyle.lineHeightMultiple = .0f;
    paragraphStyle.lineSpacing = .0f;
    paragraphStyle.maximumLineHeight = .0f;
    paragraphStyle.minimumLineHeight = .0f;
    
    paragraphStyle.paragraphSpacingBefore = .0f;
    paragraphStyle.paragraphSpacing = .0f;
    
    paragraphStyle.tabStops = [NSArray new];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary: [self generateCharacterStyle]];
    
    [dictionary setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    return dictionary;
}

- (NSDate *)customDateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second
{
    NSDateComponents *customComponents = [NSDateComponents new];
    
    [customComponents setYear:year];
    [customComponents setMonth:month];
    [customComponents setDay:day];
    [customComponents setHour:hour];
    [customComponents setMinute:minute];
    [customComponents setSecond:second];
    
    return [[NSCalendar currentCalendar] dateFromComponents:customComponents];
}

- (void)testGeneratingFontTable
{
    RKResourcePool *resources = [RKResourcePool new];
    
    // Register some fonts
    [resources indexOfFont:[NSFont fontWithName:@"Times-Roman" size:8]];
    [resources indexOfFont:[NSFont fontWithName:@"Helvetica-Oblique" size:8]];
    [resources indexOfFont:[NSFont fontWithName:@"Menlo-Bold" size:8]];
    [resources indexOfFont:[NSFont fontWithName:@"Monaco" size:8]];    
    
    // Generate the header
    STAssertEqualObjects([RKHeaderWriter fontTableFromResourceManager:resources], 
                         @"{\\fonttbl"
                          "\\f0\\fnil\\fcharset0 Times-Roman;"
                          "\\f1\\fnil\\fcharset0 Helvetica;"
                          "\\f2\\fnil\\fcharset0 Menlo-Regular;"
                          "\\f3\\fnil\\fcharset0 Monaco;"
                          "}",
                         @"Invalid font table generated"
                         );
}

- (void)testGeneratingColorTable
{
    RKResourcePool *resources = [RKResourcePool new];
    
    // Register some fonts
    [resources indexOfColor:[NSColor rtfColorWithRed:0 green:1 blue:0.5]];
    [resources indexOfColor:[NSColor rtfColorWithRed:0.1 green:0.2 blue:0.3]];
    [resources indexOfColor:[NSColor rtfColorWithRed:0.3 green:0.5 blue:0.1]];
    
    // Generate the header
    STAssertEqualObjects([RKHeaderWriter colorTableFromResourceManager:resources], 
                         @"{\\colortbl;"
                         "\\red255\\green255\\blue255;"
                         "\\red0\\green255\\blue127;"
                         "\\red25\\green51\\blue76;"
                         "\\red76\\green127\\blue25;"                         
                         "}",
                         @"Invalid color table generated"
                         );
}

- (void)testGeneratingDocumentInfo
{
    RKDocument *document = [RKDocument new];
    NSDictionary *metaData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Title {} \\ ",    NSTitleDocumentAttribute,
                                 @"Company",        NSCompanyDocumentAttribute,
                                 @"Copyright",      NSCopyrightDocumentAttribute,
                                 @"Subject",        NSSubjectDocumentAttribute,
                                 @"Author",         NSAuthorDocumentAttribute,
                                 [NSArray arrayWithObjects: @"Keyword 1", @"Keyword 2", nil],       NSKeywordsDocumentAttribute,
                                 @"Comment",        NSCommentDocumentAttribute,
                                 @"Editor",         NSEditorDocumentAttribute,
                                 [self customDateWithYear:2001 month:2 day:3 hour:4 minute:5 second:6],  NSCreationTimeDocumentAttribute,
                                 [self customDateWithYear:2006 month:5 day:4 hour:3 minute:2 second:1],  NSModificationTimeDocumentAttribute,
                                 @"Manager",        NSManagerDocumentAttribute,
                                 @"Category",       NSCategoryDocumentAttribute,
                                 nil
                                ];

    [document setMetadata: metaData];
    
    STAssertEqualObjects([RKHeaderWriter documentMetaDataFromDocument:document],
                          @"{\\info"
                                "{\\title Title \\{\\} \\\\ }"
                                "{\\*\\company Company}"
                                "{\\*\\copyright Copyright}"
                                "{\\subject Subject}"
                                "{\\author Author}"
                                "{\\keywords Keyword 1, Keyword 2}"
                                "{\\doccomm Comment}"
                                "{\\*\\editor Editor}"
                                "{\\creatim \\yr2001 \\mo2 \\dy3 \\hr4 \\min5 \\sec6}"
                                "{\\revtim \\yr2006 \\mo5 \\dy4 \\hr3 \\min2 \\sec1}"
                                "{\\manager Manager}"
                                "{\\category Category}"
                            "}",
                          @"Invalid document meta data"
                         );
}

- (void)testGeneratingDocumentFormattingData
{
    RKDocument *document = [RKDocument new];
    RKPageInsets insets = {.top = 100.0, .left = 200.0, .right = 300.0, .bottom = 400.0};

    // Test setting: Hyphenation, Footnotes on same page, Endnotes on section end, Overriding default size / margins, portrait format
    [document setHyphenationEnabled:YES];
    [document setFootnotePlacement:RKFootnotePlacementSamePage];
    [document setEndnotePlacement:RKEndnotePlacementSectionEnd];
    [document setPageSize:NSMakeSize(100.0, 200.0)];
    [document setPageInsets:insets];
    [document setPageOrientation:RKPageOrientationPortrait];
    
    [document setFootnoteEnumerationStyle:RKFootnoteEnumerationRomanLowerCase];
    [document setEndnoteEnumerationStyle:RKFootnoteEnumerationAlphabeticLowerCase];
    
    [document setFootnoteEnumerationPolicy:RKFootnoteEnumerationPerSection];
    [document setRestartEndnotesOnEachSection:NO];
    
    STAssertEqualObjects([RKHeaderWriter documentFormatFromDocument:document],
                         @"\\facingp"
                          "\\fet2\\aendnotes"
                          "\\ftnbj\\aftnbj"
                          "\\ftnnrlc\\aftnnalc\\saftnnalc"
                          "\\ftnrestart\\aftnrstcont"
                          "\\paperw2000"
                          "\\paperh4000"
                          "\\margt2000"
                          "\\margl4000"
                          "\\margr6000"
                          "\\margb8000"
                          "\\hyphauto1"
                          "\\uc0 ",
                          @"Document formatting options not correctly translated"
                         );

    // Test setting: No Hyphenation, Document endnotes, landscape format    
    [document setHyphenationEnabled:NO];
    [document setFootnotePlacement:RKFootnotePlacementDocumentEnd];
    [document setEndnotePlacement:RKEndnotePlacementDocumentEnd];    
    [document setPageOrientation:RKPageOrientationLandscape];
    
    STAssertEqualObjects([RKHeaderWriter documentFormatFromDocument:document],
                         @"\\facingp"
                         "\\fet1\\enddoc\\aenddoc"
                         "\\ftnbj\\aftnbj"
                         "\\ftnnrlc\\aftnnalc\\saftnnalc"
                         "\\ftnrestart\\aftnrstcont"                         
                         "\\landscape"
                         "\\paperw2000"
                         "\\paperh4000"
                         "\\margt2000"
                         "\\margl4000"
                         "\\margr6000"
                         "\\margb8000"
                         "\\uc0 ",
                         @"Document formatting options not correctly translated"
                         );    
    
    // Test setting: No Hyphenation, Section endnotes, landscape format    
    [document setHyphenationEnabled:NO];
    [document setFootnotePlacement:RKFootnotePlacementSectionEnd];
    [document setPageOrientation:RKPageOrientationLandscape];
    
    STAssertEqualObjects([RKHeaderWriter documentFormatFromDocument:document],
                         @"\\facingp" 
                         "\\fet1\\endnotes\\aenddoc"
                         "\\ftnbj\\aftnbj"
                         "\\ftnnrlc\\aftnnalc\\saftnnalc"
                         "\\ftnrestart\\aftnrstcont"                       
                         "\\landscape"
                         "\\paperw2000"
                         "\\paperh4000"
                         "\\margt2000"
                         "\\margl4000"
                         "\\margr6000"
                         "\\margb8000"
                         "\\uc0 ",
                         @"Document formatting options not correctly translated"
                         );  
}

- (void)testGenerateListTable
{
    NSArray *overrides = [NSArray arrayWithObjects: 
                          [NSNumber numberWithUnsignedInteger: 1],
                          [NSNumber numberWithUnsignedInteger: 3],                         
                          [NSNumber numberWithUnsignedInteger: 1],                         
                          [NSNumber numberWithUnsignedInteger: 1],                         
                          [NSNumber numberWithUnsignedInteger: 1],
                          [NSNumber numberWithUnsignedInteger: 1],
                          [NSNumber numberWithUnsignedInteger: 1],
                          [NSNumber numberWithUnsignedInteger: 1],                         
                          [NSNumber numberWithUnsignedInteger: 1],
                          nil
                         ];
    RKListStyle *firstList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects:@"%d.", @"%*%a.", @"%r.", nil] ];
    RKListStyle *secondList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects:@"---------%d", @"-", nil] startNumbers:overrides];

    // Register lists to a resource pool
    RKResourcePool *resources = [RKResourcePool new];
                                  
    [resources indexOfListStyle: firstList];
    [resources indexOfListStyle: secondList];
    
    // Generate header
    NSString *listTable = [RKHeaderWriter listTableFromResourceManager:resources];
    
    NSString *expectedListTable = 
        @"{\\*\\listtable "
            "{\\list"
                "\\listtemplateid1"
                "\\listhybrid"
                "{\\listlevel"
                    // levelcf0 (decimal)
                    "\\levelstartat1\\levelnfc0\\leveljc0\\levelold0\\levelprev0\\levelprevspace0\\levelindent0\\levelspace0"
                    "{\\*\\levelmarker \\{decimal\\}.}"
                    "{\\leveltext\\leveltemplateid1001 \\'04\t\\'00.\t;}"
                    "{\\levelnumbers \\'02;}"
                    "\\levelfollow2\\levellegal0\\levelnorestart0"
                "}"
                "{\\listlevel"
                    // levelcf4 (lower case letter)
                    "\\levelstartat1\\levelnfc4\\leveljc0\\levelold0\\levelprev0\\levelprevspace0\\levelindent0\\levelspace0"
                    "{\\*\\levelmarker \\{lower-alpha\\}.}"
                    "\\levelprepend"
                    "{\\leveltext\\leveltemplateid1002 \\'06\t\\'00.\\'01.\t;}"
                    "{\\levelnumbers \\'02\\'04;}"
                    "\\levelfollow2\\levellegal0\\levelnorestart0"
                "}"                         
                "{\\listlevel"
                    // Different starting number; levelcf2 (lower case roman)
                    "\\levelstartat1\\levelnfc2\\leveljc0\\levelold0\\levelprev0\\levelprevspace0\\levelindent0\\levelspace0"
                    "{\\*\\levelmarker \\{lower-roman\\}.}" 
                    "{\\leveltext\\leveltemplateid1003 \\'04\t\\'02.\t;}"
                    "{\\levelnumbers \\'02;}"
                    "\\levelfollow2\\levellegal0\\levelnorestart0"
                "}"                         
                "\\listid1"
                "{\\listname list1}"
            "}"
            "{\\list"
                "\\listtemplateid2"
                "\\listhybrid"
                "{\\listlevel"
                    // levelcf0 (decimal)
                    "\\levelstartat1\\levelnfc0\\leveljc0\\levelold0\\levelprev0\\levelprevspace0\\levelindent0\\levelspace0"
                    "{\\*\\levelmarker ---------\\{decimal\\}}"
                    "{\\leveltext\\leveltemplateid2001 \\'0c\t---------\\'00\t;}"
                    "{\\levelnumbers \\'0b;}"
                    "\\levelfollow2\\levellegal0\\levelnorestart0"
                "}"
                "{\\listlevel"
                    // levelcf23 (bullet)
                    "\\levelstartat3\\levelnfc23\\leveljc0\\levelold0\\levelprev0\\levelprevspace0\\levelindent0\\levelspace0"
                    "{\\*\\levelmarker -}"
                    "{\\leveltext\\leveltemplateid2002 \\'03\t-\t;}"
                    "{\\levelnumbers ;}"
                    "\\levelfollow2\\levellegal0\\levelnorestart0"
                "}"                         
                "\\listid2"
                "{\\listname list2}"
            "}"
        "}\n";
    
    STAssertEqualObjects(listTable, expectedListTable, @"Invalid list table generated");
}

- (void)testGenerateListOverrideTable
{
    RKListStyle *firstList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects:@"%d0.", @"%a1.", @"%r2.", nil] ];
    RKListStyle *secondList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects:@"%d0.%r1.%a2.%R3.%A4.", @"-", nil]];
    
    // Register lists to a resource pool
    RKResourcePool *resources = [RKResourcePool new];
    
    [resources indexOfListStyle: firstList];
    [resources indexOfListStyle: secondList];
    
    // Generate header
    NSString *listTable = [RKHeaderWriter listOverrideTableFromResourceManager:resources];

    NSString *expectedListTable = 
        @"{\\*\\listoverridetable"
           "{\\listoverride\\listid1\\listoverridecount0\\ls1}"
           "{\\listoverride\\listid2\\listoverridecount0\\ls2}"  
         "}\n";
    
    STAssertEqualObjects(listTable, expectedListTable, @"Invalid llist override table generated");
}

- (void)testGeneratingStylesheetTable
{
    RKDocument *document = [RKDocument new];
    RKResourcePool *resources = [[RKResourcePool alloc] initWithDocument:document];    
    
    document.paragraphStyles = [NSDictionary dictionaryWithObjectsAndKeys: 
                                [self generateParagraphStyle], @"PStyle",
                                nil
                                ];

    document.characterStyles = [NSDictionary dictionaryWithObjectsAndKeys: 
                                [self generateCharacterStyle], @"CStyle",
                                nil
                                ];
    
    NSString *expectedStyleSheet = 
        @"{\\stylesheet "
            "{\\s1 "
            "\\pard\\qc\\pardeftab0 "
            "\\cb2 "
            "\\cf3 "
            "\\f0 \\fs32\\fsmilli16000 \\b \\i "
            "\\shad\\shadx0\\shady0\\shadr40\\shadc4 "
            "\\strike\\strikestyle1 "
            "\\strikec5 "
            "\\strokec6 "
            "\\outl\\strokewidth240 "
            "\\sup "
            "\\uldb\\ulstyle9 "
            "\\ulc7 "
            "PStyle;"
            "}"
          "{\\*\\cs2 "
            "\\cb2 "
            "\\cf3 "
            "\\f0 \\fs32\\fsmilli16000 \\b \\i "
            "\\shad\\shadx0\\shady0\\shadr40\\shadc4 "
            "\\strike\\strikestyle1 "
            "\\strikec5 "
            "\\strokec6 "
            "\\outl\\strokewidth240 "
            "\\sup "
            "\\uldb\\ulstyle9 "
            "\\ulc7 "
            "CStyle;"
            "}"    
        "}";
    
    NSString *stylesheets = [RKHeaderWriter styleSheetsFromResourceManager: resources];
    
    STAssertEqualObjects(stylesheets, expectedStyleSheet, @"Invalid style sheet table generated");
    
    return;   
}

- (void)testRereadingPageSettingsWithCocoa
{
    RKDocument *document = [RKDocument documentWithAttributedString:[[NSAttributedString alloc] initWithString:@"abc"]];
    
    document.pageSize = NSMakeSize(300, 400);
    document.pageInsets = RKPageInsetsMake(10, 20, 30, 40);
    document.hyphenationEnabled = YES;
    
    NSDictionary *rereadDocumentProperties;
    
    NSData *rtf = [document RTF];
    NSAttributedString *rereadString = [[NSAttributedString alloc] initWithRTF:rtf documentAttributes:&rereadDocumentProperties];
    
    STAssertEqualObjects([rereadString string], @"abc\n", @"Invalid content");
    
    STAssertEquals([[rereadDocumentProperties objectForKey:NSPaperSizeDocumentAttribute] sizeValue], document.pageSize, @"Invalid paper size");
    STAssertEquals([[rereadDocumentProperties objectForKey:NSLeftMarginDocumentAttribute] floatValue], (float)document.pageInsets.left, @"Invalid margin");
    STAssertEquals([[rereadDocumentProperties objectForKey:NSRightMarginDocumentAttribute] floatValue], (float)document.pageInsets.right, @"Invalid margin");
    STAssertEquals([[rereadDocumentProperties objectForKey:NSTopMarginDocumentAttribute] floatValue], (float)document.pageInsets.top, @"Invalid margin");
    STAssertEquals([[rereadDocumentProperties objectForKey:NSBottomMarginDocumentAttribute] floatValue], (float)document.pageInsets.bottom, @"Invalid margin");    
    STAssertEquals([[rereadDocumentProperties objectForKey:NSHyphenationFactorDocumentAttribute] floatValue], 0.9f, @"Invalid hyphenation setting");    
}

- (void)testRereadingMetaDataSettingsWithCocoa
{
    RKDocument *document = [RKDocument documentWithAttributedString:[[NSAttributedString alloc] initWithString:@"abc"]];
    NSDictionary *metaData = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Title",          NSTitleDocumentAttribute,
                              @"Company",        NSCompanyDocumentAttribute,
                              @"Copyright",      NSCopyrightDocumentAttribute,
                              @"Subject",        NSSubjectDocumentAttribute,
                              @"Author",         NSAuthorDocumentAttribute,
                              [NSArray arrayWithObjects: @"Keyword 1", @"Keyword 2", nil],       NSKeywordsDocumentAttribute,
                              @"Comment",        NSCommentDocumentAttribute,
                              [self customDateWithYear:2001 month:2 day:3 hour:4 minute:5 second:6],  NSCreationTimeDocumentAttribute,
                              [self customDateWithYear:2006 month:5 day:4 hour:3 minute:2 second:1],  NSModificationTimeDocumentAttribute,
                              @"Manager",        NSManagerDocumentAttribute,
                              @"Category",       NSCategoryDocumentAttribute,
                              nil
                              ];
    
    [document setMetadata: metaData];
    
    NSDictionary *rereadDocumentProperties;
    
    NSData *rtf = [document RTF];
    NSAttributedString *rereadString = [[NSAttributedString alloc] initWithRTF:rtf documentAttributes:&rereadDocumentProperties];
    
    STAssertEqualObjects([rereadString string], @"abc\n", @"Invalid content");
    
    STAssertEqualObjects([rereadDocumentProperties objectForKey:NSTitleDocumentAttribute], @"Title", @"Invalid meta data");
    STAssertEqualObjects([rereadDocumentProperties objectForKey:NSCompanyDocumentAttribute], @"Company", @"Invalid meta data");
    STAssertEqualObjects([rereadDocumentProperties objectForKey:NSCopyrightDocumentAttribute], @"Copyright", @"Invalid meta data");
    STAssertEqualObjects([rereadDocumentProperties objectForKey:NSSubjectDocumentAttribute], @"Subject", @"Invalid meta data");
    STAssertEqualObjects([rereadDocumentProperties objectForKey:NSAuthorDocumentAttribute], @"Author", @"Invalid meta data");
    STAssertEqualObjects([rereadDocumentProperties objectForKey:NSKeywordsDocumentAttribute], ([NSArray arrayWithObjects: @"Keyword 1", @"Keyword 2", nil]), @"Invalid meta data");
    STAssertEqualObjects([rereadDocumentProperties objectForKey:NSCommentDocumentAttribute], @"Comment", @"Invalid meta data");
    STAssertEqualObjects([rereadDocumentProperties objectForKey:NSManagerDocumentAttribute], @"Manager", @"Invalid meta data");
    STAssertEqualObjects([rereadDocumentProperties objectForKey:NSCreationTimeDocumentAttribute], 
                         [self customDateWithYear:2001 month:2 day:3 hour:4 minute:5 second:6], @"Invalid meta data");
    STAssertEqualObjects([rereadDocumentProperties objectForKey:NSModificationTimeDocumentAttribute], 
                         [self customDateWithYear:2006 month:5 day:4 hour:3 minute:2 second:1], @"Invalid meta data");
}

@end
