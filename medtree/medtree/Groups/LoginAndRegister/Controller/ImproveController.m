//
//  ImproveController.m
//  medtree
//
//  Created by 孙晨辉 on 15/8/7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ImproveController.h"
#import "LocalFileController.h"
#import "ExperienceLoactionController.h"
#import "ExperienceOrgController.h"
#import "ExperienceDepController.h"
#import "ExperienceTitleController.h"
#import "RegisterSelectTimeController.h"
#import "AddTitleController.h"
#import "RootViewController.h"
//#import "VerifyController.h"
//#import "JobIntensionController.h"
// view
#import "CommonCell.h"
#import "LoadingView.h"
#import "InfoAlertView.h"
#import "ProgressHUD.h"
// tool
#import "JSONKit.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "EncodeUtil.h"
#import "ImageCenter.h"
// manager
#import "AccountHelper.h"
#import "ServiceManager.h"
// DTO
#import "OrganizationNameDTO.h"
#import "ProvinceDTO.h"
#import "DepartmentNameDTO.h"
#import "TitleDTO.h"
#import "UserDTO.h"

#define CHCellHeight 70

@interface ImproveController () <CommonCellDelegate, RegisterSelectTimeControllerDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
{
    /** 描述信息 */
    UILabel                 *titleLabel;
    /** 内容包装 */
    UIScrollView            *contentView;
    /** 姓名 */
    CommonCell              *nameCell;
    /** 单位 */
    CommonCell              *organCell;
    /** 部门 */
    CommonCell              *departmentCell;
    /** 职称 */
    CommonCell              *titleCell;
    /** 时间 */
    CommonCell              *durationCell;
    /** 复选框 */
    UIButton                *checkButton1;
    UIButton                *checkButton2;
    /** 用户协议Btn */
    UIButton                *rulesButton;
    /** 注册Btn */
    UIButton                *verifyButton;
    /** 时间计时器 */
    NSTimer                 *codeTime;
    /** 时间计时 */
    NSInteger               timeNum;
    /** cell data list */
    NSArray                 *cells;
    /** 键盘高度 */
    CGFloat                 kbEndY;
    
    //------------------------- 原来的逻辑代码
    /** 职称 */
    TitleDTO                *titleDto;
    /** 组织机构 */
    OrganizationNameDTO     *organDto;
    /** 部门 */
    DepartmentNameDTO       *departDto;
    /** 时间 */
    NSString                *startDate;
    NSString                *endDate;
    /** scrollview 滚动时候 不接收cell的事件响应 */
    BOOL                    scrolling;
}

@end

