//
//  RegisterOrganizationAddView.h
//  medtree
//
//  Created by 陈升军 on 15/4/26.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseView.h"

@protocol RegisterOrganizationAddViewDelegate <NSObject>

- (void)searchViewClickAdd;

@end


@interface RegisterOrganizationAddView : BaseView
{
    UIImageView         *iconImage;
    UILabel             *titleLab;
    UIImageView         *lineImage;
}

@property (nonatomic, assign) id<RegisterOrganizationAddViewDelegate> parent;

- (void)setData:(NSString *)text;
- (NSString *)getData;

@end
