//
//  RootViewController.m
//  medtree
//
//  Created by tangshimi on 7/29/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "RootViewController.h"
#import "YMNavigationController.h"
#import "HomeViewController.h"
#import "MyRelationViewController.h"
#import "FindController.h"
#import "RESideMenu.h"
#import "AboutMeViewController.h"
#import "Keychain.h"
#import "NewLoginController.h"
#import "AccountHelper.h"
#import "StatisticHelper.h"
#import "CommonManager.h"
#import "IMUtil+Public.h"
#import "LoginGetDataHelper.h"
#import "UserDTO.h"
#import "AdvertisementView.h"
#import "EventFeedViewController.h"
#import "RecommendDTO.h"
#import "SignDTO.h"
#import "HelpView.h"
#import "FontUtil.h"
#import "MessageViewController.h"
#import "LoginGetIntegralView.h"
#import "ChannelManager.h"
#import "MessageManager+Count.h"
#import <JSONKit.h>
#import "NewCountDTO.h"
#import "SessionDTO.h"
#import "UrlParsingHelper.h"
#import "ImproveController.h"
#import "MateFriendsController.h"
#import "HomeChannelDiscussionAndArticleCommentViewController.h"
#import "HomeChannelArticleDetailViewController.h"
#import "AboutMeJobGuideView.h"
#import "HomeJobChannelViewController.h"
#import <Reachability.h>
#import <InfoAlertView.h>

//#import "iConsole.h"

typedef NS_ENUM(NSInteger, RootViewControllerAdvertisementType) {
    RootViewControllerAdvertisementActivityType = 1,
    RootViewControllerAdvertisementWebType = 2
};

static const NSInteger kRootViewControllerLogOutAlertViewTag = 1000;
static const CGFloat kRootViewControllerLeftMenuControllerWidth = 273.0;

@interface RootViewController () <RESideMenuDelegate, ChatManagerDelegate, UIAlertViewDelegate, HelpViewDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) RESideMenu *sideMenuViewController;
@property (nonatomic, readwrite, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) AdvertisementView *advertisementView;
@property (nonatomic, strong) RecommendDTO *advertisementViewDTO;
/*d
 签到领取积分view
 **/
@property (nonatomic, strong) LoginGetIntegralView *getIntegralView;
@property (nonatomic, strong) HelpView *guideView;
@property (nonatomic, assign) BOOL leftMenuViewControllerShow;

@end

@implementation RootViewController

+ (RootViewController *)shareRootViewController
{
    static RootViewController *rootViewController = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        rootViewController = [[RootViewController alloc] init];
    });
    return rootViewController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [MedGlobal checkBigPhone];
        [MedGlobal initQueue];
        [[IMUtil sharedInstance] registerRootController:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willEnterForgroundNotificationAction:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginSuccess:)
                                                     name:LoginSuccessNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(improveThePersonalInformationSuccessNotification:)
                                                     name:ImproveThePersonalInformationSuccessNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(LogoutNotification:)
                                                     name:LogoutNotification
                                                   object:nil];
        
        Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        [reach startNotifier];

    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [FontUtil setBarFontColor:[UIColor whiteColor]];
    
    [self addChildViewController:self.sideMenuViewController];
    [self.view addSubview:self.sideMenuViewController.view];
    
    [self loginMedtree];
    
    [self showGudieView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -
#pragma mark - response event -

- (void)willEnterForgroundNotificationAction:(NSNotification *)notification
{
    if ([AccountHelper getAccount].userID) {
        [self getIntegralRequest];
    }
}

- (void)loginSuccess:(NSNotification *)notification
{
    [self loginSuccessAfter];
}

- (void)improveThePersonalInformationSuccessNotification:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loginIM];
        [self getIntegralRequest];
        [self getAdvertisementInfoRequest];
        [self getIsShowDegreeInvitePhoneController];
    });
}

- (void)LogoutNotification:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self logout];
    });
}

