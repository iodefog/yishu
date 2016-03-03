//
//  FeedDTO.m
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FeedDTO.h"
#import "DateUtil.h"
#import "JSONKit.h"

@implementation FeedDTO

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    self.feed_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"feed_id"] longLongValue]];
    self.feed_content = [self getStrValue:[dict objectForKey:@"feed_content"]];
    self.feed_time = [DateUtil convertTime:[self getStrValue:[dict objectForKey:@"feed_time"]] formate:@"yyyy-MM-dd HH:mm:ss"];
    self.tag = (NSArray *)[dict objectForKey:@"tag"];
    self.userID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"user_id"]];
    //
    self.images = (NSArray *)[dict objectForKey:@"images"];
    self.friends_activity = [dict objectForKey:@"friends_activity"];
    self.comment_count = [self getIntValue:[dict objectForKey:@"comment_count"]];
    self.like_count = [self getIntValue:[dict objectForKey:@"like_count"]];
    self.is_liked = [[dict objectForKey:@"is_liked"] boolValue];
    //
//    self.reference = [dict objectForKey:@"reference"];
    //
    {
        if (self.reference == nil) {
            self.reference = [[NSMutableDictionary alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"reference"] != [NSNull null] && [dict objectForKey:@"reference"] != nil) {
            NSDictionary *referenceData = [[dict objectForKey:@"reference"] objectFromJSONString];
            [self.reference removeAllObjects];
            [self.reference addEntriesFromDictionary:referenceData];
        }
    }
    {
        if (self.comments == nil) {
            self.comments = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"comments"] != [NSNull null] && [dict objectForKey:@"comments"] != nil) {
            NSArray *array = [dict objectForKey:@"comments"];
            [self.comments addObjectsFromArray:array];
        }
    }
    self.likes_str = [self getStrValue:[dict objectForKey:@"likes_summary"]];
    //
    return tf;
}

@end
