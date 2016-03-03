//
//  VerifyController.m
//  medtree
//
//  Created by 孙晨辉 on 15/8/7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "VerifyController.h"
// view
#import "CommonCell.h"
#import "NewPersonIdentificationDetailController.h"
#import "VerifyByCodeController.h"
// tool
#import "ColorUtil.h"
#import "MedGlobal.h"
// dto
#import "CertificationDTO.h"
#import "UserDTO.h"
#import "AccountHelper.h"
#import "ExperienceDTO.h"
#import "UserType.h"
#import "DepartmentNameDTO.h"

@interface VerifyController () <CommonCellDelegate>
{
    /** 标题label */
    UILabel         *titleLabel;
    /** 上传证件照片 */
    CommonCell      *uploadPhotoCell;
    /** 或者label */
    UILabel         *orLabel;
    /** 分界线1 */
    UILabel         *dividingLine1;
    /** 分界线2 */
    UILabel         *dividingLine2;
    /** 推荐码 */
    CommonCell      *verifyCell;
    /** 推荐码描述label */
    UILabel         *descLabel;
    NSTimeInterval  time;
}

@end

@implementation VerifyController
#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"认证您的医学身份"];
    
    titleLabel = [self createLabelWithTittle:@"认证后可以管理您的人脉，享受专属权益"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    uploadPhotoCell = [self createCommomCellWithTitle:@"上传证件照片进行认证（胸牌等）" tag:CommonCellType_Upload];
    
    orLabel = [[UILabel alloc] init];
    orLabel.text = @"或者";
    orLabel.font = [UIFont systemFontOfSize:14];
    orLabel.textColor = [ColorUtil getColor:@"a4a4a4" alpha:1];
    orLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:orLabel];
    dividingLine1 = [[UILabel alloc] init];
    dividingLine1.backgroundColor = [ColorUtil getColor:@"d6d6d6" alpha:1];
    [orLabel addSubview:dividingLine1];
    dividingLine2 = [[UILabel alloc] init];
    dividingLine2.backgroundColor = [ColorUtil getColor:@"d6d6d6" alpha:1];
    [orLabel addSubview:dividingLine2];
    
    verifyCell = [self createCommomCellWithTitle:@"我有医树推荐码" tag:CommonCellType_VerifyCode];
    
    descLabel = [self createLabelWithTittle:@"*我有从医树或朋友得到的医树推荐码"];
    
    if (self.fromRegister) {
        [self createRightNaviButton];
    } else {
        [self createBackButton];
    }
}

- (UILabel *)createLabelWithTittle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [MedGlobal getLittleFont];
    label.textColor = [ColorUtil getColor:@"767676" alpha:1.0];
    label.text = title;
    [self.view addSubview:label];
    return label;
}

- (void)createRightNaviButton
{
    UIButton *button = [NavigationBar createNormalButton:@"以后再说" target:self action:@selector(clickNotVerify)];
    [naviBar setRightButton:button];
}

