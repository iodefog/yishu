//
//  HomeJobChannelSearchEmptyView.m
//  medtree
//
//  Created by tangshimi on 12/1/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelSearchEmptyView.h"
#import "UIImage+imageWithColor.h"
#import "UIColor+Colors.h"
#import "ChannelManager.h"
#import <InfoAlertView.h>
#import <JSONKit.h>

@interface HomeJobChannelSearchEmptyView () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *enterpriseTextField;
@property (nonatomic, strong) UITextField *departmentTextField;
@property (nonatomic, strong) UITextField *jobTextField;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation HomeJobChannelSearchEmptyView

- (void)createUI
{
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorFromHexString:@"#f4f4f7"];
    [self addSubview:self.titleLabel];
    self.enterpriseTextField = [self textFieldWithPlaceholder:@"请输入单位名称（必填）"];
    self.departmentTextField = [self textFieldWithPlaceholder:@"请输入科室/部门名称（必填）"];
    self.jobTextField = [self textFieldWithPlaceholder:@"请输入职位名称（必填）"];
    
    [self addSubview:self.enterpriseTextField];
    [self addSubview:self.departmentTextField];
    [self addSubview:self.jobTextField];
    [self addSubview:self.submitButton];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(30);
        make.left.equalTo(30);
        make.right.equalTo(-30);
    }];
    
    [self.enterpriseTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.top.equalTo(self.titleLabel.bottom).offset(20);
        make.height.equalTo(50);
    }];
    
    [self.departmentTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.top.equalTo(self.enterpriseTextField.bottom).offset(15);
        make.height.equalTo(50);
    }];
    
    [self.jobTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.top.equalTo(self.departmentTextField.bottom).offset(15);
        make.height.equalTo(50);
    }];

    [self.submitButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.top.equalTo(self.jobTextField.bottom).offset(50);
        make.height.equalTo(50);
    }];
    self.submitButton.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChangeAction:)
                                                 name:UITextFieldTextDidEndEditingNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark - response evnet -

- (void)textDidChangeAction:(NSNotification *)notification
{
    if (self.enterpriseTextField.text.length > 0 &&
        self.departmentTextField.text.length > 0 &&
        self.jobTextField.text.length > 0) {
        self.submitButton.enabled = YES;
    } else {
        self.submitButton.enabled = NO;
    }
}

- (void)submitButtonAction:(UIButton *)button
{
    [self submitRequest];
}

#pragma mark -
#pragma mark - request -

- (void)submitRequest
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    NSDictionary *params = @{ @"method" : @(MethodTypeJonChannelSearchPostInfomation),
                              @"org_name" : self.enterpriseTextField.text,
                              @"dept_name" : self.departmentTextField.text,
                              @"job_name" : self.jobTextField.text };
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if (JSON[@"success"]) {
            [InfoAlertView showInfo:@"感谢您的反馈，我们会给您发送相关通知，请持续关注" inView:self duration:1.5];
        }
    } failure:^(NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self duration:1];
            }
        }
    }];
}

#pragma mark -
#pragma mark - helper -

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:15];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    return textField;
}

#pragma mark -
#pragma mark - setter and getter -

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor lightGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"未搜索到您要搜索的内容\n您可以留下您心目中想要的职位信息，我们会为您尽快加入";
//            NSString *string = @"未搜索到您要搜索的内容\n您可以留下您心目中想要的职位信息，我们会为您尽快加入";
//            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//            [paragraphStyle setLineSpacing:8];
//            
//            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
//            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, string.length)];
//            label.attributedText = attributedString;            
            label.numberOfLines = 0;
            label;
        });
    }
    return _titleLabel;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"提交" forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#d2d2d2"] size:CGSizeMake(100, 30)] forState:UIControlStateDisabled];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#365c8a"] size:CGSizeMake(100, 30)] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 5.0;
            button.clipsToBounds = YES;
            button;
        });
    }
    return _submitButton;
}

@end
