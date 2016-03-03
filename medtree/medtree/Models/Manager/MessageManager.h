//
//  MessageManager.h
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "ServiceManager.h"
#import "DB+Public.h"
#import "DataManager.h"
#import "Messages.h"

typedef enum {
    MethodType_Start                            = 300,
    
    /*消息列表*/
    MethodType_SessionList                      = 301,
    MethodType_Delete_Session                   = 302,
    /** 第一次获取消息列表 */
    MethodType_MessageList                      = 303,
    /** 删除消息 */
    MethodType_DeleteMessage                    = 304,
    /** 拉取新消息 */
    MethodType_MessageList_Pull_NewMessage      = 307,
    /** 拉去旧数据 */
    MethodType_MessageList_Pull_HistoryMessage  = 308,
    /** 判断是否从服务器拉数据 */
    MethodType_MessageList_HistoryMessage       = 309,
    /** 获取屏蔽状态 */
    MethodType_Refuse_Message                   = 320,
    MethodType_PUT_Refuse_Message               = 321,
    
    MethodType_Message_Notify_New               = 350,  // 拉取新通知数据
    MethodType_Message_Notify_History           = 351,  // 拉取历史通知数据
    MethodType_Message_Job_Push                 = 352,
    
    MethodType_End                              = 399,
} MethodType_Message;

typedef NS_ENUM(NSInteger, MethodType_MessageSetting)
{
    MethodType_MessageSetting_Get = 360,
    MethodType_MessageSetting_Put = 361,
};

@class MessageDTO;
@class SessionDTO;

@interface MessageManager : DataManager

+ (void)getSessionList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteSession:(SessionDTO *)dto success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getMessageList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)addMessage:(MessageDTO *)dto success:(SuccessBlock)success failure:(FailureBlock)failure;
// sync unread 调用
+ (void)addSession:(SessionDTO *)dto success:(SuccessBlock)success failure:(FailureBlock)failure;
/** 存储pull old消息 */
+ (void)addMessages:(NSArray *)messages type:(PullOldMsgType)type deltaTime:(NSTimeInterval)deltaTime success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)updateMessage:(MessageDTO *)dto success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)markMessageStatus:(NSString *)messageID status:(NSInteger)status;
+ (void)markAllPendingAsError;
/** 检查消息列表的连续性 */
+ (void)checkMessageContinuity:(NSArray *)messages;
/** 更新上传失败的资源消息的状态 */
+ (void)updateMessageUploadFailure:(MessageDTO *)dto success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getMessageUnreadCounts:(DictionaryBlock)result sessions:(NSArray *)sessions;
+ (void)getAllMessageUnreadCounts:(DictionaryBlock)result;

/** 进入某个对话，刷新未读数的信息 */
+ (void)updateSessionUnreadStatus:(NSString *)sessionID;

+ (void)loadCacheData;
+ (NSMutableArray *)getSessionIDs;

/** 进入后，读取未读消息 */
+ (void)readUnReadMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (NSDictionary *)unReadMessageTransformWithDict:(NSDictionary *)dict;

/** 获取历史数据 */
+ (void)getHistoryMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
/** 获取pull old 的新数据 */
+ (void)getNewMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
/** 获取当前会话最大的remoteid */
+ (void)getLastRemoteId:(ArrayBlock)result bySession:(NSString *)sessionId;

+ (NSInteger)getAllUnreadCount;

@end
