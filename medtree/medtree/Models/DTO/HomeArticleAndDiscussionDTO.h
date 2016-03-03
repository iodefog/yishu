//
//  HomeDiscussionDTO.h
//  medtree
//
//  Created by tangshimi on 9/1/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DTOBase.h"
@class UserDTO;

typedef NS_ENUM(NSInteger, HomeArticleAndDiscussionType){
    HomeArticleAndDiscussionTypeDiscussion = 1,
    HomeArticleAndDiscussionTypeArticle    = 2,
    HomeArticleAndDiscussionTypeEvent      = 5,
};

@interface HomeArticleAndDiscussionDTO : DTOBase

@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) HomeArticleAndDiscussionType type;  //1.讨论 2.文章 5.活动 (活动显示样式相同)
@property (nonatomic, copy) NSString *channelID;
@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger favourCount;
@property (nonatomic, assign) BOOL favour;
@property (nonatomic, assign) BOOL anonymous;
@property (nonatomic, copy) NSString *createrID;
@property (nonatomic, strong) UserDTO *userDTO;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, copy) NSString *updatedTime;
@property (nonatomic, assign) NSInteger clickCount;
@property (nonatomic, assign) NSInteger contentLevel;
@property (nonatomic, assign) NSInteger virtualCount;
@property (nonatomic, copy) NSString *autor;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *articleURL;
@property (nonatomic, copy) NSString *shareURL;
@property (nonatomic, assign) BOOL isEssence;

@end
