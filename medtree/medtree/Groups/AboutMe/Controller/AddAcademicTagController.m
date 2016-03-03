


//
//  AddAcademicTagController.m
//  medtree
//
//  Created by 边大朋 on 15/8/7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "AddAcademicTagController.h"
#import "AddAcademicTagCell.h"
#import "BlankCell.h"
#import "UserManager.h"
#import "AcademicTagDTO.h"
#import "Pair2DTO.h"
#import "AccountHelper.h"
#import "UserManager.h"
#import "UserDTO.h"
#import "InfoAlertView.h"

@interface AddAcademicTagController ()
{
    NSMutableArray *dataArray;
    /**post data*/
    NSMutableArray *postArray;
    NSInteger from;
    NSInteger size;
}
@end

@implementation AddAcademicTagController

#pragma  mark - UI
- (void)createUI
{
    [super createUI];
    [naviBar setTopTitle:@"添加学术标签"];
    [self createBackButton];
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    
    UIButton *editButton = [NavigationBar createNormalButton:@"保存" target:self action:@selector(clickSave)];
    [naviBar setRightButton:editButton];
    
    [table registerCells:@{@"AcademicTagDTO": [AddAcademicTagCell class], @"Pair2DTO":[BlankCell class]}];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    postArray = [[NSMutableArray alloc] init];
    dataArray = [[NSMutableArray alloc] init];

    from = 0;
    size = 10;
    
    Pair2DTO *dto = [[Pair2DTO alloc] init];
    dto.title = @"选择您的学术领域";
    [dataArray addObject:dto];
    [self loadFromNet];
}

#pragma mark - click
- (void)clickSave
{
    //判断是否选中
    [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[AcademicTagDTO class]]) {
            if (((AcademicTagDTO *)obj).isSelect) {
                //避免重复添加
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", ((AcademicTagDTO *)obj).tagName];
                NSArray *filterResult = [postArray filteredArrayUsingPredicate:predicate];
                if (filterResult.count == 0) {
                    [postArray addObject:((AcademicTagDTO *)obj).tagName];
                }
            };
        }
    }];
    if (postArray.count == 0) {
        return;
    }
    if (postArray.count + self.userTagArray.count > 9) {
        [InfoAlertView showInfo:@"最多只能添加9个学术标签" inView:self.view duration:1];
        return;
    }
    NSDictionary *param = @{@"tags":postArray};
    [UserManager addAcademicTag:param success:^(id JSON) {
        if ([JSON[@"success"] boolValue]) {
            //缓存到本地
            UserDTO *udto = [AccountHelper getAccount];
            [postArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary *newTags = [[NSMutableDictionary alloc] init];
                [newTags setValue:@0 forKey:@"count"];
                [newTags setValue:@NO forKey:@"is_like"];
                [newTags setValue:obj forKey:@"tag"];
                [udto.academic_tags addObject:newTags];
                [udto updateInfo:udto.academic_tags forKey:@"academic_tags"];
                [UserManager checkUser:udto];

            }];
            [self.delegate updateParentVC:udto];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark - load data
- (void)loadFromNet
{
    NSDictionary *param = @{@"from":[NSNumber numberWithInteger:from],@"size":[NSNumber numberWithInteger:size]};
    [UserManager getAcademicTagSystem:param success:^(id JSON) {
        NSArray *systemArray = JSON;
        
        /**查找是否是当前用户标签*/
        [systemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", ((AcademicTagDTO *)obj).tagName];
            NSArray *filterResult = [self.userTagArray filteredArrayUsingPredicate:predicate];
            if (filterResult.count > 0) {
                ((AcademicTagDTO *)obj).isUserTag = YES;
            }
        }];
        [dataArray addObjectsFromArray:systemArray];
        [table setData:@[dataArray]];
        from += ((NSArray *)JSON).count;
        if (((NSArray *)JSON).count == size) {
            table.enableFooter = YES;
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    
    AcademicTagDTO *atDTO = [dataArray objectAtIndex:index.row];
    if (atDTO.isUserTag) {
        return;
    }
    atDTO.isSelect = !atDTO.isSelect;
    //如果取消选择则把数组中选中的去掉
    if (!atDTO.isSelect) {
        if (postArray.count > 0) {
            [postArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isEqualToString:atDTO.tagName]) {
                    [postArray removeObjectAtIndex:idx];
                }
            }];
        }
    }
    [table reloadData];
}

@end
