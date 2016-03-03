//
//  RegisterOrganizationButtonView.h
//  medtree
//
//  Created by 无忧 on 14-11-7.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseView.h"

@protocol RegisterOrganizationButtonViewDelegate <NSObject>

- (void)clickButtonIdx:(NSInteger)number;

@end

@interface RegisterOrganizationButtonView : BaseView
{
    NSMutableArray          *viewArray;
    UILabel                 *lineLab1;
    UILabel                 *lineLab2;
    UILabel                 *lineLab3;
    NSInteger               selectIdx;
}

@property (nonatomic, assign) id<RegisterOrganizationButtonViewDelegate> parent;

@end