@implementation ImproveController
#pragma mark - register noti
- (void)registerNotifications
{
    [super registerNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    self.view.backgroundColor = [ColorUtil getColor:@"F4F4F7" alpha:1];
    [naviBar setTopTitle:@"完善个人信息"];
    
    contentView = [[UIScrollView alloc] init];
    contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    contentView.delegate = self;
    [self.view addSubview:contentView];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"";
    titleLabel.textColor = [ColorUtil getColor:@"767676" alpha:1.0];
    titleLabel.font = [MedGlobal getLittleFont];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"[医树]是医学专业人员的家园，为维护家园的环境，并提供给您更贴切的内容，请您完善一下信息";
    [contentView addSubview:titleLabel];
    
    nameCell = [CommonCell commoncell];
    nameCell.showHeadLine = YES;
    nameCell.title = @"姓名";
    nameCell.placeHolder = @"医树是实名社区，请填写您的真实姓名";
    nameCell.returnKeyType = UIReturnKeyNext;
    nameCell.returnKeyClicked = ^(){
        [weakSelf chooseOrgin];
    };
    [contentView addSubview:nameCell];
    
    organCell = [CommonCell commoncell];
    organCell.title = @"单位";
    organCell.placeHolder = @"请选择您当前所在的单位";
    organCell.textFieldInteractionEnabled = NO;
    [contentView addSubview:organCell];
    
    departmentCell = [CommonCell commoncell];
    departmentCell.title = @"部门";
    departmentCell.placeHolder = @"请选择您当前所在的部门";
    departmentCell.textFieldInteractionEnabled = NO;
    [contentView addSubview:departmentCell];
    
    titleCell = [CommonCell commoncell];
    titleCell.title = @"职称";
    titleCell.placeHolder = @"请选择您当前的职称";
    titleCell.textFieldInteractionEnabled = NO;
    [contentView addSubview:titleCell];
    
    durationCell = [CommonCell commoncell];
    durationCell.title = @"时间";
    durationCell.placeHolder = @"请选择您加入当前单位的时间";
    durationCell.textFieldInteractionEnabled = NO;
    [contentView addSubview:durationCell];
    
    checkButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton1 setTitle:@"我已阅读并同意" forState:UIControlStateNormal];
    [checkButton1.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [checkButton1 setImage:[ImageCenter getBundleImage:@"register_checked.png"] forState:UIControlStateSelected];
    [checkButton1 setImage:[ImageCenter getBundleImage:@"register_unchecked.png"] forState:UIControlStateNormal];
    [checkButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkButton1 addTarget:self action:@selector(agreeOurRules:) forControlEvents:UIControlEventTouchUpInside];
    checkButton1.titleLabel.font = [MedGlobal getLittleFont];
    checkButton1.selected = YES;
    [contentView addSubview:checkButton1];
    checkButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton2 setTitle:@"使用规则" forState:UIControlStateNormal];
    [checkButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkButton2 addTarget:self action:@selector(agreeOurRules:) forControlEvents:UIControlEventTouchUpInside];
    checkButton2.titleLabel.font = [MedGlobal getLittleFont];
    checkButton2.selected = YES;
    [contentView addSubview:checkButton2];
    
    rulesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rulesButton setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [rulesButton setTitleColor:[ColorUtil getColor:@"365c8a" alpha:1.0] forState:UIControlStateNormal];
    [rulesButton addTarget:self action:@selector(clickRules) forControlEvents:UIControlEventTouchUpInside];
    rulesButton.titleLabel.font = [MedGlobal getLittleFont];
    [contentView addSubview:rulesButton];
    
    verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifyButton setTitle:@"开始我的医树" forState:UIControlStateNormal];
    [verifyButton setBackgroundColor:[ColorUtil getColor:@"365c8a" alpha:1.0]];
    [verifyButton addTarget:self action:@selector(clickRegist) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:verifyButton];
    
    cells = @[nameCell, organCell, departmentCell, titleCell, durationCell];
    for (int i = 0; i < cells.count; i ++) {
        CommonCell *cell = cells[i];
        cell.delegate = self;
        cell.tag = i + 1;
    }
    if (self.isDismiss) {
        [self createCloseButton];
    } else {
        [self createBackButton];
    }
}

- (void)createCloseButton
{
    UIButton *closeBUtton = [NavigationBar createNormalButton:@"关闭" target:self action:@selector(clickClose)];
    [naviBar setLeftButton:closeBUtton];
}

