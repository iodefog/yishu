//
//  NearPeopleController.m
//  medtree
//
//  Created by 无忧 on 14-11-13.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "NearPeopleController.h"
#import "NearPeopleCell.h"
#import "UserManager.h"
#import "LoadingView.h"
#import "PersonCell.h"
#import "CoreLocation/CoreLocation.h"
#import "UserDTO.h"
#import <BaiduMapAPI/BMKLocationService.h>
#import "NewPersonDetailController.h"
#import "ColorUtil.h"
#import "RelationSearchViewController.h"

@interface NearPeopleController ()<BMKLocationServiceDelegate, CLLocationManagerDelegate>
{
    BMKLocationService *location;
    double              latitude;
    double              longitude;
    NSMutableArray      *dataArray;
    UILabel             *titleLab;
    NSInteger           startIndex;
}

@end

@implementation NearPeopleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchBar removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (location) {
        location.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (location) {
        location.delegate = nil;
        [location stopUserLocationService];
    }
}

- (void)createUI
{
    [super createUI];
    startIndex = 0;
    
    [naviBar setTopTitle:@"雷达加好友"];
    
    dataArray = [[NSMutableArray alloc] init];
    
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    [table registerCell:[NearPeopleCell class]];
    
    if([CLLocationManager locationServicesEnabled]) {
        location = [[BMKLocationService alloc] init];
        location.delegate = self;
        [location startUserLocationService];
    }else {
        NSString *prompt = @"定位服务未开启，附近的人功能无法正常使用，请通过手机系统的设置->定位服务，开启医树定位服务。";
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:prompt message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alter show];
        //提示用户无法进行定位操作
    }
    titleLab = [[UILabel alloc] init];
    titleLab.text = @"下拉刷新查看附近同时打开雷达加好友的人";
    titleLab.hidden = YES;
    titleLab.numberOfLines = 0;
    titleLab.textColor = [ColorUtil getColor:@"363636" alpha:1];
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
}

- (void)setRightBarView
{
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    CGSize size = self.view.frame.size;
    titleLab.frame = CGRectMake(20, size.height*0.38, size.width-40, 60);
    table.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(naviBar.frame));
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [location stopUserLocationService];
    latitude = userLocation.location.coordinate.latitude;
    longitude = userLocation.location.coordinate.longitude;
    
    NSLog(@"latitude%f longitude%f",latitude,longitude);
    [self getRequest];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
//    [location stopUserLocationService];
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [location stopUserLocationService];
    [location startUserLocationService];
    NSLog(@"location error");
}

- (void)getRequest
{
    NSDictionary *param = @{@"method": [NSNumber numberWithInteger:MethodType_DiscoveryPeopleNear],
                            @"from": @(startIndex),
                            @"size": [NSNumber numberWithInteger:200],
                            @"longitude":[NSNumber numberWithDouble:longitude],
                            @"latitude":[NSNumber numberWithDouble:latitude] };
    
    [ServiceManager setData:param success:^(id JSON) {
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:JSON];
        if (startIndex == 0) {
            [dataArray removeAllObjects];
        }
        if (array.count > 0) {
            [dataArray addObjectsFromArray:array];
            [table setData:[NSArray arrayWithObjects:dataArray,nil]];
        }
        titleLab.hidden = dataArray.count>0;
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (NSDictionary *)getParam_FromLocal
{
    return nil;
}

- (NSDictionary *)getParam_FromNet
{
    return nil;
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    NewPersonDetailController *detail = [[NewPersonDetailController alloc] init];
    detail.delegate = self;
    [self.navigationController pushViewController:detail animated:YES];
    detail.userId = ((UserDTO *)dto).userID;
    detail.parent = self;
}

- (void)loadHeader:(BaseTableView *)table
{
    startIndex = 0;
    [location startUserLocationService];
}

- (void)loadFooter:(BaseTableView *)table
{
    [self getRequest];
}

@end
