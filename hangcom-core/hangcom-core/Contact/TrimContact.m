//
//  TrimContact.m
//  contactutil
//
//  Created by sam on 13-5-29.
//  Copyright (c) 2013年 sam. All rights reserved.
//

#import "TrimContact.h"
#import "ContactInfo.h"

@implementation TrimContact

+ (NSMutableDictionary *)trimContactNames:(NSDictionary *)dict process:(TransGroup)process
{
    NSMutableDictionary *contacts = [NSMutableDictionary dictionary];
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    //
    NSArray *values = dict.allValues;
    for (int i=0; i<values.count; i++) {
        ContactInfo *ci = [values objectAtIndex:i];
        NSString *key = ci.name;
        NSMutableArray *array = [contacts objectForKey:key];
        if (array == nil) {
            array = [NSMutableArray array];
            [contacts setObject:array forKey:key];
        }
        [array addObject:ci];
        if (array.count > 1) {
            ContactInfo *ci = [array objectAtIndex:0];
            process(ci.name, TrimContact_Name);
            [filters setObject:array forKey:key];
        }
    }
    //
    return filters;
}

+ (NSMutableDictionary *)trimContactPhones:(NSDictionary *)dict process:(TransGroup)process
{
    NSMutableDictionary *contacts = [NSMutableDictionary dictionary];
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    //
    NSArray *values = dict.allValues;
    for (int i=0; i<values.count; i++) {
        ContactInfo *ci = [values objectAtIndex:i];
        for (int j=0; j<ci.phones.count; j++) {
            NSString *phone = [ContactUtil formatPhone:[ci.phones objectAtIndex:j]];
            NSMutableArray *array = [contacts objectForKey:phone];
            if (array == nil) {
                array = [NSMutableArray array];
                [contacts setObject:array forKey:phone];
            }
            [array addObject:ci];
            if (array.count > 1) {
                process(phone, TrimContact_Phone);
                [filters setObject:array forKey:phone];
            }
        }
    }
    //
    return filters;
}

+ (NSMutableArray *)getTrimContactByPhone:(NSDictionary *)dict process:(TransInfo)process
{
    NSMutableArray *contacts = [NSMutableArray array];
    NSArray *values = dict.allValues;
    NSInteger total = values.count;
    for (int i=0; i<total; i++) {
        BOOL isFind = NO;
        ContactInfo *ci = [values objectAtIndex:i];
        for (int j=0; j<ci.phones.count; j++) {
            if ([ContactUtil isNeedFormatPhone:[ci.phones objectAtIndex:j]]) {
                [contacts addObject:ci];
                if (process) {
                    process(ci, i, total);
                }
                isFind = YES;
                break;
            }
        }
        if (isFind == YES) {
            NSMutableString *str = [NSMutableString string];
            [str appendFormat:@"%@ :", ci.name];
            for (int i=0; i<ci.phones.count; i++) {
                if ([ContactUtil isNeedFormatPhone:[ci.phones objectAtIndex:i]]) {
                    [str appendFormat:@" %@", [ci.phones objectAtIndex:i]];
                }
            }
            //NSLog(@"getTrimContactByPhones: %@", str);
        }
    }
    return contacts;
}

+ (NSMutableArray *)getTrimContactByName:(NSDictionary *)dict process:(TransInfo)process
{
    NSMutableArray *contacts = [NSMutableArray array];
    NSArray *values = dict.allValues;
    NSInteger total = values.count;
    for (int i=0; i<total; i++) {
        ContactInfo *ci = [values objectAtIndex:i];
        if ([ContactUtil isNeedFormatName:ci] == YES) {
            [contacts addObject:ci];
            if (process) {
                process(ci, i, total);
            }
            //NSLog(@"getTrimContactByName: %@ %@", ci.fname, ci.lname);
        }
    }
    return contacts;
}

@end