- (void)clickClose
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    [self setupData];
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    
    contentView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, size.height - CGRectGetMaxY(naviBar.frame));
    
    CGFloat margin = 30;
    CGFloat titleLabelW = size.width - margin * 2;
    CGSize titleLabelS = [titleLabel.text boundingRectWithSize:CGSizeMake(titleLabelW, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:titleLabel.font} context:nil].size;
    titleLabel.frame = CGRectMake(margin, margin, titleLabelW, titleLabelS.height);
    CGFloat topCellY = CGRectGetMaxY(titleLabel.frame) + 25;
    CGFloat cellH = CHCellHeight;
    [cells enumerateObjectsUsingBlock:^(CommonCell *cell, NSUInteger idx, BOOL *stop) {
        CGFloat cellY = topCellY + cellH * idx;
        cell.frame = CGRectMake(0, cellY, size.width, cellH);
    }];
    
    CGFloat cellMaxY = topCellY + cellH * cells.count;
    CGSize checkButton1Size = [checkButton1.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:checkButton1.titleLabel.font}];
    UIImage *image = [ImageCenter getBundleImage:@"register_check_click.png"];
    CGFloat checkBtnImageW = image.size.width;
    CGFloat checkButton1X = 15;
    CGFloat checkBtnY = cellMaxY + 17;
    CGFloat checkButton1W = checkButton1Size.width + checkBtnImageW;
    CGFloat checkButton1H = checkButton1Size.height;
    CGSize rulesButtonSize = [rulesButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:rulesButton.titleLabel.font}];
    checkButton1.frame = CGRectMake(checkButton1X, checkBtnY, checkButton1W, checkButton1H);
    CGFloat checkButton1MaxX = CGRectGetMaxX(checkButton1.frame);
    CGFloat rulesButtonX = checkButton1MaxX;
    CGFloat rulesButtonY = checkBtnY;
    CGFloat rulesButtonW = rulesButtonSize.width;
    CGFloat rulesButtonH = rulesButtonSize.height;
    rulesButton.frame = CGRectMake(rulesButtonX, rulesButtonY, rulesButtonW, rulesButtonH);
    CGFloat rulesButtonMaxX = CGRectGetMaxX(rulesButton.frame);
    CGSize checkButton2Size = [checkButton2.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:checkButton2.titleLabel.font}];
    CGFloat checkButton2X = rulesButtonMaxX;
    CGFloat checkButton2W = checkButton2Size.width;
    CGFloat checkButton2H = checkButton2Size.height;
    checkButton2.frame = CGRectMake(checkButton2X, checkBtnY, checkButton2W, checkButton2H);
    
    // 注册
    CGFloat checkBtnMaxY = CGRectGetMaxY(checkButton1.frame);
    CGFloat verifyButtonX = 20;
    CGFloat verifyButtonY = checkBtnMaxY + 14;
    CGFloat verifyButtonW = size.width - verifyButtonX * 2;
    CGFloat verifyButtonH = 50;
    verifyButton.frame = CGRectMake(verifyButtonX, verifyButtonY, verifyButtonW, verifyButtonH);
    verifyButton.layer.masksToBounds = YES;
    verifyButton.layer.cornerRadius = 4;
    
    CGFloat maxHeight = CGRectGetMaxY(verifyButton.frame);
    CGSize contentSize = CGSizeZero;
    if (maxHeight < size.height) {
        contentSize = CGSizeMake(size.width, maxHeight);
    }
    else {
        contentSize = CGSizeMake(size.width, maxHeight + 80);
    }
    
    contentView.contentSize = contentSize;
}

- (void)setupData
{
    if (self.userType <= UserTypes_ManagementAndAdministrative) { // 医生、护士、其他医务人员
        organCell.placeHolder = @"请选择您当前所在的单位";
        organCell.title = @"医院";
        departmentCell.placeHolder = @"请选择您当前所在的科室";
        departmentCell.title = @"科室";
        durationCell.placeHolder = @"请选择您加入当前医院的时间";
        durationCell.title = @"时间";
        titleCell.placeHolder = @"请选择您当前职称";
        titleCell.title = @"职称";
    } else if (self.userType == UserTypes_MedicalTeaching || self.userType == UserTypes_AlwaysBecome) { // 其他
        organCell.placeHolder = @"请选择您当前所在的单位";
        organCell.title = @"单位";
        departmentCell.placeHolder = @"请选择您当前所在的部门";
        departmentCell.title = @"部门";
        durationCell.placeHolder = @"请选择您加入当前单位的时间";
        durationCell.title = @"时间";
        titleCell.placeHolder = @"请选择您当前职称";
        titleCell.title = @"职称";
    } else if (self.userType == UserTypes_Students) { // 学生
        organCell.placeHolder = @"请选择您当前所在的学校";
        organCell.title = @"学校";
        departmentCell.placeHolder = @"请选择您当前学习方向";
        departmentCell.title = @"学习方向";
        durationCell.placeHolder = @"请选择加入当前学校的时间";
        durationCell.title = @"时间";
        titleCell.placeHolder = @"请选择您当前的学历(含在读)";
        titleCell.title = @"学历";
    }
}

#pragma mark - navi
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

