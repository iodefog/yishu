//
//  IServices+Channel.h
//  medtree
//
//  Created by tangshimi on 9/9/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Channel)

+ (void)getChannelHomePageParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelRecommendParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelRecommendTagsParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelRecommendPostTagsParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelSquareParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelPublishDiscussionParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelFavourParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelUnFavourParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelInvitePeopleListParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelInvitePeopleParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelDetailCommentParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelCommentParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelCommentByIDParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelCommentFeedParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelDeleteCommentFeedParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelDailyAdvertisementSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelHomepageAdvertisementSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelDeleteDiscussionParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failur;

+ (void)getChannelMoreParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelHomePageParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelPostInterestParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelGetInterestSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelEnterpriseParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelEmploymentParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelFunctionLevelOneSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelFunctionlevelTwoParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelEmploymentCommentParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelEmploymentPublishFeedParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelEmploymentCommentFeedParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelEmploymentCommentFeedFavourParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelEmploymentCommentFeedUnFavourParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelEnterpriseRelationParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelPostSearchInfoParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelDeleteFeedParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJobChannelDeleteCommentParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelEmploymentByIDParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
