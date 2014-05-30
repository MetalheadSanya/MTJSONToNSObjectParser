//
//  MTJSONToNSObjectParser.podspec.h
//  MTJSONToNSObjectParser.podspec
//
//  Created by Alexandr Zalutskiy on 30.05.14.
//  Copyright (c) 2014 Alexandr Zalutskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTJSONToNSObjectParser : NSObject

// Extract a class of a property
+ (Class) extractClassFromPropertyName:(NSString*) propertyName ofClass: (Class) objClass;
// Parse a JSON objects into a objective-c class
+ (id) parseJSONObject:(NSDictionary*) jsonObj intoObjectiveCClass: (Class) objCClass;
// Parse an object into a JSON object
+ (NSData*) parseObjectIntoJSONData:(id) object  error:(NSError*__autoreleasing*)error;
// Parse an object into get params string
+ (NSString*) parseObjectIntoGetParamsString:(id) object;

@end