- (void) reachabilityChanged: (NSNotification*)note {
    Reachability * reach = [note object];
    
    if(![reach isReachable]) {
        [InfoAlertView showInfo:@"您已断开网络!" inView:self.view duration:2];
        return;
    }
    
    //@"网络可用";
    
    if (reach.isReachableViaWiFi) {
        //@"当前通过wifi连接";
    } else {
        //@"wifi未开启，不能用";
    }
    
    if (reach.isReachableViaWWAN) {
         //@"当前通过2g or 3g连接";
    } else {
        // @"2g or 3g网络未使用";
    }
}

#pragma mark -
#pragma mark - logout -

- (void)logout
{
    ((UIViewController *)self.tabBarController.viewControllers[3]).tabBarItem.badgeValue = nil;
    [self logoutIM];
    [self logoutMedtree];
    self.tabBarController.selectedIndex = 0;
    [AccountHelper deleteDevice:[[AccountHelper getAccount] userID] success:^(id JSON) {
        
    } failure:^(NSError *error, id JSON) {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
        
    }];
}

#pragma mark -
#pragma mark - login Medtree and logout Medtree -

- (void)loginMedtree
{
    NSString *token = [Keychain getValue:@"token"];
    NSString *userid = [Keychain getValue:@"userid"];
    BOOL isAutoLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutoLogin"] boolValue];
    if (isAutoLogin && token != nil && userid != nil && ![token isEqualToString:@""] && ![userid isEqualToString:@""]) {
        NSDictionary *dict = @{@"userid": userid, @"token": token};
        [AccountHelper tryToLoginByToken:dict success:^(id JSON) {
            if (JSON) {
                [self loginSuccessAfter];
            } else {
                [self presentLoginViewController];
            }
        } failure:^(NSError *error, id JSON) {
            [self presentLoginViewController];
        }];
    } else {
        [self presentLoginViewController];
    }
}

- (void)logoutMedtree
{
    [AccountHelper tryToLogout:nil success:^(id JSON) {
        [AccountHelper setLoginState:NO];
        [AccountHelper cleanAccount];//清空账户信息
        [[IMUtil sharedInstance] logoutIM];
        [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"isAutoLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[RootViewController shareRootViewController] presentLoginViewController];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        [StatisticHelper closeTimer];
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark -
#pragma mark - login success -

- (void)loginSuccessAfter
{
    [AccountHelper getUser_Access_token:^(id JSON) {
        
    }];
    [self loginIM];
    [self getIntegralRequest];
    [self getAdvertisementInfoRequest];
    
    UserDTO *dto = [AccountHelper getAccount];
    
    if (dto.user_status == 0) {
//        ImproveController *vc = [[ImproveController alloc] init];
//        vc.userType = (User_Types)dto.user_type;
//        NavigationController *nc = [[NavigationController alloc] initWithRootViewController:vc];
//        nc.navigationBarHidden = YES;
//        vc.isDismiss = YES;
//        [self presentViewController:nc animated:YES completion:nil];
    } else {
        [self getIsShowDegreeInvitePhoneController];
    }
    [self showBadge];
}

#pragma mark -
#pragma mark 判断是否弹出同步通讯录

- (void)getIsShowDegreeInvitePhoneController
{
    [self getCheckAddressInfo:^(id JSON) {
        BOOL isCheck = [JSON boolValue];
        if (!isCheck) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setCheckAddressInfo:@{@"isCheckAddress":[NSNumber numberWithBool:YES]}];
                MateFriendsController *phone = [[MateFriendsController alloc] init];
                NavigationController *nc = [[NavigationController alloc] initWithRootViewController:phone];
                nc.navigationBarHidden = YES;
                phone.isDismiss = YES;
                [self presentViewController:nc animated:YES completion:nil];
            });
        }
    }];
}

- (void)getCheckAddressInfo:(SuccessBlock)success
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"isCheckAddress"} success:^(id JSON) {
        NSArray *array = [NSArray arrayWithArray:JSON];
        if (array.count > 0) {
            NSMutableDictionary *inviteDict = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:0]];
            BOOL isInvite = [[inviteDict objectForKey:@"isCheckAddress"] boolValue];
            success ([NSNumber numberWithBool:isInvite]);
        } else {
            success ([NSNumber numberWithBool:NO]);
        }
    } failure:^(NSError *error, id JSON) {
        success ([NSNumber numberWithBool:NO]);
    }];
}

