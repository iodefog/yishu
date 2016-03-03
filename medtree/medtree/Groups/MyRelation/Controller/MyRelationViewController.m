//
//  MyRelationViewController.m
//  medtree
//
//  Created by tangshimi on 6/2/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MyRelationViewController.h"
#import "PairDTO.h"
#import "MyRelationTableViewCell.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "CognitionPeopleController.h"
#import "AddDegreeController.h"
#import "InfoAlertView.h"
#import "UserManager.h"
#import "RelationCommonViewController.h"
#import "RelationSchoolmateCommonViewController.h"
#import "MyRelationHeaderView.h"
#import "InfoAlertView.h"
#import "NewPersonIdentificationController.h"
#import "ExperienceListController.h"
#import "RelationPeopleViewController.h"
#import "RootViewController.h"
#import "NavigationBarHeadView.h"
#import "MyRelationMayKnowPeopleTableViewCell.h"
#import "UIColor+Colors.h"
#import "EmptyDTO.h"
#import "SectionSpaceTableViewCell.h"
#import "SectionTitleDTO.h"
#import "SectionTitleTableViewCell.h"
#import "FriendFeedViewController.h"
#import "AddDegreeController.h"
#import "CognitionPeopleController.h"
#import "ServiceManager.h"
#import "NewPersonDetailController.h"
#import "FriendRequestController.h"
#import "MyWebCardController.h"
#import "MyRelationGuideView.h"
#import "DegreeManager.h"

typedef enum {
    MyRelationViewControllerSchoolmateNotCertificationJumpType = 1,
    MyRelationViewControllerColleagueNotCertificationJumpType,
    MyRelationViewControllerPeerNotCertificationJumpType,
}MyRelationViewControllerNotCertificationJumpType;

@interface MyRelationViewController () <MyRelationHeaderViewDelegate, BaseTableViewDelegate>

@property (nonatomic, strong) MyRelationHeaderView *headerView;
@property (nonatomic, assign) BOOL firstShow;
@property (nonatomic, strong) NavigationBarHeadView *leftBarItem;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *lookMoreButton;
@property (nonatomic, strong) UIView *mayKnowPeopleView;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *mayKnowPeopleArray;
@property (nonatomic, strong) UIImageView *emptyImageView;

@end

@implementation MyRelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hideNoNetworkImage = YES;

    self.startIndex = 0;
    self.pageSize = 6;
    
    [self loadMyData];
    [self loadTableViewData];
    
    self.firstShow = YES;
    
    [table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.firstShow) {
        if ([BaseGuideView showGuideView:[NSString stringWithUTF8String:object_getClassName([MyRelationGuideView class])]]) {
            [self.headerView showHeaderButtonWithAnimated:NO];
            [MyRelationGuideView showInView:[UIApplication sharedApplication].keyWindow buttonArray:self.headerView.buttonArray];
        } else {
            [self.headerView showHeaderButtonWithAnimated:YES];
        }
        self.firstShow = NO;
    }
}

- (void)createUI
{
    [super createUI];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.mayKnowPeopleArray = [[NSMutableArray alloc] init];
    
    [naviBar setTopTitle:@"人脉"];
    [naviBar setLeftButton:self.leftBarItem];
    [naviBar setRightButton:[NavigationBar createImageButton:@"myrelation_expand_relation.png"
                                                      target:self
                                                      action:@selector(expandRelationButtonAction:)]];
    
    [table setTableHeaderView:self.headerView];
    
    [table setRegisterCells:@{ @"PairDTO" : [MyRelationTableViewCell class],
                               @"EmptyDTO" : [SectionSpaceTableViewCell class],
                               @"SectionTitleDTO" : [SectionTitleTableViewCell class],
                               @"UserDTO" : [MyRelationMayKnowPeopleTableViewCell class] }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(friendListChanged)
                                                 name:FriendListChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accountChanged)
                                                 name:UserInfoChangeNotification
                                               object:nil];
}

#pragma mark -
#pragma mark - response event -

- (void)friendListChanged
{
    [self getMyDataFromNet];
}

- (void)accountChanged
{
    [self getMyDataFromNet];
    [self mayKnowPeopleRequest];
}

- (void)lookMoreButtonAction:(UIButton *)button
{
    CognitionPeopleController *vc = [[CognitionPeopleController alloc] init];
    vc.updateBlock = ^(NSInteger index) {
        if (self.dataArray.count == 3) {
            if (index < [self.dataArray[2] count]) {
                [self mayKnowPeopleRequest];
            }
        }
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)expandRelationButtonAction:(UIButton *)button
{
    [ClickUtil event:@"expandContacts_open" attributes:nil];
    
    AddDegreeController *degree = [[AddDegreeController alloc] init];
    degree.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:degree animated:YES];
}

