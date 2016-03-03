//
//  MateFriendsController.m
//  medtree
//
//  Created by 陈升军 on 15/4/8.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MateFriendsController.h"
#import "UserManager.h"
#import "InfoAlertView.h"
#import "ContactUtil.h"
#import "ImageCenter.h"
#import "ColorUtil.h"
#import "NewInvitePhoneController.h"
#import "LoginGetDataHelper.h"
#import "MateFriendSlideView.h"
#import "MessageManager.h"
#import "LoginGetDataHelper.h"
#import "ContactUtil.h"
#import "ContactInfo.h"
#import "LoadingView.h"
#import "UserDTO.h"
#import "ColorUtil.h"
#import "InfoAlertView.h"
#import "AccountHelper.h"
#import "OperationHelper.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "pinyin.h"
#import "EncodeUtil.h"
#import "MateUserDTO.h"
#import "NewBtnCell.h"
#import "Pair2DTO.h"
#import "NewInviteUserController.h"
#import "NewMateFriendCell.h"
#import "MateUserTableController.h"
#import "NewPersonDetailController.h"
#import "ImageCenter.h"
#import "FriendRequestController.h"
#import "MedGlobal.h"
#import "NavigationController.h"
#import "FontUtil.h"

@interface MateFriendsController () <MFMessageComposeViewControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    UIImageView         *mateHeaderImage;
    UIButton            *mateButton;
     UILabel            *mateTitleLab;
    UILabel             *mateLab;
    
    BOOL                isGetDate;
    
    
    NSMutableArray      *sectionArray;
    NSMutableArray      *phonesArray;
    NSInteger           contactCount;
    NSMutableArray      *dataArray;
    NSMutableArray      *mateOtherArray;
    NSMutableArray      *mateDataArray;
    NSMutableArray      *mateUserArray;
    
    UIImageView         *noDataImage;
    UILabel             *noDataLab;
    
    UIButton            *moreUserButton;
    
    BOOL                isHaveMateData;
}

@end

@implementation MateFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self loadData:self.isDismiss];
}

- (UIButton *)createDismissButton
{
    UIButton *backButton = [NavigationBar createNormalButton:@"跳过" target:self action:@selector(clickDismiss)];
    [naviBar setLeftButton:backButton];
    return backButton;
}

- (void)clickDismiss
{
    [FontUtil setBtnTitleFontColor:[UIColor whiteColor]];
    [FontUtil setBarFontColor:[UIColor whiteColor]];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"发现医学好友"];
    [self createBackButton];
    mateHeaderImage = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"mate_friend_loading_header.png"]];
    [self.view addSubview:mateHeaderImage];
    
    mateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mateButton.layer.cornerRadius = 4;
    mateButton.layer.masksToBounds = YES;
    [mateButton setTitle:@"允许找到Ta" forState:UIControlStateNormal];
    [mateButton setBackgroundColor:[ColorUtil getColor:@"365c8a" alpha:1]];
    [mateButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mateButton];
    
    mateTitleLab = [[UILabel alloc] initWithFrame: CGRectZero];
    mateTitleLab.backgroundColor = [UIColor clearColor];
    mateTitleLab.textColor = [ColorUtil getColor:@"787878" alpha:1];
    mateTitleLab.font = [UIFont boldSystemFontOfSize:20];
    mateTitleLab.numberOfLines = 0;
    mateTitleLab.hidden = YES;
    mateTitleLab.text = @"学医的Ta在哪里？";
    mateTitleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview: mateTitleLab];
    
    mateLab = [[UILabel alloc] initWithFrame: CGRectZero];
    mateLab.backgroundColor = [UIColor clearColor];
    mateLab.textColor = [ColorUtil getColor:@"787878" alpha:1];
    mateLab.font = [MedGlobal getMiddleFont];
    mateLab.numberOfLines = 0;
