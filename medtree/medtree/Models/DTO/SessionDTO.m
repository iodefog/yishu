//
//  SessionDTO.m
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SessionDTO.h"
#import "DateUtil.h"
#import "MessageTypeProxy.h"
#import "AccountHelper.h"
#import "UserDTO.h"


@implementation SessionDTO

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    if (![dict objectForKey:@"msg"]) {
        if (![dict objectForKey:@"send_time"]) {
            self.sessionID = [self getStrValue:[dict objectForKey:@"session"]];
            self.remoteUserID = [MessageTypeProxy getTargetID:[self getStrValue:dict[@"fromuser"]] with:[self getStrValue:dict[@"touser"]]];
            self.content = [[MessageDTO alloc] init:dict];
            long long time = [[dict objectForKey:@"time"] longLongValue];
            self.updateTime = [DateUtil convertTimeFromNumber:[NSNumber numberWithLongLong:time/1000]];
        } else {
            self.content = [[MessageDTO alloc] init:dict];
            self.sessionID = [MessageTypeProxy getSessionKey:self.content.fromID with:self.content.toID];
            self.remoteUserID = [MessageTypeProxy getTargetID:self.content.toUserID with:self.content.fromUserID];
            self.updateTime = self.content.updateTime;
            self.unreadCount = [self getIntValue:dict[@"count"]];
        }
    } else {
        NSString *fromId = [self getStrValue:dict[@"remote_chat_id"]];
        NSString *toId = [self getStrValue:dict[@"user_chat_id"]];
        self.sessionID = [MessageTypeProxy getSessionKey:fromId with:toId];
        self.content = [[MessageDTO alloc] init:dict[@"msg"]];
        self.remoteUserID = [MessageTypeProxy getTargetID:self.content.toUserID with:self.content.fromUserID];
        self.updateTime = self.content.updateTime;
        self.unreadCount = [self getIntValue:dict[@"count"]];
    }
    self.sessionType = [self getIntValue:dict[@"type"]];
    //
    return tf;
}

@end