- (void)loadTableViewData
{
    SectionTitleDTO *titleDTO = [[SectionTitleDTO alloc] init];
    titleDTO.verticalViewColor = [UIColor colorFromHexString:@"#365c8a"];
    titleDTO.title = @"可能认识的人";

    [self.dataArray addObject:@[ titleDTO ]];
    
    [table setData:self.dataArray];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if ([dto isKindOfClass:[PairDTO class]]) {
        if ([[(PairDTO *)dto key] isEqualToString:@"好友动态"]) {
            FriendFeedViewController *vc = [[FriendFeedViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([dto isKindOfClass:[UserDTO class]]) {
        NewPersonDetailController *vc = [[NewPersonDetailController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userDTO = dto;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index action:(NSNumber *)action
{
    FriendRequestController *vc = [[FriendRequestController alloc] init];
    vc.dataDict = @{ @"type" : @(MethodType_Controller_Add), @"userID" : ((UserDTO *)dto).userID };
    vc.updateBlock = ^ {
        [self mayKnowPeopleRequest];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma makr-
#pragma mark - MyRelationHeaderViewDelegate -

- (void)myRelationHeaderViewSelectedType:(MyRelationHeaderViewSelectedType)type isCertificated:(BOOL)isCertificated
{    
    RelationCommonViewControllerType nextGradeType = 0;
    MyRelationViewControllerNotCertificationJumpType certificationJumpType = 0;
    
    switch (type) {
        case MyRelationHeaderViewHeadSelectedType: {
            MyWebCardController *webCard = [[MyWebCardController alloc] init];
            webCard.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webCard animated:YES];
        }
            break;
        case MyRelationHeaderViewColleagueSelectedType:
            if (isCertificated) {
                nextGradeType = RelationCommonViewControllerColleagueHospitalType;
                [ClickUtil event:@"contacts_work_list" attributes:nil];
            } else {
                certificationJumpType = MyRelationViewControllerColleagueNotCertificationJumpType;
            }
            break;
        case MyRelationHeaderViewFriendSelectedType: {
            RelationPeopleViewController *vc = [[RelationPeopleViewController alloc] init];
            vc.type = RelationPeopleViewControllerFriendType;
            vc.params = @{ @"relation_type" : @(1) };
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            [ClickUtil event:@"contacts_friend_list" attributes:nil];
            
            break;
        }
        case MyRelationHeaderViewSchoolmateSelectedType:
            if (isCertificated) {
                nextGradeType = RelationCommonViewControllerSchoolmateSchoolType;
                [ClickUtil event:@"contacts_school_list" attributes:nil];
            } else {
                if (self.headerView.workExperienceCertificated) {
                    if ([AccountHelper getAccount].educationArray.count == 0) {
                        [InfoAlertView showInfo:@"为保证给您提供信息的准确性，请先完善您的教育经历" inView:self.view duration:2];
                        self.view.userInteractionEnabled = NO;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.view.userInteractionEnabled = YES;
                            ExperienceListController *organizationList = [[ExperienceListController alloc] init];
                            organizationList.experienceType = ExperienceType_Edu;
                            [self.navigationController pushViewController:organizationList animated:YES];
                        });
                        return;
                    } else {
                        nextGradeType = RelationCommonViewControllerSchoolmateSchoolType;
                    }
                } else {
                    certificationJumpType = MyRelationViewControllerSchoolmateNotCertificationJumpType;
                }
            }
            break;
        case MyRelationHeaderViewPeerSelectedType:
            if (isCertificated) {
                nextGradeType = RelationCommonViewControllerPeerCityType;
                [ClickUtil event:@"contacts_school_list" attributes:nil];
            } else {
                certificationJumpType = MyRelationViewControllerPeerNotCertificationJumpType;
            }
            break;
        case MyRelationHeaderViewFriendOfFriendSelectedType: {
            [ClickUtil event:@"contacts_friend2_list" attributes:nil];
            nextGradeType = RelationCommonViewControllerFriendOfFriendHospitalType;
            break;
        }
        default:
            break;
    }
    
    if (nextGradeType > 0) {
        RelationCommonViewController *vc = [[RelationCommonViewController alloc] init];
        if (nextGradeType == RelationCommonViewControllerColleagueHospitalType) {
            vc.totalPeopleNumber = [self.headerView peopleNumberWithMyRelationHeaderViewSelectedType:MyRelationHeaderViewColleagueSelectedType];
        }
        vc.type = nextGradeType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (certificationJumpType > 0) {
        [self dealWithNotCertification];
    }
}

- (void)loadHeader:(MedBaseTableView *)table
{
    [self getMyDataFromNet];
    [self mayKnowPeopleRequest];
}

#pragma mark -
#pragma mark - load data -

- (void)loadMyData
{
    [self getDataFromLocal];
    [self getMyDataFromNet];
    
    [self mayKnowPeopleRequestFromLocal];
    [self mayKnowPeopleRequest];
}

#pragma mark -
#pragma mark - network request -

- (void)getMyDataFromNet
{
    [RelationManager getRelationParam:@{ @"method" : @(MethodType_Relation_Status) } success:^(id JSON) {
        if (self.headerView) {
            [self.headerView setRelationStatusDic:JSON[@"result"][@"relation"]];
        }
    } failure:^(NSError *error, id JSON) {
        [self getDataFromLocal];
    }];
}

- (void)getDataFromLocal
{
    [RelationManager getRelationFromLocalParam:@{ @"method" : @(MethodType_Relation_Status) } success:^(id JSON) {
        if (self.headerView) {
            [self.headerView setRelationStatusDic:JSON[@"result"][@"relation"]];
        }
    }];
}

- (void)mayKnowPeopleRequest
{
    NSDictionary *params = @{ @"method" : @(MethodType_DegreeInfo_Suggest),
                              @"from" : @(self.startIndex),
                              @"size" : @(self.pageSize) };
    
    [ServiceManager getData:params success:^(id JSON) {
        [self stopLoading];
        
        NSArray *array = JSON;
        if (self.dataArray.count > 1 && self.dataArray.count == 2 ) {
            [self.dataArray removeLastObject];
        }
        
        if (array.count > 0) {
            [self.dataArray addObjectsFromArray:@[ array ]];
            
            [table setData:self.dataArray];
            
            [table setTableFooterView:self.lookMoreButton];
        } else {
            [table setData:self.dataArray];
            
            [table setTableFooterView:self.emptyImageView];
        }
    } failure:^(NSError *error, id JSON) {
        [self stopLoading];

        [table setTableFooterView:self.emptyImageView];
    }];
}

- (void)mayKnowPeopleRequestFromLocal
{
    NSDictionary *params = @{ @"method" : @(MethodType_DegreeInfo_Suggest),
                              @"from" : @(self.startIndex),
                              @"size" : @(self.pageSize) };
    
    [DegreeManager getSuggestFromLocal:params success:^(id JSON) {
        if (!JSON) {
            return;
        }
        
        [self stopLoading];
        
        NSArray *array = JSON;
        if (self.dataArray.count > 1 && self.dataArray.count == 2 ) {
            [self.dataArray removeLastObject];
        }
        
        if (array.count > 0) {
            [self.dataArray addObjectsFromArray:@[ array ]];
            
            [table setData:self.dataArray];
            
            [table setTableFooterView:self.lookMoreButton];
        } else {
            [table setData:self.dataArray];
            
            [table setTableFooterView:self.emptyImageView];
        }
    }];
}

#pragma mark -
#pragma mark - helper -

- (void)dealWithNotCertification
{
    [InfoAlertView showInfo:@"为保证用户身份的真实可靠，请认证身份后查看" inView:self.view duration:2];
    self.view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = YES;
        NewPersonIdentificationController *identification = [[NewPersonIdentificationController alloc] init];
        [self.navigationController pushViewController:identification animated:YES];
        [identification loadData];
    });
}

#pragma makr -
#pragma mark - setter and getter -

- (MyRelationHeaderView *)headerView
{
    if (!_headerView) {
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        
        MyRelationHeaderView *headerView = [[MyRelationHeaderView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      width,
                                                                      width > 320 ? width - 120 : 260)];
        headerView.delegate = self;
        _headerView = headerView;
    }
    return _headerView;
}

- (NavigationBarHeadView *)leftBarItem
{
    if (!_leftBarItem) {
        _leftBarItem = ({
            NavigationBarHeadView *headView = [[NavigationBarHeadView alloc] init];
            headView.clickBlock = ^{
                [[RootViewController shareRootViewController] showLeftSideMenuViewController];
            };
            headView;
        });
    }
    return _leftBarItem;
}

- (UIButton *)lookMoreButton
{
    if (!_lookMoreButton) {
        _lookMoreButton = ({
            UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor whiteColor];
            button.frame = CGRectMake(0, 0, GetViewWidth(self.view), 40);
            [button setTitle:@"查看更多" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button addTarget:self action:@selector(lookMoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _lookMoreButton;
}

- (UIImageView *)emptyImageView
{
    if (!_emptyImageView) {
        _emptyImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = GetImage(@"relation_friend_recommend_empty.png");
            imageView.frame = CGRectMake(0, 40, GetViewWidth(self.view), imageView.image.size.height);
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.cornerRadius = 3.0;
            button.layer.masksToBounds = YES;
            [button setTitle:@"去拓展人脉" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [button setBackgroundColor:[UIColor colorFromHexString:@"#365c8a"]];
            [button addTarget:self action:@selector(expandRelationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake((GetScreenWidth - 110) / 2.0, CGRectGetMaxY(imageView.frame) + 10, 110, 35);
            
            UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GetViewWidth(self.view), imageView.image.size.height + 100)];
            view.userInteractionEnabled = YES;
            [view addSubview:imageView];
            [view addSubview:button];
            
            view;
        });
    }
    return _emptyImageView;
}

@end
