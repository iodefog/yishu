//
//  EnumBase.m
//  mcare-model
//
//  Created by sam on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EnumBase.h"

@implementation EnumBase

@synthesize value;
@synthesize name;
@synthesize type;

- (id)init:(NSInteger)v with:(NSString *)n type:(NSString *)t
{
    self = [super init];
    value = v;
    name = [n copy];
    type = [t copy];
    return self;
}

- (NSArray *)getEnums
{
    return nil;
}

- (EnumBase *)getDefault
{
    return nil;
}

- (EnumBase *)parse:(NSInteger)v
{
    EnumBase *obj = [self getDefault];
    NSArray *array = [self getEnums];
    for (int i=0; i<array.count; i++) {
        EnumBase *eb = [array objectAtIndex:i];
        if (eb.value == v) {
            obj = eb;
            break;
        }
    }
    return obj;
}

- (EnumBase *)getType:(NSInteger)t
{
    EnumBase *obj = nil;
    NSArray *array = [self getEnums];
    for (int i=0; i<array.count; i++) {
        EnumBase *eb = [array objectAtIndex:i];
        if (eb.value == t) {
            obj = eb;
            break;
        }
    }
    return obj;
}

- (EnumBase *)getType2:(NSString *)t
{
    EnumBase *obj = [self getDefault];
    NSArray *array = [self getEnums];
    for (int i=0; i<array.count; i++) {
        EnumBase *eb = [array objectAtIndex:i];
        if ([eb.type isEqualToString:t] == YES) {
            obj = eb;
            break;
        }
    }
    return obj;
}

- (EnumBase *)getName:(NSString *)n
{
    EnumBase *obj = [self getDefault];
    NSArray *array = [self getEnums];
    for (int i=0; i<array.count; i++) {
        EnumBase *eb = [array objectAtIndex:i];
        if ([eb.name isEqualToString:n] == YES) {
            obj = eb;
            break;
        }
    }
    return obj;
}

- (NSInteger)getValue
{
    return value;
}

+ (EnumBase *)sharedInstance
{
    return nil;
}

- (NSDictionary *)JSON
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //
    [dict setObject:name forKey:@"name"];
    [dict setObject:[NSNumber numberWithInteger:value] forKey:@"value"];
    //
    return dict;
}


@end