- (void)setCheckAddressInfo:(NSDictionary *)dict
{
    dispatch_async([MedGlobal getDbQueue], ^{
        DTOBase *dto = [[DTOBase alloc] init:dict];
        [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"isCheckAddress",@"info":dto} success:^(id JSON) {
        } failure:^(NSError *error, id JSON) {
            
        }];
    });
}

#pragma mark - 
#pragma mark - login IM and logout IM -

- (void)loginIM
{
    [AccountHelper getUser_Im_password:^(id JSON) {
        [Keychain setValue:JSON key:@"password"];

        [CommonManager getIpList:nil success:^(id JSON) {
            NSArray *ips = [(NSDictionary *)JSON objectForKey:@"result"];
            if (ips.count > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:ips forKey:@"ipList"];
                [[IMUtil sharedInstance] setHost:[ips objectAtIndex:0]];
                [[IMUtil sharedInstance] startIM];
            }
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"isAutoLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } failure:^(NSError *error, id JSON) {
            [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"isAutoLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }];
}

- (void)logoutIM
{
    [[IMUtil sharedInstance] logoutIM];
}

/**
 *  删除当前ip并获取新ip如果都没有从数据库中删除
 */
- (void)deleteIP
{
    [[IMUtil sharedInstance] logoutIM];
    NSMutableArray *ipList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ipList"]];
    if (ipList.count > 1) {
        [ipList removeObjectAtIndex:0];
        [[IMUtil sharedInstance] setHost:[ipList objectAtIndex:0]];
        [[IMUtil sharedInstance] startIM];
        [[NSUserDefaults standardUserDefaults] setObject:ipList forKey:@"ipList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [CommonManager deleteIp:nil success:^(id JSON) {
            [self loginIM];
        } failure:nil];
    }
}

#pragma mark -
#pragma mark - 系统通知接收 分发 -

- (void)didRegisterAPNS:(BOOL)force
{
#if !TARGET_IPHONE_SIMULATOR
    NSString *device_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if (device_token.length > 0) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        BOOL inHouse = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"InHouse"] boolValue];
        [param setObject:inHouse ? @"medtree" : @"medtreeapp" forKey:@"app"];
#if DEBUG
        [param setObject:[NSNumber numberWithBool:YES] forKey:@"debug"];
#else
        [param setObject:[NSNumber numberWithBool:NO] forKey:@"debug"];
#endif
        [param setObject:device_token forKey:@"device_token"];
        [param setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
        
//        [CommonManager updateAPNS:param success:^(id JSON) {
//            NSDictionary *dict = (NSDictionary *)JSON;
//            if ([[dict objectForKey:@"success"] boolValue]) {
//                isRegisterAPNS = YES;
//            }
//        } failure:^(NSError *error, id JSON) {
//            
//        }];
    }
#endif
}

- (void)pushToController:(NSDictionary *)info type:(MessageType)type
{
    switch (type) {
        case MessageTypeActivityNotify: {
            if ([info[@"type"] integerValue] == 1) {
                EventFeedViewController *event = [[EventFeedViewController alloc] init];
                event.eventID = [info[@"id"] isKindOfClass:[NSNumber class]] ? [info[@"id"] stringValue] : info[@"id"];
                event.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:event animated:YES];
            } else if ([info[@"type"] integerValue] == 11) {
                [UrlParsingHelper operationUrl:info[@"url"] controller:self title:@"活动"];
            }
            
            break;
        }
        case MessageTypeArticleNotify:{
            HomeChannelArticleDetailViewController *vc = [[HomeChannelArticleDetailViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.articleID = [info[@"id"] isKindOfClass:[NSNumber class]] ? [info[@"id"] stringValue] : info[@"id"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case MessageTypeDiscussNotify:{
            HomeChannelDiscussionAndArticleCommentViewController *vc = [[HomeChannelDiscussionAndArticleCommentViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.type = HomeChannelDiscussionAndArticleCommentViewControllerTypeDiscussionAndArticle;
            vc.articleAndDiscussionID = [info[@"id"] isKindOfClass:[NSNumber class]] ? [info[@"id"] stringValue] : info[@"id"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case MessageTypeWebNotify: {
            [UrlParsingHelper operationUrl:info[@"url"] controller:self.tabBarController title:info[@"title"]];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)didReceivedAPNS:(NSDictionary *)info isStart:(BOOL)isStart
{
    MessageType type = (MessageType)[[info objectForKey:@"type"] integerValue];
    NSDictionary *dict = [info objectForKey:@"args"];
    
    if (isStart) {
        [self pushToController:dict type:type];
    } else {
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        } else {
            [self pushToController:dict type:type];
        }
    }
}

#pragma mark -
#pragma mark - 签到领积分 -

- (void)getIntegralRequest
{
    if ([self.getIntegralView todayGetIntegral]) {
        return;
    }
    
    [UserManager pointSignIn:nil success:^(id JSON) {
        if ([[JSON objectForKey:@"success"] boolValue]) {
            SignDTO *dto = [[SignDTO alloc] init:[JSON objectForKey:@"result"]];
           if (dto.point > 0) {
                self.getIntegralView.signDTO = dto;
                [self.getIntegralView showInView:self.tabBarController.view];
            } else {
                [self.getIntegralView setTodayAlreadyGetIntergtal];
            }
        }
    } failure:^(NSError *error, id JSON) {

    }];
}

#pragma mark -
#pragma makr - 广告 -

- (void)getAdvertisementInfoRequest
{
    if ([self.advertisementView todayShowAdvertisementView]) {
        return;
    }
    
    NSDictionary *params = @{ @"method" : @(MethodTypeChannelDailyAdvertisement) };
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        NSArray *array = JSON;
        if (array.count <= 0) {
            return;
        }
        self.advertisementView.recommendDTO = [array firstObject];
        [self.advertisementView showAnimated:YES];
        self.advertisementViewDTO = [array firstObject];
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark -
#pragma mark - GuideView 引导页 -

- (void)showGudieView
{
    if ([self isShowGuideView]) {
        return;
    }
    
    [self setIsShowHelp:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:self.guideView];
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:version forKey:@"version"];
    [userDefault synchronize];
}

- (BOOL)isShowGuideView
{
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    
    if (!version || version.length == 0 ) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark -
#pragma mark - public -

- (void)showLeftSideMenuViewController
{
    [ClickUtil event:@"me_open" attributes:@{}];
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)hideLeftSideMenuViewController
{
    [self.sideMenuViewController hideMenuViewController];
}

- (void)presentLoginViewController
{
    NewLoginController *loginController = [[NewLoginController alloc] init];
    loginController.parent = self;
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginController];
    nav.navigationBarHidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
#pragma mark - private -
- (void)showBadge
{
    NSInteger notifyCount = [MessageManager getAllNotifyCount];
    NSInteger unreadCount = [MessageManager getAllUnreadCount];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger count = notifyCount + unreadCount;
        if (count == 0) {
            ((UIViewController *)self.tabBarController.viewControllers[3]).tabBarItem.badgeValue = nil;
        } else {
            ((UIViewController *)self.tabBarController.viewControllers[3]).tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", @(count)];
        }
    });
}

#pragma mark -
#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case kRootViewControllerLogOutAlertViewTag:
            if (buttonIndex == 0) {
                if ([AccountHelper getLoginState]) {
                    [(UINavigationController *)self.tabBarController.selectedViewController popToRootViewControllerAnimated:NO];
                    self.tabBarController.selectedIndex = 0;
                }
            }
            [self logout];

            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - UINavigationControllerDelegate -

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    navigationController.interactivePopGestureRecognizer.enabled = ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)] && [navigationController.viewControllers count] > 1);
    
    if (navigationController.viewControllers.count > 1) {
        self.sideMenuViewController.panGestureEnabled = NO;
    } else {
        self.sideMenuViewController.panGestureEnabled = YES;
    }
}

#pragma mark -
#pragma mark - UITabBarControllerDelegate -

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    switch (tabBarController.selectedIndex) {
        case 0:
            [ClickUtil event:@"homepage_open" attributes:@{}];
            break;
        case 1:
            [ClickUtil event:@"contacts_open" attributes:@{}];
            break;
        case 2:
            [ClickUtil event:@"message_open" attributes:@{}];
            break;
        case 3:
            [ClickUtil event:@"discover_open" attributes:@{}];
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark -
#pragma mark - RESideMenuDelegate -

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuViewControllerWillShowNotification object:nil];
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    self.leftMenuViewControllerShow = YES;
    
    [AboutMeJobGuideView showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuViewControllerWillHideNotification object:nil];
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    self.leftMenuViewControllerShow = NO;
}

- (void)sideMenu:(RESideMenu *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (!sideMenu.panGestureEnabled) {
        return;
    }
    
    CGPoint point = [recognizer translationInView:self.view];
    
    if (self.leftMenuViewControllerShow) {
        if (point.x > 0.0) {
            point.x += kRootViewControllerLeftMenuControllerWidth;
        }
    }
    CGFloat alpha = (fabs(point.x) >= kRootViewControllerLeftMenuControllerWidth ? kRootViewControllerLeftMenuControllerWidth : fabs(point.x)) / kRootViewControllerLeftMenuControllerWidth;
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (point.x > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MenuViewControllerWillHideNotification
                                                                object:nil
                                                              userInfo:@{ @"alpha" : @(1 - alpha)}];
        } else {
            if (!self.leftMenuViewControllerShow) {
                return;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:MenuViewControllerWillShowNotification
                                                                object:nil
                                                              userInfo:@{ @"alpha" : @(alpha)}];
        }
    }    
}

#pragma mark -
#pragma mark - ChatManagerDelegate -
/** 连接成功 */
- (void)didConnectionSuccess
{

}

- (void)connectionErrorWithIP:(NSString *)ip
{
    [self deleteIP];
}

static NSTimeInterval csdeltaTime;
- (void)handleAuthSuccess:(NSDictionary *)info
{
    if (info) {
        csdeltaTime = [info[kDeltaTime] doubleValue];
    }
}

/** 认证成功 */
- (void)handleAuthFail:(NSDictionary *)info
{
    [self loginIM];
}

/** 发送消息回调 */
- (void)didSendTcpMessage:(MessageDTO *)dto error:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MessageStatusChangeNotification object:dto];
}

