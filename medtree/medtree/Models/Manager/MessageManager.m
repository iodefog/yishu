//
//  MessageManager.m
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "MessageManager.h"
#import "MessageDTO.h"
#import "SessionDTO.h"
#import "JSONKit.h"
#import "MedGlobal.h"

#import "UserManager.h"
#import "IMUtil+Message.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "MessageTypeProxy.h"
#import "Messages.h"

#import "IServices+NofityMessage.h"
#import "NotifyMessageDTO.h"
#import "PostManager.h"

@implementation MessageManager

+ (BOOL)isHit:(NSInteger)method
{
    if (method > MethodType_Start && method < MethodType_End) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    
    switch (method) {
        case MethodType_SessionList: {
            [MessageManager getSessionList:param success:success failure:failure];
            break;
        }
        case MethodType_MessageList: {
            [MessageManager getMessageList:param success:success failure:failure];
            break;
        }
        case MethodType_MessageList_Pull_NewMessage: {
            [MessageManager getNewMessage:param success:success failure:failure];
            break;
        }
        case MethodType_MessageList_Pull_HistoryMessage: {
            [MessageManager getHistoryMessages:param success:success failure:failure];
            break;
        }
        case MethodType_MessageList_HistoryMessage: {
            [MessageManager getHistoryMessage:param success:success failure:failure];
            break;
        }
        case MethodType_Message_Notify_New: {
            [MessageManager getLastestNotifyMessage:param success:success failure:failure];
            break;
        }
        case MethodType_Message_Notify_History: {
            [MessageManager getHistoryNotifyMessage:param success:success failure:failure];
            break;
        }
        case MethodType_Message_Job_Push: {
            [MessageManager getPushJobList:param success:success failure:failure];
            break;
        }
        case MethodType_MessageSetting_Get: {
            [MessageManager getDisturbState:param success:success failure:failure];
            break;
        }
        case MethodType_Refuse_Message: {
            [MessageManager getRefuseState:param success:success failure:failure];
            break;
        }
    }
}

+ (void)setData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    
    switch (method) {
        case MethodType_Delete_Session: {
            SessionDTO *dto = [param objectForKey:@"session"];
            [MessageManager deleteSession:dto success:success failure:failure];
            break;
        }
        case MethodType_MessageSetting_Put: {
            [MessageManager setDisturb:param success:success failure:failure];
            break;
        }
        case MethodType_PUT_Refuse_Message: {
            [MessageManager putRefuseState:param success:success failure:failure];
            break;
        }
    }
}

#pragma mark - Session -
#pragma mark Get DB Session List
+ (void)getSessionList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] selectAllSessions:^(NSArray *array) {
        success(array);
    }];
}

#pragma mark Delete Session
+ (void)deleteSession:(SessionDTO *)dto success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] deleteSession:dto];
    [[DB shareInstance] deleteMessages:dto.sessionID];
    [[MessageManager getSessionIDs] removeObject:dto.sessionID];
    success(dto);
}

#pragma mark - Store Sync Unread Session
+ (void)addSession:(SessionDTO *)dto success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if (dto.sessionID.length > 1) {
        if ([[MessageManager getSessionIDs] containsObject:dto.sessionID]) {
            [[DB shareInstance] updateUnreadSession:dto];
        } else {
            [[DB shareInstance] insertUnreadSession:dto];
            [[MessageManager getSessionIDs] addObject:dto.sessionID];
        }
        [[DB shareInstance] selectLastestRemoteid:^(NSNumber *remoteid) {
            if (remoteid.integerValue < dto.content.remoteID) {
                NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"max_msg_id": @(dto.content.remoteID), @"min_msg_id":remoteid,@"limit":@10, @"type": @(dto.sessionType)}];
                if (dto.sessionType == SessionTypeGroup) {
                    [param setObject:dto.content.toID forKey:@"group_chat_id"];
                } else {
                    [param setObject:[MessageTypeProxy getSessionKey:dto.content.fromID with:dto.content.toID] forKey:@"remote_chat_id"];
                }
                [param setObject:@(PullOldMsgRequestLatest) forKey:@"request_type"];
                [[IMUtil sharedInstance] pullOldMsg:param];
                if (success) {
                    success(nil);
                }
            }
        } session:dto.sessionID];
    }
}

