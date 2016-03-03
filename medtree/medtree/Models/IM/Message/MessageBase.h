//
//  ImRequestBase.h
//  jiayi-common
//
//  Created by sam on 6/6/15.
//  Copyright (c) 2015 孙晨辉. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageBase : NSObject

+ (NSNumber *)genRID;
+ (NSString *)getUserChatID;
+ (void)setUserChatID:(NSString *)cid;
+ (NSString *)getUserID;
+ (void)setUserID:(NSString *)uid;

@end

typedef enum {
    Send_Message_Status_Failure,
    Send_Message_Status_Success,
    Send_Message_Status_TimeOut,
} Send_Message_Status;

@interface ImRequestBase : NSObject

// data转换后的dict
@property (nonatomic, strong) NSDictionary *userInfo;

// 消息类型
@property (nonatomic, assign) NSInteger msgType;
// 客户端请求编号
@property (nonatomic, assign) long long rId;
// 用户 id
@property (nonatomic, strong) NSString *userChatId;

- (id)initWithData:(NSData *)data;

- (id)initWithMessage:(NSDictionary *)dict;

- (void)parseMessage:(NSDictionary *)dict;

- (NSDictionary *)toJson;

- (NSData *)toData;

@end


@interface ImResponseBase : ImRequestBase

// 状态码, 200 表示成功
@property (nonatomic, assign) long status;
// 具体错误信息
@property (nonatomic, strong) NSString  *errorMsg;
// AES密码
@property (nonatomic, strong) NSString *password;

@end


@interface ImMessageRequest : ImRequestBase

@property (nonatomic, strong) NSString  *remoteChatId;

@property (nonatomic, strong) NSString  *groupChatId;

@property (nonatomic, assign) NSInteger type;

@end


@interface ImMessageResponse : ImMessageRequest

@property (nonatomic, assign) long status;

@property (nonatomic, strong) NSString  *errorMsg;

@end