/** 新消息提示 */
- (void)didReceiveUnreadMessages:(NSArray *)array
{
    for (NSDictionary *dict in array) {
        SessionDTO *dto = [[SessionDTO alloc] init:dict];
        [MessageManager addSession:dto success:nil failure:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MessageListChangeNotification object:nil];
    [self showBadge];
}

/** 拉取消息 */
- (void)didReceiveMessages:(NSArray *)array type:(PullOldMsgType)type
{
    [MessageManager addMessages:array type:type deltaTime:csdeltaTime success:^(id JSON) {
        switch (type) {
            case PullOldMsgRequestLatest: {
                [[NSNotificationCenter defaultCenter] postNotificationName:MessagePullNewMessageNotification object:array];
                break;
            }
            case PullOldMsgRequestOld: {
                [[NSNotificationCenter defaultCenter] postNotificationName:MessagePullHistoryMessageNotification object:array];
                break;
            }
            case PullOldMsgRequestPointed: {
                break;
            }
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

/** 拉去消息 */
- (void)didLoginFromOtherDevice:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message.length > 0 ? message : @"你的医树账号已在其它设备上登录，请注意账号安全。"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    alert.tag = kRootViewControllerLogOutAlertViewTag;
    [alert show];
    
    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"isAutoLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)notifyNewMessage:(MessageDTO *)message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NewMessageNotification object:message];
}

- (void)imClientBreakOff
{
    [MessageManager markAllPendingAsError];
}

- (void)notifyNewSystemMessage:(NSInteger)type content:(NSString *)content
{
    switch (type) {
        case MessageTypeNewFriend: {
            NewCountDTO *dto = [[NewCountDTO alloc] init:[content objectFromJSONString]];
            dto.key = kMatchNewFriend;
            [MessageManager addNewCount:dto success:nil failure:nil];
            [self showBadge];
            [[NSNotificationCenter defaultCenter] postNotificationName:FriendListChangeNotification object:nil];
            break;
        }
        case MessageTypeNoticeNotify: {
            NewCountDTO *dto = [[NewCountDTO alloc] init:[content objectFromJSONString]];
            dto.key = kNotifyMessage;
            [MessageManager addNewCount:dto success:nil failure:nil];
            [self showBadge];
            [[NSNotificationCenter defaultCenter] postNotificationName:NewCountListChangeNotification object:content];
            break;
        }
        case MessageTypeNewActivity: {
            break;
        }
        case MessageTypeCerification: {
            [AccountHelper getUserInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
            break;
        }
        case MessageTypeRelation: {
            [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
            break;
        }
        case MessageTypeNewFeed: {
            break;
        }
        case MessageTypeJobNotify: {
            NewCountDTO *dto = [[NewCountDTO alloc] init:[content objectFromJSONString]];
            dto.key = kNotifyJob;
            [MessageManager addNewCount:dto success:nil failure:nil];
            [self showBadge];
            [[NSNotificationCenter defaultCenter] postNotificationName:NewJobStateNotification object:content];
            break;
        }
        case MessageTypeNewJobPushNotify: {
            NewCountDTO *dto = [[NewCountDTO alloc] init:[content objectFromJSONString]];
            dto.key = kNotifyNewJob;
            [MessageManager addNewCount:dto success:nil failure:nil];
            [self showBadge];
            [[NSNotificationCenter defaultCenter] postNotificationName:NewJobAssisantNotification object:content];
            break;
        }
    }
}

- (void)didReceivedAPNS:(NSDictionary *)info
{
    [self didReceivedAPNS:info isStart:NO];
}

#pragma mark -
#pragma mark - HelpViewDelegate -

- (void)setIsShowHelp:(BOOL)isShow
{
    if (isShow) {
        [self.guideView showHelp];
        [UIView animateWithDuration:0.5 animations:^{
            self.guideView.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.guideView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.guideView removeFromSuperview];
        }];
    }
}

#pragma mark -
#pragma mark - setter/getter -

- (UITabBarController *)tabBarController
{
    if (!_tabBarController) {
        NSArray *tabBarItemImageArray = @[ @"home", @"job", @"relation", @"message", @"find" ];
        NSArray *tabBarItemTitleArrray = @[ @"首页", @"职位", @"人脉", @"消息", @"发现" ];
        
        __block NSMutableArray *tabBarItemArray = [NSMutableArray new];
        [tabBarItemImageArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            UIImage *unSelectedImage = [[UIImage imageNamed:obj] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_click", obj]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:unSelectedImage selectedImage:selectedImage];
            [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] } forState:UIControlStateSelected];
            [tabBarItemArray addObject:tabBarItem];
        }];
        
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.delegate = self;
        tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
        
        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        YMNavigationController *homeNavigationController = [[YMNavigationController alloc] initWithRootViewController:homeViewController];
        homeNavigationController.delegate = self;
        homeNavigationController.navigationBarHidden = YES;
        homeNavigationController.tabBarItem = tabBarItemArray[0];
        homeNavigationController.tabBarItem.title = tabBarItemTitleArrray[0];
        
        HomeJobChannelViewController *homeJobChannelViewController =[[HomeJobChannelViewController alloc] init];
        YMNavigationController *homeJobNavigationController = [[YMNavigationController alloc] initWithRootViewController:homeJobChannelViewController];
        homeJobNavigationController.delegate = self;
        homeJobNavigationController.navigationBarHidden = YES;
        homeJobNavigationController.tabBarItem = tabBarItemArray[1];
        homeJobNavigationController.tabBarItem.title = tabBarItemTitleArrray[1];
        
        MyRelationViewController *myRelationViewController = [[MyRelationViewController alloc] init];
        YMNavigationController *myRelationNavigationController = [[YMNavigationController alloc] initWithRootViewController:myRelationViewController];
        myRelationNavigationController.delegate = self;
        myRelationNavigationController.navigationBarHidden = YES;
        myRelationNavigationController.tabBarItem = tabBarItemArray[2];
        myRelationNavigationController.tabBarItem.title = tabBarItemTitleArrray[2];
        
        MessageViewController *messageViewController = [[MessageViewController alloc] init];
        YMNavigationController *messageNavigationController = [[YMNavigationController alloc] initWithRootViewController:messageViewController];
        messageNavigationController.delegate = self;
        messageNavigationController.navigationBarHidden = YES;
        messageNavigationController.tabBarItem = tabBarItemArray[3];
        messageNavigationController.tabBarItem.title = tabBarItemTitleArrray[3];

        FindController *findViewController = [[FindController alloc] init];
        YMNavigationController *findNavigationController = [[YMNavigationController alloc] initWithRootViewController:findViewController];
        findNavigationController.delegate = self;
        findNavigationController.navigationBarHidden = YES;
        findNavigationController.tabBarItem = tabBarItemArray[4];
        findNavigationController.tabBarItem.title = tabBarItemTitleArrray[4];

        NSArray *controllersArray = @[ homeNavigationController,
                                       homeJobNavigationController,
                                       myRelationNavigationController,
                                       messageNavigationController,
                                       findNavigationController ];
        [tabBarController setViewControllers:controllersArray];
        
        tabBarController.selectedIndex = 0;
        
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

- (RESideMenu *)sideMenuViewController
{
    if (!_sideMenuViewController) {
        AboutMeViewController *aboutMeViewController = [[AboutMeViewController alloc] init];
        
        RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:self.tabBarController
                                                                        leftMenuViewController:aboutMeViewController
                                                                       rightMenuViewController:nil];
        sideMenuViewController.backgroundImage = [UIImage imageNamed:@"home_back_image.jpg"];
        sideMenuViewController.delegate = self;
        sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
        sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
        sideMenuViewController.contentViewShadowOpacity = 0.6;
        sideMenuViewController.contentViewShadowRadius = 12;
        sideMenuViewController.contentViewShadowEnabled = YES;
        sideMenuViewController.scaleContentView = NO;
        sideMenuViewController.scaleMenuView = NO;
        sideMenuViewController.fadeMenuView = NO;
        sideMenuViewController.bouncesHorizontally = NO;
        sideMenuViewController.contentViewInPortraitOffsetCenterX = GetScreenWidth / 2 - (GetScreenWidth - kRootViewControllerLeftMenuControllerWidth);
        sideMenuViewController.parallaxEnabled = YES;
        _sideMenuViewController = sideMenuViewController;
    }
    return _sideMenuViewController;
}

- (AdvertisementView *)advertisementView
{
    if (!_advertisementView) {
        AdvertisementView *advertisementView = [[AdvertisementView alloc] initWithFrame:CGRectZero inView:[UIApplication sharedApplication].keyWindow];
        __weak __typeof(self) weakSelf = self;
        advertisementView.clickBlock = ^ {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [ClickUtil event:@"AD_click" attributes:@{}];
            if (strongSelf.advertisementViewDTO.content_type == RootViewControllerAdvertisementActivityType) {
                EventFeedViewController *efc = [[EventFeedViewController alloc] init];
                efc.eventID = strongSelf.advertisementViewDTO.recommendID;
                [strongSelf.navigationController pushViewController:efc animated:YES];
            } else if (strongSelf.advertisementViewDTO.content_type == RootViewControllerAdvertisementWebType) {
                [UrlParsingHelper operationUrl:strongSelf.advertisementViewDTO.url
                                    controller:strongSelf
                                         title:strongSelf.advertisementViewDTO.title];
            }
        };
        _advertisementView = advertisementView;
    }
    return _advertisementView;
}

- (LoginGetIntegralView *)getIntegralView
{
    if (!_getIntegralView) {
        _getIntegralView = ({
            LoginGetIntegralView *view = [[LoginGetIntegralView alloc] initWithFrame:self.view.bounds];
            view.getMoreIntegralBlock = ^{
                [UrlParsingHelper operationUrl:@"https://m.medtree.cn/inner/public/daily/store/pointrule?inapp=1&token=1" controller:self title:@"获取更多积分"];
            };
            view;
        });
    }
    return _getIntegralView;
}

- (HelpView *)guideView
{
    if (!_guideView) {
        _guideView = ({
            HelpView *view = [[HelpView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            view.parent = self;
            view;
        });
    }
    return _guideView;
}

@end