#pragma mark - Message -
#pragma mark First Into MessageController Load Message Data
+ (void)getMessageList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *sessionID = [param objectForKey:@"sessionID"];
    [[DB shareInstance] selectMessages:^(NSArray *array) {
        for (int i = 0; i < array.count; i ++) {
            MessageDTO *dto = [array objectAtIndex:i];
            if ([dto.fromID isEqualToString:[[AccountHelper getAccount] chatID]]) {
                if (![[MessageManager getLocalMessageIDs] containsObject:dto.messageID]) {
                    [[MessageManager getLocalMessageIDs] addObject:dto.messageID];
                }
            }
        }
        [MessageManager checkMessageContinuity:array];
        success(array);
    } sessionID:sessionID];
}

#pragma mark Try To Pull History Message Data
+ (void)getHistoryMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *sessionID = [param objectForKey:@"sessionID"];
    NSDate *createTime = param[@"createTime"];
    NSNumber *messageID = [param objectForKey:@"remoteID"];
    [[DB shareInstance] selectMessages:^(NSArray *array) {
        for (int i=0; i < array.count; i++) {
            MessageDTO *dto = [array objectAtIndex:i];
            if ([dto.fromID isEqualToString:[[AccountHelper getAccount] chatID]]) {
                if (![[MessageManager getLocalMessageIDs] containsObject:dto.messageID]) {
                    [[MessageManager getLocalMessageIDs] addObject:dto.messageID];
                }
            }
        }
        [MessageManager checkMessageContinuity:array];
        success(array);
    } sessionID:sessionID createTime:createTime remoteID:messageID];
}

#pragma mark Pull History Message Data
+ (void)getHistoryMessages:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *sessionID = [param objectForKey:@"sessionID"];
    NSDate *createTime = param[@"createTime"];
    [[DB shareInstance] selectMessages:^(NSArray *array) {
        for (int i=0; i<array.count; i++) {
            MessageDTO *dto = [array objectAtIndex:i];
            if ([dto.fromID isEqualToString:[[AccountHelper getAccount] chatID]]) {
                if (![[MessageManager getLocalMessageIDs] containsObject:dto.messageID]) {
                    [[MessageManager getLocalMessageIDs] addObject:dto.messageID];
                }
            }
        }
        [MessageManager checkMessageContinuity:array];
        success(array);
    } sessionID:sessionID createTime:createTime];
}

#pragma mark Pull Lastest Message Data
+ (void)getNewMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *sessionID = [param objectForKey:@"sessionID"];
    NSDate *createTime = param[@"createTime"];
    [[DB shareInstance] selectNewMessage:^(NSArray *array) {
        for (int i=0; i<array.count; i++) {
            MessageDTO *dto = [array objectAtIndex:i];
            if ([dto.fromID isEqualToString:[[AccountHelper getAccount] chatID]]) {
                if (![[MessageManager getLocalMessageIDs] containsObject:dto.messageID]) {
                    [[MessageManager getLocalMessageIDs] addObject:dto.messageID];
                }
            }
        }
        success(array);
    } sessionID:sessionID createTime:createTime];
}

#pragma mark Check Message Data Continuity
+ (void)checkMessageContinuity:(NSArray *)messages
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (MessageDTO *dto in messages) { // 去除发送失败的
        if (dto.remoteID != 0) {
            [arrayM addObject:dto];
        }
    }
    NSSortDescriptor *descripter = [NSSortDescriptor sortDescriptorWithKey:@"remoteID" ascending:YES];
    NSArray *data = [arrayM sortedArrayUsingDescriptors:@[descripter]];
    if (data.count > 1) {
        int count = (int)data.count - 1;
        for (int i = count; i >= 1; i --) {
            MessageDTO *firstDto = data[i];
            MessageDTO *secondDto = data[i-1];
            if (firstDto.remoteID - secondDto.remoteID > 1) {
                NSMutableDictionary *info = [NSMutableDictionary dictionary];
                NSString *toID = firstDto.sessionID;
                [info setObject:toID forKey:@"remote_chat_id"];
                [info setObject:toID forKey:@"group_chat_id"];
                [info setObject:[NSNumber numberWithLongLong:secondDto.remoteID] forKey:@"min_msg_id"];
                [info setObject:[NSNumber numberWithLongLong:(firstDto.remoteID - 1)] forKey:@"max_msg_id"];
                [info setObject:@(firstDto.sessionType) forKey:@"type"];
                [info setObject:@(PullOldMsgRequestPointed) forKey:@"request_type"];
                [[IMUtil sharedInstance] pullOldMsg:info];
            }
        }
    }
}

