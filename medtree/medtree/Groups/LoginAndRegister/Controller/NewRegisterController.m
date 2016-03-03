//
//  NewRegisterController.m
//  medtree
//
//  Created by Jiangmm on 15/12/18.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "NewRegisterController.h"
#import "LocalFileController.h"
#import "RootViewController.h"
#import "SecurityCodeController.h"
//view
#import "InfoAlertView.h"
#import "CommonCell.h"
#import "ProgressHUD.h"
#import "LoadingView.h"
//tool
#import "CommonHelper.h"
#import "EncodeUtil.h"
#import "JSONKit.h"
//manager
#import "AccountHelper.h"
#import "UserManager.h"




@interface NewRegisterController ()<CommonCellDelegate,UIScrollViewDelegate, UIAlertViewDelegate>
{
    /** 内容包装 */
    UIScrollView            *contentView;
    /** 姓名 */
    CommonCell              *nameCell;
    /** 手机号 */
    CommonCell              *phoneCell;
    /** 密码 */
    CommonCell              *passwordCell;
    /** 注册Btn */
    UIButton                *registBtn;
    /** 用户协议Btn */
    UIButton                *rulesBtn;
    /** 复选框 */
    UIButton                *checkBtn;
    /** cell data list */
    NSArray                 *cells;
    /** 键盘高度 */
    CGFloat                 kbEndY;
    /** scrollview 滚动时候 不接收cell的事件响应 */
    BOOL                    scrolling;
}
@end

#define CHCellHeight 70

@implementation NewRegisterController

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
    
    nameCell = [[CommonCell alloc] init];
    nameCell.showHeadLine = YES;
    nameCell.title = @"姓名";
    nameCell.placeHolder = @"输入您的真实姓名";
    nameCell.returnKeyType = UIReturnKeyNext;
   
    [contentView addSubview:nameCell];
    
    phoneCell = [[CommonCell alloc] init];
    phoneCell.title = @"手机号";
    phoneCell.placeHolder = @"输入您的手机号";
    phoneCell.keyboardType = UIKeyboardTypePhonePad;
    phoneCell.returnKeyType = UIReturnKeySend;
    phoneCell.maxLength = 11;
    [contentView addSubview:phoneCell];
    
    passwordCell = [[CommonCell alloc] init];
    passwordCell.title = @"密码";
    passwordCell.placeHolder = @"请设置6位以上密码，且包含字母和数字";
    passwordCell.keyboardType = UIKeyboardTypeDefault;
    passwordCell.returnKeyType = UIReturnKeyGo;
    passwordCell.secureTextEntry = YES;
    passwordCell.maxLength = 16;
    passwordCell.showMedLine = NO;
    passwordCell.showFootLine = YES;
    [contentView addSubview:passwordCell];
    
    registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn setBackgroundColor:[ColorUtil getColor:@"365c8a" alpha:1.0]];
    [registBtn addTarget:self action:@selector(clickRegist) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:registBtn];
    
    checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn setTitle:@"点注册表示同意" forState:UIControlStateNormal];
    [checkBtn setTitleColor:[ColorUtil getColor:@"a6a6a6" alpha:1.0] forState:UIControlStateNormal];
    checkBtn.titleLabel.font = [MedGlobal getLittleFont];
    [contentView addSubview:checkBtn];
    
    rulesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rulesBtn setTitle:@"《医树用户协议》" forState:UIControlStateNormal];
    [rulesBtn setTitleColor:[ColorUtil getColor:@"365c8a" alpha:1.0] forState:UIControlStateNormal];
    [rulesBtn addTarget:self action:@selector(clickRules) forControlEvents:UIControlEventTouchUpInside];
    rulesBtn.titleLabel.font = [MedGlobal getLittleFont];
    [contentView addSubview:rulesBtn];
    
    cells = @[nameCell,phoneCell,passwordCell];
    for (int i = 0; i < cells.count; i++) {
        CommonCell *cell = cells[i];
        cell.delegate = self;
        cell.tag = i + 1;
        
    }
    [self createBackButton];

}

