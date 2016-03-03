//
//  HomeRecommendChannelDTO.h
//  medtree
//
//  Created by tangshimi on 8/18/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DTOBase.h"

typedef NS_ENUM(NSInteger, HomeRecommendChannelDetailDTOType) {
    HomeRecommendChannelDetailDTOTypeUnKnow = 0,
    HomeRecommendChannelDetailDTOTypeNormalChannel = 1, //普通频道
    HomeRecommendChannelDetailDTOTypeJobChannel,        //职业频道
};

@interface HomeRecommendChannelDetailDTO : DTOBase

@property (nonatomic, copy) NSString *channelID;
@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, copy) NSString *channelImage;
@property (nonatomic, assign) BOOL alreadySetTags;
@property (nonatomic, assign) BOOL channelHaveTags;
@property (nonatomic, copy) NSString *createrID;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, assign) BOOL canPublish; //能否发帖
@property (nonatomic, assign) BOOL canEnter; //能否进入频道
@property (nonatomic, copy) NSString *publishFeedPlaceHolderText;
@property (nonatomic, assign) HomeRecommendChannelDetailDTOType type;
@property (nonatomic, copy) NSString *channelIntroduction;

@end
