//
//  EditDatePickerView.m
//  medtree
//
//  Created by 无忧 on 14-9-17.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "EditDatePickerView.h"
#import "DateUtil.h"
#import "TimeSelectView.h"
#import "CommonHelper.h"

@implementation EditDatePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
    
    isStartTime = YES;
    
    bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    headerLine = [[UILabel alloc] init];
    headerLine.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:headerLine];
    
    footLine = [[UILabel alloc] init];
    footLine.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:footLine];
    
    midLab = [[UILabel alloc] init];
    midLab.backgroundColor = [UIColor clearColor];
    midLab.textColor = [UIColor darkGrayColor];
    midLab.text = @"--";
    midLab.hidden = YES;
    midLab.textAlignment = NSTextAlignmentCenter;
    midLab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:midLab];
    
    startTimeLab = [[UILabel alloc] init];
    startTimeLab.backgroundColor = [UIColor clearColor];
    startTimeLab.textColor = [UIColor darkGrayColor];
    startTimeLab.text = @"开始时间";
    startTimeLab.textAlignment = NSTextAlignmentCenter;
    startTimeLab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:startTimeLab];
    
    endTimeLab = [[UILabel alloc] init];
    endTimeLab.backgroundColor = [UIColor clearColor];
    endTimeLab.textColor = [UIColor darkGrayColor];
    endTimeLab.textAlignment = NSTextAlignmentCenter;
    endTimeLab.font = [UIFont systemFontOfSize:14];
    endTimeLab.text = @"结束时间";
    endTimeLab.hidden = YES;
    [bgView addSubview:endTimeLab];
    
    datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePickerView.datePickerMode = UIDatePickerModeDate;
    datePickerView.maximumDate = [NSDate date];
    datePickerView.hidden = YES;
    NSString *time = [NSString stringWithFormat:@"1980-01-01 00:00:00"];
    NSLog(@"%@,%@",time,[DateUtil convertTime:time]);
    [datePickerView setDate:[DateUtil convertTime:time] animated:YES];
    [datePickerView addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:datePickerView];

    timeSelectLeft = [[TimeSelectView alloc] init];
    timeSelectLeft.parent = self;
    timeSelectLeft.hidden = YES;
    [self addSubview:timeSelectLeft];
    
    timeSelectRight = [[TimeSelectView alloc] init];
    timeSelectRight.hidden = YES;
    timeSelectRight.parent = self;
    [self addSubview:timeSelectRight];
}

- (void)setInfo:(NSDictionary *)dict
{
    isBirthday = [[dict objectForKey:@"isBirthday"] boolValue];
    if ([[dict objectForKey:@"isBirthday"] boolValue]) { // 填写生日
        self.startTime = [dict objectForKey:@"birthday"];
        if (self.startTime.length == 0) {
            self.startTime = [DateUtil getFormatTime:[NSDate date] format:@"yyyy.MM.dd"];
            startTimeLab.text = [DateUtil getFormatTime:[NSDate date] format:@"yyyy.MM.dd"];
        } else {
            startTimeLab.text = self.startTime;
            NSString *time =[NSString stringWithFormat:@"%@ 00:00:00",[startTimeLab.text stringByReplacingOccurrencesOfString:@"." withString:@"-"]];
            NSLog(@"%@,%@",time,[DateUtil convertTime:time]);
            [datePickerView setDate:[DateUtil convertTime:time] animated:YES];
        }
        datePickerView.hidden = NO;
    } else {
        midLab.hidden = NO;
        endTimeLab.hidden = NO;
        timeSelectLeft.hidden = NO;
        timeSelectRight.hidden = NO;
        
        NSInteger year = [[DateUtil getFormatTime:[NSDate date] format:@"yyyy"] integerValue];
        if ([[dict objectForKey:@"startTime"] length] == 0) {
            if ([[dict objectForKey:@"org_type"] integerValue] == 10 && [dict[@"experience_type"] integerValue] == 1) { // 学校，教育经历
                if ([[dict objectForKey:@"user_type"] integerValue] == 8) {  // 学生
                    self.startTime = [NSString stringWithFormat:@"%@", @(year - 3)];
                    self.endTime = @"至今";
                } else {
//                    self.startTime = [NSString stringWithFormat:@"%@", @(year - 20)];
//                    self.endTime = [NSString stringWithFormat:@"%@", @(year - 15)];
                    
                    self.startTime = [NSString stringWithFormat:@"%@", @(year - 3)];
                    self.endTime = @"至今";
                }
            } else if ([[dict objectForKey:@"org_type"] integerValue] == 0 && [dict[@"experience_type"] integerValue] == 2) {  // 工作经历
                if ([[dict objectForKey:@"user_type"] integerValue] == 8) {  // 学生
                    self.startTime = [NSString stringWithFormat:@"%@",@(year - 3)];
                    self.endTime = @"至今";
                } else {
                    self.startTime = [NSString stringWithFormat:@"%@", @(year - 15)];
                    self.endTime = @"至今";
                }
            } else {
                if ([[dict objectForKey:@"user_type"] integerValue] == 8) {  // 学生
                    self.startTime = [NSString stringWithFormat:@"%@", @(year - 3)];
                    self.endTime = @"至今";
                } else {
                    self.startTime = [NSString stringWithFormat:@"%@", @(year - 15)];
                    self.endTime = @"至今";
                }
            }
            startTimeLab.text = self.startTime;
            endTimeLab.text = self.endTime;
        } else {
            self.startTime = [CommonHelper getDateWithStringToMonth:[dict objectForKey:@"startTime"]];
            self.endTime = [CommonHelper getDateWithStringToMonth:[dict objectForKey:@"endTime"]];
            if (self.endTime.length == 0) {
                self.endTime = @"至今";
            } else {
                self.endTime = [CommonHelper getDateWithStringToMonth:[dict objectForKey:@"endTime"]];
            }
            startTimeLab.text = self.startTime;
            endTimeLab.text = self.endTime;
        }
        [timeSelectLeft setTitle:@"开始时间" time:self.startTime];
        [timeSelectRight setTitle:@"结束时间" time:self.endTime];
    }
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    bgView.frame = CGRectMake(0, 20, size.width, 40);
    headerLine.frame = CGRectMake(0, 0, size.width, 0.5);
    footLine.frame = CGRectMake(0, bgView.frame.size.height-0.5, size.width, 0.5);
    if (midLab.hidden) {
        startTimeLab.frame = CGRectMake(0, 0, size.width, 40);
    } else {
        startTimeLab.frame = CGRectMake(0, 0, size.width/2, 40);
        midLab.frame = CGRectMake(0, 0, size.width, 40);
        endTimeLab.frame = CGRectMake(size.width/2, 0, size.width/2, 40);
    }
    datePickerView.frame = CGRectMake(0, size.height-180, size.width, 180);
    timeSelectRight.frame = CGRectMake(size.width/2, size.height-180, size.width/2, 180);
    timeSelectLeft.frame = CGRectMake(0, size.height-180, size.width/2, 180);
}

- (void)dateChange:(UIDatePicker *)picker
{
    self.startTime = [DateUtil getFormatTime:picker.date format:@"yyyy.MM.dd"];
    startTimeLab.text = [DateUtil getFormatTime:picker.date format:@"yyyy.MM.dd"];
}

- (void)selectTime:(NSString *)time title:(NSString *)title
{
    if ([title isEqualToString:@"开始时间"]) {
        self.startTime = time;
        startTimeLab.text = time;
    } else {
        self.endTime = time;
        endTimeLab.text = time;
    }
}

@end
