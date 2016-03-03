//
//  OperationHelper.h
//  medtree
//
//  Created by sam on 8/15/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ClickAction_MessageContact      = 100,
    ClickAction_MessageContent      = 101,
    ClickAction_MessageStatus       = 102,
    ClickAction_MessageLongPress    = 103,
    ClickAction_ColleagueList       = 200,
    ClickAction_ClassmateList       = 201,
    ClickAction_InviteFirend        = 202,
    ClickAction_FeedComment         = 203,
    ClickAction_FeedReplyUser       = 204,
    ClickAction_FeedReport          = 205,
    ClickAction_FeedCommentReport   = 206,
    ClickAction_FeedDelete          = 207,
    ClickAction_FeedCommentDelete   = 208,
    ClickAction_FeedReplyToUser     = 209,
    ClickAction_FriendRequestDeny   = 301,
    ClickAction_FriendRequestAccept = 302,
    ClickAction_FriendRequestInvite = 303,
    ClickAction_FirendAdd           = 304,
    ClickAction_ShowImage           = 400,
    ClickAction_PlayVoice           = 401,
    ClickAction_MateUser            = 402,
    ClickAction_OpenURL             = 501,
    ClickAction_ForumDetail         = 502,
    ClickAction_UserTagAdd          = 503,
    
} Click_Action;

@interface OperationHelper : NSObject

+ (void)setRootController:(UIViewController *)uvc;
+ (UIViewController *)getRootController;

@end
