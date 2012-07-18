//
//  RKPDFWriterTypes.h
//  RTFKit
//
//  Created by Friedrich Gräter on 18.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Rendering options for PDF output
 @const
 RKPDFWriterShowBoundingBoxes        Adds bounding boxes around the actually rendered text frames (intended for debugging layout settings)
 RKPDFWriterShowTextFrames           Adds text frames around text frames (intended for debugging layout settings)
 */
typedef enum : NSUInteger {
    RKPDFWriterShowBoundingBoxes     = 0,
    RKPDFWriterShowTextFrames        = 1,
}RKPDFWriterRenderingOptions;