- (CommonCell *)createCommomCellWithTitle:(NSString *)title tag:(NSInteger)tag
{
    CommonCell *commonCell = [CommonCell commoncell];
    commonCell.textFieldInteractionEnabled = NO;
    commonCell.title = title;
    commonCell.tag = tag;
    commonCell.delegate = self;
    commonCell.showNextImg = YES;
    commonCell.showHeadLine = YES;
    commonCell.showMedLine = NO;
    commonCell.showFootLine = YES;
    [self.view addSubview:commonCell];
    return commonCell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView
{
    CGSize size = self.view.frame.size;

    CGFloat margin = 15;
    CGFloat cellH = 70;
    titleLabel.frame = CGRectMake(margin, CGRectGetMaxY(naviBar.frame) + 30, size.width - margin * 2, titleLabel.font.lineHeight);
    uploadPhotoCell.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 25, size.width, cellH);
    
    CGSize orLabelSize = [orLabel.text sizeWithAttributes:@{NSFontAttributeName:orLabel.font}];
    CGFloat orLabelX = 0;
    CGFloat orLabelY = CGRectGetMaxY(uploadPhotoCell.frame) + 20;
    CGFloat orLabelW = size.width;
    CGFloat orLabelH = orLabelSize.height;
    orLabel.frame = CGRectMake(orLabelX, orLabelY, orLabelW, orLabelH);
    CGFloat dividingLineY = orLabelH * 0.5;
    CGFloat dividingLine1X = 24;
    CGFloat dividingLineW = size.width * 0.5 - dividingLine1X * 2 - orLabelSize.width * 0.5;
    CGFloat dividingLineH = 1;
    dividingLine1.frame = CGRectMake(dividingLine1X, dividingLineY, dividingLineW, dividingLineH);
    CGFloat dividingLine2X = size.width * 0.5 + orLabelSize.width * 0.5 + dividingLine1X;
    dividingLine2.frame = CGRectMake(dividingLine2X, dividingLineY, dividingLineW, dividingLineH);
    
    verifyCell.frame = CGRectMake(0, CGRectGetMaxY(orLabel.frame) + 20, size.width, cellH);
    descLabel.frame = CGRectMake(margin, CGRectGetMaxY(verifyCell.frame) + 10, size.width - margin * 2, descLabel.font.lineHeight);
}

#pragma mark - click
- (void)clickNotVerify
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ImproveThePersonalInformationSuccessNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CommonCellDelegate
- (void)clickCell:(CommonCell *)cell
{
    NSTimeInterval begin = [[NSDate date] timeIntervalSince1970];
    if (begin - time < 0.3) return;
    time = begin;

    NSInteger tag = cell.tag;
    if (tag == CommonCellType_Upload) {
        NewPersonIdentificationDetailController *vc = [[NewPersonIdentificationDetailController alloc] init];
        if (self.fromRegister) {
            CertificationDTO *dto = [[CertificationDTO alloc] init];
            dto.userType = self.userType;
            vc.certifDto = dto;
        } else {
            vc.experienceDto = self.experienceDto;
            vc.fromVC = self.fromVC;
            vc.delegate = self.delegate;
            vc.certifDto = self.certifDto;
        }
        vc.fromRegister = self.fromRegister;
        //注册时候
        if (self.fromRegister) {
            UserDTO *udto = [AccountHelper getAccount];
            ExperienceDTO *experienceDTO;
            if (udto.user_type == UserTypes_Students) {
                experienceDTO = [[ExperienceDTO alloc] init:[udto.educationArray firstObject]];
            } else {
                experienceDTO = [[ExperienceDTO alloc] init:[udto.experienceArray firstObject]];
            }
            NSDictionary *dict = @{@"organization_name":experienceDTO.org,
                                   @"experience_id":experienceDTO.experienceId,
                                   @"dep":experienceDTO.department.name,
                                   @"title":experienceDTO.title};
            [vc updateInfo:dict];
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tag == CommonCellType_VerifyCode) {
        VerifyByCodeController *vc = [[VerifyByCodeController alloc] init];
        if (self.fromRegister) { // 注册
            CertificationDTO *dto = [[CertificationDTO alloc] init];
            dto.userType = self.userType;
            vc.certifDto = dto;
            
            UserDTO *udto = [AccountHelper getAccount];
            ExperienceDTO *experienceDTO;
            if (udto.user_type == UserTypes_Students) {
                experienceDTO = [[ExperienceDTO alloc] init:[udto.educationArray firstObject]];
            } else {
                experienceDTO = [[ExperienceDTO alloc] init:[udto.experienceArray firstObject]];
            }
            NSDictionary *dict = @{@"organization_name":experienceDTO.org,
                                   @"experience_id":experienceDTO.experienceId,
                                   @"dep":experienceDTO.department.name,
                                   @"title":experienceDTO.title};
            [vc updateInfo:dict];
        } else {
            vc.fromVC = self.fromVC;
            vc.delegate = self.delegate;
            vc.certifDto = self.certifDto;
            vc.experienceDto = self.experienceDto;
        }
        vc.fromRegister = self.fromRegister;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
