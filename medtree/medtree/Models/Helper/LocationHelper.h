//
//  LocationHelper.h
//  tennis
//
//  Created by lyuan on 13-6-23.
//  Copyright (c) 2013年 lyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>

@interface LocationHelper : NSObject <BMKMapViewDelegate, UIAlertViewDelegate>
{
    BMKMapView          *mapView;//地图
    NSString            *gpsCity;//通过GPS定位的城市
    BOOL                isLoadSites;
}

+ (id)shareInstance;
- (void)startLocation:(id)delegete;

+ (void)setCityName:(NSString *)name;
+ (CLLocationCoordinate2D)getCoordinate;
+ (NSString *)getGPSCityName;
+ (NSString *)getCityName;
+ (NSInteger)getCityID;

@property (nonatomic, assign) CLLocationCoordinate2D coordinage;
@property (nonatomic, strong) NSString  *cityName;
@property (nonatomic, assign) NSInteger cityID;
@property (nonatomic, assign) id parent;

@end