//    mateLab.text = @"当年和你一起埋头学医的Ta在哪里？\n曾经和你一起并肩工作的Ta在哪里？\n此时默默沉寂在你手机里的Ta在哪里？\n未来和你一起游刃职场的Ta又在哪里？";
    [self.view addSubview: mateLab];
    
    isGetDate = NO;
    
    mateUserArray = [[NSMutableArray alloc] init];
    mateDataArray = [[NSMutableArray alloc] init];
    mateOtherArray = [[NSMutableArray alloc] init];
    dataArray = [[NSMutableArray alloc] init];
    phonesArray = [[NSMutableArray alloc] init];
    sectionArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < ALPHA.length; i++) {
        [sectionArray addObject:[NSMutableArray array]];
        [mateOtherArray addObject:[NSMutableArray array]];
        [mateUserArray addObject:[NSMutableArray array]];
        [dataArray addObject:[NSMutableArray array]];
    }
    
    isHaveMateData = NO;
    table.enableHeader = NO;
    table.enableFooter = NO;
    table.backgroundColor = [UIColor clearColor];
    table.hidden = YES;
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [table registerCells:@{@"UserDTO": [NewMateFriendCell class],@"Pair2DTO": [NewBtnCell class]}];
    
    noDataImage = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"new_image_no_data.png"]];
    noDataImage.hidden = YES;
    [self.view addSubview:noDataImage];
    
    noDataLab = [[UILabel alloc] initWithFrame: CGRectZero];
    noDataLab.backgroundColor = [UIColor clearColor];
    noDataLab.textColor = [ColorUtil getColor:@"767676" alpha:1];
    noDataLab.font = [MedGlobal getMiddleFont];
    noDataLab.numberOfLines = 0;
    noDataLab.hidden = YES;
    noDataLab.text = @"医树中暂时还没发现您的好友哦\n看来您还是来得挺早的\n试试邀请您的医学好友加入\n多邀请，多好礼哦";
    noDataLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview: noDataLab];
    
    moreUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreUserButton.backgroundColor = [ColorUtil getColor:@"365c8a" alpha:1];
    moreUserButton.layer.cornerRadius = 4;
    moreUserButton.layer.masksToBounds = YES;
    moreUserButton.userInteractionEnabled = NO;
    [moreUserButton setTitle:@"邀请好友" forState:UIControlStateNormal];
    moreUserButton.hidden = YES;
    [moreUserButton setTitleColor:[ColorUtil getColor:@"ffffff" alpha:1] forState:UIControlStateNormal];
    [moreUserButton addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreUserButton];
}

/****获取数据库中账号是否已匹配***/
- (void)getCheckMateFriendsInfo:(SuccessBlock)success
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"is_mate_friend"} success:^(id JSON) {
        NSArray *array = [NSArray arrayWithArray:JSON];
        if (array.count > 0) {
            NSMutableDictionary *inviteDict = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:0]];
            BOOL is_mate_friend = [[inviteDict objectForKey:@"is_mate_friend"] boolValue];
            success ([NSNumber numberWithBool:is_mate_friend]);
        } else {
            success ([NSNumber numberWithBool:NO]);
        }
    } failure:^(NSError *error, id JSON) {
        success ([NSNumber numberWithBool:NO]);
    }];
}

/****设置数据库中账号已匹配***/
- (void)setCheckMateFriendsInfo:(NSDictionary *)dict
{
    dispatch_async([MedGlobal getDbQueue], ^{
        DTOBase *dto = [[DTOBase alloc] init:dict];
        [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"is_mate_friend",@"info":dto} success:^(id JSON) {
            
        } failure:^(NSError *error, id JSON) {
            
        }];
    });
}

