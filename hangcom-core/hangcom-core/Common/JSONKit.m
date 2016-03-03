//
//  JSONKit.m
//  hangcom-core
//
//  Created by tangshimi on 6/8/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "JSONKit.h"

@implementation JSONKit

@end

@implementation NSObject (NSObject_JsonWriting)

- (NSString *)JSONString
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                           options:0
                                                             error:&error];
        if (error == nil) {
            NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return json;
        } else {
            NSLog(@"Json write error: %@ \n", [error description]);
        }
    }
    
    return nil;
}

@end

@implementation NSString (NSString_JsonParsing)

- (id)objectFromJSONString
{
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) {
        return nil;
    }
    
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (jsonObj == nil || error != nil) {
        NSLog(@"Json parse error: %@ \n", [error localizedDescription]);
        return nil;
    }
    
    return jsonObj;
}

@end
