//
//  SettingNotifcationViewController.m
//  medtree
//
//  Created by 边大朋 on 15/9/23.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "SettingNotifcationViewController.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "MessageManager.h"

@interface SettingNotifcationViewController ()
{
    NSString *settingKey;
    NSArray  *titleArray;
}
@end

static NSString *const kSettingNotifcation = @"kSettingNotifcationViewController";

@implementation SettingNotifcationViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    settingKey = [NSString stringWithFormat:@"%@%@", kSettingNotifcation, [[AccountHelper getAccount] userID]];
    [self setupData];
}

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    [naviBar setTopTitle:@"新消息通知"];
    [self createBackButton];
    titleArray = @[@"通知免打扰",@"职位备忘免打扰",@"求职小助手消息免打扰"];
    CGSize size = self.view.frame.size;

    for (NSInteger i = 0; i < titleArray.count; i++) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor =[UIColor whiteColor];
        [self.view addSubview:bgView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArray[i];
        [bgView addSubview:titleLabel];
        
        UISwitch *setSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        setSwitch.tag = 100+i;
        [bgView addSubview:setSwitch];
        //线
        UILabel *dividingLine = [[UILabel alloc]init];
        dividingLine.backgroundColor = [ColorUtil getColor:@"d6d6d6" alpha:1];
        [bgView addSubview:dividingLine];
        
        bgView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame)+62*i, size.width, 62);
        CGSize titleSize = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}];
        titleLabel.frame = CGRectMake(15, (bgView.frame.size.height - titleSize.height) / 2, titleSize.width, titleSize.height);
        setSwitch.frame = CGRectMake(size.width - 15 - setSwitch.frame.size.width, (bgView.frame.size.height - setSwitch.frame.size.height) / 2, setSwitch.frame.size.width, setSwitch.frame.size.height);
        CGFloat dividingLineW = size.width - 15 * 2;
        CGFloat dividingLineH = 1;
        CGFloat dividingLineY = CGRectGetHeight(bgView.frame) - dividingLineH;
        dividingLine.frame = CGRectMake(15, dividingLineY, dividingLineW, dividingLineH);
        if (i == 2) {
            dividingLine.frame = CGRectMake(0, dividingLineY, size.width, dividingLineH);
        }
    }
}

- (void)clickBack
{
    UISwitch *notifiSwitch = [self.view viewWithTag:100];
    UISwitch *positionSwitch = [self.view viewWithTag:101];
    UISwitch *messageSwitch = [self.view viewWithTag:102];
    NSDictionary *param = @{@"refuse_notification":@(notifiSwitch.on),
                            @"refuse_job_record":@(positionSwitch.on),
                            @"refuse_job_assistent":@(messageSwitch.on),
                            @"method":@(MethodType_MessageSetting_Put)};
    [MessageManager setData:param success:^(id JSON) {
        NSLog(@"%@",JSON);
    } failure:^(NSError *error, id JSON) {
        
    }];
    
    
    [super clickBack];
}
- (void)setupData
{
    [self getDataFramNet];
}

- (void)getDataFramNet
{
    UISwitch *notifiSwitch = [self.view viewWithTag:100];
    UISwitch *positionSwitch = [self.view viewWithTag:101];
    UISwitch *messageSwitch = [self.view viewWithTag:102];
    NSDictionary *param = @{@"method":@(MethodType_MessageSetting_Get)};
    [MessageManager getData:param success:^(id JSON) {
        [notifiSwitch setOn:[JSON[@"refuse_notification"] boolValue]];
        [positionSwitch setOn:[JSON[@"refuse_job_record"] boolValue]];
        [messageSwitch setOn:[JSON[@"refuse_job_assistent"] boolValue]];
    } failure:^(NSError *error, id JSON) {
        
    }];
}

@end