- (void)loadData:(BOOL)sender
{
    mateTitleLab.hidden = NO;
    mateLab.text = @"为了更好的发现您的医学好友，我们需要\n访问您的通讯录，本次访问仅供“匹配”\n您的人脉所用，敬请您放心。";
    if (self.isDismiss) {
        [FontUtil setBtnTitleFontColor:[UIColor whiteColor]];
        [self createDismissButton];
    } else {
        mateTitleLab.hidden = YES;
        mateLab.text = @"当年和你一起埋头学医的Ta在哪里？\n曾经和你一起并肩工作的Ta在哪里？\n此时默默沉寂在你手机里的Ta在哪里？\n未来和你一起游刃职场的Ta又在哪里？";
        [self createBackButton];
        [self getCheckMateFriendsInfo:^(id JSON) {
            if ([JSON boolValue]) {
//                [self loadData];
                [self clickButton];
                mateButton.hidden = YES;
            }
        }];
    }
    [self viewDidLayoutSubviews];
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToNewInvite) name:MatchFriendOverNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mateUserList) name:@"update_mate_friend_over" object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize size = self.view.frame.size;
    if ([[MedGlobal getPhone] isEqualToString:@"iPhone4"]) {
        mateButton.frame = CGRectMake(15, size.height - 70, size.width - 30, 50);
        mateHeaderImage.frame = CGRectMake((size.width-266)/2, [self getOffset]+44+20, 266, 182);
    } else {
        mateButton.frame = CGRectMake(15, size.height-100, size.width-30, 50);
        mateHeaderImage.frame = CGRectMake((size.width-266)/2, [self getOffset]+44+50, 266, 182);
    }
    
    if (mateLab.text.length > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 10;
        NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle};
        mateLab.attributedText = [[NSAttributedString alloc]initWithString:mateLab.text attributes:attributes];
        mateLab.textAlignment = NSTextAlignmentCenter;
    }
    if (self.isDismiss) {
        mateTitleLab.frame = CGRectMake(0, mateHeaderImage.frame.origin.y+mateHeaderImage.frame.size.height+10, size.width, 30);
        mateLab.frame = CGRectMake(0, mateTitleLab.frame.origin.y+mateTitleLab.frame.size.height+20, size.width, 80);
    } else {
        mateLab.frame = CGRectMake(0, mateHeaderImage.frame.origin.y+mateHeaderImage.frame.size.height+20, size.width, 120);
    }
    
    
    if (moreUserButton.hidden) {
        table.frame = CGRectMake(0, [self getOffset]+44, size.width, size.height-[self getOffset]-44);
    } else {
        table.frame = CGRectMake(0, [self getOffset]+44, size.width, size.height-[self getOffset]-44-60);
    }
    noDataImage.frame = CGRectMake((size.width-272)/2, [self getOffset]+44+20, 272, 188);
    noDataLab.frame = CGRectMake(0, noDataImage.frame.origin.y+noDataImage.frame.size.height+10, size.width, 80);
    moreUserButton.frame = CGRectMake(15, size.height-55, size.width-30, 50);
}

- (void)clickButton
{
    [self getContactsCount:^(id JSON) {
        if ([JSON integerValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [InfoAlertView showInfo:@"通讯录为空，无法进行匹配" inView:self.view duration:1];
            });
        } else {
            mateButton.userInteractionEnabled = NO;
            [self checkContactStats];
        }
    }];
}

- (void)getContactsCount:(SuccessBlock)success
{
    if (&ABAddressBookRequestAccessWithCompletion) {
        // on iOS 6
        CFErrorRef err;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &err);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // ABAddressBook doesn't gaurantee execution of this block on main thread, but we want our callbacks to be
            if (!granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有权限访问通讯录！\n\n如果想联系正在使用“医书”的通讯录好友\n请点击：设置->通用->还原->还原位置与隐私" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    alert.tag = 1001;
                    [alert show];
                });
            } else {
                NSInteger count = ABAddressBookGetPersonCount(addressBook);
                [self setReminderText:count];
                success([NSNumber numberWithInteger:count]);
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            NSInteger count = ABAddressBookGetPersonCount(addressBook);
            [self setReminderText:count];
            success([NSNumber numberWithInteger:count]);
        });
    }
}

- (void)setReminderText:(NSInteger)count
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //        phoneCount = count;
        //        [imageTextView1 setInfo:@{@"showNext":[NSNumber numberWithBool:YES],@"title":[NSString stringWithFormat:@"查看通讯录：%d",count],@"image":@"DegreeInvitePhoneRoundView_add.png",@"tag":[NSNumber numberWithInt:2]}];
        //        [self viewDidLayoutSubviews];
    });
}

- (void)checkContactStats
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [mateButton setTitle:@"正在发现医学好友" forState:UIControlStateNormal];
        mateButton.userInteractionEnabled = NO;
//        [self showLookImagesView];
        
        mateHeaderImage.image = [ImageCenter getBundleImage:@"mate_friend_loading_header.png"];
        [self.view addSubview:mateHeaderImage];
    });
    
    [UserManager checkContactUpdate:^(id JSON) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setCheckMateFriendsInfo:@{@"is_mate_friend":[NSNumber numberWithBool:YES]}];
            
            isGetDate = YES;
            [LoginGetDataHelper getContactData:[NSNumber numberWithInt:0]];
        });
    } failure:^(NSError *error, id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [mateButton setTitle:@"匹配医学好友" forState:UIControlStateNormal];
            mateButton.userInteractionEnabled = YES;
            [LoadingView showProgress:NO inView:self.view];
            [InfoAlertView showInfo:@"匹配失败，请重试" inView:self.view duration:1];
        });
    }];
}

