//
//  IdentitySelectorController.m
//  medtree
//
//  Created by 孙晨辉 on 15/7/30.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "IdentitySelectorController.h"
#import "RegisterController.h"
#import "NewRegisterController.h"
// model
#import "UserType.h"
// view
#import "VerticalButton.h"
// 工具
#import "ImageCenter.h"
#import "MedGlobal.h"
#import "ColorUtil.h"

@interface IdentitySelectorController ()
{
    UIScrollView            *contentView;
    /** 背景 */
    UIImageView             *identityCardBgView;
    /** 提手 */
    UIImageView             *velcroView;
    /** 标题 */
    UILabel                 *titleLabel;
    /** 身份选择数组 */
    NSMutableArray          *buttons;
    NSTimeInterval          time;
}

@end

@implementation IdentitySelectorController

#pragma mark - UI
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)createUI
{
    [super createUI];

    self.view.backgroundColor = [ColorUtil getColor:@"F4F4F7" alpha:1];
    [naviBar setTopTitle:@"选择您的身份"];
    
    contentView = [[UIScrollView alloc] init];
    [self.view addSubview:contentView];
    
    identityCardBgView = [[UIImageView alloc] init];
    identityCardBgView.userInteractionEnabled = YES;
    UIImage *image = [ImageCenter getNamedImage:@"identity_selector_bg.png"];
    identityCardBgView.image = [image stretchableImageWithLeftCapWidth:170 topCapHeight:70];
    [contentView addSubview:identityCardBgView];
    
    velcroView = [[UIImageView alloc] init];
    velcroView.contentMode = UIViewContentModeScaleToFill;
    velcroView.image = [ImageCenter getBundleImage:@"velcro.png"];
    [contentView addSubview:velcroView];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = [MedGlobal getLargeFont];
    titleLabel.textColor = [ColorUtil getColor:@"1b1c1c" alpha:1.0];
    titleLabel.text = @"身份卡";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [identityCardBgView addSubview:titleLabel];
    
    NSArray *array = @[@"医院在职医生", @"医院在职护士", @"医院其他医务人员", @"卫生行政/\n医学教科研人员", @"医学院校在读学生", @"医学其他人员"];
    buttons = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        VerticalButton *button = [VerticalButton button];
        button.image = [ImageCenter getNamedImage:[NSString stringWithFormat:@"identity_selector_%d.png", i]];
        button.title = array[i];
        button.tag = i;
        [button addTarget:self action:@selector(clickIdentitySelector:) forControlEvents:UIControlEventTouchUpInside];
        [identityCardBgView addSubview:button];
        [buttons addObject:button];
    }
    
    [self createBackButton];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGSize size = self.view.frame.size;
    contentView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, size.height - CGRectGetMaxY(naviBar.frame));
    
    CGFloat velcroViewH = 48;
    CGFloat velcroViewW = 30;
    CGFloat velcroViewX = (size.width - velcroViewW) * 0.5;
    CGFloat velcroViewY = 17;
    velcroView.frame = CGRectMake(velcroViewX, velcroViewY, velcroViewW, velcroViewH);
    
    CGFloat margin = 15;
    CGFloat identityCardBgViewY = 33;
    CGFloat identityCardBgViewW = size.width - margin * 2;
    titleLabel.frame = CGRectMake(0, 50, identityCardBgViewW, titleLabel.font.lineHeight);
    CGFloat buttonTop = 80;
    CGFloat buttonMargin = 25;
    CGFloat buttonW = identityCardBgViewW * 0.5;
    CGFloat buttonH = 125;
    [buttons enumerateObjectsUsingBlock:^(VerticalButton *button, NSUInteger idx, BOOL *stop) {
        NSInteger row = idx / 2;
        NSInteger colomn = idx % 2;
        CGFloat buttonX = buttonW * colomn;
        CGFloat buttonY = buttonTop + row * (buttonH + buttonMargin);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }];
    CGFloat identityCardBgViewH = buttonTop + (buttons.count / 2) * (buttonH + buttonMargin);
    identityCardBgView.frame = CGRectMake(margin, identityCardBgViewY, identityCardBgViewW, identityCardBgViewH);
    
    CGFloat contentSizeH = CGRectGetMaxY(identityCardBgView.frame) + 60;
    contentView.contentSize = CGSizeMake(size.width, contentSizeH);
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

- (void)clickIdentitySelector:(UIButton *)button
{
    NSTimeInterval begin = [[NSDate date] timeIntervalSince1970];
    if (begin - time < 0.3) return;
    time = begin;
    int buttonIndex = (int)button.tag;
    User_Types type = UserTypes_Unknown;
    if (buttonIndex < 2) { // 医生、护士
        NSLog(@"identity1 --- %@", [UserType getLabel:(buttonIndex + UserTypes_Physicians)]);
        type = buttonIndex + UserTypes_Physicians;
    } else if (buttonIndex == 2) { // 其他医务人员
        NSLog(@"identity2 --- %@", [UserType getLabel:UserTypes_ManagementAndAdministrative]);
        type = UserTypes_ManagementAndAdministrative;
    } else if (buttonIndex == 3) { // 卫生行政、医学教科研人员
        NSLog(@"identity2 --- %@", [UserType getLabel:UserTypes_MedicalTeaching]);
        type = UserTypes_MedicalTeaching;
    } else if (buttonIndex == 5) {  // 医学其他人员
        NSLog(@"identity2 --- %@", [UserType getLabel:UserTypes_AlwaysBecome]);
        type = UserTypes_AlwaysBecome;
    } else if (buttonIndex == 4) { // 学生
        NSLog(@"identity3 --- %@", [UserType getLabel:UserTypes_Students]);
        type = UserTypes_Students;
    }
    
    if (type != UserTypes_Unknown) {
        NewRegisterController *vc = [[NewRegisterController alloc] init];
        vc.userType = type;
        vc.phoneNum = _phoneNum;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
