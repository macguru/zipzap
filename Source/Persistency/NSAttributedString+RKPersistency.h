//
//  NSAttributedString+RKPersistency.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Allows to serialize an attributed string that uses RTFKit features to a property list
 */
@interface NSAttributedString (RKPersistency)

/*!
 @abstract Specifies a mapping from names to classes of all attributes that can be persisted.
 */
+ (NSDictionary *)persistableAttributeTypes;

/*!
 @abstract Initializes an attributed string from its property list representation
 */
- (id)initWithRTFKitPropertyListRepresentation:(id)propertyList error:(NSError **)error;

/*!
 @abstract Serializes an attributed string to a property list representation
 */
- (id)RTFKitPropertyListRepresentation;

@end
