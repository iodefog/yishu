//
//  LoginController1.m
//  medtree
//
//  Created by 孙晨辉 on 15/4/14.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewLoginController.h"
#import "InfoAlertView.h"
#import "ImageCenter.h"
#import "ColorUtil.h"
#import "AccountHelper.h"
#import "ProgressHUD.h"
#import "LoginBtn.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import "NewForgetPasswordController.h"
#import "IdentitySelectorController.h"
#import "CommonCell.h"
#import "UserManager.h"
#import "UserDTO.h"
#import "RootViewController.h"
#import "RegisterController.h"
#import "ImproveController.h"
#import "CommonHelper.h"

#define CHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define CHLoginViewHeight 100
#define CHMargin 20
#define CHRegistBtnHeight 50
#define CHLineMargin 24

#define CHMarginS 10
#define CHCellHeight 70
#define CHLoginBtnW 68
#define CHLoginBtnH 24

#define CHLabelFont [UIFont systemFontOfSize:14]
#define CHTextFieldFont [UIFont systemFontOfSize:14]

@interface NewLoginController () <UITextFieldDelegate, NewForgetPasswordControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
{
    /** 滚动条 */
    UIScrollView *scrollView;
    /** logo */
    UIImageView *logoImageView;
    /** 登录框 */
    UIView *loginView;
    /** 忘记密码 */
    UIButton *forgetBtn;
    /** 或者label */
    UILabel *orLabel;
    /** 注册按钮 */
    UIButton *registBtn;
    /** 分界线1 */
    UILabel *dividingLine1;
    /** 分界线2 */
    UILabel *dividingLine2;
    
    /** 手机号 */
    CommonCell *phoneCell;
    
    /** 密码 */
    CommonCell *pwdCell;
    
    /** 登录按钮 */
    UIButton *loginBtn;
    
    /** 更换网络 */
    UIButton    *changeNetWorkButton;
    NSString    *phoneNum;
}



@end

@implementation NewLoginController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    NSLog(@"dealloc %s", __func__);
}

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    statusBar.hidden = YES;
    naviBar.hidden = YES;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    self.view.backgroundColor = CHColor(241, 241, 245);
    
    // logo
    logoImageView = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"icon_Logo.png"]];
    [scrollView addSubview:logoImageView];
    
    // 登录框
    loginView = [[UIView alloc] init];
    loginView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:loginView];
    
    // 登录框内部
    [self setupLoginView];
    
    // 立即注册
    registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn addTarget:self action:@selector(clickRegist) forControlEvents:UIControlEventTouchUpInside];
    [registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [registBtn setTitleColor:[ColorUtil getColor:@"365c8a" alpha:1.0] forState:UIControlStateNormal];
    [scrollView addSubview:registBtn];
    
    // 忘记密码
    forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn addTarget:self action:@selector(clickForgetButton) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn setBackgroundColor:CHColor(241, 241, 245)];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetBtn setTitleColor:[ColorUtil getColor:@"365c8a" alpha:1.0] forState:UIControlStateNormal];
    [scrollView addSubview:forgetBtn];

    // 切换网络
    BOOL isHouse = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"InHouse"] boolValue];
    if (isHouse) {
        changeNetWorkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [changeNetWorkButton setTitle:@"线上网络" forState:UIControlStateNormal];
        [changeNetWorkButton setTitle:@"测试网络" forState:UIControlStateSelected];
        [changeNetWorkButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [changeNetWorkButton setImage:[ImageCenter getBundleImage:@"register_checked.png"] forState:UIControlStateSelected];
        [changeNetWorkButton setImage:[ImageCenter getBundleImage:@"register_unchecked.png"] forState:UIControlStateNormal];
        [changeNetWorkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [changeNetWorkButton addTarget:self action:@selector(clickChangeNewWork) forControlEvents:UIControlEventTouchUpInside];
        changeNetWorkButton.titleLabel.font = [MedGlobal getTinyLittleFont];
        changeNetWorkButton.selected = [[[NSUserDefaults standardUserDefaults] objectForKey:TESTENVIRONMENT] boolValue];
        [scrollView addSubview:changeNetWorkButton];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view bringSubviewToFront:statusBar];
    [self.view bringSubviewToFront:naviBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldresignFirstResponder)];
    [self.view addGestureRecognizer:tap];
    
    CGFloat width = self.view.frame.size.width;         // 屏幕宽度
    CGFloat height = self.view.frame.size.height;       // 屏幕高度
    
    // logo
    CGFloat logoImageViewY = 90;
    CGFloat delta = 0.5;
    CGFloat logoImageViewW = 168;
    CGFloat logoImageViewH = 168;
    
    
    if ([[MedGlobal getPhone] isEqualToString:@"iPhone4"])
    {
        logoImageViewY = 50;
        delta = 0.4;
    }
    
    logoImageViewW = logoImageViewW * delta;
    logoImageViewH = logoImageViewH * delta;
    CGFloat logoImageViewX = (width - logoImageViewW) * 0.5;
    logoImageView.frame = CGRectMake(logoImageViewX, logoImageViewY, logoImageViewW, logoImageViewH);
    
    // 登录框
    CGFloat logoImageViewMaxY = CGRectGetMaxY(logoImageView.frame) + (CHMargin + 12) * 2;
    if (height == 480)
    {
        logoImageViewMaxY = logoImageViewMaxY - (CHMargin + 12);
    }
    loginView.frame = CGRectMake(0, logoImageViewMaxY, width, CHCellHeight * 2);
    
    // 登录框内部
    [self layoutLoginView];
    
    // 立即注册
    CGFloat loginViewMaxY = CGRectGetMaxY(loginView.frame);
    CGSize registBtnSize = [registBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:registBtn.titleLabel.font}];
    CGFloat registBtnX = CHMargin;
    CGFloat registBtnH = registBtnSize.height;
    CGFloat registBtnW = registBtnSize.width;
    CGFloat registBtnY = loginViewMaxY + CHMargin;
    registBtn.frame = CGRectMake(registBtnX, registBtnY, registBtnW, registBtnH);
    
    //忘记密码
    CGSize forgetBtnSize = [forgetBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:forgetBtn.titleLabel.font}];
    CGFloat forgetBtnW = forgetBtnSize.width;
    CGFloat forgetBtnH = forgetBtnSize.height;
    CGFloat forgetBtnX = width - forgetBtnW - CHMargin;
    CGFloat forgetBtnY = loginViewMaxY + CHMargin;

    forgetBtn.frame = CGRectMake(forgetBtnX, forgetBtnY, forgetBtnW, forgetBtnH);
    
    
    BOOL isHouse = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"InHouse"] boolValue];
    if (isHouse) {
        // 切换网络
        UIImage *image = [ImageCenter getBundleImage:@"register_check_click.png"];
        CGFloat changeNetWorkButtonImageW = image.size.width;
        CGSize changeNetWorkButtonSize = [changeNetWorkButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:changeNetWorkButton.titleLabel.font}];
        CGFloat changeNetWorkButtonW = changeNetWorkButtonSize.width + changeNetWorkButtonImageW;
        changeNetWorkButton.frame = CGRectMake(CHMargin, CGRectGetMaxY(registBtn.frame) + CHMargin, changeNetWorkButtonW, forgetBtnH);
    }
    
    if (CGRectGetMaxY(registBtn.frame)+CHMargin > height) {
        scrollView.contentSize = CGSizeMake(width, CGRectGetMaxY(registBtn.frame)+CHMargin);
    } else {
        scrollView.contentSize = CGSizeMake(width, height-[MedGlobal getOffset]);
    }
}

