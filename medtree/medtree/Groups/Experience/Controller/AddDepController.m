//
//  AddDepController.m
//  medtree
//
//  Created by 孙晨辉 on 15/8/5.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "AddDepController.h"
#import "CustomTextField.h"
#import "FontUtil.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "DepartmentNameDTO.h"
#import "YMScrollView.h"
#import "InfoAlertView.h"

@interface AddDepController ()
{
    YMScrollView            *contentView;
    UILabel                 *noticeLab;
    CustomTextField         *inputView;
    UILabel                 *exampleLab;
    CGFloat                 duration;
}

@end

@implementation AddDepController
#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    [self createView];
    [self createBackButton];
    [self createSaveBtn];
}

- (void)createView
{
    contentView = [[YMScrollView alloc] init];
    [self.view addSubview:contentView];
    
    noticeLab = [[UILabel alloc] init];
    noticeLab.font = [MedGlobal getMiddleFont];
    noticeLab.textColor = [ColorUtil getColor:@"555555" alpha:1];
    noticeLab.numberOfLines = 0;
    [contentView addSubview:noticeLab];
    
    inputView = [[CustomTextField alloc] init];
    [contentView addSubview:inputView];
    
    exampleLab = [[UILabel alloc] init];
    exampleLab.numberOfLines = 0;
    exampleLab.font = [MedGlobal getMiddleFont];
    exampleLab.textColor = [ColorUtil getColor:@"555555" alpha:1];
    [contentView addSubview:exampleLab];
}

- (void)createSaveBtn
{
    UIButton *saveBtn = [NavigationBar createNormalButton:@"确定" target:self action:@selector(save)];
    [naviBar setRightButton:saveBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FontUtil setBarFontColor:[UIColor whiteColor]];
    
    [self setupData];
    [self setupView];
}

- (void)setupData
{
    [inputView becomeFirstResponder];
    [naviBar setTopTitle:@"创建新的部门"];
    noticeLab.text = @"您创建的部门需要您身份认证后，才能直接在该单位的部门列表中显示";
    exampleLab.text = @"请填写规范的部门全称 如： “卫生应急办公室”";
    inputView.placeholder = @"请填写规范的部门全称";
    if (_depName.length > 0) {
        inputView.text = _depName;
    }
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    CGFloat space = 15;
    CGSize maxSize = CGSizeMake(size.width - space * 2, MAXFLOAT);
    CGSize noticeSize = [noticeLab.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:noticeLab.font} context:nil].size;
    noticeLab.frame = CGRectMake(space, space, size.width - space * 2, noticeSize.height);
    
    CGFloat inputViewY = CGRectGetMaxY(noticeLab.frame) + space;
    inputView.frame = CGRectMake(0, inputViewY, size.width, 55);
    
    exampleLab.frame = CGRectMake(space, CGRectGetMaxY(inputView.frame) + space, size.width - space * 2, 50);
    CGFloat contentViewY = CGRectGetMaxY(naviBar.frame);
    contentView.frame = CGRectMake(0, contentViewY, size.width, size.height - contentViewY);
    contentView.contentSize = CGSizeMake(CGRectGetWidth(contentView.frame), CGRectGetHeight(contentView.frame));
}

#pragma mark - register
- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNumber) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - noti
- (void)keyboardWillShow:(NSNotification *)notification
{
    duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyFrame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize size = contentView.frame.size;
    
    if (keyFrame.size.height -  (size.height - CGRectGetMaxY(inputView.frame)) > 0) {
        CGFloat chaHeight = keyFrame.size.height - (size.height - CGRectGetMaxY(inputView.frame));
        contentView.contentOffset = CGPointMake(0, chaHeight);
    }
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [UIView animateWithDuration:duration animations:^{
        contentView.contentOffset = CGPointMake(0, 0);
    }];
    [self.view endEditing:YES];
}

#pragma mark - click
- (void)save
{
    NSString *depName = [inputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (depName.length == 0) return;
    DepartmentNameDTO *dto = [[DepartmentNameDTO alloc] init];
    dto.name = depName;
    NSDictionary *dict = @{@"data":@"department", @"department":dto};
    [self.navigationController popToViewController:self.fromVC animated:YES];
    if ([self.parent respondsToSelector:@selector(updateInfo:)]) {
        [self.parent updateInfo:dict];
    }
}

#pragma mark - noti
- (void)checkNumber
{
    if (inputView.text.length > 20) {
        [InfoAlertView showInfo:@"职称字数不能超过20个" inView:self.view duration:1.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            inputView.text = [inputView.text substringToIndex:20];
        });
    }
}

@end
