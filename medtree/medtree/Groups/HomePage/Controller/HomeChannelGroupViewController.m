//
//  HomeChannelGroupViewController.m
//  medtree
//
//  Created by tangshimi on 8/19/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeChannelGroupViewController.h"
#import "SectionTitleDTO.h"
#import "SectionTitleTableViewCell.h"
#import "HomeChannelGroupDTO.h"
#import "HomeChannelGroupTableViewCell.h"
#import "EmptyDTO.h"
#import "SectionSpaceTableViewCell.h"
#import "UIColor+Colors.h"

@interface HomeChannelGroupViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HomeChannelGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    table.frame = self.view.bounds;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerCells:@{ @"EmptyDTO" : [SectionSpaceTableViewCell class],
                           @"SectionTitleDTO" : [SectionTitleTableViewCell class],
                           @"HomeChannelGroupDTO" : [HomeChannelGroupTableViewCell class] }];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self loadData];
}

- (void)createUI
{
    [super createUI];
    
    naviBar.hidden = YES;
    statusBar.hidden = YES;
}

- (void)viewDidLayoutSubviews
{

}

- (void)loadData
{
    EmptyDTO *dto1 = [[EmptyDTO alloc] init];
    SectionTitleDTO *titleDTo = [[SectionTitleDTO alloc] init];
    titleDTo.verticalViewColor = [UIColor colorFromHexString:@"#365c8a"];
    titleDTo.title = @"我的群组";
    HomeChannelGroupDTO *groupDto = [[HomeChannelGroupDTO alloc] init];
    HomeChannelGroupDTO *groupDto1 = [[HomeChannelGroupDTO alloc] init];
    HomeChannelGroupDTO *groupDto2 = [[HomeChannelGroupDTO alloc] init];
    EmptyDTO *dto2 = [[EmptyDTO alloc] init];
    
    [self.dataArray addObject:@[ dto1, titleDTo, groupDto, groupDto1, groupDto2, dto2 ]];
    
    
    EmptyDTO *dto3 = [[EmptyDTO alloc] init];
    SectionTitleDTO *titleDTo1 = [[SectionTitleDTO alloc] init];
    titleDTo1.title = @"全部群组";
    titleDTo1.verticalViewColor = [UIColor colorFromHexString:@"#365c8a"];

    HomeChannelGroupDTO *groupDto3 = [[HomeChannelGroupDTO alloc] init];
    HomeChannelGroupDTO *groupDto4 = [[HomeChannelGroupDTO alloc] init];
    HomeChannelGroupDTO *groupDto5 = [[HomeChannelGroupDTO alloc] init];
    EmptyDTO *dto4 = [[EmptyDTO alloc] init];
    [self.dataArray addObject:@[ dto3, titleDTo1, groupDto3, groupDto4, groupDto5, dto4 ]];
    
    [table setData:self.dataArray];
}

@end
