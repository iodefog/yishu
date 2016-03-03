//
//  ResumeEditViewController.m
//  medtree
//
//  Created by 孙晨辉 on 15/11/10.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "ResumeEditViewController.h"
#import "CommonCell.h"
#import "CHTextView.h"
#import "PairDTO.h"
#import <DateUtil.h>
#import "ResumeEditSelectCell.h"
#import "UserManager.h"
#import <InfoAlertView.h>

@interface ResumeEditViewController () <UIPickerViewDelegate>
{
    CommonCell                  *textCell;
    CHTextView                  *textView;
    UIPickerView                *genderView;
    UIDatePicker                *datePicker;
    Gender_Types                genderSelected;
}

@property (nonatomic, strong) NSArray *provices;
@property (nonatomic, strong) NSArray *experiences;
@property (nonatomic, strong) NSArray *genders;

@end

@implementation ResumeEditViewController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    textCell = [CommonCell commoncell];
    textCell.showFootLine = YES;
    textCell.showHeadLine = YES;
    textCell.showMedLine = NO;
    textCell.hidden = YES;
    [self.view addSubview:textCell];
    
    // 生日选择器
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate new];
    datePicker.minimumDate = [DateUtil convertTime:@"1900-01-01 00:00:00"];
    datePicker.hidden = YES;
    NSString *time = [NSString stringWithFormat:@"1980-01-01 00:00:00"];
    [datePicker setDate:[DateUtil convertTime:time] animated:YES];
    [self.view addSubview:datePicker];
    
    genderView = [[UIPickerView alloc] init];
    genderView.delegate = self;
    genderView.backgroundColor = [UIColor whiteColor];
    genderView.hidden = YES;
    [self.view addSubview:genderView];
    
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc] init];
    table.enableHeader = NO;
    table.hidden = YES;
    [table registerCells:@{@"PairDTO":[ResumeEditSelectCell class]}];
    
    textView = [[CHTextView alloc] init];
    textView.hidden = YES;
    [self.view addSubview:textView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBackButton];
    [naviBar setTopTitle:self.naviTitle];
    [self createRightNavi];
    [self setupData];
    [self setupView];
}

- (void)viewDidLayoutSubviews {
    if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
        [table setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([table respondsToSelector:@selector(setLayoutMargins:)])  {
        [table setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)createRightNavi
{
    UIButton *button = [NavigationBar createNormalButton:@"保存" target:self action:@selector(clickSave)];
    [naviBar setRightButton:button];
}

- (void)setupData
{
    [naviBar setTopTitle:[NSString stringWithFormat:@"编辑%@", self.naviTitle]];
    switch (self.editType) {
        case ResumeRowTypePhone: {  // 单行文本
            textCell.keyboardType = UIKeyboardTypeNumberPad;
        }
        case ResumeRowTypeName: {   // 单行文本
            textCell.text = self.value;
            textCell.hidden = NO;
            break;
        }
        case ResumeRowTypeGender: {  // 选择器
            genderView.hidden = NO;
            if (self.genderType == GenderTypes_Secrecy) {
                genderSelected = GenderTypes_Male;
            } else {
                genderSelected = self.genderType;
            }
            [genderView selectRow:(self.genderType - 1) inComponent:0 animated:NO];
            break;
        }
        case ResumeRowTypeBirthplace:
        case ResumeRowTypeResidential: {  // 列表选择
            for (PairDTO *dto in self.provices) {
                if ([dto.value isEqualToString:self.value]) {
                    dto.isSelect = YES;
                }
            }
            table.hidden = NO;
            [table setData:@[self.provices]];
            break;
        }
        case ResumeRowTypeWorkExperience: {  // 列表选择
            for (PairDTO *dto in self.experiences) {
                if (dto.type == self.workType) {
                    dto.isSelect = YES;
                }
            }
            table.hidden = NO;
            [table setData:@[self.experiences]];
            break;
        }
        case ResumeRowTypeBirthday: {   // 日期选择器
            datePicker.hidden = NO;
            if (self.birthday) {
                [datePicker setDate:self.birthday animated:YES];
            }
            break;
        }
        case ResumeRowTypeInterest:
        case ResumeRowTypeSelfIntroduction:
        case ResumeRowTypeHonour: {  // 多行文本
            textView.placeHolder = [NSString stringWithFormat: @"填写自己的%@", self.naviTitle];
            textView.text = self.value;
            textView.hidden = NO;
            break;
        }
        default: {
            break;
        }
    }
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    textCell.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, 50);
    table.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, size.height - CGRectGetMaxY(naviBar.frame));
    datePicker.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, datePicker.frame.size.height);
    genderView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, genderView.frame.size.height);
    textView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, 200);
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.genders.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.genders objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
        genderSelected = GenderTypes_Male;
    } else if (row == 1) {
        genderSelected = GenderTypes_Female;
    }
}

#pragma mark - base table delegate
- (void)clickCell:(PairDTO *)dto index:(NSIndexPath *)index
{
    if (self.editType == ResumeRowTypeWorkExperience) {
        for (PairDTO *pdto in self.experiences) {
            if (pdto.isSelect) {
                pdto.isSelect = NO;
            }
        }
        dto.isSelect = YES;
        self.workType = dto.type;
        [table setData:@[self.experiences]];
    } else {
        for (PairDTO *pdto in self.provices) {
            if (pdto.isSelect) {
                pdto.isSelect = NO;
            }
        }
        dto.isSelect = YES;
        self.value = dto.value;
        [table setData:@[self.provices]];
    }
}

