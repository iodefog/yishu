//
//  NewGenderPickerView.h
//  medtree
//
//  Created by 边大朋 on 15-4-6.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@protocol NewGenderPickerViewDelegate <NSObject>

- (void)clickSaveGender:(NSInteger)gender;

@end

@interface NewGenderPickerView :BaseView

@property (nonatomic, weak) id<NewGenderPickerViewDelegate> parent;
@property (nonatomic, strong) UIPickerView    *picker;
@end
