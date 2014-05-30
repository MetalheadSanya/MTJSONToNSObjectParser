//
//  MTJSONToNSObjectParser.m
//  MTJSONToNSObjectParser
//
//  Created by Alexandr Zalutskiy on 30.05.14.
//  Copyright (c) 2014 Alexandr Zalutskiy. All rights reserved.
//

#import "MTJSONToNSObjectParser.h"
#import <objc/runtime.h>

@implementation MTJSONToNSObjectParser

+ (Class) extractClassFromPropertyName:(NSString*) propertyName ofClass: (Class) objClass {
    // Get property by name
    objc_property_t property = class_getProperty(objClass, [propertyName UTF8String]);
    // Get attributes of property which contains class name
    const char *propertyAttrs = property_getAttributes(property);
    NSString *strProp = [NSString stringWithCString:propertyAttrs encoding:NSUTF8StringEncoding];
    // Extact class name from property attributes
    // Search begin of the class name
    NSRange rangeBegin = [strProp rangeOfString:@"@\""];
    // Search end of the class name
    NSRange rangeEnd = [strProp rangeOfString:@"\","];
    // Remove wrap (@"") from the class name
    NSString *className = [strProp substringWithRange:NSMakeRange(rangeBegin.length+1,rangeEnd.location-3)];
    // Return class got from the name
    return NSClassFromString(className);
}

+ (id) parseJSONObject:(NSDictionary*) jsonObj intoObjectiveCClass: (Class) objCClass {
    // Initialize target object
    id object = [[objCClass alloc] init];
    // Enumerate all attributes in JSON object
    [jsonObj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj != [NSNull null]) {
            // If JSON object contains nested object make recursive call for that object
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [object setValue:[MTJSONToNSObjectParser parseJSONObject:obj intoObjectiveCClass:[MTJSONToNSObjectParser extractClassFromPropertyName:key ofClass:objCClass]] forKey:key];
                // If JSON object doesn't contain nested object, just write value into object's property
            } else {
                [object setValue:[jsonObj valueForKey:key] forKey:key];
            }
        }
    }];
    // Return target object
    return object;
}

+ (NSData*) parseObjectIntoJSONData:(id) object  error:(NSError*__autoreleasing *)error {
    NSMutableDictionary* jsonDictionary = [[NSMutableDictionary alloc] init];
    uint propertyCount,i;
    // Get list of properties
    objc_property_t *properties = class_copyPropertyList([object class], &propertyCount);
    // Enumerate all properties and set values into a dictionary
    for (i = 0; i<propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if (propName) {
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];

            id value = [object valueForKey:propertyName];

            if (value) {
                [jsonDictionary setObject:value forKey:propertyName];
            }
        }
    }
    free(properties);
    // Serialize a dictionary into a JSON data
    NSData* data = nil;
    if (jsonDictionary.count > 0) {
        data = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error:error];
    }
    // Return JSON data
    return data;
}

+ (NSString*) parseObjectIntoGetParamsString:(id) object {
    // Initialize target object
    NSMutableString* getParams = [[NSMutableString alloc] initWithString:@""];
    // Get list of properties
    uint propertyCount,i;
    objc_property_t *properties = class_copyPropertyList([object class], &propertyCount);
    // Enumerate all properties and set values into a dictionary
    for (i = 0; i<propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if (propName) {
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];

            id value = [object valueForKey:propertyName];

            if (value) {
                if (i < propertyCount-1) {
                    [getParams appendFormat:@"%@=%@&",propertyName,value];
                } else {
                    [getParams appendFormat:@"%@=%@",propertyName,value];
                }
            }
        }
    }
    free(properties);
    // Return get params string
    return getParams;
}

@end
