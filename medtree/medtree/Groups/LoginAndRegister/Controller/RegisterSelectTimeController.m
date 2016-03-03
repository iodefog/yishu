//
//  RegisterSelectTimeController.m
//  medtree
//
//  Created by 无忧 on 14-11-6.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "RegisterSelectTimeController.h"
#import "EditDatePickerView.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "InfoAlertView.h"

@interface RegisterSelectTimeController () 
{
    EditDatePickerView      *datePicker;
}

@end

@implementation RegisterSelectTimeController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    [self createEditDatePicker];
    [naviBar setTopTitle:@"请选择时间"];
    [naviBar setTopLabelColor:[UIColor whiteColor]];
}

- (void)createEditDatePicker
{
    datePicker = [[EditDatePickerView alloc] init];
    [self.view addSubview:datePicker];
}

- (void)createRightButton
{
    UIButton *rightButton = [NavigationBar createNormalButton:@"确认" target:self action:@selector(clickOver)];
    [naviBar setRightButton:rightButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBackButton];
    [self createRightButton];
    NSDictionary *dict = @{@"isBirthday":@NO,
                           @"startTime":(self.startTime.length > 0) ? self.startTime : @"",
                           @"endTime":(self.endTime.length > 0) ? self.endTime : @"",
                           @"org_type":@(self.orgType),
                           @"user_type":@(self.userType),
                           @"experience_type":@(self.experienceType)};
    [datePicker setInfo:dict];
    CGSize size = self.view.frame.size;
    datePicker.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, size.height - CGRectGetMaxY(naviBar.frame));
}

#pragma mark - click
- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickOver
{
    if ([datePicker.startTime integerValue] < self.birthday) {
        [InfoAlertView showInfo:@"起始时间不能大过您的出生哦！" inView:self.view duration:1];
        return;
    }
    if ([datePicker.endTime isEqualToString:@"至今"]) {
        [self.parent updateTime:@{@"start":datePicker.startTime,@"end":@""}];
        [self clickBack];
    } else {
        if ([datePicker.startTime integerValue] > [datePicker.endTime integerValue]) {
            [InfoAlertView showInfo:@"起始时间不能大于结束时间哦！" inView:self.view duration:1];
        } else {
            [self.parent updateTime:@{@"start":datePicker.startTime,@"end":datePicker.endTime}];
            [self clickBack];
        }
    }
}

@end
