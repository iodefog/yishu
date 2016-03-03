//
//  EventManager.h
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "ServiceManager.h"

typedef NS_ENUM(NSInteger, MethodTypeEvent) {
    MethodTypeEventList = 400,  //活动列表
    MethodTypeEventFeedList,    //活动动态列表
    MethodTypeEventFeedByID,    //根据活动ID 得到一个活动信息
    MethodTypeEventFeedSearch,  //动态搜索
};

@interface EventManager : DataManager


@end
