//
//  MessageTypeProxy.m
//  medtree
//
//  Created by sam on 6/13/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MessageTypeProxy.h"
#import "MessageManager.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "MessageBase.h"

#define USE_IM_TCP

@implementation MessageTypeProxy

#pragma mark - 转换消息类型
+ (NSString *)getMineType:(NSInteger)type
{
    NSString *mineType = @"text/plain";
    if (type == MessageTypeInstanceImage) {
        mineType = @"image/jpeg";
    } else if (type == MessageTypeInstanceVoice) {
        mineType = @"audio/amr";
    } else if (type == MessageTypeInstanceVideo) {
        mineType = @"video/mp4";
    }
    return mineType;
}

+ (NSInteger)getMessageType:(NSString *)mineType
{
    NSInteger type = 0;
    if ([mineType hasPrefix:@"text"]) {
        type = MessageTypeInstanceText;
    } else if ([mineType hasPrefix:@"image"]) {
        type = MessageTypeInstanceImage;
    } else if ([mineType hasPrefix:@"audio"]) {
        type = MessageTypeInstanceVoice;
    } else if ([mineType hasPrefix:@"video"]) {
        type = MessageTypeInstanceVideo;
    }
    return type;
}

+ (NSString *)getSessionKeyFromUser:(UserDTO *)user
{
    NSString *sessionId = user.chatID;
    return sessionId;
}

+ (NSString *)getSessionKey:(NSString *)from with:(NSString *)to
{
    NSString *sessionId = nil;
    NSString *chatId = [[AccountHelper getAccount] chatID];
    if ([from isEqualToString:chatId]) {
        sessionId = to;
    } else {
        sessionId = from;
    }
    return sessionId;
}

+ (NSString *)getTargetID:(NSString *)from with:(NSString *)to
{
    NSString *targetId = nil;
    NSString *chatId = [[AccountHelper getAccount] userID];
    if ([from isEqualToString:chatId]) {
        targetId = to;
    } else {
        targetId = from;
    }
    return targetId;
}

+ (BOOL)isLocalFromUserID:(NSString *)from
{
    return [from isEqualToString:[[AccountHelper getAccount] userID]];
}

@end
