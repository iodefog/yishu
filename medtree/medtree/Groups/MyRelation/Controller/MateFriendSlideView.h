//
//  MateFriendSlideView.h
//  medtree
//
//  Created by 陈升军 on 15/4/13.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseView.h"
#import "CycleScrollView.h"

@class CycleScrollView;

@interface MateFriendSlideView : BaseView <CycleScrollViewDelegate>
{
    CycleScrollView         *mainScorllView;
}

@end
