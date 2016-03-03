//
//  HomeJobChannelEnterpriseViewController.m
//  medtree
//
//  Created by tangshimi on 11/10/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelEnterpriseMapViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "AnnotationView.h"

@interface HomeJobChannelEnterpriseMapViewController () <BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *enterpriseNameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;

@end

@implementation HomeJobChannelEnterpriseMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.enterpriseNameLabel];
    [self.bottomView addSubview:self.addressLabel];
    [self.bottomView addSubview:self.mapButton];
    
    self.mapView.frame = CGRectMake(0, 0, GetScreenWidth, GetScreenHeight - 100);
    
    [self.backButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(0);
        make.size.equalTo(CGSizeMake(50, 40));
    }];
    
    [self.bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    
    [self.enterpriseNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(8);
        make.top.equalTo(8);
    }];
    
    [self.addressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.enterpriseNameLabel.bottom).offset(5);
        make.left.equalTo(8);
    }];
    
    [self.mapButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-8);
        make.centerX.equalTo(0);
        make.width.equalTo(100);
    }];
    
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    param.isAccuracyCircleShow = YES;
    param.isRotateAngleValid = YES;
    [self.mapView updateLocationViewWithParam:param];
    
    [self.locationService startUserLocationService];
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层
        
    BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = self.latitude;
    coor.longitude = self.longitude;
    pointAnnotation.coordinate = coor;
    pointAnnotation.title = self.enterpriseName;
    [self.mapView addAnnotation:pointAnnotation];
    
    BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:BMKCoordinateRegionMake( (CLLocationCoordinate2D){self.latitude, self.longitude  }, BMKCoordinateSpanMake(0.05, 0.05))];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    self.enterpriseNameLabel.text = self.enterpriseName;;

    [self getAddress];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.locationService.delegate = self;
    self.geoCodeSearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.locationService.delegate = nil;
    self.geoCodeSearch.delegate = nil;
}

- (void)dealloc {
    if (self.mapView) {
        self.mapView = nil;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark - BMKLocationServiceDelegate -

- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
    
    self.currentLocation = userLocation.location.coordinate;
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
}

#pragma mark -
#pragma mark - BMKMapViewDelegate -

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"myAnnotationView";
    AnnotationView *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[AnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    return annotationView;
}

#pragma mark -
#pragma mark - BMKGeoCodeSearchDelegate -

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    self.addressLabel.text = result.address;
}

#pragma mark -
#pragma mark - response event -

- (void)backButtonAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mapButtonAction:(UIButton *)button
{
    BMKOpenDrivingRouteOption *opt = [[BMKOpenDrivingRouteOption alloc] init];
    opt.appScheme = @"medtree://medtree";

    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
    start.pt = self.currentLocation;
    opt.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D coor2;
    coor2.latitude = self.latitude;
    coor2.longitude = self.longitude;
    end.pt = coor2;
    //指定终点名称
    end.name = self.enterpriseName;
    
    opt.endPoint = end;
    BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapDrivingRoute:opt];
}

- (void)getAddress
{
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){ self.latitude, self.longitude };
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag) {
        NSLog(@"反geo检索发送成功");
    } else {
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark -
#pragma mark - setter and getter -

- (BMKMapView *)mapView
{
    if (!_mapView) {
        BMKMapView *mapView = [[BMKMapView alloc] init];
        mapView.mapType = BMKMapTypeStandard;
       // mapView.delegate = self;
        _mapView = mapView;
    }
    return _mapView;
}

- (BMKLocationService *)locationService
{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc] init];
    }
    return _locationService;
}

- (BMKGeoCodeSearch *)geoCodeSearch
{
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    }
    return _geoCodeSearch;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            [button setImage:GetImage(@"btn_back.png") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _backButton;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView  = ({
            UIView *view = [[UIView alloc] init];
            view.userInteractionEnabled = YES;
            view.backgroundColor = [UIColor whiteColor];
            
            view;
        });
    }
    return _bottomView;
}

- (UILabel *)enterpriseNameLabel
{
    if (!_enterpriseNameLabel) {
        _enterpriseNameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:15];
            label;
        });
    }
    return _enterpriseNameLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel =  ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:13];
            label;
        });
    }
    return _addressLabel;
}

- (UIButton *)mapButton
{
    if (!_mapButton) {
        _mapButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"地图导航" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(mapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 5.0;
            button.clipsToBounds = YES;
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor blueColor].CGColor;
            button;
        });
    }
    return _mapButton;
}

@end
