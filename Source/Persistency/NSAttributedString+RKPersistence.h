//
//  NSAttributedString+RKPersistence.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPersistenceContext;

/*!
 @abstract Allows to serialize an attributed string that uses RTFKit features to a property list
 */
@interface NSAttributedString (RKPersistence)

/*!
 @abstract Registers a numeric attribute for serialization.
 */
+ (void)registerNumericAttributeForPersistence:(NSString *)attributeName;

/*!
 @abstract Registers a numeric attribute for serialization.
 @discussion Receives a mapping from enumeration value names to value.
 */
+ (void)registerNumericAttributeForPersistence:(NSString *)attributeName usingSignedEnumeration:(NSDictionary *)enumeration;

/*!
 @abstract Registers a numeric attribute for serialization.
 @discussion Receives a mapping from enumeration flag names to value.
 */
+ (void)registerNumericAttributeForPersistence:(NSString *)attributeName usingFlags:(NSDictionary *)flags;

/*!
 @abstract Registers a string attribute for serialization.
 */
+ (void)registerStringAttributeForPersistence:(NSString *)attributeName;

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
 @discussion Serializes all attributes as specified by 'persistableAttributeTypes'.
 */
- (id)RTFKitPropertyListRepresentation;

/*!
 @abstract Creates an attribute dictionary from its property list representation
 @discussion A persistence context must be provided that serializes additional data for certain attributes.
 */
+ (NSDictionary *)attributeDictionaryFromRTFKitPropertyListRepresentation:(id)serializedAttributes usingContext:(RKPersistenceContext *)context error:(NSError **)error;

/*!
 @abstract Serializes an attribute dictionary to its property list representation
 @discussion A persistence context must be provided that serializes additional data for certain attributes.
 */
+ (id)RTFKitPropertyListRepresentationForAttributeDictionary:(NSDictionary *)attributes usingContext:(RKPersistenceContext *)context;

@end
