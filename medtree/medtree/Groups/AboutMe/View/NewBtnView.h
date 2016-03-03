//
//  NewBtnView.h
//  medtree
//
//  Created by 边大朋 on 15-4-1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseView.h"

@protocol NewBtnViewDelegate <NSObject>

@optional

- (void)btnClickSave;
- (void)btnClickPush;

@end
@interface NewBtnView : BaseView


@property (nonatomic, weak) id<NewBtnViewDelegate> parent;

- (void)setInfo:(NSString *)str;

@end
