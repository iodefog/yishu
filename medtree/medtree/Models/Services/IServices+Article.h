//
//  IServices+Article.h
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Article)

+ (void)getArticle:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getArticleRecommend:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getArticleByID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;


+ (void)getCommentByID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)sendComment:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)sendLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)sendUnLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteComment:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)report:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
@end