- (void)pushToNewInvite
{
    if (isGetDate) {
        isGetDate = NO;
        [self loadData];
    }
}

- (void)showLookImagesView
{
    mateLab.hidden = YES;
    mateHeaderImage.hidden = YES;
    mateButton.hidden = YES;
}

- (void)hiddenView
{
    table.hidden = NO;
    moreUserButton.hidden = NO;
}

- (void)clickBtn
{
    NewInviteUserController *users = [[NewInviteUserController alloc] init];
    NavigationController *nc = [[NavigationController alloc] initWithRootViewController:users];
    nc.navigationBarHidden = YES;
    [self presentViewController:nc animated:YES completion:^{
        [users setUserList:dataArray];
    }];
}

- (void)loadData
{
    [self getContactInfo];
}

- (void)getContactInfo
{
    if (&ABAddressBookRequestAccessWithCompletion) {
        // on iOS 6
        CFErrorRef err;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &err);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // ABAddressBook doesn't gaurantee execution of this block on main thread, but we want our callbacks to be
            if (!granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有权限访问通讯录！\n\n如果需要打开通讯录权限，请点击：设置->通用->还原->还原位置与隐私" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                });
            } else {
                [self getAllContacts];
            }
        });
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getAllContacts];
        });
    }
}

- (void)getAllContacts
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [LoadingView setOffset:self.view.frame.origin.y/2];
//        [LoadingView showProgress:YES inView:self.view];
    });
    //
    [ContactUtil getAllContacts:YES process:^(id info, NSInteger idx, NSInteger total) {
        ContactInfo *ci = (ContactInfo *)info;
        for (int i=0; i<ci.phones.count; i++) {
            NSString *phone = [ci.phones objectAtIndex:i];
            [ci.phones replaceObjectAtIndex:i withObject:[ContactUtil formatPhone:phone]];
        }
        [ContactUtil addContact:ci sectionArray:sectionArray];
        contactCount++;
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<sectionArray.count; i++) {
            NSMutableArray *array = [NSMutableArray array];
            NSMutableArray *array2 = [sectionArray objectAtIndex:i];
            for (int j=0; j<array2.count; j++) {
                ContactInfo *ci = (ContactInfo *)[array2 objectAtIndex:j];
                [array addObject:[self convertUser:ci]];
            }
            [sectionArray replaceObjectAtIndex:i withObject:array];
        }
        [self mateUserList];
    });
}

- (UserDTO *)convertUser:(ContactInfo *)ci
{
    UserDTO *dto = [[UserDTO alloc] init];
    dto.name = ci.name;
    NSDictionary *dict = @{@"name": ci.name, @"phones": ci.phones};
    [dto parse2:dict];
    //
    NSMutableString *phones = [NSMutableString string];
    for (int i=0; i<ci.phones.count; i++) {
        [phones appendString:[ci.phones objectAtIndex:i]];
        [phones appendString:@" "];
    }
    //
    dto.desc = phones;
    dto.extendData = ci;
    return dto;
}

