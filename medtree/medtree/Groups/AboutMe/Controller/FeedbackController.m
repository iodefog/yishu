//
//  FeedbackController.m
//  medtree
//
//  Created by 无忧 on 14-10-28.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "FeedbackController.h"
#import "TextViewEx.h"
#import "MedGlobal.h"
#import "ServiceManager.h"
#import "InfoAlertView.h"
#import "JSONKit.h"
#import "LoadingView.h"
#import "PersonEditSetTextView.h"

@interface FeedbackController ()
{
    PersonEditSetTextView          *textView;
}

@end

@implementation FeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)clickCancel
{
    [textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSend
{
    UIButton *btn = (UIButton *)naviBar.rightButton;
    if (textView.textViewInfo.length == 0 || [textView.textViewInfo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [InfoAlertView showInfo:@"请输入您要反馈的意见！" inView:self.view duration:1];
    } else {
        btn.enabled = NO;
        naviBar.userInteractionEnabled = NO;
        [LoadingView showProgress:YES inView:self.view];
        [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_Feedback],@"feedback":textView.textViewInfo} success:^(id JSON) {
            btn.enabled = YES;
            naviBar.userInteractionEnabled = YES;
            [LoadingView showProgress:NO inView:self.view];
            
            BOOL isSuccess = [[JSON objectForKey:@"success"] boolValue];
            if (isSuccess) {
                [InfoAlertView showInfo:@"反馈成功！" inView:self.view duration:1];
                [self performSelector:@selector(clickCancel) withObject:nil afterDelay:1];
            } else {
                [InfoAlertView showInfo:@"意见反馈失败！请重试" inView:self.view duration:1];
            }
        } failure:^(NSError *error, id JSON) {
            naviBar.userInteractionEnabled = YES;
            btn.enabled = YES;
            [LoadingView showProgress:NO inView:self.view];
            if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
                NSDictionary *result = [JSON objectFromJSONString];
                if ([result objectForKey:@"message"] != nil) {
                    [InfoAlertView showInfo:[result objectForKey:@"message"]  inView:self.view duration:1];
                }
            }
        }];
    }
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"意见反馈"];
    
    UIButton *leftButton = [NavigationBar createNormalButton:@"取消" target:self action:@selector(clickCancel)];
    [naviBar setLeftButton:leftButton];
    
    UIButton *rightButton = [NavigationBar createNormalButton:@"发送" target:self action:@selector(clickSend)];
    [rightButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [naviBar setRightButton:rightButton];
    
    textView = [[PersonEditSetTextView alloc] initWithFrame:CGRectZero];
    [textView setBgTitle:@"添加反馈意见"];
    [self.view addSubview:textView];
    [textView setTextViewBecomeFirstResponder];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGSize size = self.view.frame.size;
    textView.frame = CGRectMake(0, [self getOffset]+44, size.width, 200);
}

@end
