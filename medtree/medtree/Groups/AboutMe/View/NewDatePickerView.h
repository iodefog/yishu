//
//  NewDatePickerView.h
//  medtree
//
//  Created by 边大朋 on 15-4-6.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseView.h"

@protocol NewDatePickerViewDelegate <NSObject>

- (void)clickSaveDate;

@end

@interface NewDatePickerView : BaseView

- (void)setInfo:(NSDictionary *)dict;
@property (nonatomic, strong) NSString                          *startTime;
@property (nonatomic, strong) UIDatePicker                      *datePickerView;
@property (nonatomic, weak) id<NewDatePickerViewDelegate>       parent;
@end
