//
//  Keychain.m
//  hangcom-core
//
//  Created by lyuan on 14-6-10.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "Keychain.h"
#import "SSKeychain.h"

@implementation Keychain

+ (void)setValue:(NSString *)value key:(NSString *)key;
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:[NSString stringWithFormat:@"CFBundleIdentifier_%@",key]];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSString *bundleid = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
//    [SSKeychain deletePasswordForService:bundleid account:key];
//    [SSKeychain setPassword:value forService:bundleid account:key];
}

+ (NSString *)getValue:(NSString *)key
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"CFBundleIdentifier_%@",key]]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"CFBundleIdentifier_%@",key]];
    } else {
        return @"";
    }
    
//    NSString *bundleid = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
//    return [SSKeychain passwordForService:bundleid account:key];
}

@end
