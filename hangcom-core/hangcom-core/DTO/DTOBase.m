//
//  DTOBase.m
//  mcare-core
//
//  Created by sam on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DTOBase.h"

@implementation DTOBase

- (id)init:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        BOOL tf = [self parse:dict];
        if (tf == NO) {
            self = nil;
        } else {
            rawInfo = [[NSMutableDictionary alloc] init];
            [rawInfo addEntriesFromDictionary:dict];
        }
    }
    return self;
}

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    return tf;
}

- (BOOL)parse2:(NSDictionary *)result
{
    BOOL tf = YES;
    return tf;
}

- (NSDictionary *)JSON
{
    return rawInfo;
}

- (void)setJSON:(NSDictionary *)JSON
{
    if (rawInfo == nil) {
        rawInfo = [[NSMutableDictionary alloc] init];
    }
    [rawInfo removeAllObjects];
    [rawInfo addEntriesFromDictionary:JSON];
}

- (NSInteger)getIntValue:(NSNumber *)num
{
    NSInteger n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num intValue];
    }
    return n;
}

- (BOOL)getBoolValue:(NSNumber *)num
{
    BOOL result = NO;
    if ((NSObject *)num != [NSNull null]) {
        result = [num boolValue];
    }
    return result;
}

- (float)getFloatValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num floatValue];
    }
    return n;
}

- (double)getDoubleValue:(NSNumber *)num
{
    double n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num doubleValue];
    }
    return n;
}

- (NSString *)getStrValue:(NSString *)str
{
    NSString *s = @"";
    if ((NSObject *)str != [NSNull null] && str != nil) {
        s = [NSString stringWithFormat:@"%@", str];
    }
    return s;
}

- (NSDate *)getDateValue:(id)date
{
    NSDate *d = nil;
    if ((NSObject *)date != [NSNull null] && date != nil) {
        d = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    }
    return d;
}

- (NSArray *)getArrayValue:(NSArray *)arr
{
    if ((NSObject *)arr != [NSNull null]) {
        return arr;
    }
    return [[NSArray alloc] init];
}

- (NSString *)toParam
{
    return @"";
}

- (void)updateInfo:(NSObject *)obj forKey:(NSString *)key
{
    if ([rawInfo objectForKey:@"result"]) {
        NSMutableDictionary *dict = [rawInfo objectForKey:@"result"];
        [rawInfo removeAllObjects];
        [rawInfo addEntriesFromDictionary:dict];
    }
    [rawInfo setObject:obj forKey:key];
}

- (NSString *)description
{
    return [super description];
}

@end
