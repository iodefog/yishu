//
//  LocationHelper.m
//  tennis
//
//  Created by lyuan on 13-6-23.
//  Copyright (c) 2013年 lyuan. All rights reserved.
//

#import "LocationHelper.h"

@implementation LocationHelper

@synthesize coordinage;
@synthesize cityName;
@synthesize cityID;
@synthesize parent;

- (void)initLocationManager
{
    mapView = [[BMKMapView alloc] init];
    mapView.delegate = self;
    //
}

- (void)startLocation:(id)delegete
{
    isLoadSites = NO;
    parent = delegete;
    
    //showsUserLocation为YES则每隔一段时间都会定位一次,定位成功调用didUpdateUserLocation获取用户的经纬度。
    mapView.showsUserLocation = (delegete != nil);
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    
}

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation != nil) {
        //打印当前用户位置
        NSLog(@"userLocation=%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        //反向解析地理位置
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
        pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude};
        
        //根据经纬度获取街道信息
         NSLog(@"search address faile");
    }
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied) {
        //第一次安装含有定位功能的软件时
        //程序将自定提示用户是否让当前App打开定位功能，
        //如果这里选择不打开定位功能，
        //再次调用定位的方法将会失败，并且进到这里。
        //除非用户在设置页面中重新对该软件打开定位服务，
        //否则程序将一直进到这里。
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务已经关闭" message:@"请您在设置页面中打开本软件的定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 1001;
        [alert show];
    } else if ([error code] == kCLErrorHeadingFailure) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"您是否继续定位，以便获取您周围场馆信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1002;
        [alert show];
    }
}

//BMKSearch代理
/**
 *返回地址信息搜索结果
 *@param result 搜索结果
 *@param error 错误号，@see BMKErrorCode
 */
//- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo*)result errorCode:(int)error
//{
//    if (error == kCLErrorLocationUnknown) {
//        //不需要总是不停的定位:定位成功－则关闭定位。
//        mapView.showsUserLocation = NO;
//        
//        //查询地址成功
//        NSLog(@"完整的位置信息:%@街道号:%@\n街道名称:%@\n区域:%@\n城市:%@\n省份:%@",
//              result.strAddr,
//              result.addressComponent.streetNumber,
//              result.addressComponent.streetName,
//              result.addressComponent.district,
//              result.addressComponent.city,
//              result.addressComponent.province);
//        //
//        gpsCity = result.addressComponent.city;
//        [self setCityName:gpsCity];
//        //
//        if (isLoadSites == NO) {
//            isLoadSites = YES;
//            if (parent && [parent respondsToSelector:@selector(loadData)]) {
//                [parent performSelector:@selector(loadData)];
//                parent = nil;
//            }
//        }
//    }
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1002 && buttonIndex == 1) {
        [self startLocation:parent];
    }
}

/********/
+ (CLLocationCoordinate2D)getCoordinate
{
    return [[LocationHelper shareInstance] getCoordinage];
}

+ (void)setCityWithID:(NSInteger)cityID
{
//    [[LocationHelper shareInstance] setCityID:cityID];
}

+ (NSString *)getGPSCityName
{
    return [[LocationHelper shareInstance] getGPSCity];
}

+ (NSString *)getCityName
{
    return [[LocationHelper shareInstance] getCityName];
}

+ (NSInteger)getCityID
{
    return [[LocationHelper shareInstance] getCityID];
}

+ (void)setCityName:(NSString *)name
{
    [[LocationHelper shareInstance] setCityName:name];
}

+ (id)shareInstance
{
    static LocationHelper *instance;
    if (!instance) {
        instance = [[LocationHelper alloc] init];
        [instance initLocationManager];
//        instance.cityID = [[[CityTypes sharedInstance] getDefault] value];
    }
    return instance;
}

- (void)setCoordinage:(CLLocationCoordinate2D)coord
{
    coordinage = coord;
}

- (void)setCityName:(NSString *)name
{
    cityName = name;
//    cityID = [[[CityTypes sharedInstance] getName:cityName] value];
}

- (void)setCityID:(NSInteger)ID
{
    cityID = ID;
//    cityName = [[[CityTypes sharedInstance] getType:cityID] name];
}

- (CLLocationCoordinate2D)getCoordinage
{
    return coordinage;
}

- (NSString *)getGPSCity
{
    return gpsCity;
}

- (NSString *)getCityName
{
    return cityName;
}

- (NSInteger)getCityID
{
    return cityID;
}

@end