- (NSArray *)createSectionHeaders:(NSArray *)array
{
    NSMutableArray *headers = [NSMutableArray array];
    for (int i=0; i<ALPHA.length; i++) {
        UIView *view = [[UIImageView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = [[ALPHA substringFromIndex:i] substringToIndex:1];
        label.textColor = [UIColor darkGrayColor];
        label.font = [MedGlobal getTinyLittleFont];
        [view addSubview:label];
        //
        [headers addObject:view];
    }
    return headers;
}

- (NSArray *)createSectionHeights:(NSArray *)array
{
    NSMutableArray *heights = [NSMutableArray array];
    for (int i=0; i<ALPHA.length; i++) {
        if ([[array objectAtIndex:i] count] > 0) {
            [heights addObject:@20];
        } else {
            [heights addObject:@0];
        }
    }
    return heights;
}

- (void)mateUserList
{
    [mateDataArray removeAllObjects];
    [mateOtherArray removeAllObjects];
    [dataArray removeAllObjects];
    [mateUserArray removeAllObjects];
    
    for (int i = 0; i < ALPHA.length; i++) {
        [mateOtherArray addObject:[NSMutableArray array]];
        [mateUserArray addObject:[NSMutableArray array]];
        [dataArray addObject:[NSMutableArray array]];
    }
    
    for (int i = 0; i < [[LoginGetDataHelper mateData] count]; i ++) {
        MateUserDTO *mdto = [[MateUserDTO alloc] init:[[LoginGetDataHelper mateData] objectAtIndex:i]];
        if (mdto.marked_user_id.length > 1) {
            UserDTO *udto = [[UserDTO alloc] init:[mdto.matched_users objectAtIndex:0]];
            udto.sameStatus = mdto.status;
            udto.match_type = mdto.match_type;
            NSMutableString *phones = [NSMutableString string];
            for (int i=0; i<udto.phones.count; i++) {
                [phones appendString:[udto.phones objectAtIndex:i]];
                [phones appendString:@" "];
            }
            udto.desc = phones;
            //
            ContactInfo *ci = [[ContactInfo alloc] init];
            ci.name = udto.name;
            ci.reverse1 = udto.userID;
            NSIndexPath *indexPath = [ContactUtil addContact:ci sectionArray:mateUserArray];
            [[mateUserArray objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:udto];
        }
        [mateDataArray addObject:mdto];
    }
    
    if (mateDataArray.count > 0) {
        for (int i = 0; i < sectionArray.count; i ++) {
            NSMutableArray *array = [sectionArray objectAtIndex:i];
            for (int j = 0; j < [array count]; j ++) {
                //                if (![[array objectAtIndex:j] isKindOfClass:[UserDTO class]]) {
                //                    continue;
                //                }
                UserDTO *dto = [array objectAtIndex:j];
                dto.sameNameNum = 0;
                BOOL isFind = NO;
                for (int k = 0; k < mateDataArray.count; k ++) {
                    MateUserDTO *mdto = [mateDataArray objectAtIndex:k];
                    NSLog(@"%@",mdto.mateID);
                    if (isFind) {
                        break;
                    }
                    if ([mdto.name isEqualToString:dto.name]) {
                        for (int l = 0; l < [mdto.phones_encrypted count]; l ++) {
                            NSString *key = [mdto.phones_encrypted objectAtIndex:l];
                            if (isFind) {
                                break;
                            }
                            for (int m = 0; m < dto.phones.count; m ++) {
                                NSString *phone = [EncodeUtil getMD5ForStr:[dto.phones objectAtIndex:m]];
                                if ([key isEqualToString:phone]) {
                                    isFind = YES;
                                    isHaveMateData = YES;
                                    if (mdto.marked_user_id.length > 1) {
                                        UserDTO *udto = [[UserDTO alloc] init:[mdto.matched_users objectAtIndex:0]];
                                        udto.sameStatus = mdto.status;
                                        udto.phones = [NSMutableArray arrayWithArray:dto.phones];
                                        udto.match_type = mdto.match_type;
                                        [[mateOtherArray objectAtIndex:i] addObject:udto];
                                    } else {
                                        dto.sameNameNum = mdto.same_name_count;
                                        dto.mateID = mdto.mateID;
                                        dto.sameStatus = mdto.status;
                                        dto.match_type = mdto.match_type;
                                        [[mateOtherArray objectAtIndex:i] addObject:dto];
                                    }
                                    break;
                                }
                            }
                        }
                    }
                }
                if (!isFind) {
                    [[dataArray objectAtIndex:i] addObject:dto];
                }
            }
        }
        
        Pair2DTO *pdto = [[Pair2DTO alloc] init:@{}];
        pdto.title = @"邀请好友";
        
        //判断匹配结果和本地通讯录之间是否有交集
        if (isHaveMateData) {
            [table setSectionHeader:[self createSectionHeaders:mateOtherArray]];
            [table setSectionTitleHeight:[self createSectionHeights:mateOtherArray]];
            //
            NSMutableArray *titles = [NSMutableArray array];
            for (int i=0; i<ALPHA.length; i++) {
                [titles addObject:[ALPHA substringWithRange:NSMakeRange(i, 1)]];
            }
            [table setSectionIndexTitles:titles];
            //
//            [mateOtherArray addObject:[NSArray arrayWithObjects:pdto, nil]];
            [table setData:mateOtherArray];
            table.hidden = NO;
            moreUserButton.hidden = NO;
        } else {
            noDataLab.hidden = NO;
            noDataImage.hidden = NO;
            moreUserButton.hidden = NO;
        }
    } else {
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:sectionArray];
        noDataLab.hidden = NO;
        noDataImage.hidden = NO;
        moreUserButton.hidden = NO;
        //现实指定提示试图
    }
    
    mateHeaderImage.hidden = YES;
    mateLab.hidden = YES;
    mateButton.hidden = YES;
    moreUserButton.userInteractionEnabled = YES;
    [LoadingView showProgress:NO inView:self.view];
    
    mateTitleLab.hidden = YES;
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if (self.isDismiss) {
        self.navigationController.delegate = self;
        if ([MedGlobal getSysVer] >= 7.0) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
    NewPersonDetailController *person = [[NewPersonDetailController alloc] init];
    person.userDTO = (UserDTO *)dto;
    person.delegate = self;
    self.parent = self;
    [self.navigationController pushViewController:person animated:YES];
}

- (void)clearUser:(UserDTO *)dto
{
    [LoadingView showProgress:YES inView:self.view];
    [LoginGetDataHelper updateMateData:dto.mateID user:dto overlook:YES];
}

- (void)clickCell:(id)dto action:(NSNumber *)action
{
    if ([action integerValue] == ClickAction_InviteFirend) {
        UserDTO *udto = (UserDTO *)dto;
        if (udto.phones.count == 0) {
            return;
        }
        if (udto.phones.count == 1) {
            [self postInvitewithPhone:[udto.phones objectAtIndex:0]];
        } else {
            NSString *phone1 = nil;
            NSString *phone2 = nil;
            NSString *phone3 = nil;
            [phonesArray removeAllObjects];
            [phonesArray addObjectsFromArray:udto.phones];
            if (udto.phones.count > 2) {
                phone1 = [udto.phones objectAtIndex:0];
                phone2 = [udto.phones objectAtIndex:1];
                phone3 = [udto.phones objectAtIndex:2];
            } else {
                phone1 = [udto.phones objectAtIndex:0];
                phone2 = [udto.phones objectAtIndex:1];
            }
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:phone1,phone2,phone3,nil];
            sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [sheet showInView:self.view];
        }
    } else if ([action integerValue] == ClickAction_MateUser) {
        if (self.isDismiss) {
            self.navigationController.delegate = self;
            if ([MedGlobal getSysVer] >= 7.0) {
                self.navigationController.interactivePopGestureRecognizer.delegate = self;
            }
        }
        MateUserTableController *user = [[MateUserTableController alloc] init];
        //        [self presentViewController:user animated:YES completion:^{
        //            [user setUserInfo:dto];
        //        }];
        [self.navigationController pushViewController:user animated:YES];
        [user setUserInfo:dto];
    } else if ([action integerValue] == ClickAction_FirendAdd) {
        FriendRequestController *request = [[FriendRequestController alloc] init];
        request.dataDict = @{@"type":[NSNumber numberWithInt:MethodType_Controller_Add],@"userID":((UserDTO *)dto).userID};
        request.updateBlock = ^ {
        };
        [self presentViewController:request animated:YES completion:^{
            
        }];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < phonesArray.count) {
        [self postInvitewithPhone:[phonesArray objectAtIndex:buttonIndex]];
    }
}

- (void)postInvitewithPhone:(NSString *)phone
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendSMS:[NSString stringWithFormat:@"我正在用医树，既可以做职业发展还可以管理自己的人脉，你也试试。注册时请在邀请人处填写我的医树号:%@，我们就能加为好友了。下载地址 https://medtree.cn/release/?package=medtree",[[AccountHelper getAccount] userID]] recipientList:[NSArray arrayWithObjects:phone, nil]];
    });
}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]) {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MessageComposeResultCancelled) {
            [InfoAlertView showInfo:@"短信发送已取消！" inView:self.view duration:1];
        } else if (result == MessageComposeResultSent) {
            [InfoAlertView showInfo:@"短信发送成功！" inView:self.view duration:1];
        } else {
            [InfoAlertView showInfo:@"短信发送失败！" inView:self.view duration:1];
        }
    }];
}

#pragma mark -
#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
