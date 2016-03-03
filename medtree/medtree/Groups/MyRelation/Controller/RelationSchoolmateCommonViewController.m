//
//  RelationSchoolmateCommonViewController.m
//  medtree
//
//  Created by tangshimi on 6/11/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "RelationSchoolmateCommonViewController.h"
#import "HorizontalScrollTabView.h"
#import "RelationCommonViewController.h"
#import "RelationPeopleViewController.h"
#import "UIColor+Colors.h"
#import "ImageCenter.h"

@interface RelationSchoolmateCommonViewController () <HorizontalScrollTabViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong)HorizontalScrollTabView *horizontalTabView;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)NSMutableArray *viewsArray;
@property (nonatomic, strong)NSDictionary *dictInfo;
@property (nonatomic, assign)BOOL isShouldLayout;
@property (nonatomic, strong)UIButton *leftBackButton;

@end

@implementation RelationSchoolmateCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hideNoNetworkImage = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentIndex = 0;
    self.isShouldLayout = YES;
    self.viewsArray = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < self.horizontalTabView.items.count; i ++) {
        [self.viewsArray addObject:[NSNull null]];
    }
    
    self.horizontalTabView.frame = CGRectMake(40, 20, GetScreenWidth - 80, 42);

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 3) {
        [naviBar setLeftButton:self.leftBackButton];
    }
}

- (void)dealloc
{
    
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setTopView:self.horizontalTabView];
    [self.view addSubview:self.scrollView];
    
    [self createBackButton];
}

- (void)viewDidLayoutSubviews
{
    if (!self.isShouldLayout) {
        return;
    }
    
    [super viewDidLayoutSubviews];
    
    self.isShouldLayout = NO;
    
    self.scrollView.frame = CGRectMake(0,
                                       CGRectGetMaxY(naviBar.frame),
                                       CGRectGetWidth(self.view.frame),
                                       CGRectGetHeight(self.view.frame) - 64);
    NSInteger pageNumer = 2;
    if (self.type == RelationSchoolmateCommonViewControllerSchoolType) {
        pageNumer = 1;
    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * pageNumer,
                                             CGRectGetHeight(self.scrollView.frame));
    
    if (self.viewsArray[self.selectedIndex] == [NSNull null]) {
        [self.scrollView addSubview:[self viewController:self.selectedIndex].view];
        self.scrollView.contentOffset = CGPointMake(self.selectedIndex * CGRectGetWidth(self.view.frame), 0);
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate -

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    if (index == self.currentIndex) {
        return;
    }
    
    self.currentIndex = index;
    [self.horizontalTabView setSelectedItemIndex:index];
    
    if (self.viewsArray[index] == [NSNull null]) {
        [self.scrollView addSubview:[self viewController:index].view];
    }
}

#pragma mark -
#pragma mark - HorizontalScrollTabViewDelegate -

- (BOOL)horizontalScrollTabViewItemShouldClick:(NSInteger)selectedIndex
{
    return YES;
}

- (void)horizontalScrollTabViewItemDidClick:(NSInteger)selectedIndex
{
    if (self.type != RelationSchoolmateCommonViewControllerSchoolType) {
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame) * selectedIndex, 0);
        
        if (self.viewsArray[selectedIndex] == [NSNull null]) {
            [self.scrollView addSubview:[self viewController:selectedIndex].view];
        }
    } else {
        RelationCommonViewController *vc = self.viewsArray[0];
        if (selectedIndex == 0) {
            vc.type = RelationCommonViewControllerClassmateSchoolType;
            self.selectedIndex = 0;
        } else if (selectedIndex == 1) {
            vc.type = RelationCommonViewControllerSchoolmateSchoolType;
            self.selectedIndex = 1;
        }
    }
}

#pragma mark -
#pragma mark - response event -

- (void)handlePanGustureAction:(UIPanGestureRecognizer *)panGesture
{
//    if (self.scrollView.contentOffset.x <= 0) {
//        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
}

- (void)leftBackButtonAction:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark - helper -

