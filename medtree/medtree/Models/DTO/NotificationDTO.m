//
//  NotificationDTO.m
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationDTO.h"
#import "DateUtil.h"

@implementation NotificationDTO

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    self.userID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"user_id"]];
    self.message = [self getStrValue:[dict objectForKey:@"message"]];
    self.ticket = [self getStrValue:[dict objectForKey:@"ticket"]];
    self.parent_ticket = [self getStrValue:[dict objectForKey:@"parent_ticket"]];
    self.status = [self getIntValue:[dict objectForKey:@"status"]];
//    self.type = [self getIntValue:[dict objectForKey:@"type"]];
    self.time = [DateUtil convertTime:[dict objectForKey:@"create_time"]];
    self.processed = [[dict objectForKey:@"processed"] boolValue];
    //
    return tf;
}

@end
