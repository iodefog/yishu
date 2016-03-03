//
//  FormAlert.h
//  medtree
//
//  Created by 边大朋 on 15-4-5.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseView.h"

@protocol FormAlertDelegate <NSObject>

- (void)clickSave;

@end

@class TextViewEx;
@interface FormAlert : BaseView

@property (nonatomic, strong) TextViewEx          *textView;
@property (nonatomic, assign) BOOL                canEdit;
@property (nonatomic,weak) id<FormAlertDelegate> parent;

- (void)setEnableSaveBtn;
- (void)setNotEnableSaveBtn;
//- (void)clearText;

@end
