//
//  DB+Topic.h
//  medtree
//
//  Created by 陈升军 on 14/12/30.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DB.h"

@class TopicDTO;

@interface DB (Topic)

- (void)createTable_Topic;
- (void)insertTopic:(TopicDTO *)dto;
- (void)selectTopicDTOResult:(ArrayBlock)result;
- (void)selecTopicWithTopicID:(ArrayBlock)result topicID:(NSString *)topicID;
- (void)updateTopic:(TopicDTO *)dto;

@end
