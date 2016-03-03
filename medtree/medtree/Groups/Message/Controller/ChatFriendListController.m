//
//  ChatFriendListController.m
//  medtree
//
//  Created by sam on 10/16/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "ChatFriendListController.h"
#import "ImageCenter.h"
#import "FontUtil.h"
#import "ColorUtil.h"
#import "MessageController.h"
#import "RelationManager.h"
#import <InfoAlertView.h>
#import "StatusView.h"

@interface ChatFriendListController ()

@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) StatusView *statusView;

@end

@implementation ChatFriendListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBackButton];
    
    table.sectionIndexBackgroundColor = [UIColor clearColor];
    table.sectionIndexColor = [ColorUtil getColor:@"8a8a8a" alpha:1.0];
    
    self.pageSize = 10;
    
    [self getDataFromLocal];
    [self getDataFromNet];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)createUI
{
    [super createUI];
}

- (void)setRightBarView
{
    
}

- (void)clickBackButton
{
    
}

- (void)getDataFromNet
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(MethodType_Relation_result) forKey:@"method"];
    [param setObject:@(self.startIndex) forKey:@"from"];
    [param setObject:@(self.pageSize) forKey:@"size"];
    [param setObject:@1 forKeyedSubscript:@"relation_type"];
    
    [RelationManager getRelationParam:param success:^(id JSON) {
        [self handleRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)getDataFromLocal
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(MethodType_Relation_result) forKey:@"method"];
    [param setObject:@(self.startIndex) forKey:@"from"];
    [param setObject:@(self.pageSize) forKey:@"size"];
    [param setObject:@1 forKeyedSubscript:@"relation_type"];
    
    [RelationManager getRelationFromLocalParam:param success:^(id JSON) {
        [self handleLocalRequest:JSON];
    }];
}

- (void)handleRequest:(id)JSON
{
    if ([[JSON objectForKey:@"success"] integerValue] != kRequestSuccessCode) {
        [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:2];
        return;
    }
    
    NSArray *peopleArray = [JSON objectForKey:@"people"];
    
    if (peopleArray.count == 0) {
        self.statusView.statusType = StatusViewEmptyStatusType;
    } else {
        [self.statusView hide];
    }
    
    table.enableFooter = (peopleArray.count >= self.pageSize);
    
    if (self.startIndex == 0) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:peopleArray];
    
    self.startIndex += peopleArray.count;
    
    [table setData:@[ self.dataArray ]];
}

- (void)handleLocalRequest:(id)JSON
{
    NSArray *peopleArray = [JSON objectForKey:@"people"];
    
    if (peopleArray.count == 0) {
        self.statusView.statusType = StatusViewEmptyStatusType;
    } else {
        [self.statusView hide];
    }
    
    if (peopleArray.count == 0) {
        return ;
    }
    
    table.enableFooter = NO;
    
    [table setData:@[ peopleArray ]];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    MessageController *vc = [[MessageController alloc] init];
    vc.target = dto;
    [self.navigationController pushViewController:vc animated:YES];
    if (self.shareInfo.length > 0) {
        [vc setInputMessage:self.shareInfo];
    }
}

- (void)loadHeader:(BaseTableView *)table
{
    self.startIndex = 0;
    [self getDataFromNet];
}

- (void)loadFooter:(BaseTableView *)table
{
    [self getDataFromNet];
}

#pragma mark - Setter & getter
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (StatusView *)statusView
{
    if (!_statusView) {
        StatusView *view = [[StatusView alloc] initWithInView:self.view];
        view.removeFromSuperViewWhenHide = YES;
        _statusView = view;
    }
    return _statusView;
}

@end