#pragma mark Store Sending Message
+ (void)addMessage:(MessageDTO *)dto success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if (dto.sessionID.length > 1) {
        if ([dto.fromID isEqualToString:[[AccountHelper getAccount] chatID]]) {
            if ([[MessageManager getLocalMessageIDs] containsObject:dto.messageID]) {
                [[DB shareInstance] updateMessage:dto];
            } else {
                [[DB shareInstance] insertMessage:dto];
                [[MessageManager getLocalMessageIDs] addObject:dto.messageID];
            }
        } else {
            [[DB shareInstance] insertMessage:dto];
        }
        
        if ([[MessageManager getSessionIDs] containsObject:dto.sessionID]) {
            [[DB shareInstance] updateSession:dto];
        } else {
            [[DB shareInstance] insertSession:dto];
            [[MessageManager getSessionIDs] addObject:dto.sessionID];
        }
    }
}

#pragma mark Store Pull Old Message
+ (void)addMessages:(NSArray *)messages type:(PullOldMsgType)type deltaTime:(NSTimeInterval)deltaTime success:(SuccessBlock)success failure:(FailureBlock)failure
{
    switch (type) {
        case PullOldMsgRequestLatest: {
            [[DB shareInstance] insertLastestMessages:messages success:success];
            break;
        }
        case PullOldMsgRequestOld: {
            [[DB shareInstance] insertOldMessages:messages deltaTime:deltaTime success:success];
            break;
        }
        case PullOldMsgRequestPointed: {
            [[DB shareInstance] insertPointMessages:messages deltaTime:deltaTime success:success];
            break;
        }
    }
}

#pragma mark Clean Current Session Unread Count
+ (void)updateSessionUnreadStatus:(NSString *)sessionID
{
    if (sessionID.length > 1) {
        if ([[MessageManager getSessionIDs] containsObject:sessionID]) {
            [[DB shareInstance] clearUnreadCount:sessionID];
        }
    }
}

#pragma mark Update Message Status
+ (void)updateMessageUploadFailure:(MessageDTO *)dto success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] updateMessageStatus:dto];
}

#pragma mark Send Message Status
+ (void)updateMessage:(MessageDTO *)dto success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] updateMessageStatus:dto];
    [[DB shareInstance] updateSessionRemoteId:dto];
}

#pragma mark - Get All Unread Count
+ (NSInteger)getAllUnreadCount
{
    return [[DB shareInstance] getAllUnreadCount];
}

+ (void)loadCacheData
{
    [[MessageManager getSessionIDs] removeAllObjects];
    [[MessageManager getSessionIDs] addObjectsFromArray:[[DB shareInstance] selectSessionIDs]];
    //
    [[MessageManager getLocalMessageIDs] removeAllObjects];
}

+ (NSMutableArray *)getSessionIDs
{
    static NSMutableArray *ids = nil;
    if (ids == nil) {
        ids = [[NSMutableArray alloc] init];
    };
    return ids;
}

+ (NSMutableArray *)getLocalMessageIDs
{
    static NSMutableArray *ids = nil;
    if (ids == nil) {
        ids = [[NSMutableArray alloc] init];
    };
    return ids;
}

+ (void)getMessageUnreadCounts:(DictionaryBlock)result sessions:(NSArray *)sessions
{
    [[DB shareInstance] getMessageUnreadCounts:result sessions:sessions];
}

