//
//  TimeSelectView.h
//  medtree
//
//  Created by 无忧 on 14-9-22.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseView.h"

@protocol TimeSelectViewDelegate <NSObject>

- (void)selectTime:(NSString *)time title:(NSString *)title;

@end

@interface TimeSelectView : BaseView <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UILabel               *titleLab;
    UIPickerView          *timePicker;
    NSMutableArray        *timeArray;
    
}

@property (nonatomic, assign) id<TimeSelectViewDelegate> parent;
@property (nonatomic, strong) NSString *selectTime;

- (void)setTitle:(NSString *)title time:(NSString *)time;
- (void)setStandardTime:(NSString *)time;

@end
