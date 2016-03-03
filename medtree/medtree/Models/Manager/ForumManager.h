//
//  ForumManager.h
//  medtree
//
//  Created by 陈升军 on 15/3/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DataManager.h"

@class ForumDTO;

@interface ForumManager : DataManager

typedef enum {
    MethodType_Forum_Start                      = 1200,
    MethodType_Forum_GetForum                   = 1201,
    MethodType_Forum_GetForumWithID             = 1202,
    MethodType_Forum_PostForumWithID            = 1203,
    MethodType_Forum_getForumUsers              = 1204,
    MethodType_Forum_PostQuestion               = 1205,
    MethodType_Forum_ClosePost                  = 1206,
    MethodType_Forum_GetForumCategories         = 1207,
    MethodType_Forum_PostInviteUsers            = 1208,
    MethodType_Forum_ForumUnread                = 1209,
    MethodType_Forum_ForumUnreadLocal           = 1214,
    MethodType_Forum_ForumWithForumID           = 1210,
    MethodType_Forum_GetForumFromDB             = 1211,
    MethodType_Forum_GetForumAnonymous          = 1212,
    MethodType_Forum_KeepForumAnonymous         = 1213,
    MethodType_Forum_ForumCommentDelete         = 1214,
    MethodType_Forum_ForumShareToFeed           = 1215,
    MethodType_Forum_ForumAddPoint              = 1216,
    MethodType_Forum_ForumZoneFromDB            = 1217,
    MethodType_Forum_GetForumMore               = 1218,
    MethodType_Forum_RecommendForum             = 1219, //热文推荐
    MethodType_Forum_HelpOut_Category_Add_Local = 1220, //添加帮帮忙分类缓存
    MethodType_Forum_HelpOut_Category_Local     = 1220, //帮帮忙分类缓存
    
    MethodType_Forum_NotLikeForumComment        = 1221,
    MethodType_Forum_LikeForumComment           = 1222,
    
    MethodType_Forum_End                        = 1299,
} Method_Forum;

+ (void)getForumDTO:(NSString *)forumID success:(SuccessBlock)success;
+ (void)checkForumDTO:(ForumDTO *)dto;

+ (void)loadCacheData;

@end
