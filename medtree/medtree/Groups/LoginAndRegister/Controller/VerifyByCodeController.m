//
//  VerifyByCodeController.m
//  medtree
//
//  Created by 孙晨辉 on 15/8/10.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "VerifyByCodeController.h"
#import "CommonCell.h"
#import "ExperienceListController.h"
#import "LoadingView.h"
#import "YMScrollView.h"
// tool
#import "ColorUtil.h"
#import "MedGlobal.h"
#import "JSONKit.h"
// dto
#import "CertificationDTO.h"
#import "UserType.h"
// manager
#import "ServiceManager.h"

@interface VerifyByCodeController () <CommonCellDelegate>
{
    YMScrollView        *contentView;
    /** 描述 */
    UILabel             *descLabel;
    /** 医树推荐码 */
    UILabel             *medtreeTitleLab;
    CommonCell          *verifyCodeCell;
    /** 所在单位 */
    UILabel             *experienceTitleLab;
    /** 确认并保存 */
    UIButton            *saveButton;
    /** 经历id */
    NSString            *experience_id;
}

@property (nonatomic, strong) CommonCell *organCell;

@end

@implementation VerifyByCodeController

- (void)createUI
{
    [super createUI];
    
    contentView = [[YMScrollView alloc] init];
    [self.view addSubview:contentView];
    
    descLabel = [[UILabel alloc] init];
    descLabel.font = [MedGlobal getMiddleFont];
    descLabel.textColor = [ColorUtil getColor:@"767676" alpha:1.0];
    descLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:descLabel];
    
    medtreeTitleLab = [self createLabelWithTitle:@"    医树推荐码"];
    
    verifyCodeCell = [CommonCell commoncell];
    verifyCodeCell.placeHolder = @"请输入您得到的医树推荐码";
    verifyCodeCell.showMedLine = NO;
    verifyCodeCell.tag = CommonCellType_VerifyCode;
    verifyCodeCell.delegate = self;
    [contentView addSubview:verifyCodeCell];
    
    experienceTitleLab = [self createLabelWithTitle:@"    所在单位"];
    
    [contentView addSubview:self.organCell];
    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 4;
    [saveButton setTitle:@"确认并提交" forState:UIControlStateNormal];
    [saveButton setBackgroundColor:[ColorUtil getColor:@"365c8a" alpha:1]];
    [saveButton addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:saveButton];
}

- (UILabel *)createLabelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.backgroundColor = [ColorUtil getColor:@"E9E9E9" alpha:1];
    label.font = [MedGlobal getLittleFont];
    [contentView addSubview:label];
    return label;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBackButton];
    [naviBar setTopTitle:@"认证您的医学身份"];
    [self setupView];
    [self setupData];
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    
    contentView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, size.height - CGRectGetMaxY(naviBar.frame));
    descLabel.frame = CGRectMake(0, 0, size.width, 60);
    medtreeTitleLab.frame = CGRectMake(0, CGRectGetMaxY(descLabel.frame), size.width, 30);
    verifyCodeCell.frame = CGRectMake(0, CGRectGetMaxY(medtreeTitleLab.frame), size.width, 70);
    experienceTitleLab.frame = CGRectMake(0, CGRectGetMaxY(verifyCodeCell.frame), size.width, 30);
    _organCell.frame = CGRectMake(0, CGRectGetMaxY(experienceTitleLab.frame), size.width, 70);
    saveButton.frame = CGRectMake(44, CGRectGetMaxY(_organCell.frame) + 37, size.width - 88, 55);
    contentView.contentSize = CGSizeMake(size.width, CGRectGetMaxY(saveButton.frame));
}

- (void)setupData
{
    descLabel.text = [NSString stringWithFormat:@"身份：%@", [UserType getLabel:self.certifDto.userType]];
    
    if (self.experienceDto) {
        self.certifDto.reason = self.experienceDto.org;
        experience_id = self.experienceDto.experienceId;
        self.organCell.title = self.experienceDto.org;
    }
}

#pragma mark - click
- (void)clickSave
{
    NSString *msg = @"";
    if (self.certifDto.reason.length == 0) {
        msg = @"请选择所在单位";
    } else if (verifyCodeCell.text.length == 0) {
        msg = @"请添加推荐码";
    }
    if (msg.length == 0) {
        [self postData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }
}

#pragma mark - private 
- (void)postData
{
    [LoadingView showProgress:YES inView:self.view];
    NSString *verifyCode = verifyCodeCell.text;
    NSDictionary *dict = @{@"method":[NSNumber numberWithInt:MethodType_UserInfo_CertificationApply],
                           @"user_type":[NSNumber numberWithInteger:self.certifDto.userType],
                           @"reason":self.certifDto.reason,
                           @"experience_id":experience_id,
                           @"certi_code":verifyCode};
    [ServiceManager setData:dict success:^(id JSON) {
        self.view.userInteractionEnabled = YES;
        [LoadingView showProgress:NO inView:self.view];
        if ([[JSON objectForKey:@"success"] boolValue]) {
            if (self.fromRegister) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ImproveThePersonalInformationSuccessNotification object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                CertificationDTO *dto = [[CertificationDTO alloc] init:[JSON objectForKey:@"result"]];
                if (dto.status == CertificationStatusType_No) {
                    dto.status = CertificationStatusType_Wait;
                }
                [self.delegate updateCertificationArray:dto];
                [self.navigationController popToViewController:self.fromVC animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeCertificatedNotification object:nil];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[JSON objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alert show];
        }
    } failure:^(NSError *error, id JSON) {
        self.view.userInteractionEnabled = YES;
        [LoadingView showProgress:NO inView:self.view];
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if (result[@"message"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:result[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                [alert show];
            }
        }
    }];
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [verifyCodeCell resignFirstResponder];
}

#pragma mark - CommonCellDelegate
- (void)clickCell:(CommonCell *)cell
{
    NSInteger tag = cell.tag;
    if (tag == CommonCellType_VerifyCode) {
        [cell becomeFirstResponder];
    } else if (tag == CommonCellType_Organ) {
        if (_fromRegister) {
            return;
        }
        ExperienceListController *vc = [[ExperienceListController alloc] init];
        vc.fromVerify = YES;
        vc.experienceType = (self.certifDto.userType == 8) ? ExperienceType_Edu : ExperienceType_Work;
        vc.parent = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - public
- (void)updateInfo:(NSDictionary *)dict
{
    self.certifDto.reason = [dict objectForKey:@"organization_name"];
    experience_id = [dict objectForKey:@"experience_id"];
    self.organCell.title = [dict objectForKey:@"organization_name"];
}

#pragma mark -setter & getter
- (CommonCell *)organCell
{
    if (_organCell == nil) {
        _organCell = [CommonCell commoncell];
        _organCell.title = @"选择认证资料相关单位";
        _organCell.backgroundColor = [UIColor clearColor];
        _organCell.textFieldInteractionEnabled = NO;
        _organCell.tag = CommonCellType_Organ;
        _organCell.delegate = self;
    }
    return _organCell;
}

@end
