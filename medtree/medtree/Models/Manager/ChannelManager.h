//
//  ChannelManager.h
//  medtree
//
//  Created by tangshimi on 9/9/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DataManager.h"

typedef  NS_ENUM(NSInteger, MethodTypeChannel) {
    MethodTypeChannelHomePage = 7000, //主页
    MethodTypeChannelRecommend,       //频道推荐
    MethodTypeChannelRecommendTags,   //频道推荐筛选标签
    MethodTypeChannelRecommendPostTags, //频道推荐上传筛选标签
    MethodTypeChannelSquare,            //频道广场
    MethodTypeChannelPublishDiscussion, //发布评论
    MethodTypeChannelFavour,            //赞
    MethodTypeChannelUnFavour,          //取消赞
    MethodTypeChannelInvitePeopleList,  //邀请人列表
    MethodTypeChannelInvitePeople,      //邀请
    MethodTypeChannelDetailComment,     //发表评论
    MethodTypeChannelComment,            //一个文章、讨论的评论列表
    MethodTypeChannelCommentByID,       //通过ID获取一个文章、讨论的评论列表
    MethodTypeChannelCommentFeed,        //评论动态、评论
    MethodTypeChannelDeleteCommentFeed,  //删除动态、评论
    MethodTypeChannelDailyAdvertisement, //每日首次登陆广告
    MethodTypeChannelHomepageAdvertisement, //首页广告
    MethodTypeChannelDeleteDiscussion,   //删除讨论

    MethodTypeChannelMoreChannel,       //更多频道
    
    MethodTypeJobChannelHomePage,       //职业频道首页
    MethodTypeJobChannelPostinterests,  //职业频道上传兴趣标签
    MethodtypeJonChannelGetInterests,   //职业频道已选标签
    MethodTypeJobChannelEnterprise,     //职业频道企业
    MethodTypeJobChannelEmployment,     //职业频道招聘
    MethodTypeJobChannelFunctionLevelOne, //职能一级列表
    MethodTypeJobChannelFunctionLevelTwo, //职能二级列表
    MethodTypeJobChannelEmploymentComment, //职位的评论列表
    MethodTypeJobChannelEmploymentPublishFeed, //职位的动态
    MethodTypeJobChannelEmploymentCommentFeed, //评论职位的动态、评论
    MethodTypeJobChannelEmploymenFeedFavour,   //职位动态点赞
    MethodTypeJobChannelEmploymenFeedUnFavour,  //职位动态取消点赞
    MethodTypeJobChannelEnterpriseRelation, //企业人脉
    MethodTypeJonChannelSearchPostInfomation, //搜索职位，没有结果，提交搜索信息
    MethodTypeJobChannelDeleteFeed,        //删除职位的动态
    MethodTypeJobChannelDeleteComment,     //删除职位的评论
    MethodTypeJobChannelEmploymentByID,    //通过ID获取一个职位的信息
};

@interface ChannelManager : DataManager

+ (void)getChannelParam:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getChannelFromLocalParam:(NSDictionary *)dict success:(SuccessBlock)success;

+ (NSDictionary *)paraseDiscussionAndArticleData:(NSDictionary *)dict;

+ (NSDictionary *)paraseCommentData:(NSDictionary *)dict;

@end
