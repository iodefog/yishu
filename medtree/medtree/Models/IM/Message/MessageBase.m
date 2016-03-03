//
//  ImRequestBase.m
//  jiayi-common
//
//  Created by sam on 6/6/15.
//  Copyright (c) 2015 孙晨辉. All rights reserved.
//

#import "MessageBase.h"
#import "DateUtil.h"
#import "JSONKit.h"
#import "MessageBody.h"


@implementation MessageBase

+ (NSNumber *)genRID
{
    return [DateUtil convertNumberFromTime1000:[NSDate date]];
}

static NSString *userChatId;

+ (NSString *)getUserChatID
{
    return userChatId == nil ? @"" : userChatId;
}

+ (void)setUserChatID:(NSString *)cid
{
    userChatId = cid;
}

static NSString *userId;

+ (NSString *)getUserID
{
    return userId == nil ? @"" : userId;
}

+ (void)setUserID:(NSString *)uid
{
    userId = uid;
}

@end


@implementation ImRequestBase

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        [self parseData:data];
    }
    return self;
}


- (id)initWithMessage:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self parseMessage:dict];
    }
    return self;
}


- (void)parseData:(NSData *)data
{
    MessageBody *mb = [MessageBody decode:data];
    //
    NSString *str = [[NSString alloc] initWithData:mb.data encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[str objectFromJSONString]];
    [dict setValue:[NSNumber numberWithInteger:mb.type] forKey:@"msg_type"];
    [self parseMessage:dict];
}

- (void)parseMessage:(NSDictionary *)dict
{
    if (dict) {
        self.userInfo = dict;
        //
        self.msgType = [[dict objectForKey:@"msg_type"] integerValue];
        //
        if ([dict objectForKey:@"r_id"]) {
            self.rId = [[dict objectForKey:@"r_id"] longLongValue];
        } else {
            self.rId = [[MessageBase genRID] longLongValue];
        }
        if ([dict objectForKey:@"user_chat_id"]) {
            self.userChatId = [dict objectForKey:@"user_chat_id"];
        } else {
            self.userChatId = [MessageBase getUserChatID];
        }
    }
}

- (NSDictionary *)toJson
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.userInfo];
    [dict setValue:[NSNumber numberWithLongLong:self.rId] forKey:@"r_id"];
    [dict setValue:self.userChatId forKey:@"user_chat_id"];
    return dict;
}

- (NSData *)toData
{
    MessageBody *mb = [[MessageBody alloc] init];
    mb.type = self.msgType;
    //
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:[self toJson]];
    [body removeObjectForKey:@"msg_type"];
    //
    mb.data = [[body JSONString] dataUsingEncoding:NSUTF8StringEncoding];
    return [MessageBody encode:mb];
}

@end


@implementation ImResponseBase

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    //
    if (dict) {
        self.status = [[dict objectForKey:@"status"] longValue];
        self.errorMsg = [dict objectForKey:@"err_msg"];
        self.password = [dict objectForKey:@"password"];
    }
}

- (NSDictionary *)toJson
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super toJson]];
    [dict setValue:[NSNumber numberWithLong:self.status] forKey:@"status"];
    [dict setValue:self.errorMsg forKey:@"err_msg"];
    return dict;
}

@end


@implementation ImMessageRequest

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    //
    if (dict) {
        self.remoteChatId = [dict objectForKey:@"remote_chat_id"];
        self.groupChatId = [dict objectForKey:@"group_chat_id"];
        self.type = [[dict objectForKey:@"type"] integerValue];
    }
}

@end


@implementation ImMessageResponse

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    //
    if (dict) {
        self.status = [[dict objectForKey:@"status"] longValue];
        self.errorMsg = [dict objectForKey:@"err_msg"];
    }
}

@end

