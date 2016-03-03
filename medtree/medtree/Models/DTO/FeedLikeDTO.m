//
//  FeedLikeDTO.m
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FeedLikeDTO.h"
#import "FeedDTO.h"
#import "DateUtil.h"

@implementation FeedLikeDTO

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    self.user_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"user_id"] longLongValue]];
    self.user_avatar = [self getStrValue:[dict objectForKey:@"user_avatar"]];
    self.user_name = [self getStrValue:[dict objectForKey:@"user_name"]];
    self.like_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"like_id"] longLongValue]];
    self.like_time = [DateUtil convertTime:[self getStrValue:[dict objectForKey:@"like_time"]] formate:@"yyyy-MM-dd HH:mm:ss"];
    self.target_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"target_id"] longLongValue]];
    self.target_type = [self getIntValue:[dict objectForKey:@"target_type"]];
    //
    self.feed = [[FeedDTO alloc] init:[dict objectForKey:@"feed"]];
    //
    return tf;
}

@end
