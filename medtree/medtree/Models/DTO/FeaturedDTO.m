//
//  FeaturedDTO.m
//  medtree
//
//  Created by 陈升军 on 15/4/1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "FeaturedDTO.h"
#import "DateUtil.h"

@implementation FeaturedDTO

- (BOOL)parse:(NSDictionary *)dict
{
    NSLog(@"%@",dict);
    self.featuredID = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"id"] longLongValue]];
    {
        long long time = [[dict objectForKey:@"created"] longLongValue];
        self.created = [DateUtil convertTimeFromNumber:[NSNumber numberWithLongLong:time/1000]];
    }
    
    self.view_count = [self getIntValue:[dict objectForKey:@"view_count"]];
    self.style= [self getIntValue:[dict objectForKey:@"style"]];
    
    self.title = [self getStrValue:[dict objectForKey:@"title"]];
    self.summary = [self getStrValue:[dict objectForKey:@"summary"]];
    
    self.name = [self getStrValue:[dict objectForKey:@"name"]];
    self.category = [self getStrValue:[dict objectForKey:@"category"]];
    
    //
    {
        if (self.images == nil) {
            self.images = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"images"] != [NSNull null] && [dict objectForKey:@"images"] != nil) {
            [self.images removeAllObjects];
            NSArray *array = [dict objectForKey:@"images"];
            [self.images addObjectsFromArray:array];
        }
    }
    
    //
    {
        if (self.urls == nil) {
            self.urls = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"urls"] != [NSNull null] && [dict objectForKey:@"urls"] != nil) {
            [self.urls removeAllObjects];
            NSArray *array = [dict objectForKey:@"urls"];
            [self.urls addObjectsFromArray:array];
        }
    }
    
    return YES;
}

@end
