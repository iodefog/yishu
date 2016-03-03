//
//  AcademicPickerController.m
//  medtree
//
//  Created by 边大朋 on 15/8/10.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "CardInfoPickerController.h"
#import "ColorUtil.h"
#import "UserManager.h"
#import "DateUtil.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "EditPersonCardInfoController.h"

@interface CardInfoPickerController ()<UIPickerViewDelegate>
{
    NSMutableArray          *dataArray;
    UIPickerView            *genderView;
    UIDatePicker            *datePickerView;
    UIButton                *coverView;
    NSInteger               genderSelected;
    UserDTO                 *udto;
    NSString                *startTime;
}
@end

@implementation CardInfoPickerController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    self.view.backgroundColor = [ColorUtil getColor:@"F1F1F5" alpha:1];
    
    UIButton *editButton = [NavigationBar createNormalButton:@"保存" target:self action:@selector(clickSave)];
    [naviBar setRightButton:editButton];
    
    genderView = [[UIPickerView alloc] init];
    genderView.delegate = self;
    genderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:genderView];
    
    datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePickerView.backgroundColor = [UIColor whiteColor];
    datePickerView.datePickerMode = UIDatePickerModeDate;
    datePickerView.maximumDate = [NSDate new];
    [datePickerView addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePickerView];
    [self createBackButton];
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    genderView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, genderView.frame.size.height-75);
    datePickerView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, datePickerView.frame.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    udto = [AccountHelper getAccount];
    startTime = [self birthday];
    if (self.pickerType == PickerType_Gender) {
        [naviBar setTopTitle:@"选择性别"];
        dataArray = [[NSMutableArray alloc] initWithObjects:@"男", @"女", nil];
        datePickerView.hidden = YES;
        genderSelected = udto.gender;
        [genderView selectRow:genderSelected - 1 inComponent:0 animated:NO];
    } else if (self.pickerType == PickerType_Birthday) {
        genderView.hidden = YES;
        [naviBar setTopTitle:@"出生日期"];
        NSString *birthday = [self birthday];
        NSString *time = [birthday stringByReplacingOccurrencesOfString:@"." withString:@"-"];
        NSDate *date =[DateUtil convertTime:[time stringByAppendingString:@" 00:00:00"]];
        
        [datePickerView setDate:date animated:YES];
    }
    [self setupView];
}

- (UIButton *)createBackButton
{
    UIButton *backButton = [NavigationBar createImageButton:@"btn_back.png" selectedImage:@"btn_back_click.png" target:self action:@selector(clickBack)];
    [naviBar setLeftButton:backButton];
    return backButton;
}

#pragma mark - click
- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSave
{
    NSDictionary *param;
    if (self.pickerType == PickerType_Gender) {
        if (genderSelected == 0) {//保密时不滑动picker就点击保存给默认值
            genderSelected = 1;
        }
        param = @{@"gender":[NSNumber numberWithInteger:genderSelected]};
    } else {
        if (!startTime) {
            return;
        }
        param = @{@"birthday":startTime};
    }
    
    [UserManager postUserCard:param success:^(id JSON) {
        NSLog(@"---%@", JSON);
        if ([JSON[@"success"] boolValue]) {
            if (self.pickerType == PickerType_Gender) {
                udto.gender = genderSelected;
            } else if (self.pickerType == PickerType_Birthday){
                udto.birthday = startTime;
            }
            if (JSON[@"result"]) {
                NSDictionary *dict = [NSDictionary dictionaryWithDictionary:JSON[@"result"]];
                if (dict[@"is_card_complete"]) {
                    udto.is_card_complete = [dict[@"is_card_complete"] boolValue];
                }
            }
            [UserManager checkUser:udto];
           
            if ([self.parent isKindOfClass:[EditPersonCardInfoController class]]) {
                ((EditPersonCardInfoController *)(self.parent)).userDTO = udto;
            }
             [self.navigationController popViewControllerAnimated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
            });
        }
    } failure:^(NSError *error, id JSON) {
    }];
}

- (void)dateChange:(UIDatePicker *)picker
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    startTime = [df stringFromDate:datePickerView.date];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [dataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
        genderSelected = 1;
    } else if (row == 1) {
        genderSelected = 2;
    }
}

#pragma mark - private
- (NSString *)birthday
{
    NSString *birthday;
    if(udto.birthday.length == 0) {
        NSInteger year = [[DateUtil getFormatTime:[NSDate date] format:@"yyyy"] integerValue] - 30;
        birthday = [NSString stringWithFormat:@"%@.01.01", @(year)];
    } else {
        birthday = udto.birthday;
    }
    return birthday;
}

@end
