
//
//  RegisterController.m
//  medtree
//
//  Created by 孙晨辉 on 15/7/30.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "RegisterController.h"
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
#import "CommonHelper.h"
// manager
#import "AccountHelper.h"
#import "ServiceManager.h"
// DTO
#import "OrganizationNameDTO.h"
#import "ProvinceDTO.h"
#import "DepartmentNameDTO.h"
#import "TitleDTO.h"

NSString *const kRegistAction = @"RegistAction";

#define CHCellHeight 70

@interface RegisterController () <CommonCellDelegate, RegisterSelectTimeControllerDelegate, UIScrollViewDelegate>
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
    /** 手机号 */
    CommonCell              *phoneCell;
    /** 获取验证码 */
    UIButton                *obtainBtn;
    /** 验证码 */
    CommonCell              *captchaCell;
    /** 密码 */
    CommonCell              *passwordCell;
    /** 邀请人 */
    CommonCell              *inviteCell;
    /** 复选框 */
    UIButton                *checkBtn1;
    UIButton                *checkBtn2;
    /** 用户协议Btn */
    UIButton                *rulesBtn;
    /** 注册Btn */
    UIButton                *registBtn;
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
    
    NSTimeInterval          time;
}

@end

@implementation RegisterController
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
    [naviBar setTopTitle:@"注册"];
    
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
    
    phoneCell = [CommonCell commoncell];
    phoneCell.title = @"手机号";
    phoneCell.placeHolder = @"请输入您的真实手机号";
    phoneCell.keyboardType = UIKeyboardTypePhonePad;
    phoneCell.returnKeyType = UIReturnKeySend;
    phoneCell.maxLength = 11;
    phoneCell.returnKeyClicked = ^(){
        [weakSelf obtainCaptcha];
    };
    [contentView addSubview:phoneCell];
    
    obtainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [obtainBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    obtainBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [obtainBtn setTitleColor:[ColorUtil getColor:@"365c8a" alpha:1.0] forState:UIControlStateNormal];
    [obtainBtn addTarget:self action:@selector(obtainCaptcha) forControlEvents:UIControlEventTouchUpInside];
    [phoneCell addSubview:obtainBtn];
    
    captchaCell = [CommonCell commoncell];
    captchaCell.title = @"验证码";
    captchaCell.placeHolder = @"请输入手机短信验证码";
    captchaCell.keyboardType = UIKeyboardTypeNumberPad;
    captchaCell.returnKeyType = UIReturnKeyNext;
    captchaCell.maxLength = 4;
    captchaCell.returnKeyClicked = ^(){
        [weakSelf->passwordCell becomeFirstResponder];
    };
    [contentView addSubview:captchaCell];
    
    passwordCell = [CommonCell commoncell];
    passwordCell.title = @"密码";
    passwordCell.placeHolder = @"请设置6位以上密码，至少包含1个字母";
    passwordCell.keyboardType = UIKeyboardTypeDefault;
    passwordCell.returnKeyType = UIReturnKeyNext;
    passwordCell.secureTextEntry = YES;
    passwordCell.returnKeyType = UIReturnKeyNext;
    passwordCell.maxLength = 16;
    passwordCell.returnKeyClicked = ^(){
        [weakSelf->inviteCell becomeFirstResponder];
    };
    [contentView addSubview:passwordCell];
    
    inviteCell = [CommonCell commoncell];
    inviteCell.title = @"邀请人(选填)";
    inviteCell.placeHolder = @"如您是受邀加入，请填写邀请人医树号";
    inviteCell.showFootLine = YES;
    inviteCell.showMedLine = NO;
    inviteCell.keyboardType = UIKeyboardTypeNumberPad;
    inviteCell.returnKeyType = UIReturnKeyGo;
    inviteCell.returnKeyClicked = ^(){
        [weakSelf clickRegist];
    };
    [contentView addSubview:inviteCell];
    
    checkBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn1 setTitle:@"我已阅读并同意" forState:UIControlStateNormal];
    [checkBtn1.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [checkBtn1 setImage:[ImageCenter getBundleImage:@"register_checked.png"] forState:UIControlStateSelected];
    [checkBtn1 setImage:[ImageCenter getBundleImage:@"register_unchecked.png"] forState:UIControlStateNormal];
    [checkBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkBtn1 addTarget:self action:@selector(agreeOurRules:) forControlEvents:UIControlEventTouchUpInside];
    checkBtn1.titleLabel.font = [MedGlobal getLittleFont];
    checkBtn1.selected = YES;
    [contentView addSubview:checkBtn1];
    checkBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn2 setTitle:@"使用规则" forState:UIControlStateNormal];
    [checkBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkBtn2 addTarget:self action:@selector(agreeOurRules:) forControlEvents:UIControlEventTouchUpInside];
    checkBtn2.titleLabel.font = [MedGlobal getLittleFont];
    checkBtn2.selected = YES;
    [contentView addSubview:checkBtn2];
    
    rulesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rulesBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [rulesBtn setTitleColor:[ColorUtil getColor:@"365c8a" alpha:1.0] forState:UIControlStateNormal];
    [rulesBtn addTarget:self action:@selector(clickRules) forControlEvents:UIControlEventTouchUpInside];
    rulesBtn.titleLabel.font = [MedGlobal getLittleFont];
    [contentView addSubview:rulesBtn];
    
    registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registBtn setBackgroundColor:[ColorUtil getColor:@"365c8a" alpha:1.0]];
    [registBtn addTarget:self action:@selector(clickRegist) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:registBtn];
    
    cells = @[nameCell, organCell, departmentCell, titleCell, durationCell, phoneCell, captchaCell, passwordCell, inviteCell];
    for (int i = 0; i < cells.count; i ++) {
        CommonCell *cell = cells[i];
        cell.delegate = self;
        cell.tag = i + 1;
    }
    
    [self createBackButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_phoneNum) {
        phoneCell.text = _phoneNum;
    }
    timeNum = 60;
    
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
    
    CGSize obtainBtnSize = [[obtainBtn titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName:obtainBtn.titleLabel.font}];
    CGFloat obtainBtnX = size.width - obtainBtnSize.width - 15;
    CGFloat obtainBtnY = (cellH - obtainBtnSize.height) * 0.5;
    CGFloat obtainBtnW = obtainBtnSize.width;
    CGFloat obtainBtnH = obtainBtnSize.height;
    obtainBtn.frame = CGRectMake(obtainBtnX, obtainBtnY, obtainBtnW, obtainBtnH);
    
    CGFloat cellMaxY = topCellY + cellH * cells.count;
    CGSize checkBtn1Size = [checkBtn1.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:checkBtn1.titleLabel.font}];
    UIImage *image = [ImageCenter getBundleImage:@"register_check_click.png"];
    CGFloat checkBtnImageW = image.size.width;
    CGFloat checkBtn1X = 15;
    CGFloat checkBtnY = cellMaxY + 17;
    CGFloat checkBtn1W = checkBtn1Size.width + checkBtnImageW;
    CGFloat checkBtn1H = checkBtn1Size.height;
    CGSize rulesBtnSize = [rulesBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:rulesBtn.titleLabel.font}];
    checkBtn1.frame = CGRectMake(checkBtn1X, checkBtnY, checkBtn1W, checkBtn1H);
    CGFloat checkBtn1MaxX = CGRectGetMaxX(checkBtn1.frame);
    CGFloat rulesBtnX = checkBtn1MaxX;
    CGFloat rulesBtnY = checkBtnY;
    CGFloat rulesBtnW = rulesBtnSize.width;
    CGFloat rulesBtnH = rulesBtnSize.height;
    rulesBtn.frame = CGRectMake(rulesBtnX, rulesBtnY, rulesBtnW, rulesBtnH);
    CGFloat rulesBtnMaxX = CGRectGetMaxX(rulesBtn.frame);
    CGSize checkBtn2Size = [checkBtn2.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:checkBtn2.titleLabel.font}];
    CGFloat checkBtn2X = rulesBtnMaxX;
    CGFloat checkBtn2W = checkBtn2Size.width;
    CGFloat checkBtn2H = checkBtn2Size.height;
    checkBtn2.frame = CGRectMake(checkBtn2X, checkBtnY, checkBtn2W, checkBtn2H);
    
    // 注册
    CGFloat checkBtnMaxY = CGRectGetMaxY(checkBtn1.frame);
    CGFloat registBtnX = 20;
    CGFloat registBtnY = checkBtnMaxY + 14;
    CGFloat registBtnW = size.width - registBtnX * 2;
    CGFloat registBtnH = 50;
    registBtn.frame = CGRectMake(registBtnX, registBtnY, registBtnW, registBtnH);
    registBtn.layer.masksToBounds = YES;
    registBtn.layer.cornerRadius = 4;
    
    CGFloat maxHeight = CGRectGetMaxY(registBtn.frame);
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
    // 密码
    NSString *pattern = @"[a-zA-Z]";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:passwordCell.text options:0 range:NSMakeRange(0, passwordCell.text.length)];
    if (results.count == 0) {
        msg = @"密码中必须有一位字母";
    } else if (passwordCell.text.length < 6 || passwordCell.text.length > 16) {
        msg = @"请设置6位以上16位以内的密码";
    } else if (passwordCell.text.length == 0) {
        msg = @"请设置密码";
    }
    // 验证码
    if (captchaCell.text.length != 4) {
        msg = @"验证码为4位哦";
    }
    // 手机号
    if (phoneCell.text.length == 0) {
        msg = @"请填写手机号";
    } else if (![CommonHelper isPhone:phoneCell.text]) {
        msg = @"请填写正确的手机号";
    }
    // 邀请码
    if (inviteCell.text.length > 0) {
        if (![CommonHelper isNumberText:inviteCell.text]) {
            msg = @"邀请码不正确";
        }
    }
    // 免责手册
    if (!checkBtn1.isSelected) {
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

#pragma mark 获取验证码
- (void)obtainCaptcha
{
    BOOL isPhone = [CommonHelper isPhone:phoneCell.text];
    if (isPhone) {
        [self runTime];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请填写正确的手机号码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark 确认是否同意
- (void)agreeOurRules:(UIButton *)button
{
    button.selected = !button.isSelected;
    checkBtn1.selected = button.isSelected;
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
    // 用户类型
    [dictM setObject:@(self.userType) forKey:@"user_type"];
    // 注册方式 手机：1，邮箱：2，邀请码：3.
    [dictM setObject:@1 forKey:@"reg_type"];
    // 姓名
    [dictM setObject:nameCell.text forKey:@"real_name"];
    // 组织机构
    [dictM setObject:organDto.province.name forKey:@"province"];
    [dictM setObject:organDto.organizationID.length > 0 ? organDto.organizationID : @"" forKey:@"organization_id"];
    [dictM setObject:organDto.name forKey:@"organization"];
    [dictM setObject:@(organDto.type) forKey:@"org_type"];
    // 部门
    NSMutableArray *depArray = [[NSMutableArray alloc] init];
    if (departDto.parent_name.length > 0) { // 有两级目录
        [depArray addObject:@{@"department_id":departDto.parent_id,@"department":departDto.parent_name}];
    }
    [depArray addObject:@{@"department_id":departDto.departmentID == nil ? @"" :departDto.departmentID,@"department":departDto.name}];
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
    // 手机号
    [dictM setObject:phoneCell.text forKey:@"mobile"];
    // 验证码
    [dictM setObject:captchaCell.text forKey:@"verify_code"];
    // 密码
    [dictM setObject:[EncodeUtil getMD5ForStr:passwordCell.text] forKey:@"password"];
    // 邀请人
    [dictM setObject:inviteCell.text forKey:@"referrer"];
    // invite_code 暂时没有
    
    [dictM setObject:@(MethodType_UserRegisterAll) forKey:@"method"];
    
    [[ProgressHUD instance] showProgressHD:YES inView:self.view info:@"注册中..."];
    [AccountHelper tryToRegisterAll:dictM success:^(id JSON) {
        [[ProgressHUD instance] showProgressHD:NO inView:self.view info:@"注册中"];
        self.view.userInteractionEnabled = YES;
        if ([JSON[@"success"] boolValue]) {
            [ClickUtil event:@"logon_immlogon_click" attributes:@{}];
            // 24小时内注册计数
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:kRegistAction]];
            if (!dict) {
                dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@([NSDate date].timeIntervalSince1970) forKey:@"time"];
                [dict setObject:@1 forKey:@"count"];
            } else {
                NSTimeInterval duration = [dict[@"time"] doubleValue];
                NSInteger count = [dict[@"count"] integerValue];
                if ([NSDate date].timeIntervalSince1970 - duration < 24 * 60 * 60) { // 24小时以内
                    count ++;
                    [dict setObject:@(count) forKey:@"count"];
                } else {
                    [dict setObject:@1 forKey:@"count"];
                    [dict setObject:@([NSDate date].timeIntervalSince1970) forKey:@"time"];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kRegistAction];
            
            NSLog(@"注册成功 ------ %@", JSON);
            [[RootViewController shareRootViewController] loginIM];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
            
            // 认证身份信息
            [[NSNotificationCenter defaultCenter] postNotificationName:ImproveThePersonalInformationSuccessNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            if (JSON[@"message"]) {
                [InfoAlertView showInfo:JSON[@"message"] duration:1.0];
            }
        }
    } failure:^(NSError *error, id JSON) {
        [[ProgressHUD instance] showProgressHD:NO inView:self.view info:@"注册中"];
        [InfoAlertView showInfo:error.localizedDescription duration:1.0];
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)runTime
{
    [self textFieldresignFirstResponder];
    [LoadingView showProgress:YES inView:self.view];
    phoneCell.userInteractionEnabled = NO;
    [self getInvitationCodeAgain];
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

- (void)getInvitationCodeAgain
{
    [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_Register_VerifyPhone],@"mobile":phoneCell.text} success:^(id JSON) {
        [LoadingView showProgress:NO inView:self.view];
        if ([[JSON objectForKey:@"success"] boolValue]) {
            if ([codeTime isValid]) {
                [codeTime invalidate];
                codeTime = nil;
            }
            codeTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(clickTime:) userInfo:nil repeats:YES];
        } else {
            phoneCell.userInteractionEnabled = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[JSON objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    } failure:^(NSError *error, id JSON) {
        [LoadingView showProgress:NO inView:self.view];
        phoneCell.userInteractionEnabled = YES;
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[result objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
    }];
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
        RegisterSelectTimeController *vc = [[RegisterSelectTimeController alloc] init];
        vc.parent = self;
        vc.startTime = startDate;
        vc.endTime = endDate;
        vc.userType = self.userType;
        vc.orgType = organDto.type;
        vc.experienceType = experience_type;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 时间计时器
- (void)clickTime:(NSTimer *)sender
{
    timeNum--;
    if (timeNum > 0) {
        [obtainBtn setTitle:[NSString stringWithFormat:@"(%@)",@(timeNum)] forState:UIControlStateNormal];
    } else {
        [obtainBtn setTitle:@"重新获取?" forState:UIControlStateNormal];
        timeNum = 60;
        phoneCell.userInteractionEnabled = YES;
        [codeTime invalidate];
        codeTime = nil;
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
    NSTimeInterval begin = [[NSDate date] timeIntervalSince1970];
    if (begin - time < 0.3) return;
    time = begin;
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
        case CommonCellType_Phone:
            [cell becomeFirstResponder];
            break;
        case CommonCellType_Captcha:
            [cell becomeFirstResponder];
            break;
        case CommonCellType_Password:
            [cell becomeFirstResponder];
            break;
        case CommonCellType_Inviter:
            [cell becomeFirstResponder];
            break;
        default:
            break;
    }
}

- (void)textFieldBecomeFirstRespond:(CommonCell *)cell
{
    if (kbEndY == 0) return;
    NSLog(@"%f,  contentY - %f", CGRectGetMaxY(cell.frame), contentView.contentOffset.y);
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
