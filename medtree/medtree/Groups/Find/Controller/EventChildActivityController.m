//
//  EventChildActivityController.m
//  medtree
//
//  Created by 边大朋 on 15-4-13.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "EventChildActivityController.h"
#import "ImagePairCell.h"
#import "EventDTO.h"
#import "PairDTO.h"
#import "CommonWebController.h"
#import "StatusView.h"

@interface EventChildActivityController ()

@end

@implementation EventChildActivityController

- (void)viewDidLoad {
    [super viewDidLoad];

    [naviBar setTopTitle:self.eventDTO.title];
    
    NSMutableArray *cellNames = [NSMutableArray array];
    NSMutableArray *iconArray = [NSMutableArray array];
    NSMutableArray *heightArray = [NSMutableArray array];
    if (self.eventDTO.links.count > 0) {
        for (int i = 0; i < self.eventDTO.links.count; i ++) {
            NSDictionary *dict = [self.eventDTO.links objectAtIndex:i];
            [cellNames addObject:[dict objectForKey:@"name"]];
            [iconArray addObject:@"event_Activity_Table_icon.png"];
        }
    }
    [heightArray addObject:[NSNumber numberWithFloat:0]];
    [heightArray addObject:[NSNumber numberWithFloat:20]];
    [table setSectionTitleHeight:heightArray];
    
    NSMutableArray *cells = [NSMutableArray array];
    NSMutableArray *section = [NSMutableArray array];
    
    for (int i=0; i<cellNames.count; i++) {
        PairDTO *dto = [[PairDTO alloc] init];
        dto.label = [cellNames objectAtIndex:i];
        dto.imageName = [iconArray objectAtIndex:i];
        dto.accessType = UITableViewCellAccessoryNone;
        if (i == 0) {
            dto.isShowHeaderLine = YES;
        } else {
            dto.isShowHeaderLine = NO;
        }
        if (i == cellNames.count-1) {
            dto.isShowFootLine = YES;
        } else {
            dto.isShowFootLine = NO;
        }
        [section addObject:dto];
    }
    [cells addObject:section];
    [table setData:cells];
    
    if (cellNames.count == 0) {
        StatusView *view = [[StatusView alloc] initWithInView:self.view];
        [view showWithStatusType:StatusViewEmptyStatusType];
        [self.view addSubview:view];
    }
}

- (void)createUI
{
    [super createUI];
    [self createBackButton];
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    [table registerCell:[ImagePairCell class]];
    table.enableHeader = NO;
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.eventDTO.links objectAtIndex:index.row]];
    CommonWebController *web = [[CommonWebController alloc] init];
    web.urlPath = [dict objectForKey:@"url"];
    web.naviTitle = [dict objectForKey:@"name"];
    web.isShowShare = NO;
    [self.navigationController pushViewController:web animated:YES];
}

@end
