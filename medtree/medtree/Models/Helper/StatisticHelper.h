//
//  StatisticHelper.h
//  medtree
//
//  Created by sam on 8/15/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    StatisticAction_MT_APP_START    = 1,
    StatisticAction_MT_APP_EXIT     = 2,
    StatisticAction_MT_APP_ACTIVE   = 3,
    StatisticAction_MT_APP_INACTIVE = 4,
    StatisticAction_MT_SIGN_IN      = 5,
    StatisticAction_MT_SIGN_OUT     = 6,
    StatisticAction_MT_MSG_FRIEND   = 11,
    StatisticAction_MT_MSG_NEWS     = 12,
    StatisticAction_MT_HOME         = 21,
    StatisticAction_MT_TREND        = 22,
    StatisticAction_MT_CONNECT      = 23,
    StatisticAction_MT_DISCOVERY    = 24,
    StatisticAction_MT_MINE         = 25,
    StatisticAction_MT_SELF         = 31,
    StatisticAction_MT_NEWS_LIST    = 32,
    StatisticAction_MT_NEWS         = 33,
    StatisticAction_MT_TOPIC_LIST   = 34,
    StatisticAction_MT_TOPIC        = 35,
    
    StatisticAction_MT_FORUM_SQUARE           = 40,
    StatisticAction_MT_FORUM_QUESTION         = 41,
    StatisticAction_MT_FORUM_SQUARE_LIST      = 42,
    StatisticAction_MT_FORUM_MY_QUESTION      = 43,
    StatisticAction_MT_FORUM_MY_JION          = 44,
    StatisticAction_MT_FORUM_FEED_LIST        = 45,
    StatisticAction_MT_FORUM_FEED_DETAIL      = 46,
    StatisticAction_MT_FORUM_NEWS             = 47,
    
} Statistic_Action;


@class ActionDTO;

@interface StatisticHelper : NSObject {
    NSTimer *timer;
}

+ (id)shareInstance;

+ (void)startTimer;
+ (void)addAction:(Statistic_Action)action attr:(NSString *)attr;

+ (void)closeTimer;

/**
 *  从后台进入立即轮询监测一次
 */
- (void)checkUnRead;

@end