- (UIViewController *)viewController:(NSInteger)index
{
    if (index > self.horizontalTabView.items.count - 1) {
        return nil;
    }
    
    if (self.viewsArray[index] != [NSNull null]) {
        return self.viewsArray[index];
    }
    
    UIViewController *vc = nil;
    if (index == 0) {
        vc = [self classmateSelectTypeViewController];
    } else {
        vc = [self schoolmateSelectTypeViewController];
    }
    
    vc.view.frame = CGRectMake(index * CGRectGetWidth(self.scrollView.frame),
                               0,
                               CGRectGetWidth(self.scrollView.frame),
                               CGRectGetHeight(self.scrollView.frame));
    [self addChildViewController:vc];
    
    [self.viewsArray replaceObjectAtIndex:index withObject:vc];
    
    return vc;
}

- (BOOL)isRelationSchoolmateCommonViewControllerSchoolType
{
    if (self.type == RelationSchoolmateCommonViewControllerSchoolType) {
        return YES;
    } else {
        return NO;
    }
}

- (UIViewController *)classmateSelectTypeViewController
{
    if ([self isRelationSchoolmateCommonViewControllerSchoolType]) {
        RelationCommonViewController *vc = [[RelationCommonViewController alloc] init];
        vc.type = RelationCommonViewControllerClassmateSchoolType;
        return vc;
    } else {
        RelationPeopleViewController *vc = [[RelationPeopleViewController alloc] init];
        vc.type = RelationPeopleViewControllerClassmateType;
        vc.params = self.params;
        return vc;
    }
}

- (UIViewController *)schoolmateSelectTypeViewController
{
    if (self.type == RelationSchoolmateCommonViewControllerSchoolmatePeopleType) {
        RelationPeopleViewController *vc = [[RelationPeopleViewController alloc] init];
        vc.type = RelationPeopleViewControllerSchoolmateType;
        return vc;
    } else {
        RelationCommonViewControllerType type;
        
        switch (self.type) {
            case RelationSchoolmateCommonViewControllerSchoolmateGradeType:
                type = RelationCommonViewControllerSchoolmateGradeType;
                break;
            case RelationSchoolmateCommonViewControllerSchoolmateAcademicYearType:
                type = RelationCommonViewControllerSchoolmateAcademicYearType;
                break;
            case RelationSchoolmateCommonViewControllerSchoolmateMajorType:
                type = RelationCommonViewControllerSchoolmateMajorType;
                break;
            case RelationSchoolmateCommonViewControllerClassmatePeopleType:
                type = RelationCommonViewControllerSchoolmateGradeType;
                break;
            default:
                break;
        }
        
        RelationCommonViewController *vc = [[RelationCommonViewController alloc] init];
        vc.type = type;
        vc.totalPeopleNumber = (type == RelationCommonViewControllerSchoolmateGradeType) ? self.totalPeopleNumber : 0;
        vc.params = self.params;
        return vc;
    }
}

#pragma mark -
#pragma mark - setter and getter -

- (HorizontalScrollTabView *)horizontalTabView
{
    if (!_horizontalTabView) {
        HorizontalScrollTabView *tabView = [[HorizontalScrollTabView alloc] initWithFrame:CGRectZero];
        tabView.delegate = self;
        tabView.selectedItemColor = [UIColor whiteColor];
        tabView.unSelectedItemColor = [UIColor lightGrayColor];
        tabView.itemFont = [UIFont systemFontOfSize:18];
        tabView.minItemWidth = 82.5;
        tabView.itemSpace = 50;
        tabView.edgeSpace = 20;
        tabView.showBottomLine = YES;
        tabView.bottomLineColor = [UIColor colorFromHexString:@"#159fd9"];
        [tabView setSelectedItemIndex:0];
        tabView.items = @[ @"同学", @"校友" ];
        
        _horizontalTabView = tabView;
    }
    return _horizontalTabView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.bounces = NO;
        [scrollView.panGestureRecognizer addTarget:self action:@selector(handlePanGustureAction:)];
        
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIButton *)leftBackButton
{
    if (!_leftBackButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        button.frame = CGRectMake(0, 0, 80, 44);
        [button addTarget:self action:@selector(leftBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftBackButton = button;
    }
    return _leftBackButton;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    self.horizontalTabView.selectedItemIndex = selectedIndex;
}

@end