- (void)setupLoginView
{
    __unsafe_unretained typeof(self) vc = self;
    phoneCell = [CommonCell commoncell];
    phoneCell.title = @"手机号";
    phoneCell.placeHolder = @"请输入已注册手机号";
    phoneCell.returnKeyType = UIReturnKeyNext;
    phoneCell.keyboardType = UIKeyboardTypeNumberPad;
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldBecomeFirstRespond:)];
    [phoneCell addGestureRecognizer:phoneTap];
    phoneCell.returnKeyClicked = ^{
        [vc->pwdCell becomeFirstResponder];
    };
    [loginView addSubview:phoneCell];
    
    pwdCell = [CommonCell commoncell];
    pwdCell.title = @"密码";
    pwdCell.placeHolder = @"请输入注册密码";
    pwdCell.returnKeyType = UIReturnKeyDone;
    pwdCell.keyboardType = UIKeyboardTypeDefault;
    UITapGestureRecognizer *pwdTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldBecomeFirstRespond:)];
    [pwdCell addGestureRecognizer:pwdTap];
    pwdCell.secureTextEntry = YES;
    pwdCell.returnKeyClicked = ^{
        [vc clickLogin];
    };
    [loginView addSubview:pwdCell];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [loginBtn setBackgroundImage:[ImageCenter getBundleImage:@"new_btn_login.png"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    [pwdCell addSubview:loginBtn];
}

- (void)layoutLoginView
{
    CGFloat width = self.view.frame.size.width;
    
    phoneCell.frame = CGRectMake(0, 0, width, CHCellHeight);
    pwdCell.frame = CGRectMake(0, CHCellHeight, width, CHCellHeight);

    phoneCell.showHeadLine = YES;
    pwdCell.showMedLine = NO;
    pwdCell.showFootLine = YES;
     
    CGFloat loginBtnX = width - CHMarginS - CHLoginBtnW;
    CGFloat loginBtnY = (CHCellHeight - CHLoginBtnH) * 0.5;
    CGFloat loginBtnW = CHLoginBtnW;
    CGFloat loginBtnH = CHLoginBtnH;
    loginBtn.frame = CGRectMake(loginBtnX, loginBtnY, loginBtnW, loginBtnH);
}

#pragma mark - click
- (void)clickLogin
{
    [self becomeFirstResponder];
    [phoneCell resignFirstResponder];
    [pwdCell resignFirstResponder];
    NSString *username = phoneCell.text;
    NSString *pwd = pwdCell.text;
    
    NSString *msg = @"";
    if (username.length == 0) {
        msg = @"请输入账号";
    }
    else if (pwd.length == 0) {
        msg = @"请输入密码";
    }
    
    if (msg.length == 0) {
        if (![self checkNetworkStatus]) {
            [InfoAlertView showInfo:@"请检查您的网络连接" inView:self.view duration:1];
            return;
        }
        [[ProgressHUD instance] showProgressHD:YES inView:self.view info:@"登录中..."];
        
        NSDictionary *dict = @{@"username": username, @"password": pwd};
        
        [AccountHelper tryToLogin:dict success:^(id JSON) {
            /** 登录成功 */
            [[ProgressHUD instance] showProgressHD:NO inView:self.view info:@"登录中"];
            BOOL tf = [[JSON objectForKey:@"success"] boolValue];
            if (tf) {
                
                [ClickUtil event:@"signIn_signIn" attributes:@{}];
                
//                UserDTO *dto = JSON[@"user"];
//                if (dto.user_status == 1) { // 个人信息已完善
                    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
//                } else { // 网页注册
//                    ImproveController *vc = [[ImproveController alloc] init];
//                    vc.userType = (User_Types)dto.user_type;
//                    [self.navigationController pushViewController:vc animated:YES];
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }
            } else {
                if ([[JSON objectForKey:@"message"] isEqualToString:@"账号不存在"]) {
                    if ([CommonHelper isPhone:phoneCell.text]) {
                        phoneNum = phoneCell.text;
                    } else {
                        phoneNum = @"";
                    }
                    [self clickRegist];
                } else {
                    [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:1];
                }
            }
        } failure:^(NSError *error, id JSON) {
            [[ProgressHUD instance] showProgressHD:NO inView:self.view info:@"登录中"];
            if (!JSON) {
                [InfoAlertView showInfo:@"当前网络不好，请稍后重试" inView:self.view duration:1];
            }
            else {
                [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:1];
            }
        }];
    }
    else {
        [InfoAlertView showInfo:msg inView:self.view duration:1];
    }
}

