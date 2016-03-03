//
//  HomeChannelDetailBottomOperateView.h
//  medtree
//
//  Created by tangshimi on 8/21/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HomeChannelDetailBottomOperateViewOperationType) {
    HomeChannelDetailBottomOperateViewOperationTypeFavour,
    HomeChannelDetailBottomOperateViewOperationTypeRespond,
    HomeChannelDetailBottomOperateViewOperationTypeInvite,
    HomeChannelDetailBottomOperateViewOperationTypeShare
};

typedef NS_ENUM(NSInteger, HomeChannelDetailBottomOperateViewType) {
    HomeChannelDetailBottomOperateViewTypeDiscussion,
    HomeChannelDetailBottomOperateViewTypeArticle
};

@protocol HomeChannelDetailBottomOperateViewDelegate <NSObject>

- (void)homeChannelDetailBottomOperateViewDidSelectWithType:(HomeChannelDetailBottomOperateViewOperationType)type;

@end

@interface HomeChannelDetailBottomOperateView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(HomeChannelDetailBottomOperateViewType)type;

@property (nonatomic, weak) id<HomeChannelDetailBottomOperateViewDelegate> delegate;

@property (nonatomic, assign) BOOL favour;
@property (nonatomic, assign) NSInteger favourNumber;
@property (nonatomic, assign) NSInteger speakCountNumber;

@end
