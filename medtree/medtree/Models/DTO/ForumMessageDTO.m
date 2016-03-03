//
//  ForumMessageDTO.m
//  medtree
//
//  Created by 陈升军 on 15/3/14.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ForumMessageDTO.h"
#import "DateUtil.h"

@implementation ForumMessageDTO

- (BOOL)parse:(NSDictionary *)dict
{
    NSLog(@"%@",dict);
    self.ref_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"ref_id"] longLongValue]];
    self.from_user = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"from_user"] longLongValue]];
    {
        long long time = [[dict objectForKey:@"timestamp"] longLongValue];
        self.timestamp = [DateUtil convertTimeFromNumber:[NSNumber numberWithLongLong:time/1000]];
    }

    self.ref_type = [self getIntValue:[dict objectForKey:@"ref_type"]];

    self.message = [self getStrValue:[dict objectForKey:@"message"]];
    self.ref_title = [self getStrValue:[dict objectForKey:@"ref_title"]];
    
    return YES;
}

@end
