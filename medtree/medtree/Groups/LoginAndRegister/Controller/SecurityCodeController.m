//
//  SecurityCodeController.m
//  medtree
//
//  Created by Jiangmm on 15/12/18.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "SecurityCodeController.h"
#import "CommonCell.h"
#import "ServiceManager.h"
#import "UserManager.h"
#import "LoadingView.h"
#import "RegisterManager.h"
#import "InfoAlertView.h"
#import "ProgressHUD.h"
#import "AccountHelper.h"
#import "RootViewController.h"
NSString *const kNewRegistAction = @"NewRegistAction";

@interface SecurityCodeController ()<UITextFieldDelegate>
{
    /** 描述信息 */
    UILabel                 *titleLabel;
    UILabel                 *phoneNum;
    /** 验证码 */
    CommonCell              *captchaCell;
    /** 接收短信的时间*/
    UIButton                *receiveBtn;
    /** 提交 */
    UIButton                *commitBtn;
    /** 时间计时器 */
    NSTimer                 *codeTime;
    /** 时间计时 */
    NSInteger               timeNum;
}

@end

@implementation SecurityCodeController

- (void)createUI
{
    [super createUI];
    self.view.backgroundColor = [ColorUtil getColor:@"F4F4F7" alpha:1];

    titleLabel = [[UILabel alloc] init];
    NSString *string = @"我们已经发送了验证码到您的手机";
    NSRange range = [string rangeOfString:@"验证码"];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute addAttributes:@{NSForegroundColorAttributeName:[ColorUtil getColor:@"1eccb1" alpha:1.0]} range:range];
    [titleLabel setText:string];
    [titleLabel setAttributedText:attribute];
    
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:titleLabel];
    
    phoneNum = [[UILabel alloc] init];
    phoneNum.font = [UIFont systemFontOfSize:16];
    phoneNum.textColor = [UIColor blackColor];
    [self.view addSubview:phoneNum];
    
    captchaCell = [[CommonCell alloc] init];
    captchaCell.title = @"验证码";
    captchaCell.placeHolder = @"请输入验证码";
    captchaCell.showHeadLine = YES;
    captchaCell.showFootLine = YES;
    captchaCell.keyboardType = UIKeyboardTypeNumberPad;
    captchaCell.returnKeyType = UIReturnKeyGo;
    captchaCell.maxLength = 4;
    [self.view addSubview:captchaCell];
    
    receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [receiveBtn setTitle:[NSString stringWithFormat:@"接收短信大约需要%@秒",@(60)] forState:UIControlStateNormal];
    receiveBtn.enabled = NO;
    [receiveBtn setTitleColor:[ColorUtil getColor:@"365c8a" alpha:1.0] forState:UIControlStateNormal];
    receiveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [receiveBtn addTarget:self action:@selector(clickReceive) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:receiveBtn];
    
    commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setBackgroundColor:[ColorUtil getColor:@"365c8a" alpha:1.0]];
    [commitBtn addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
    
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"验证码短信可能略有延迟，确定返回并重新开始？"
                                                       delegate:self
                                              cancelButtonTitle:@"返回"
                                              otherButtonTitles:@"等待", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
    }
}
#pragma  mark - click -
- (void)clickReceive
{
    NSString *mobile = self.userInfo[@"mobile"];
    [ServiceManager setData:@{@"method":@(MethodType_Register_VerifyPhone),
                              @"mobile":mobile}
                    success:^(id JSON) {
                        [LoadingView showProgress:NO inView:self.view];
                        if ([[JSON objectForKey:@"success"] boolValue]) {
                            [self runTime];
                            receiveBtn.enabled = NO;
                            DLog(@"重新获取验证码成功");
                        } else {
                           DLog(@"获取验证码失败");
                        }}
                    failure:^(NSError *error, id JSON) {
                        [LoadingView showProgress:NO inView:self.view];
                        DLog(@"获取验证码失败");
                    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    phoneNum.text = self.userInfo[@"mobile"];
    [self setupView];
    [self runTime];
    
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    CGSize titleLabelS = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}];
    CGFloat titlteLabelY = CGRectGetMaxY(naviBar.frame) + 25;
    titleLabel.frame = CGRectMake(size.width * 0.5 - titleLabelS.width * 0.5,titlteLabelY, titleLabelS.width, titleLabelS.height);
    
    CGSize phoneNumS = [phoneNum.text sizeWithAttributes:@{NSFontAttributeName:phoneNum.font}];
    CGFloat phoneNumY = CGRectGetMaxY(titleLabel.frame) + 6;
    phoneNum.frame = CGRectMake(size.width * 0.5 - phoneNumS.width * 0.5, phoneNumY, phoneNumS.width, phoneNumS.height);
    
    CGFloat captchaCellY = CGRectGetMaxY(phoneNum.frame) + 25;
    captchaCell.frame = CGRectMake(0, captchaCellY, size.width, 70);
    
    CGSize receiveBtnS = [receiveBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:receiveBtn.titleLabel.font}];
    CGFloat receiveBtnY = CGRectGetMaxY(captchaCell.frame) + 25;
    receiveBtn.frame = CGRectMake(size.width * 0.5 - (receiveBtnS.width + 5 )* 0.5, receiveBtnY, receiveBtnS.width + 5, receiveBtnS.height);
    
    CGFloat commitBtnY = CGRectGetMaxY(receiveBtn.frame) + 40;
    commitBtn.frame = CGRectMake(20, commitBtnY, size.width - 20 * 2, 55);
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 4;

}

