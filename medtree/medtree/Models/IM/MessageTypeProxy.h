//
//  MessageTypeProxy.h
//  medtree
//
//  Created by sam on 6/13/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserDTO;

typedef NS_ENUM(NSInteger, MessageType) {
    MessageTypeInstanceText                 = 1,    // 文本消息
    MessageTypeInstanceImage                = 2,    // 图片消息
    MessageTypeInstanceVoice                = 3,    // 声音消息
    MessageTypeInstanceVideo                = 4,    // 视频消息
    MessageTypeNewFriend                    = 10,   // 新朋友
    MessageTypeIMMessageNotify              = 20,   // IM消息
    MessageTypeNoticeNotify                 = 30,   // 通知列表消息
    MessageTypeActivityNotify               = 40,   // 活动
    MessageTypeArticleNotify                = 50,   // 文章
    MessageTypeDiscussNotify                = 60,   // 讨论
    MessageTypeWebNotify                    = 70,   // 网页
    MessageTypeRelation                     = 100,  // 人脉关系变动
    MessageTypeCerification                 = 110,  // 身份认证信息
    MessageTypeNewFeed                      = 120,  // 动态更新
    MessageTypeNewActivity                  = 130,  // 活动更新
    MessageTypeJobNotify                    = 140,  // 简历状态更新
    MessageTypeNewJobPushNotify             = 150,  // 小助手职位推送
};

@interface MessageTypeProxy : NSObject

+ (NSString *)getMineType:(NSInteger)type;
+ (NSInteger)getMessageType:(NSString *)type;
+ (NSString *)getSessionKeyFromUser:(UserDTO *)user;
+ (NSString *)getSessionKey:(NSString *)from with:(NSString *)to;
+ (NSString *)getTargetID:(NSString *)from with:(NSString *)to;

/** 判断发送方是否是本人 */
+ (BOOL)isLocalFromUserID:(NSString *)from;

@end
