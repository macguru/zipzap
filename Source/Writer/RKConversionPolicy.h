//
//  RKConversionPolicy.h
//  RTFKit
//
//  Created by Friedrich Gräter on 15.08.13.
//  Copyright (c) 2013 The Soulmen. All rights reserved.
//

/*!
 @abstract Policies for converting RTF files. Used to set compatibility options for different target applications (e.g. Microsoft Word, Pages).

 @const RKConversionPolicyConvertAttachments			Specifies that image attachments should be converted (should be set for RTFD and Word, but not for plain system RTF).
 @const	RKConversionPolicyReferenceAttachments			Specifies that image attachments should be referenced, instead of directly embedded. (should be set for RTFD)

 @const RKConversionPolicyPositionListMarkerUsingTabs	Specifies that list markers should be positioned using tabs, instead of paragaph indents only (should be set for system-compatible RTF).
 
 */
typedef enum : NSUInteger {
    RKConversionPolicyConvertAttachments			= (1 << 0),
	RKConversionPolicyReferenceAttachments			= (1 << 1),
	
	RKConversionPolicyPositionListMarkerUsingTabs	= (1 << 2)
} RKConversionPolicy;


/*!
 @abstract Creates a new conversion policy ensuring that images are not exported.
 @discussion May be used to disable the export of images in nested strings (e.g. footnotes).
 */
#define RKConversionPolicySkippingAttachments(__policy)		((__policy) & (~(RKConversionPolicyConvertAttachments | RKConversionPolicyReferenceAttachments)))