- (void)runTime
{
    if ([codeTime isValid]) {
        [codeTime invalidate];
        codeTime = nil;
    }
    timeNum = 60;
    codeTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(clickTime:) userInfo:nil repeats:YES];
}

#pragma mark 时间计时器
- (void)clickTime:(NSTimer *)time
{
    timeNum--;
    if (timeNum > 0) {
        [receiveBtn setTitle:[NSString stringWithFormat:@"接收短信大约需要%@秒",@(timeNum)] forState:UIControlStateNormal];
    } else {
        [receiveBtn setTitle:@"收不到验证码?" forState:UIControlStateNormal];
        receiveBtn.enabled = YES;
        [codeTime invalidate];
        codeTime = nil;
    }


}
#pragma  mark  - click 提交 -
- (void)clickCommit
{
    NSString *msg = @"";
    if (captchaCell.text.length != 4) {
        msg = @"验证码为4位哦";
    }
    if (msg.length == 0) {
        [captchaCell resignFirstResponder];
        [self getRegist];
        
    } else {
        [InfoAlertView showInfo:msg inView:self.view duration:1];
    }
}

- (void)getRegist
{
    //验证码
    [self.userInfo setObject:captchaCell.text forKey:@"verify_code"];
    [self.userInfo setObject:@(MethodType_Register_RegisterAccount) forKey:@"method"];
    
    [[ProgressHUD instance] showProgressHD:YES inView:self.view info:@"注册中..."];
    [AccountHelper tryToRegisterAll:self.userInfo success:^(id JSON) {
        [[ProgressHUD instance] showProgressHD:NO inView:self.view info:@"注册中"];
        self.view.userInteractionEnabled = YES;
        if ([JSON[@"success"] boolValue]) {
            [ClickUtil event:@"logon_immlogon_click" attributes:@{}];
            // 24小时内注册计数
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:kNewRegistAction]];
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
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kNewRegistAction];
            
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
- (void)tapClick
{
    [captchaCell resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [captchaCell resignFirstResponder];
    return YES;
    
}
#pragma mark - CommonCellDelegate
- (void)clickCell:(CommonCell *)cell
{
    if (CommonCellType_Captcha) {
        [cell becomeFirstResponder];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