#pragma mark 注册
- (void)clickRegist
{    
    NSString *msg = @"";
    NSInteger number = self.userType;
    // 免责手册
    if (!checkButton1.isSelected) {
        msg = @"您尚未同意使用条例";
    }
    // 职称
    if (titleCell.text.length == 0) {
        if (number == 8) {
            msg = @"请选择您当前的学历(含在读)";
        } else {
            msg = @"请选择您当前的职称";
        }
    }
    // 时间
    if (durationCell.text.length == 0) {
        if (number < 7) {
            msg = @"请选择加入本医院的时间";
        } else if (number == 7 || number == 10) {
            msg = @"请选择加入本单位的时间";
        } else if (number == 8) {
            msg = @"请选择入学的时间";
        }
    }
    // 部门
    if (departmentCell.text.length == 0) {
        if (number < 7) {
            msg = @"请选择您当前所在科室";
        } else if (number == 7 || number == 10) {
            msg = @"请选择您当前所在部门";
        } else if (number == 8) {
            msg = @"请选择您当前学习方向";
        }
    }
    // 组织
    if (organCell.text.length == 0) {
        if (number < 7) {
            msg = @"请选择您当前所在医院";
        } else if (number == 7) {
            msg = @"请选择您当前所在单位";
        } else if (number == 8) {
            msg = @"请选择您当前所在学校";
        }
    }
    // 姓名
    if (nameCell.text.length == 0) {
        msg = @"请填写真实姓名";
    }
    if (msg.length == 0) {
        [self getRegister];
        self.view.userInteractionEnabled = NO;
    } else {
        [InfoAlertView showInfo:msg inView:self.view duration:1];
    }
}

#pragma mark 确认是否同意
- (void)agreeOurRules:(UIButton *)button
{
    button.selected = !button.isSelected;
    checkButton1.selected = button.isSelected;
}

#pragma mark 阅读协议
- (void)clickRules
{
    LocalFileController *rules = [[LocalFileController alloc] init];
    [self.navigationController pushViewController:rules animated:YES];
}

