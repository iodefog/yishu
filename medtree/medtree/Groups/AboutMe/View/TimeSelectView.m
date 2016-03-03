//
//  TimeSelectView.m
//  medtree
//
//  Created by 无忧 on 14-9-22.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "TimeSelectView.h"
#import "DateUtil.h"
#import "MedGlobal.h"

@implementation TimeSelectView

- (void)createUI
{
    timeArray = [[NSMutableArray alloc] init];
    
    titleLab = [[UILabel alloc] init];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.text = @"开始时间";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [MedGlobal getLittleFont];
    [self addSubview:titleLab];
    
    timePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    timePicker.delegate = self;
    timePicker.dataSource = self;
    timePicker.showsSelectionIndicator = YES;
//    timePicker.hidden = YES;
    [self addSubview:timePicker];
    
    NSInteger year = [[DateUtil getFormatTime:[NSDate date] format:@"yyyy"] integerValue];
    
    for (NSInteger i = year; i > year-100; i --) {
        NSString *str = [NSString stringWithFormat:@"%@",@(i)];
        [timeArray addObject:str];
    }
    [timePicker reloadAllComponents];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    titleLab.frame = CGRectMake(0, 0, size.width, 20);
    timePicker.frame = CGRectMake(0, 20, size.width, size.height-20);
}

- (void)setTitle:(NSString *)title time:(NSString *)time
{
    titleLab.text = title;
    if ([title isEqualToString:@"结束时间"]) {
        [timeArray insertObject:@"至今" atIndex:0];
    }
    self.selectTime = time;
    if ([time isEqualToString:@"至今"] || [time isEqualToString:@""]) {
        
    } else {
        [timePicker selectRow:[timeArray indexOfObject:time] inComponent:0 animated:YES];
    }
    
}

- (void)setStandardTime:(NSString *)time
{
    
}

#pragma mark - PickerView lifecycle

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.frame.size.width;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return timeArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [timeArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self showTime:[timeArray objectAtIndex:row]];
}

- (void)showTime:(NSString *)time
{
    [self.parent selectTime:time title:titleLab.text];
}


@end
