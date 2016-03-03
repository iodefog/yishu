//
//  NewCommonFriendController.m
//  medtree
//
//  Created by 边大朋 on 15-4-17.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewCommonFriendController.h"
#import "NewCommonCell.h"
#import "UserDTO.h"
#import "UserManager.h"
#import "LoadingView.h"
#import "NewPersonDetailController.h"

@interface NewCommonFriendController ()
{
    NSString *userID;
    NSInteger  pageSize;
    NSInteger  from;
    NSMutableArray *allArray;
}
@end

@implementation NewCommonFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    [super createUI];
    [naviBar setTopTitle:@"共同好友"];
    [self createBackButton];
    table.enableHeader = NO;
    table.enableFooter = NO;
    [table setIsNeedFootView:NO];
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    [table registerCells:@{@"UserDTO":[NewCommonCell class]}];
    from = 0;
    pageSize = 10;
    allArray = [[NSMutableArray alloc] init];
    
}


- (void)loadInfo:(NSString *)userId
{
    userID = userId;
   // [self getDataFromLocal];
    [self requestData];

    
}

- (void)requestData
{
//    [self showProgress];
    [UserManager getCommentFriend:[self getParam_FromNet] success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self hideProgress];
            //
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getParam_FromNet]];
            [dict setObject:JSON forKey:@"data"];
            [self parseData:dict];
        });
    } failure:^(NSError *error, id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self hideProgress];
            //
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getParam_FromNet]];
            [dict setObject:JSON forKey:@"error"];
            [self parseDataError:JSON];
        });
    }];
}

- (void)parseData:(NSMutableDictionary *)dict
{
    NSArray *datas = [[dict objectForKey:@"data"] objectForKey:@"result"];
    if ([[dict objectForKey:@"method"] integerValue] == MethodType_Comment_FriendList) {
        // clear database cache
        if (datas.count > 0 && from == 0) {
            
        }
        if (datas.count > 0) {
            for (int i = 0; i < datas.count; i++) {
                UserDTO *udto = [[UserDTO alloc] init:[datas objectAtIndex:i]];
                [allArray addObject:udto];
            }
            from += datas.count;
        }
        table.enableFooter = datas.count >= pageSize;
        [table setData:[NSArray arrayWithObjects:allArray, nil]];
    }
}

- (NSDictionary *)getParam_FromNet
{
  return  @{@"method":[NSNumber numberWithInteger:MethodType_Comment_FriendList],@"from":[NSNumber numberWithInteger:from], @"size": [NSNumber numberWithInteger:pageSize],@"userID":userID};
}

- (void)parseDataError:(id)JSON
{
    
}

//- (void)showProgress
//{
//    [LoadingView showProgress:YES inView:self.view];
//}
//
//- (void)hideProgress
//{
//    [LoadingView showProgress:NO inView:self.view];
//}

- (void)loadFooter:(BaseTableView *)table
{
    [self requestData];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    NewPersonDetailController *person = [[NewPersonDetailController alloc] init];
    person.userDTO = (UserDTO *)dto;
    person.parent = self;
    [self.navigationController pushViewController:person animated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize size = self.view.frame.size;
    table.frame = CGRectMake(0, [self getOffset]+44, size.width, size.height-44-[self getOffset]);
    
}




@end
