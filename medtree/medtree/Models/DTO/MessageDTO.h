//
//  MessageDTO.h
//  medtree
//
//  Created by sam on 8/14/14.
//  copyright (c) 2014 sam. All rights reserved.
//

#import "DTOBase.h"
#import "MessageTypeProxy.h"

@class UserDTO;

typedef enum {
    MessageHide = 0,
    MessagePending,
    MessageFail,
    MessageSent,
    MessageIgnore,
    //
    MessageUploading,
    MessageUploadFail,
    
    MessageUnRead = 10,
    MessageRead
} MessageStatus;

typedef NS_ENUM(NSUInteger, SessionType) {
    SessionTypeAll          = 1,
    SessionTypeSingle       = 2,
    SessionTypeGroup        = 3,
};

@interface MessageDTO : DTOBase

@property (nonatomic, strong) NSString      *messageID;         // chat ID   rid
@property (nonatomic, assign) NSInteger     remoteID;           // 每个会话中消息的唯一ID 用来对消息排序
@property (nonatomic, strong) NSString      *sessionID;         // userId ID fromID-toID
@property (nonatomic, strong) NSString      *fromUserID;        // 与sessionID对应，指自己的userID
@property (nonatomic, strong) NSString      *toUserID;          // 与sessionID对应，指对方的userID
@property (nonatomic, strong) NSString      *fromID;            // 环信ID 自己 非2000XXX格式
@property (nonatomic, strong) NSString      *toID;              // 环信ID 对方 非2000XXX格式  remote_chat_id
@property (nonatomic, strong) NSString      *content;
/** 发送方为自己时有数据 */
@property (nonatomic, strong) NSString      *remoteToID;
/** 入库时间 */
@property (nonatomic, strong) NSDate        *createTime;
@property (nonatomic, strong) NSDate        *updateTime;        // 更新时间
@property (nonatomic, assign) MessageStatus status;
@property (nonatomic, assign) BOOL          isShowTime;         // 是否显示时间
@property (nonatomic, assign) BOOL          isFromSelf;         //
@property (nonatomic, strong) UserDTO       *fromUser;
@property (nonatomic, strong) UserDTO       *toUser;

@property (nonatomic, assign) MessageType   type;               // 决定是哪类信息，对应 Message_Type
@property (nonatomic, assign) SessionType   sessionType;        // 会话类型
@property (nonatomic, assign) NSInteger     errorCode;          // 错误编码
//@property (nonatomic, strong) NSDictionary  *data;              // 发送
@property (nonatomic, strong, readonly) NSString      *photoUrl;               // 消息url
@property (nonatomic, strong, readonly) NSString      *photoFile;

@end
