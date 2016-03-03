//
//  AddTitleController.m
//  medtree
//
//  Created by 边大朋 on 15/6/18.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "AddTitleController.h"
#import "InfoAlertView.h"

#import "RegisterController.h"
#import "ExperienceDetailController.h"
#import "TitleDTO.h"
#import "CustomTextField.h"

@interface AddTitleController () <UITextFieldDelegate>
{
    CustomTextField             *textField;
}
@end

@implementation AddTitleController
#pragma mark - UI
- (void)createUI
{
    [super createUI];
    [self createBackButton];
    [self createRightButton];
    [self createView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    [self setupData];
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNumber) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    textField.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame) + 20, size.width, 60);
}

- (void)setupData
{
    [naviBar setTopTitle:@"填写职称/职务"];
    [naviBar setTopLabelColor:[UIColor whiteColor]];
    textField.placeholder = @"请填写您的职称/职务";
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.text = self.titleName;
}

- (void)createView
{
    textField = [[CustomTextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:textField];
}

- (void)createRightButton
{
    UIButton *rightButton = [NavigationBar createNormalButton:@"确认" target:self action:@selector(save)];
    [naviBar setRightButton:rightButton];
}

#pragma mark - click
- (void)save
{
    if ([textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return;
    }
    
    if (textField.text.length > 0) {
        TitleDTO *dto = [[TitleDTO alloc] init];
        dto.title = textField.text;
        [self.parent updateInfo:@{@"data":@"title",@"title":dto}];
        [self.navigationController popToViewController:self.fromVC animated:YES];
    }
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

#pragma mark - noti
- (void)checkNumber
{
    if (textField.text.length > 20) {
        [InfoAlertView showInfo:@"职称字数不能超过20个" inView:self.view duration:1.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            textField.text = [textField.text substringToIndex:20];
        });
    }
}

@end