- (void)clickForgetButton
{
    [self setupNavigationDelegate];
    
    NewForgetPasswordController *forgetPwdVC = [[NewForgetPasswordController alloc] init];
    forgetPwdVC.parent = self;
    [forgetPwdVC setNaviColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:forgetPwdVC animated:YES];
}

- (void)clickRegist
{
    [self setupNavigationDelegate];
    [ClickUtil event:@"logon_logon" attributes:@{}];
    NSMutableDictionary *dictM = [[NSUserDefaults standardUserDefaults] objectForKey:kRegistAction];
    NSTimeInterval time = [dictM[@"time"] doubleValue];
    NSInteger count = [dictM[@"count"] integerValue];
    if ([NSDate date].timeIntervalSince1970 - time < 24 * 60 * 60) { // 24小时以内
        if (count > 2) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您今天注册过多，请24小时以后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    IdentitySelectorController *vc = [[IdentitySelectorController alloc] init];
    if (phoneNum) {
        vc.phoneNum = phoneNum;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickChangeNewWork
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL networkStats = changeNetWorkButton.isSelected;
    networkStats = !networkStats;
    [defaults setObject:@(networkStats) forKey:TESTENVIRONMENT];
    [defaults synchronize];
    changeNetWorkButton.selected = !changeNetWorkButton.isSelected;
    [AccountHelper tryToChangeEngineSuccess:nil failure:nil];
}

#pragma mark 手势
- (void)textFieldBecomeFirstRespond:(UIGestureRecognizer *)gesture
{
    CommonCell *cell = (CommonCell *)gesture.view;
    [cell becomeFirstResponder];
}

#pragma mark - private
- (void)setupNavigationDelegate
{
    self.navigationController.delegate = self;
    if ([MedGlobal getSysVer] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

#pragma mark - 键盘位置影响
- (void)keyboardWillChange:(NSNotification *)noti
{
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //获取键盘结束的y值
    CGRect kbEndFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbEndY = kbEndFrame.origin.y;
    CGFloat loginViewMaxY = CGRectGetMaxY(loginView.frame);
    CGFloat delatY = loginViewMaxY - kbEndY + CHMargin;
    if (delatY > 0)
    {// 需要调整
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0, -delatY, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    else if (kbEndY == [UIScreen mainScreen].bounds.size.height)
    {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

#pragma mark - 检查网络
- (BOOL)checkNetworkStatus
{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags) {
        return NO;
    }
    //根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    return (isReachable&&!needsConnection) ? YES : NO;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

#pragma mark - RegisterControllerDelegate
- (void)setUserName:(NSString *)userName passWord:(NSString *)passWord
{
    phoneCell.text = userName;
    pwdCell.text = passWord;
}

#pragma mark ---
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [phoneCell resignFirstResponder];
    [pwdCell resignFirstResponder];
}

#pragma mark - 手势
- (void)textFieldresignFirstResponder
{
    [phoneCell resignFirstResponder];
    [pwdCell resignFirstResponder];
    scrollView.scrollEnabled = YES;
}

@end
