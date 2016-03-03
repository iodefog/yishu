//
//  ForumManager.m
//  medtree
//
//  Created by 陈升军 on 15/3/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ForumManager.h"
#import "IServices+Public.h"
#import "ForumDTO.h"
#import "DB+Public.h"
#import "UserDTO.h"
#import "UserManager.h"
#import "ForumPostDTO.h"
#import "ForumMessageDTO.h"
#import "MedGlobal.h"
#import "DataManager+Cache.h"

@implementation ForumManager

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
     NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    //
        switch (method) {
        case MethodType_Forum_GetForumMore:
        case MethodType_Forum_GetForum:{
            [IServices getForumList:param success:^(id JSON) {
                NSLog(@"%@", param);

                
                NSMutableArray *array = [NSMutableArray array];
                NSMutableArray *result = [JSON objectForKey:@"result"];
                
                NSArray *user = [NSArray arrayWithArray:[[JSON objectForKey:@"meta"] objectForKey:@"profiles"]];
                if (user.count > 0) {
                    for (int i = 0; i < user.count; i ++) {
                        UserDTO *dto = [[UserDTO alloc] init:[user objectAtIndex:i]];
                        [UserManager checkUser:dto];
                    }
                }
                
                for (int i = 0; i < result.count; i ++) {
                    ForumDTO *dto = [[ForumDTO alloc] init:[result objectAtIndex:i]];
                    [ForumManager checkForumDTO:dto];
                    [array addObject:dto];

                }
                
                //按分类缓存数据
                [ForumManager checkForumArray:array];
               
                [DataManager cache:dict data:JSON];
                
                success(array);
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Forum_GetForumWithID:{
            [IServices getForumWithPostID:param success:^(id JSON) {
                NSMutableArray *array = [NSMutableArray array];
                NSMutableArray *result = [JSON objectForKey:@"result"];
                NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
                NSArray *user = [NSArray arrayWithArray:[[JSON objectForKey:@"meta"] objectForKey:@"profiles"]];
                if (user.count > 0) {
                    for (int i = 0; i < user.count; i ++) {
                        UserDTO *dto = [[UserDTO alloc] init:[user objectAtIndex:i]];
                        [userDict setObject:dto.name forKey:dto.userID];
                        [UserManager checkUser:dto];
                    }
                }
                
                for (int i = 0; i < result.count; i ++) {
                    ForumPostDTO *dto = [[ForumPostDTO alloc] init:[result objectAtIndex:i]];
                    
                    NSMutableArray *data = [NSMutableArray array];
                    NSMutableArray *comment = [NSMutableArray arrayWithArray:dto.comments];
                    for (int i = 0; i < comment.count; i ++) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[comment objectAtIndex:i]];
                        NSString *user_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"user_id"] longLongValue]];
                        NSString *reply_to_user_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"reply_to_user_id"] longLongValue]];
                        if ([userDict objectForKey:user_id]) {
                            [dict setObject:[userDict objectForKey:user_id] forKey:@"user_name"];
                        }
                        if ([userDict objectForKey:reply_to_user_id]) {
                            [dict setObject:[userDict objectForKey:reply_to_user_id] forKey:@"reply_to_user_name"];
                        }
                        [data addObject:dict];
                    }
                    [dto.comments removeAllObjects];
                    [dto.comments addObjectsFromArray:data];
                    [array addObject:dto];
                }
                success(array);
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Forum_getForumUsers:{
            [IServices getForumUsers:param success:^(id JSON) {
                NSMutableArray *array = [NSMutableArray array];
                NSMutableArray *result = [JSON objectForKey:@"result"];
                for (int i = 0; i < result.count; i ++) {
                    UserDTO *dto = [[UserDTO alloc] init:[result objectAtIndex:i]];
                    [array addObject:dto];
                }
                success(array);
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Forum_GetForumCategories:{
            [IServices getForumCategories:param success:^(id JSON) {
                NSMutableArray *result = [JSON objectForKey:@"result"];
                success(result);
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Forum_HelpOut_Category_Local: {//获取帮帮忙筛选分类缓存
        
            NSNumber *zone = [param objectForKey:@"zone"];
            NSString *category = [param objectForKey:@"category"];
            [[DB shareInstance] selectTypeForumWithZoneAndCategory:zone category:category result:^(NSArray *array) {
                success(array);
                }
             ];
            break;
        }
        case MethodType_Forum_ForumUnread:{
            [IServices getUnreadInfo:param success:^(id JSON) {
                
                NSArray *user = [NSArray arrayWithArray:[[JSON objectForKey:@"meta"] objectForKey:@"profiles"]];
                if (user.count > 0) {
                    for (int i = 0; i < user.count; i ++) {
                        UserDTO *dto = [[UserDTO alloc] init:[user objectAtIndex:i]];
                        [UserManager checkUser:dto];
                    }
                }
                NSArray *help = [NSArray arrayWithArray:[[JSON objectForKey:@"meta"] objectForKey:@"helps"]];
                for (int i = 0; i < help.count; i ++) {
                    ForumDTO *dto = [[ForumDTO alloc] init:[help objectAtIndex:i]];
                    [ForumManager checkForumDTO:dto];
                }
                
                NSMutableArray *array = [NSMutableArray array];
                NSMutableArray *result = [JSON objectForKey:@"result"];
                for (int i = 0; i < result.count; i ++) {
                    ForumMessageDTO *message = [[ForumMessageDTO alloc] init:[result objectAtIndex:i]];
                    [array addObject:message];
                    [ForumManager checkForumMessageDTO:message];
                }
                success(array);
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Forum_ForumWithForumID:{
            [IServices getForumWithID:param success:^(id JSON) {
                
                NSArray *user = [NSArray arrayWithArray:[[JSON objectForKey:@"meta"] objectForKey:@"profiles"]];
                if (user.count > 0) {
                    for (int i = 0; i < user.count; i ++) {
                        UserDTO *dto = [[UserDTO alloc] init:[user objectAtIndex:i]];
                        [UserManager checkUser:dto];
                    }
                }
                ForumDTO *dto = [[ForumDTO alloc] init:[JSON objectForKey:@"result"]];
                [ForumManager checkForumDTO:dto];
                success(dto);
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Forum_GetForumFromDB: {
            if ([param objectForKey:@"key"]) {
                [[DB shareInstance] selectForum:[param objectForKey:@"key"] value:[param objectForKey:@"value"] result:^(NSArray *array) {
                    success (array);
                }];
            } else {
                [[DB shareInstance] selectAllForumResult:^(NSArray *array) {
                    success (array);
                }];
            }
            break;
        }
        case MethodType_Forum_ForumZoneFromDB: {
            [[DB shareInstance] selectForumWithZone:[[param objectForKey:@"zone"] integerValue] result:^(NSArray *array) {
                success (array);
            }];
            break;
        }
        case MethodType_Forum_GetForumAnonymous: {
            [[DB shareInstance] selectForumAnonymousWithID:[param objectForKey:@"forumid"] result:^(NSArray *array) {
                success (array);
            }];
            break;
        }
        case MethodType_Forum_KeepForumAnonymous: {
            [[DB shareInstance] selectForumAnonymousWithID:[param objectForKey:@"forumid"] result:^(NSArray *array) {
                if (array.count > 0) {
                    [[DB shareInstance] updateForumAnonymous:param];
                } else {
                    [[DB shareInstance] insertForumAnonymous:param];
                }
            }];
            
            break;
        }
        case MethodType_Forum_ForumUnreadLocal: {
            [[DB shareInstance] selectAllForumMessageResult:^(NSArray *array) {
                for (int i = 0; i < array.count; i ++) {
                    ForumMessageDTO *message = [array objectAtIndex:i];
                    [[ForumManager getForumUnreadInfo] setObject:message forKey:[NSString stringWithFormat:@"%@%@",message.ref_id,message.timestamp]];
                }
                success (array);
            }];
            break;
        }
        case MethodType_Forum_RecommendForum: {
            [IServices getRecommendForumList:param success:^(id JSON) {
                
                NSMutableArray *array = [NSMutableArray array];
                NSMutableArray *result = [JSON objectForKey:@"result"];
                
                NSArray *user = [NSArray arrayWithArray:[[JSON objectForKey:@"meta"] objectForKey:@"profiles"]];
                if (user.count > 0) {
                    for (int i = 0; i < user.count; i ++) {
                        UserDTO *dto = [[UserDTO alloc] init:[user objectAtIndex:i]];
                        [UserManager checkUser:dto];
                    }
                }
                
                for (int i = 0; i < result.count; i ++) {
                    ForumDTO *dto = [[ForumDTO alloc] init:[result objectAtIndex:i]];
                    [ForumManager checkForumDTO:dto];
                    [array addObject:dto];
                }
                success(array);
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
        }
            break;
        default:
            break;
    }
}


- (void)getUnreadInfo:(SuccessBlock)success
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"forum_unread"} success:^(id JSON) {
        NSArray *array = [NSArray arrayWithArray:JSON];
        if (array.count > 0) {
            NSMutableDictionary *inviteDict = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:0]];
            success (inviteDict);
        } else {
            success (nil);
        }
    } failure:^(NSError *error, id JSON) {
        success (nil);
    }];
}

- (void)setUnreadInfo:(NSDictionary *)dict
{
    dispatch_async([MedGlobal getDbQueue], ^{
        DTOBase *dto = [[DTOBase alloc] init:dict];
        [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"forum_unread",@"info":dto} success:^(id JSON) {
            
        } failure:^(NSError *error, id JSON) {
            
        }];
    });
}

+ (NSMutableDictionary *)getForumInfo
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
    }
    return dict;
}

+ (void)getForumDTO:(NSString *)forumID success:(SuccessBlock)success
{
    if ([[ForumManager getForumInfo] objectForKey:forumID]) {
        success([[ForumManager getForumInfo] objectForKey:forumID]);
    } else {
        [[DB shareInstance] selectForumWithID:forumID result:^(NSArray *array) {
            if (array.count > 0) {
                success ([array objectAtIndex:0]);
            } else {
                success (nil);
            }
        }];
    }
}

+ (void)setData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    //
    //
    switch (method) {
        case MethodType_Forum_PostForumWithID:{
            [IServices postForumWithPostID:param success:^(id JSON) {
                
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Forum_PostQuestion:{
            [IServices postQuestion:param success:^(id JSON) {
                
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Forum_ClosePost:{
            [IServices closePost:param success:^(id JSON) {
                
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Forum_PostInviteUsers:{
            [IServices postInviteUsers:param success:^(id JSON) {
                
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Forum_ForumCommentDelete: {
            [IServices deleteForumComment:param success:^(id JSON) {
                
                success(JSON);
            } failure:failure];
            break;
        }
        case MethodType_Forum_ForumShareToFeed: {
            [IServices forumShareToFeed:param success:^(id JSON) {
                
                success(JSON);
            } failure:failure];
            break;
        }
        case MethodType_Forum_ForumAddPoint: {
            [IServices forumAddPoint:param success:success failure:failure];
            break;
        }
        case MethodType_Forum_HelpOut_Category_Add_Local: {
           // [ForumManager addHelpOutCacheWithCatgory:dto]
            
            break;
        }
        case MethodType_Forum_LikeForumComment: {
            // [ForumManager addHelpOutCacheWithCatgory:dto]
            [IServices likeForumCommont:param success:success failure:failure];
            break;
        }
        case MethodType_Forum_NotLikeForumComment: {
            // [ForumManager addHelpOutCacheWithCatgory:dto]
            [IServices notLikeForumCommont:param success:success failure:failure];
            break;
        }
        default:
            break;
    }
    //
}

+ (BOOL)isHit:(NSInteger)method
{
    if (method > MethodType_Forum_Start && method < MethodType_Forum_End) {
        return YES;
    } else {
        return NO;
    }
}

//按照分类来缓存帮帮忙
+ (void) checkForumArray:(NSArray *)array
{
    NSMutableArray *ids = [ForumManager selectTypeForumIDs];
    if (array.count > 0) {
        for (ForumDTO *dto in array) {
            if ([ids containsObject:dto.forumID]) {
                [[DB shareInstance] updateTypeForum:dto];
            } else {
                [[DB shareInstance] insertTypeForum:dto];
                [ids addObject:dto.forumID];
            }
        }
        
    }
}

//处理缓存
+ (void)loadCacheData
{
    [[ForumManager selectTypeForumIDs] removeAllObjects];
    [[ForumManager selectTypeForumIDs] addObjectsFromArray:[[DB shareInstance] selectTypeForumIDs]];
    
    [[ForumManager selectForumIDs] removeAllObjects];
    [[ForumManager selectForumIDs] addObjectsFromArray:[[DB shareInstance] selectForumIds]];
}

+ (NSMutableArray *)selectForumIDs
{
    static NSMutableArray *forumIdArray = nil;
    if (forumIdArray == nil) {
        forumIdArray = [[NSMutableArray alloc] init];
    }
    return forumIdArray;
}

+ (NSMutableArray *)selectTypeForumIDs
{
    static NSMutableArray *forum_ids = nil;
    if (forum_ids == nil) {
        forum_ids = [[NSMutableArray alloc] init];
    }
    return forum_ids;
}

+ (void)checkForumDTO:(ForumDTO *)dto
{
//    if ([[ForumManager getForumInfo] objectForKey:dto.forumID]) {
//        [[ForumManager getForumInfo] setObject:dto forKey:dto.forumID];
//        [[DB shareInstance] updateForum:dto];
//    } else {®
//        [[ForumManager getForumInfo] setObject:dto forKey:dto.forumID];
//        [[DB shareInstance] insertForum:dto];
//    }
    
    NSMutableArray *ids = [ForumManager selectForumIDs];
    if ([ids containsObject:dto.forumID]) {
        [[DB shareInstance] updateForum:dto];
    } else {
        [[DB shareInstance] insertForum:dto];
        [ids addObject:dto.forumID];
    }
    
}

+ (NSMutableDictionary *)getForumUnreadInfo
{
    static NSMutableDictionary *unread = nil;
    if (unread == nil) {
        unread = [[NSMutableDictionary alloc] init];
    }
    return unread;
}

+ (void)checkForumMessageDTO:(ForumMessageDTO *)dto
{
    if (![[ForumManager getForumUnreadInfo] objectForKey:[NSString stringWithFormat:@"%@%@",dto.ref_id, dto.timestamp]]) {
        [[ForumManager getForumUnreadInfo] setObject:dto forKey:[NSString stringWithFormat:@"%@%@",dto.ref_id, dto.timestamp]];
        [[DB shareInstance] insertForumMessage:dto];
    }
}

@end
