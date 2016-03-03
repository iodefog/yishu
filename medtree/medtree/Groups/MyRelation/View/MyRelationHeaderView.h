//
//  MyRelationHeaderView.h
//  medtree
//
//  Created by tangshimi on 6/12/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "BaseView.h"

typedef enum {
    MyRelationHeaderViewHeadSelectedType,
    MyRelationHeaderViewColleagueSelectedType,
    MyRelationHeaderViewFriendOfFriendSelectedType,
    MyRelationHeaderViewFriendSelectedType,
    MyRelationHeaderViewPeerSelectedType,
    MyRelationHeaderViewSchoolmateSelectedType
}MyRelationHeaderViewSelectedType;

@protocol MyRelationHeaderViewDelegate <NSObject>

- (void)myRelationHeaderViewSelectedType:(MyRelationHeaderViewSelectedType)type isCertificated:(BOOL)isCertificated;

@end


@interface MyRelationHeaderView : BaseView

@property (nonatomic, weak) id<MyRelationHeaderViewDelegate> delegate;
@property (nonatomic, strong) NSDictionary *relationStatusDic;
@property (nonatomic, readonly, assign) BOOL workExperienceCertificated;
@property (nonatomic, readonly, copy) NSArray *buttonArray;

- (NSInteger)peopleNumberWithMyRelationHeaderViewSelectedType:(MyRelationHeaderViewSelectedType)type;

- (void)showHeaderButtonWithAnimated:(BOOL)animated;

@end


@interface MyRelationHeaderViewButton : UIButton

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@end