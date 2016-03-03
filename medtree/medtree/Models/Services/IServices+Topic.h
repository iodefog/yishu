//
//  IServices+Topic.h
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Topic)

+ (void)getTopic:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getTopicFeeds:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)searchTopicUsers:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)postTopicLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteTopicLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getTopicByID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
