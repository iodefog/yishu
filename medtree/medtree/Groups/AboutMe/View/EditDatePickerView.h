//
//  EditDatePickerView.h
//  medtree
//
//  Created by 无忧 on 14-9-17.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseView.h"
#import "TimeSelectView.h"

@class TimeSelectView;

@interface EditDatePickerView : BaseView <TimeSelectViewDelegate>
{
    UIView          *bgView;
    UILabel         *headerLine;
    UILabel         *footLine;
    UILabel         *startTimeLab;
    UILabel         *midLab;
    UILabel         *endTimeLab;
    BOOL            isStartTime;
    BOOL            isBirthday;
    UIDatePicker    *datePickerView;
    NSString        *firstText;
    NSString        *secondText;
    TimeSelectView  *timeSelectLeft;
    TimeSelectView  *timeSelectRight;
}

@property (nonatomic, strong) NSString    *startTime;
@property (nonatomic, strong) NSString    *endTime;

- (void)setInfo:(NSDictionary *)dict;

@end
