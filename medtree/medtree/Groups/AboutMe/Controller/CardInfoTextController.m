

//
//  CardInfoTextController.m
//  medtree
//
//  Created by 边大朋 on 15/8/10.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "CardInfoTextController.h"
#import "PersonEditSetTextView.h"
#import "LoadingView.h"
#import "UserManager.h"
#import "UserDTO.h"
#import "EditPersonCardInfoController.h"
#import "AccountHelper.h"
#import "ColorUtil.h"
#import "InfoAlertView.h"
#import "JSONKit.h"

@interface CardInfoTextController ()
{
    PersonEditSetTextView   *textView;
    UserDTO *udto;
}

@end

@implementation CardInfoTextController

- (void)createUI
{
    [super createUI];
    self.view.backgroundColor = [ColorUtil getColor:@"F1F1F5" alpha:1];
    UIButton *editButton = [NavigationBar createNormalButton:@"保存" target:self action:@selector(clickSave)];
    [naviBar setRightButton:editButton];
    
    textView = [[PersonEditSetTextView alloc] initWithFrame:CGRectZero];

    [textView setTextViewBecomeFirstResponder];
    [self.view addSubview:textView];
    textView.parent = self;
    
    [self createBackButton];
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    udto = [AccountHelper getAccount];
    
    NSString *placeHolderText = @"限制在240个文字以内...";
    NSString *topTitle;
    NSString *textData;
    if (self.textType == CardInfoTextType_Name) {
        topTitle = @"编辑姓名";
        textData = udto.name;
        placeHolderText = @"请填写姓名";
    } else if (self.textType == CardInfoTextType_Sideline) {
        topTitle = @"编辑职位";
        if (udto.sideline.length > 0) {
            textData = udto.sideline;
        }
    } else if (self.textType == CardInfoTextType_Achievement) {
        topTitle = @"编辑个人成就";
        if (udto.achievement.length > 0) {
            textData = udto.achievement;
        }
    } else if (self.textType == CardInfoTextType_Birthplace) {
        topTitle = @"编辑出生地";
        if (udto.birthplace.length > 0) {
            textData = udto.birthplace;
        }
         placeHolderText = @"请填写出生地";
    } else if (self.textType == CardInfoTextType_Phone) {
        topTitle = @"编辑联系电话";
        if (udto.phone.length > 0) {
            textData = udto.phone;
        }
         placeHolderText = @"请填写联系电话";
    }
    [naviBar setTopTitle:topTitle];
    [textView setBgTitle:placeHolderText];
    [textView setTextViewTextInfo:textData];
}

- (void)clickSave
{
    if (textView.textViewInfo.length == 0 || [textView.textViewInfo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0){
        return;
    } else if (textView.textViewInfo.length > 240 && self.textType == CardInfoTextType_Achievement) {
        [InfoAlertView showInfo:@"字数不能大于240个字" inView:self.view duration:1];
        return;
    } else if (textView.textViewInfo.length > 120 && self.textType == CardInfoTextType_Sideline) {
        [InfoAlertView showInfo:@"字数不能大于120个字" inView:self.view duration:1];
        return;
    } else if (textView.textViewInfo.length > 16 && self.textType == CardInfoTextType_Name) {
        [InfoAlertView showInfo:@"字数不能大于16个字" inView:self.view duration:1];
        return;
    } else if (textView.textViewInfo.length > 16 && self.textType == CardInfoTextType_Birthplace) {
        [InfoAlertView showInfo:@"字数不能大于16个字" inView:self.view duration:1];
        return;
    } else if (textView.textViewInfo.length > 16 && self.textType == CardInfoTextType_Phone) {
        [InfoAlertView showInfo:@"字数不能大于16个字" inView:self.view duration:1];
        return;
    }

    NSDictionary *param;
    NSString *text = textView.textViewInfo;
    if (self.textType == CardInfoTextType_Name) {
        param = @{@"real_name":text};
    } else if (self.textType == CardInfoTextType_Sideline) {
        param = @{@"sideline":text};
    } else if (self.textType == CardInfoTextType_Achievement) {
        param = @{@"achievement":text};
    } else if (self.textType == CardInfoTextType_Birthplace) {
        param = @{@"birthplace":text};
    } else if (self.textType == CardInfoTextType_Phone) {
        param = @{@"phone":text};
    }
    
    [UserManager postUserCard:param success:^(id JSON) {
        NSLog(@"---%@", JSON);
        if ([JSON[@"success"] boolValue]) {
            if (self.textType == CardInfoTextType_Name) {
                udto.name = text;
            } else if (self.textType == CardInfoTextType_Sideline){
                udto.sideline = text;
            } else if (self.textType == CardInfoTextType_Achievement) {
                udto.achievement = text;
            } else if (self.textType == CardInfoTextType_Phone) {
                udto.phone = text;
            } else if (self.textType == CardInfoTextType_Birthplace) {
                udto.birthplace = text;
            }
            if (JSON[@"result"]) {
                NSDictionary *dict = [NSDictionary dictionaryWithDictionary:JSON[@"result"]];
                if (dict[@"is_card_complete"]) {
                    udto.is_card_complete = [dict[@"is_card_complete"] boolValue];
                }
            }
            [UserManager checkUser:udto];
            
            if ([self.parent isKindOfClass:[EditPersonCardInfoController class]]) {
                ((EditPersonCardInfoController *)(self.parent)).userDTO = udto;
            }
            [self.navigationController popViewControllerAnimated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
            });
        }
    } failure:^(NSError *error, id JSON) {
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize size = self.view.frame.size;
    textView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, 200);
    if (self.textType == CardInfoTextType_Name || self.textType == CardInfoTextType_Phone || self.textType == CardInfoTextType_Birthplace) {
        textView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, 50);
    }
}


@end
