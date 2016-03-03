//
//  MessageDTO.m
//  medtree
//
//  Created by sam on 8/14/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "MessageDTO.h"
#import "DateUtil.h"
#import "MessageTypeProxy.h"
#import "UserDTO.h"
#import <JSONKit.h>

@implementation MessageDTO

- (BOOL)parse:(NSDictionary *)dict
{
    if (![dict objectForKey:@"r_id"]) {
        self.sessionID = [self getStrValue:[dict objectForKey:@"session"]];
        self.messageID = [self getStrValue:[dict objectForKey:@"messageid"]];
        self.fromUserID = [self getStrValue:[dict objectForKey:@"fromuser"]];
        self.fromID = [self getStrValue:[dict objectForKey:@"from"]];
        self.toUserID = [self getStrValue:[dict objectForKey:@"touser"]];
        self.toID = [self getStrValue:[dict objectForKey:@"to"]];
        self.status = (MessageStatus)[self getIntValue:[dict objectForKey:@"status"]];
        self.type = [self getIntValue:[dict objectForKey:@"type"]];
        self.sessionType = [self getIntValue:dict[@"sessionType"]];
        long long time = [[dict objectForKey:@"time"] longLongValue];
        self.updateTime = [DateUtil convertTimeFromNumber:[NSNumber numberWithLongLong:time / 1000]];
        self.content = [self getStrValue:[dict objectForKey:@"content"]];
        self.remoteToID = self.toID;
//        self.url = [self getStrValue:[dict objectForKey:@"url"]];
    } else {
        self.sessionType = [self getIntValue:dict[@"type"]];
        if (dict[@"from_chat_id"]) { // pull_old_request 解析
            self.content = [self getStrValue:dict[@"content"]];
            self.fromID = [self getStrValue:dict[@"from_chat_id"]];
            self.fromUserID = [self getStrValue:[dict objectForKey:@"from_user_id"]];
            self.toID = [self getStrValue:dict[@"to_chat_id"]];
            self.toUserID = [self getStrValue:[dict objectForKey:@"to_user_id"]];
            self.messageID = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"r_id"] longLongValue]];
        } else {  // send_msg_request、new_msg_info 解析
            self.messageID = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"msg_r_id"] longLongValue]];
            self.fromID = [self getStrValue:dict[@"user_chat_id"]];
            self.toID = [self getStrValue:[dict objectForKey:@"remote_chat_id"]];
        }
        
        if ([dict objectForKey:@"maxMsgId"]) {
            self.remoteID = [self getIntValue:[dict objectForKey:@"maxMsgId"]];
        } else if ([dict objectForKey:@"msg_id"]) {
            self.remoteID = [self getIntValue:[dict objectForKey:@"msg_id"]];
        }
        
        NSString *mineType = [self getStrValue:[dict objectForKey:@"mine_type"]];
        
        if (mineType.length > 0) { //收到消息
            self.type = [MessageTypeProxy getMessageType:mineType];
        }
        
        if (self.sessionType == SessionTypeGroup) {
            self.sessionID = [self getStrValue:dict[@"group_chat_id"]];
            NSString *fromUserID = [self getStrValue:dict[@"from_user_id"]];
            self.toID = [MessageTypeProxy isLocalFromUserID:fromUserID]?[self getStrValue:dict[@"group_id"]]:@"";
            self.remoteToID = self.toID;
            self.toUserID = [self getStrValue:dict[@"group_chat_id"]];
        } else if (self.sessionType == SessionTypeSingle){
            self.sessionID = [MessageTypeProxy getSessionKey:self.fromID with:self.toID];
            NSString *fromUserID = [self getStrValue:dict[@"from_user_id"]];
            self.remoteToID = [MessageTypeProxy isLocalFromUserID:fromUserID]?[self getStrValue:dict[@"to_user_id"]]:@"";
        }
        
        NSTimeInterval time = [self getDoubleValue:dict[@"send_time"]];
        self.updateTime = [NSDate dateWithTimeIntervalSince1970:time/1000];
    }
    return YES;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"remotedId -- %ld \n content -- %@", (long)self.remoteID, self.content];
}

- (NSString *)photoUrl
{
    if (self.type == MessageTypeInstanceImage) {
        if (self.status == MessageSent || self.status == MessageHide) {
            NSDictionary *dict = [self.content objectFromJSONString];
            return [[MedGlobal getPicHost:ImageType_Orig] stringByAppendingPathComponent:dict[@"image"][@"path"]];
        } else {
            return @"";
        }
    } else {
        return @"";
    }
}

- (NSString *)photoFile
{
    if (self.type == MessageTypeInstanceImage) {
        if (self.status == MessageUploading || self.status == MessageUploadFail) {
            NSDictionary *dict = [self.content objectFromJSONString];
            return dict[@"image"][@"path"];
        } else {
            return @"";
        }
    } else {
        return @"";
    }
}

@end