#pragma  mark - backBtn -
- (UIButton *)createBackButton
{
    UIButton *backButton = [NavigationBar createImageButton:@"btn_back.png" selectedImage:@"btn_back_click.png" target:self action:@selector(clickBack)];
    [naviBar setLeftButton:backButton];
    return backButton;
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_phoneNum) {
        phoneCell.text = _phoneNum;
    }
    [self setupView];
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    contentView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, size.height - CGRectGetMaxY(naviBar.frame));
    CGFloat cellH = CHCellHeight;
    [cells enumerateObjectsUsingBlock:^(CommonCell *cell, NSUInteger idx, BOOL *stop) {
        CGFloat cellY = cellH * idx;
        cell.frame = CGRectMake(0, cellY, size.width, cellH);
    }];
    
    //注册
    CGFloat cellMaxY = cellH *cells.count;
    CGFloat registBtnY = cellMaxY + 40;
    registBtn.frame = CGRectMake(20, registBtnY, size.width - 20 * 2, 55);
    registBtn.layer.masksToBounds = YES;
    registBtn.layer.cornerRadius = 4;
    
    CGFloat checkBtnY = CGRectGetMaxY(registBtn.frame) + 13;
    CGSize checkBtnSize = [checkBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:checkBtn.titleLabel.font}];
    CGFloat checkBtnX = 80;
    checkBtn.frame = CGRectMake(checkBtnX, checkBtnY, checkBtnSize.width, checkBtnSize.height);
    
    CGFloat rulesBtnX = CGRectGetMaxX(checkBtn.frame);
    CGSize rulesBtnSize = [rulesBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:rulesBtn.titleLabel.font}];
    rulesBtn.frame = CGRectMake(rulesBtnX, checkBtnY, rulesBtnSize.width, rulesBtnSize.height);

}

#pragma  mark - 注册 -
- (void)clickRegist
{
    NSString *msg = @"";
    //姓名
    if (nameCell.text.length == 0) {
        msg = @"请填写真实的姓名";
    }
    // 密码
    NSString *pattern = @"[a-zA-Z]+[0-9]+|[0-9]+[a-zA-Z]+";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:passwordCell.text options:0 range:NSMakeRange(0, passwordCell.text.length)];
    if (results.count == 0) {
        msg = @"请设置6位以上密码，且包含字母和数字";
    } else if (passwordCell.text.length < 6 || passwordCell.text.length > 16) {
        msg = @"请设置6位以上密码，且包含字母和数字";
    } else if (passwordCell.text.length == 0) {
        msg = @"请设置6位以上密码，且包含字母和数字";
    }

    //手机号
    if (phoneCell.text.length == 0) {
        msg = @"请填写手机号";
    } else if (![CommonHelper isPhone:phoneCell.text]) {
        msg = @"请填写正确的手机号";
    }
    
    if (msg.length == 0) {
        [nameCell resignFirstResponder];
        [phoneCell resignFirstResponder];
        [passwordCell resignFirstResponder];
        [self obtainCaptcha];
        
    }else{
        [InfoAlertView showInfo:msg inView:self.view duration:1];
    }
}


#pragma mark 获取验证码
- (void)obtainCaptcha
{
    BOOL isPhone = [CommonHelper isPhone:phoneCell.text];
    if (isPhone) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认手机号码"
                                                            message:[NSString stringWithFormat:@"我们将发送验证码短信到这个号码\n%@", phoneCell.text]
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"好", nil];
        [alertView show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"请填写正确的手机号码"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma  mark - 阅读协议 -
- (void)clickRules
{
    LocalFileController *rules = [[LocalFileController alloc] init];
    [self.navigationController pushViewController:rules animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
 
    [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_Register_VerifyPhone],
                              @"mobile":phoneCell.text} success:^(id JSON) {
        [LoadingView showProgress:NO inView:self.view];
        if ([[JSON objectForKey:@"success"] boolValue]) {
           
            NSMutableDictionary *dictM = [[NSMutableDictionary alloc] init];
            //用户类型
            [dictM setObject:@(self.userType) forKey:@"user_type"];
            //注册方式 手机：1， 邮箱：2，邀请码：3
            [dictM setObject:@1 forKey:@"reg_type"];
            //姓名
            [dictM setObject:nameCell.text forKey:@"realname"];
            //手机号
            [dictM setObject:phoneCell.text forKey:@"mobile"];
            //密码
            [dictM setObject:[EncodeUtil getMD5ForStr:passwordCell.text] forKey:@"password"];

            SecurityCodeController *vc = [[SecurityCodeController alloc] init];
            vc.userInfo = dictM;
            [self.navigationController pushViewController:vc animated:YES];

        }else {
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
        case CommonCellType_Phone:
            [cell becomeFirstResponder];
            break;
        case CommonCellType_Password:
            [cell becomeFirstResponder];
            break;
        default:
            break;
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

#pragma mark -
#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self getInvitationCodeAgain];
    }
}

@end
