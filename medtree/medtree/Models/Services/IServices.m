//
//  IServices.m
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "IServices.h"

@implementation IServices

+ (NSDictionary *)getLoginHeader
{
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    return header;
}

+ (NSDictionary *)getLoginBody:(NSString *)account password:(NSString *)password
{
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    return header;
}

@end
