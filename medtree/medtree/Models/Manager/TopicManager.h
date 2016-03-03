//
//  TopicManager.h
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface TopicManager : DataManager

typedef enum {
    MethodType_Topic_Start                      = 800,
    MethodType_Topic_GetTopic                   = 801,
    MethodType_Topic_GetTopicFeeds              = 802,
    MethodType_Topic_SearchTopicUsers           = 803,
    MethodType_Topic_PostTopicLike              = 804,
    MethodType_Topic_DeleteTopicLike            = 805,
    MethodType_Topic_GetTopicFeedsMore          = 806,
    MethodType_Topic_GetTopic2Feeds             = 807,
    MethodType_Topic_GetTopicDB                 = 808,
    MethodType_Topic_GetTopicByID               = 809,
    MethodType_Topic_End                        = 899,
} Method_Topic;

@end
