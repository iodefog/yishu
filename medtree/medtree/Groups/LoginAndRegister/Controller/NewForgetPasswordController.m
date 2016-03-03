//
//  ForgetPasswordController1.m
//  medtree
//
//  Created by 孙晨辉 on 15/4/15.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewForgetPasswordController.h"
#import "CommonCell.h"
#import "InfoAlertView.h"
#import "CommonHelper.h"
#import "ServiceManager.h"
#import "JSONKit.h"
#import "ColorUtil.h"
#import "EncodeUtil.h"
#import "ImageCenter.h"

#define CHCellHeight 70
#define CHMargin 20
#define CHMarginS 10
#define CHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface NewForgetPasswordController ()
{
    /** cell框 */
    UIView                  *contentView;
    /** 手机cell */
    CommonCell              *phoneCell;
    /** 验证码cell */
    CommonCell              *captchaCell;
    /** 密码cell */
    CommonCell              *pwdCell;
    /** 获取验证码 */
    UIButton                *obtainBtn;
    /**  修改密码Btn */
    UIButton                *alertPwdBtn;
    /** 倒计时 */
    NSInteger               timeFloat;
    /** 计时器 */
    NSTimer                 *codeTime;
    /** 所有cells */
    NSArray                 *cells;
}

@end

@implementation NewForgetPasswordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldresignFirstResponder)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    [self createBackButton];
    
    timeFloat = 60;
    
    __unsafe_unretained typeof(self) vc = self;
    
    [naviBar setTopTitle:@"忘记密码?"];
    [naviBar setTopLabelColor:[UIColor whiteColor]];
    [self createBackButton];
    
    contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    phoneCell = [CommonCell commoncell];
    phoneCell.placeHolder = @"输入手机号";
    phoneCell.returnKeyType = UIReturnKeyDone;
    phoneCell.keyboardType = UIKeyboardTypeNumberPad;
    phoneCell.returnKeyClicked = ^{
        [vc obtainCaptcha];
    };
    [contentView addSubview:phoneCell];
    
    obtainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [obtainBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    obtainBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [obtainBtn setTitleColor:[ColorUtil getColor:@"365c8a" alpha:1.0] forState:UIControlStateNormal];
    [obtainBtn addTarget:self action:@selector(obtainCaptcha) forControlEvents:UIControlEventTouchUpInside];
    [phoneCell addSubview:obtainBtn];
    
    captchaCell = [CommonCell commoncell];
    captchaCell.placeHolder = @"输入手机验证码";
    captchaCell.keyboardType = UIKeyboardTypeNumberPad;
    captchaCell.returnKeyType = UIReturnKeyNext;
    captchaCell.returnKeyClicked = ^{
        [vc->pwdCell becomeFirstResponder];
    };
    [contentView addSubview:captchaCell];
    
    pwdCell = [CommonCell commoncell];
    pwdCell.placeHolder = @"新的密码";
    pwdCell.secureTextEntry = YES;
    pwdCell.keyboardType = UIKeyboardTypeDefault;
    pwdCell.returnKeyType = UIReturnKeyDone;
    pwdCell.returnKeyClicked = ^{
        [vc alertPwdClick];
    };
    [contentView addSubview:pwdCell];
    
    alertPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [alertPwdBtn setTitle:@"完成" forState:UIControlStateNormal];
    [alertPwdBtn setBackgroundColor:[ColorUtil getColor:@"365c8a" alpha:1.0]];
    [alertPwdBtn addTarget:self action:@selector(alertPwdClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertPwdBtn];
    
    cells = @[phoneCell, captchaCell, pwdCell];
}

- (void)setNaviTitle:(NSString *)title
{
    [naviBar setTopTitle:title];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    contentView.frame = CGRectMake(0, [self getOffset] + 44, width, CHCellHeight * 3);
    
    [self setupCells];
    
    CGFloat alertPwdBtnX = CHMargin;
    CGFloat alertPwdBtnY = height - CHMargin * 2 - CHCellHeight;
    CGFloat alertPwdBtnW = width - CHMargin * 2;
    alertPwdBtn.frame = CGRectMake(alertPwdBtnX, alertPwdBtnY, alertPwdBtnW, 50);
    alertPwdBtn.layer.masksToBounds = YES;
    alertPwdBtn.layer.cornerRadius = 4;
}

- (void)setupCells
{
    CGFloat width = contentView.frame.size.width;
    phoneCell.frame = CGRectMake(0, 0, width, CHCellHeight);
    UIFont *font = obtainBtn.titleLabel.font;
    CGSize obtainBtnSize = [obtainBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat obtainBtnX = width - obtainBtnSize.width - CHMarginS;
    CGFloat obtainBtnY = (CHCellHeight - obtainBtnSize.height) * 0.5;
    CGFloat obtainBtnW = obtainBtnSize.width;
    CGFloat obtainBtnH = obtainBtnSize.height;
    obtainBtn.frame = CGRectMake(obtainBtnX, obtainBtnY-10, obtainBtnW, obtainBtnH+20);
    captchaCell.frame = CGRectMake(0, CHCellHeight, width, CHCellHeight);
    pwdCell.frame = CGRectMake(0, CHCellHeight * 2, width, CHCellHeight);
    
    phoneCell.showHeadLine = YES;
    pwdCell.showFootLine = YES;
    pwdCell.showMedLine = NO;
}

#pragma mark - navi
- (void)clickBack
{
    [self textFieldresignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)createBackButton
//{
//    UIButton *backButton = [NavigationBar createImageButton:@"btn_back.png" selectedImage:@"btn_back_click.png" target:self action:@selector(clickBack)];
//    [naviBar setLeftButton:backButton];
//}

#pragma mark - click
#pragma mark 获取验证码
- (void)obtainCaptcha
{
    BOOL isPhone = [CommonHelper isNumberText:phoneCell.text];
    if (isPhone) {
        obtainBtn.enabled = NO;
        [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_Register_PassResetCode],@"type":isPhone?@"mobile":@"email",@"username":phoneCell.text} success:^(id JSON) {
            
            if ([[JSON objectForKey:@"success"] boolValue]) {
                codeTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(clickCodeTime) userInfo:nil repeats:YES];
            } else {
                obtainBtn.enabled = YES;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[JSON objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        } failure:^(NSError *error, id JSON) {
            obtainBtn.enabled = YES;
            if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
                NSDictionary *result = [JSON objectFromJSONString];
                if ([result objectForKey:@"message"] != nil) {
                    [InfoAlertView showInfo:[result objectForKey:@"message"]  inView:self.view duration:1];
                }
            }
        }];
    } else {
        [InfoAlertView showInfo:@"请填写正确的手机号" inView:self.view duration:1];
    }
    
}

#pragma mark 修改密码
- (void)alertPwdClick
{
    NSString *msg = @"";
    if (phoneCell.text.length == 0) {
        msg = @"请输入手机号";
    } else if (captchaCell.text.length == 0) {
        msg = @"请输入验证码";
    } else if (pwdCell.text.length == 0) {
        msg = @"请输入密码";
    } else if (pwdCell.text.length < 6 || pwdCell.text.length > 16) {
        msg = @"请设置6位以上密码，且包含字母和数字";
    }
    
    NSString *pattern = @"[a-zA-Z]+[0-9]+|[0-9]+[a-zA-Z]+";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:pwdCell.text options:0 range:NSMakeRange(0, pwdCell.text.length)];
    if (results.count == 0)
    {
        msg = @"请设置6位以上密码，且包含字母和数字";
    }
    
    if (msg.length == 0) {
        BOOL isPhone = [CommonHelper isNumberText:phoneCell.text];
        [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_Register_ResetPassword],@"type":isPhone?@"mobile":@"email",@"username":phoneCell.text,@"code":captchaCell.text,@"password":[EncodeUtil getMD5ForStr:pwdCell.text]} success:^(id JSON) {
            
            BOOL isSuccess = [[JSON objectForKey:@"success"] boolValue];
            if (isSuccess) {
                [InfoAlertView showInfo:@"密码修改成功！"inView:self.view duration:1];

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                
            } else {
                [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:1];
            }
        } failure:^(NSError *error, id JSON) {
            if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
                NSDictionary *result = [JSON objectFromJSONString];
                if ([result objectForKey:@"message"] != nil) {
                    [InfoAlertView showInfo:[result objectForKey:@"message"]  inView:self.view duration:1];
                }
            }
        }];
    } else {
        [InfoAlertView showInfo:msg inView:self.view duration:1];
    }
}

#pragma mark - private
- (void)clickCodeTime
{
    timeFloat--;
    if (timeFloat > 0) {
        [obtainBtn setTitle:[NSString stringWithFormat:@"%@", @(timeFloat)] forState:UIControlStateDisabled];
    } else {
        [codeTime invalidate];
        obtainBtn.enabled = YES;
        [obtainBtn setTitle:@"重新获取？" forState:UIControlStateNormal];
        timeFloat = 60;
    }
    [self setupCells];
}

#pragma mark - 手势
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

- (void)setNaviColor:(UIColor *)color
{
    [naviBar changeBackGroundImage:@"whiteColor_naviBar_background.png"];
    statusBar.image = [ImageCenter getBundleImage:@"whiteColor_naviBar_background_top.png"];
    [naviBar setTopLabelColor:[UIColor blackColor]];
    naviBar.backgroundColor = color;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
