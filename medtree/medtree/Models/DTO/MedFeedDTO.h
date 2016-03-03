//
//  MedFeedDTO.h
//  medtree
//
//  Created by tangshimi on 9/16/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DTOBase.h"
@class UserDTO;

typedef NS_ENUM(NSInteger, FeedType) {
    FeedTypeDiscussion = 1,
    FeedTypeArticle,
    FeedTypeFriend,
    FeedTypeEvent
};

@interface MedFeedDTO : DTOBase

@property (nonatomic, copy) NSString *feedID;
@property (nonatomic, copy) NSString *creatorID;
@property (nonatomic, strong) UserDTO *creatorDTO;
@property (nonatomic, assign) FeedType type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSArray *imageArray;
@property (nonatomic, copy) NSArray *commentArray;
@property (nonatomic, assign) BOOL anonymous;
@property (nonatomic, assign) NSInteger commentNumber;
@property (nonatomic, assign) NSInteger favourNumber;
@property (nonatomic, assign) BOOL favoured;
@property (nonatomic, copy) NSString *favourContent;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) BOOL searchFeed;

- (instancetype)init:(NSDictionary *)dict nameForIDInfo:(NSDictionary *)userInfo;

@end