#pragma mark - click
- (void)clickSave
{
    if (self.netRequest) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [param setObject:@(MethodType_Resume_Put) forKey:@"method"];
        [param setObject:self.resumeId forKey:@"resumeId"];
        switch (self.editType) {
            case ResumeRowTypeName: {
                [param setObject:textCell.text forKey:@"real_name"];
                break;
            }
            case ResumeRowTypeGender: {
                [param setObject:@(genderSelected) forKey:@"gender"];
                break;
            }
            case ResumeRowTypeBirthplace: {
                [param setObject:self.value forKey:@"birth_province"];
                break;
            }
            case ResumeRowTypeBirthday: {
                NSString *birthday = [DateUtil getFormatTime:datePicker.date format:@"yyyy-MM-dd HH:mm:ss"];
                [param setObject:birthday forKey:@"birthday"];
                break;
            }
            case ResumeRowTypePhone: {
                [param setObject:textCell.text forKey:@"mobile"];
                break;
            }
            case ResumeRowTypeInterest: {
                [param setObject:@[@{@"key":@"interest", @"value":textView.text}] forKey:@"data"];
                [param setObject:@(MethodType_UserInfo_Update) forKey:@"method"];
                [param removeObjectForKey:@"resumeId"];
                break;
            }
            case ResumeRowTypeSelfIntroduction: {
                [param setObject:textView.text forKey:@"self_introduction"];
                break;
            }
            case ResumeRowTypeHonour: {
                [param setObject:textView.text forKey:@"honor"];
                break;
            }
            case ResumeRowTypeResidential: {
                [param setObject:self.value forKey:@"live_province"];
                break;
            }
            case ResumeRowTypeWorkExperience: {
                [param setObject:@(self.workType) forKey:@"work_experience"];
                break;
            }
            default: {
                break;
            }
        }
        [UserManager setData:param success:^(id JSON) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"json - %@", JSON);
            if ([JSON[@"success"] boolValue]) {
                [self handleData];
            } else {
                if (JSON[@"message"]) {
                    [InfoAlertView showInfo:JSON[@"message"] inView:self.view duration:1.0];
                }
            }
        } failure:^(NSError *error, id JSON) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    } else {
        if (self.editType == ResumeRowTypeInterest) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:@[@{@"key":@"interest", @"value":textView.text}] forKey:@"data"];
            [param setObject:@(MethodType_UserInfo_Update) forKey:@"method"];
            [UserManager setData:param success:^(id JSON) {
                if ([JSON[@"success"] boolValue]) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self handleData];
                } else {
                    if (JSON[@"message"]) {
                        [InfoAlertView showInfo:JSON[@"message"] inView:self.view duration:1.0];
                    }
                }
            } failure:^(NSError *error, id JSON) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        } else {
            [self handleData];
        }
    }
}

#pragma mark - private
- (void)handleData
{
    switch (self.editType) {
        case ResumeRowTypeName: {
            [self.delegate updateType:self.editType value:textCell.text index:self.index];
            break;
        }
        case ResumeRowTypeGender: {
            [self.delegate updateType:self.editType key:genderSelected index:self.index];
            break;
        }
        case ResumeRowTypeBirthplace: {
            [self.delegate updateType:self.editType value:self.value index:self.index];
            break;
        }
        case ResumeRowTypeBirthday: {
            NSString *birthday = [DateUtil getFormatTime:datePicker.date format:@"yyyy-MM-dd"];
            [self.delegate updateType:self.editType value:birthday index:self.index];
            break;
        }
        case ResumeRowTypePhone: {
            [self.delegate updateType:self.editType value:textCell.text index:self.index];
            break;
        }
        case ResumeRowTypeInterest: {
            [self.delegate updateType:self.editType value:textView.text index:self.index];
            break;
        }
        case ResumeRowTypeSelfIntroduction: {
            [self.delegate updateType:self.editType value:textView.text index:self.index];
            break;
        }
        case ResumeRowTypeHonour: {
            [self.delegate updateType:self.editType value:textView.text index:self.index];
            break;
        }
        case ResumeRowTypeResidential: {
            [self.delegate updateType:self.editType value:self.value index:self.index];
            break;
        }
        case ResumeRowTypeWorkExperience: {
            [self.delegate updateType:self.editType key:self.workType index:self.index];
            break;
        }
        default: {
            break;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter & setter
- (NSArray *)provices
{
    if (!_provices) {
        NSString *bundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Province.bundle"];
        NSArray *array = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/provinces.plist", bundlePath]];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSString *province in array) {
            PairDTO *dto = [[PairDTO alloc] init:@{}];
            dto.value = province;
            [arrayM addObject:dto];
        }
        _provices = [NSArray arrayWithArray:arrayM];
    }
    return _provices;
}

- (NSArray *)experiences
{
    if (!_experiences) {
        NSArray *titles = @[@"1年以内", @"1~3年", @"3~5年", @"5~10年", @"10年以上"];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (WorkExperienceType i = WorkExperienceTypeOverOne; i <= WorkExperienceTypeOverTen; i ++) {
            PairDTO *dto = [[PairDTO alloc] init:@{}];
            dto.type = i;
            dto.value = titles[(i - WorkExperienceTypeOverOne)];
            [arrayM addObject:dto];
        }
        _experiences = [NSArray arrayWithArray:arrayM];
    }
    return _experiences;
}

- (NSArray *)genders
{
    if (!_genders) {
        _genders = @[@"男", @"女"];
    }
    return _genders;
}

@end