+ (void)getAllMessageUnreadCounts:(DictionaryBlock)result
{
    [[DB shareInstance] getAllMessageUnreadCounts:result];
}

+ (void)markMessageStatus:(NSString *)messageID status:(NSInteger)status
{
    [[DB shareInstance] markMessageStatus:messageID status:status];
}

+ (void)markAllPendingAsError
{
    [[DB shareInstance] markAllPendingAsError];
}

+ (void)getLastRemoteId:(ArrayBlock)result bySession:(NSString *)sessionId
{
    [[DB shareInstance] getLastRemoteId:result bySession:sessionId];
}

/**
 *  读取未读数
 */
+ (void)readUnReadMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices readUnReadMessage:param success:^(id JSON) {
//        NSDictionary *dict = (NSDictionary *)JSON;
        if ([[JSON objectForKey:@"success"] boolValue]) {
            success([JSON objectForKey:@"result"]);
        } else {
            success(nil);
        }
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (NSDictionary *)unReadMessageTransformWithDict:(NSDictionary *)dict
{
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];

    NSLog(@"messageDict ----------------------- %@", dict);

    if ([dict objectForKey:@"type"]) {
        
    } else {
        return messageDict;
    }
    
    messageDict[@"type"] = dict[@"type"];
    messageDict[@"messageid"] = dict[@"id"];
    messageDict[@"from"] = dict[@"from"];
    messageDict[@"fromuser"] = dict[@"from"];
    messageDict[@"fromuser"] = dict[@"from"];
    messageDict[@"session"] = dict[@"from"];
    if ([dict.allKeys containsObject:@"args"])
    {
        messageDict[@"content"] = dict[@"args"];
        NSDictionary *content = [dict[@"args"] objectFromJSONString];
        messageDict[@"data"] = content;
        
    }
    if ([dict.allKeys containsObject:@"url"])
    {
        messageDict[@"url"] = dict[@"url"];
    }
    if ([dict.allKeys containsObject:@"created"])
    {
        messageDict[@"time"] = dict[@"created"];
    }
    return messageDict;
}

#pragma mark - Notify Message -
#pragma mark Get Lastest Notify Message
+ (void)getLastestNotifyMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getLastestNotifyMessage:param success:^(NSDictionary *JSON) {
        [MessageManager handleNotifyMessage:JSON success:success];
    } failure:^(NSError *error, id JSON) {
        failure(error, JSON);
    }];
}

#pragma mark Get History Notify Message
+ (void)getHistoryNotifyMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getHistoryNotifyMessage:param success:^(NSDictionary *JSON) {
        [MessageManager handleNotifyMessage:JSON success:success];
    } failure:^(NSError *error, id JSON) {
        failure(error, JSON);
    }];
}

+ (void)handleNotifyMessage:(NSDictionary *)param success:(SuccessBlock)success
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    if ([param[@"success"] boolValue]) {
        if ([param[@"result"] count] > 0) {
            [data addObjectsFromArray:param[@"result"]];
            
            NSArray *posts = param[@"meta"][@"posts"];
            NSArray *profiles = param[@"meta"][@"profiles"];
            [UserManager insertUsers:profiles];
            [PostManager inserPosts:posts];
        }
    }
    success(data);
}

+ (void)getPushJobList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getPushJobList:param success:success failure:failure];
}

+ (void)getRefuseState:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getRefuseState:param success:success failure:failure];
}

+ (void)putRefuseState:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices putRefuseState:param success:success failure:failure];
}

//获得消息免打扰状态
+ (void)getDisturbState:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getDisturbState:param success:^(id JSON) {
        if ([[JSON objectForKey:@"success"] boolValue]) {
            success([JSON objectForKey:@"result"]);
        } else {
            success(nil);
        }
    } failure:^(NSError *error, id JSON) {
         failure(error, JSON);
    }];
}

//设置免打扰状态
+ (void)setDisturb:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices setDisturb:param success:success failure:^(NSError *error, id JSON) {
         failure(error, JSON);
    }];
}

@end
