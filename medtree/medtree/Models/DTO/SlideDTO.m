//
//  SlideDTO.m
//  medtree
//
//  Created by 陈升军 on 15/4/1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "SlideDTO.h"
#import "DateUtil.h"

@implementation SlideDTO

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    self.title = [self getStrValue:[dict objectForKey:@"title"]];
    self.name = [self getStrValue:[dict objectForKey:@"name"]];
    self.slideType = [self getIntValue:[dict objectForKey:@"slideType"]];
    //
    if (self.images == nil) {
        self.images = [[NSMutableArray alloc] init];
    }
    if ((NSObject *)[dict objectForKey:@"images"] != [NSNull null] && [dict objectForKey:@"images"] != nil) {
        NSArray *array = [dict objectForKey:@"images"];
        [self.images addObjectsFromArray:array];
    }
    if (self.urls == nil) {
        self.urls = [[NSMutableArray alloc] init];
    }
    if ((NSObject *)[dict objectForKey:@"urls"] != [NSNull null] && [dict objectForKey:@"urls"] != nil) {
        NSArray *array = [dict objectForKey:@"urls"];
        [self.urls addObjectsFromArray:array];
    }
    return tf;
}

@end
