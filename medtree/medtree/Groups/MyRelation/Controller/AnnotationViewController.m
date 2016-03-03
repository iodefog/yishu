//
//  AnnotationViewController.m
//  medtree
//
//  Created by tangshimi on 6/14/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "AnnotationViewController.h"
#import <BaiduMapAPI/BMKMapView.h>
#import <BaiduMapAPI/BMKPointAnnotation.h>
#import "AnnotationView.h"
#import "ImageCenter.h"
#import "RelationLocationDTO.h"
#import "RelationCommonViewController.h"

NSInteger const kMaxAnnotationNumber = 100;

@interface AnnotationViewController () <BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;

@end

@implementation AnnotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hideNoNetworkImage = YES;
    
    [self.view addSubview:self.mapView];
    
    self.mapView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"地图"];
    [self createBackButton];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)dealloc {
    if (self.mapView) {
        self.mapView = nil;
    }
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

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    RelationCommonViewController *vc = [[RelationCommonViewController alloc] init];
    vc.type = RelationCommonViewControllerMapFirstGradeDepartmentType;
    vc.params = @{ @"relation_type" : self.param[@"relation_type"], @"facet" : @"first_dept_name", @"org_name" : view.annotation.title };
    [vc setTopTitle:view.annotation.title];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - response event -

- (void)backButtonAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - setter and getter -

- (BMKMapView *)mapView
{
    if (!_mapView) {
        BMKMapView *mapView = [[BMKMapView alloc] init];
        mapView.mapType = BMKMapTypeStandard;
        mapView.delegate = self;
        [mapView setMaxZoomLevel:14];
        _mapView = mapView;
    }
    return _mapView;
}

- (void)setAnnotation:(NSArray *)annotation
{
    if (!annotation) {
        return;
    }
    
    [annotation enumerateObjectsUsingBlock:^(RelationLocationDTO *dto, NSUInteger idx, BOOL *stop) {
        if (idx > kMaxAnnotationNumber - 1) {
            return;
        }
        BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = dto.latitude;
        coor.longitude = dto.longitude;
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = dto.name;
        [self.mapView addAnnotation:pointAnnotation];
    }];
}

@end