#pragma mark - private
#pragma mark 验证完成开始注册
- (void)getRegister
{
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc] init];

    // 姓名
    [dictM setObject:nameCell.text forKey:@"realname"];
    // 组织机构
    [dictM setObject:organDto.province.name forKey:@"province"];
    [dictM setObject:organDto.organizationID.length > 0 ? organDto.organizationID : @"" forKey:@"organization_id"];
    [dictM setObject:organDto.name forKey:@"organization"];
    [dictM setObject:@(organDto.type) forKey:@"org_type"];
    // 部门
    NSMutableArray *depArray = [[NSMutableArray alloc] init];
    [depArray addObject:@{@"department_id":departDto.departmentID,@"department":departDto.name}];
    if (departDto.parent_name.length > 0) { // 有两级目录
        [depArray addObject:@{@"department_id":departDto.parent_id,@"department":departDto.parent_name}];
    }
    [dictM setObject:depArray forKey:@"departments"];
    // 职称
    [dictM setObject:titleDto.title forKey:@"title"];
    [dictM setObject:@(titleDto.titleType) forKey:@"title_type"];
    // 时间
    NSString *startTime = startDate;
    startTime = [startTime stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    startTime = [NSString stringWithFormat:@"%@-01-01 00:00:00",startTime];
    [dictM setValue:startTime forKey:@"start_time"];
    
    if (endDate.length == 0) {
        [dictM setValue:@"" forKey:@"end_time"];
    } else {
        NSString *endTime = endDate;
        endTime = [endTime stringByReplacingOccurrencesOfString:@"." withString:@"-"];
        endTime = [NSString stringWithFormat:@"%@-01-01 00:00:00",endTime];
        [dictM setValue:endTime forKey:@"end_time"];
    }
    
    [dictM setObject:@(MethodType_Register_RegisterExperience) forKey:@"method"];
    
    [[ProgressHUD instance] showProgressHD:YES inView:self.view info:@"完善信息中..."];
    [AccountHelper tryToVeryfyInformation:dictM success:^(id JSON) {
        [[ProgressHUD instance] showProgressHD:NO inView:self.view info:@"完善信息中"];
        self.view.userInteractionEnabled = YES;
        if ([JSON[@"success"] boolValue]) {
            NSLog(@"注册成功 ------ %@", JSON);
            [AccountHelper setAccount:[[UserDTO alloc] init:JSON[@"result"]]];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ImproveThePersonalInformationSuccessNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [InfoAlertView showInfo:JSON[@"message"] duration:1.0];
        }
    } failure:^(NSError *error, id JSON) {
        [[ProgressHUD instance] showProgressHD:NO inView:self.view info:@"注册中"];
        [InfoAlertView showInfo:error.localizedDescription duration:1.0];
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)textFieldresignFirstResponder
{
    for (CommonCell *cell in cells)
    {
        if ([cell isFirstResponder])
        {
            [cell resignFirstResponder];
        }
    }
}

#pragma mark 选择机构
- (void)chooseOrgin
{
    [self textFieldresignFirstResponder];
    NSLog(@"选择机构");
    ExperienceLoactionController *location = [[ExperienceLoactionController alloc] init];
    [self.navigationController pushViewController:location animated:YES];
    location.parent = self;
    NSInteger org_type = OrgType_Hospital;
    ExperienceType exp_type = ExperienceType_Work;
    if (self.userType == UserTypes_Students) {
        org_type = OrgType_School;
        exp_type = ExperienceType_Edu;
    } else if (self.userType == UserTypes_MedicalTeaching || self.userType == UserTypes_AlwaysBecome) {
        org_type = OrgType_All;
    }
    location.expType = exp_type;
    location.fromVC = self;
    location.userType = self.userType;
    [location setOrgType:(OrgType)org_type];
}

#pragma mark 选择部门
- (void)chooseDepart
{
    [self textFieldresignFirstResponder];
    NSLog(@"选择部门");
    if (organDto.name.length == 0) {
        if (self.userType < UserTypes_MedicalTeaching) {
            [InfoAlertView showInfo:@"请先选择您当前所在医院" inView:self.view duration:1];
        } else if (self.userType == UserTypes_MedicalTeaching || self.userType == UserTypes_AlwaysBecome) {
            [InfoAlertView showInfo:@"请先选择您当前所在单位" inView:self.view duration:1];
        } else if (self.userType == UserTypes_Students) {
            [InfoAlertView showInfo:@"请先选择您当前所在学校" inView:self.view duration:1];
        }
    } else {
        ExperienceDepController *dep = [[ExperienceDepController alloc] init];
        dep.parent = self;
        dep.orgType = (OrgType)organDto.type;
        dep.experienceType = (self.userType!=UserTypes_Students)?ExperienceType_Work:ExperienceType_Edu;
        dep.organDto = organDto;
        dep.fromVC = self;
        dep.depName = departmentCell.text;
        [self.navigationController pushViewController:dep animated:YES];
    }
}

#pragma mark 选择学历、职务
- (void)chooseTitle
{
    [self textFieldresignFirstResponder];
    if (organDto.name.length == 0) {
        if (self.userType < UserTypes_MedicalTeaching) {
            [InfoAlertView showInfo:@"请先选择您当前所在医院" inView:self.view duration:1];
        } else if (self.userType == UserTypes_MedicalTeaching || self.userType == UserTypes_AlwaysBecome) {
            [InfoAlertView showInfo:@"请先选择您当前所在单位" inView:self.view duration:1];
        } else if (self.userType == UserTypes_Students) {
            [InfoAlertView showInfo:@"请先选择您当前所在学校" inView:self.view duration:1];
        }
    } else {
        OrgType org_type = (OrgType)organDto.type;
        ExperienceType experience_type = ExperienceType_Work;
        if (self.userType == UserTypes_Students) {
            experience_type = ExperienceType_Edu;
            org_type = OrgType_School;
        }
        if (org_type == OrgType_Unit) { // 其他
            AddTitleController *add = [[AddTitleController alloc] init];
            add.fromVC = self;
            add.parent = self;
            [self.navigationController pushViewController:add animated:YES];
        } else {
            ExperienceTitleController *titleVC = [[ExperienceTitleController alloc] init];
            titleVC.experienceType = experience_type;
            titleVC.orgType = org_type;;
            titleVC.titleDto = titleDto;
            titleVC.parent = self;
            titleVC.userType = self.userType;
            [self.navigationController pushViewController:titleVC animated:YES];
        }
    }
}

#pragma mark 选择时间
- (void)chooseTime
{
    [self textFieldresignFirstResponder];
    NSLog(@"选择起止时间");
    if (organDto.name.length == 0) {
        if (self.userType < UserTypes_MedicalTeaching) {
            [InfoAlertView showInfo:@"请先选择您当前所在医院" inView:self.view duration:1];
        } else if (self.userType == UserTypes_MedicalTeaching || self.userType == UserTypes_AlwaysBecome) {
            [InfoAlertView showInfo:@"请先选择您当前所在单位" inView:self.view duration:1];
        } else if (self.userType == UserTypes_Students) {
            [InfoAlertView showInfo:@"请先选择您当前所在学校" inView:self.view duration:1];
        }
    } else {
        ExperienceType experience_type = ExperienceType_Work;
        if (self.userType == UserTypes_Students) {
            experience_type = ExperienceType_Edu;
        }
        RegisterSelectTimeController *time = [[RegisterSelectTimeController alloc] init];
        time.parent = self;
        time.startTime = startDate;
        time.endTime = endDate;
        time.userType = self.userType;
        time.orgType = organDto.type;
        time.experienceType = experience_type;
        [self.navigationController pushViewController:time animated:YES];
    }
}

#pragma mark - RegisterSelectTimeControllerDelegate
- (void)updateTime:(NSDictionary *)dict
{
    startDate = [dict objectForKey:@"start"];
    endDate = [dict objectForKey:@"end"];
    if ((NSObject *)[dict objectForKey:@"end"] == [NSNull null] || [[dict objectForKey:@"end"] length] == 0) {
        durationCell.text = [NSString stringWithFormat:@"%@--至今",[dict objectForKey:@"start"]];
    } else {
        durationCell.text = [NSString stringWithFormat:@"%@--%@",[dict objectForKey:@"start"],[dict objectForKey:@"end"]];
    }
}

#pragma mark - parent Delegate
- (void)updateInfo:(NSDictionary *)dict
{
    if ([[dict objectForKey:@"data"] isEqualToString:@"title"]) {   // 职位
        titleDto = dict[@"title"];
        titleCell.text = titleDto.title;
    } else if ([[dict objectForKey:@"data"] isEqualToString:@"organization"]) {   // 组织机构
        organDto = dict[@"organization"];
        organCell.text = organDto.name;
        //重置科室／时间
        departmentCell.text = @"";
        durationCell.text = @"";
        titleCell.text = @"";
        titleDto = nil;
        departDto = nil;
        startDate = @"";
        endDate = @"";
    } else if ([[dict objectForKey:@"data"] isEqualToString:@"department"]) { //  部门
        departDto = dict[@"department"];
        departmentCell.text = departDto.name;
    }
}

#pragma mark - CommonCellDelegate
- (void)clickCell:(CommonCell *)cell
{
    if (scrolling) return;
    NSInteger tag = cell.tag;
    [self textFieldresignFirstResponder];
    switch (tag) {
        case CommonCellType_Name:
            [cell becomeFirstResponder];
            break;
        case CommonCellType_Organ:
            [self chooseOrgin];
            break;
        case CommonCellType_Department:
            [self chooseDepart];
            break;
        case CommonCellType_Duration:
            [self chooseTime];
            break;
        case CommonCellType_Title:
            [self chooseTitle];
            break;
        default:
            break;
    }
}

- (void)textFieldBecomeFirstRespond:(CommonCell *)cell
{
    if (kbEndY == 0) return;
    CGFloat delta = kbEndY - (CGRectGetMaxY(cell.frame) + CGRectGetMaxY(naviBar.frame) - contentView.contentOffset.y);
    if (delta != CHCellHeight) { // 需要移出一个contentview的高度
        CGFloat offsetY = contentView.contentOffset.y;
        CGFloat newOffsetY = offsetY + (CHCellHeight - delta);
        [UIView animateWithDuration:0.25 animations:^{
            contentView.contentOffset = CGPointMake(0, newOffsetY);
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrolling = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    scrolling = NO;
}

#pragma mark - 键盘位置影响
- (void)keyboardWillShow:(NSNotification *)noti
{
    //获取键盘结束的y值
    CGRect kbEndFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbEndY = kbEndFrame.origin.y;
    CGFloat firstTextMaxY = 0;
    
    for (CommonCell *cell in cells) {
        if ([cell isFirstResponder]) {
            firstTextMaxY = CGRectGetMaxY(cell.frame);
        }
    }
    
    CGFloat contentViewMinY = CGRectGetMinY(contentView.frame);
    firstTextMaxY += contentViewMinY;
    CGFloat delta = firstTextMaxY - kbEndY + CHCellHeight;
    if (delta > 0) {// 键盘挡住输入框
        [UIView animateWithDuration:0.25 animations:^{
            contentView.contentOffset = CGPointMake(0, delta);
        }];
    }
}

@end

