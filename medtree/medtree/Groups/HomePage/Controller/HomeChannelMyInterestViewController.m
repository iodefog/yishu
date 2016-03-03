//
//  HomeChannelMyInterestViewController.m
//  medtree
//
//  Created by tangshimi on 8/19/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeChannelMyInterestViewController.h"
#import "HomeChannelMyInterestCollectionViewCell.h"
#import "UIColor+Colors.h"
#import "ChannelManager.h"
#import "HomeRecommendChannelDetailDTO.h"
#import <InfoAlertView.h>
#import "HomeChannelViewController.h"
#import <JSONKit.h>

NSString *const HomeChannelMyInterestCollectionViewCellReuseID = @"HomeChannelMyInterestCollectionViewCell";

@interface HomeChannelMyInterestViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectiveView;
@property (nonatomic, strong) NSMutableArray *selectedInfoArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HomeChannelMyInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedInfoArray = [[NSMutableArray alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];
    
    self.collectiveView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), CGRectGetWidth(self.view.frame), GetScreenHeight - CGRectGetMaxY(naviBar.frame));
    
    switch (self.type) {
        case HomeChannelMyInterestViewControllerTypeFirstChoseInterest:
            [self createBackButton];
            [naviBar setRightButton:[NavigationBar createButton:@"保存" type:0 target:self action:@selector(saveButtonAction:)]];
            break;
        case HomeChannelMyInterestViewControllerTypeNormalChoseInterest:
            [naviBar setLeftButton:[NavigationBar createButton:@"取消" type:0 target:self action:@selector(cancleButtonAction:)]];
            [naviBar setRightButton:[NavigationBar createButton:@"保存" type:0 target:self action:@selector(saveButtonAction:)]];
            break;
        case HomeChannelMyInterestViewControllerTypePublishDiscussionChoseInterest:
            [naviBar setLeftButton:[NavigationBar createButton:@"取消" type:0 target:self action:@selector(cancleButtonAction:)]];
            [naviBar setRightButton:[NavigationBar createButton:@"确定" type:0 target:self action:@selector(confirmButtonAction:)]];
            break;
    }
    
    [self getTagsRequest];
}

- (void)createUI
{
    [super createUI];
    
    if (self.type == HomeChannelMyInterestViewControllerTypePublishDiscussionChoseInterest) {
        [naviBar setTopTitle:@"请选择标签"];
    } else if (self.type == HomeChannelMyInterestViewControllerTypeFirstChoseInterest
               || self.type == HomeChannelMyInterestViewControllerTypeNormalChoseInterest) {
        [naviBar setTopTitle:@"我感兴趣的内容"];
    }
    
    [self.view addSubview:self.collectiveView];
}

#pragma mark -
#pragma mark - UICollectionViewDelegateFlowLayout -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeZero;
    } else {
        return CGSizeMake(GetScreenWidth, 115);
    }
}

#pragma mark -
#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeChannelMyInterestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeChannelMyInterestCollectionViewCellReuseID
                                                                                              forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row][@"name"];
    
    __block BOOL isSelected = NO;
    [self.selectedInfoArray enumerateObjectsUsingBlock:^(NSDictionary *tagDic, NSUInteger idx, BOOL *stop) {
        if ([[NSString stringWithFormat:@"%@", tagDic[@"id"]] isEqualToString:[NSString stringWithFormat:@"%@", self.dataArray[indexPath.row][@"id"]]]) {
            isSelected = YES;
        }
    }];
    
    cell.showSelectedView = isSelected;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeChannelMyInterestCollectionViewCell *cell = (HomeChannelMyInterestCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (!cell.showSelectedView) {
        [self.selectedInfoArray addObject:self.dataArray[indexPath.row]];
    } else {
        [self.selectedInfoArray removeObject:self.dataArray[indexPath.row]];
    }
 
    cell.showSelectedView = !cell.showSelectedView;
}

#pragma mark -
#pragma mark - response event -

- (void)saveButtonAction:(UIButton *)button
{
    if (self.selectedInfoArray.count > 0) {
        [self setTagsRequest];
    } else {
        [InfoAlertView showInfo:@"请选择您感兴趣的内容" inView:self.view duration:1];
    }
}

- (void)cancleButtonAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmButtonAction:(UIButton *)button
{
    if (self.choseInterstBlock) {
        __block NSMutableArray *tagsArray = [NSMutableArray new];
        
        [self.selectedInfoArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
            [tagsArray addObject:dic[@"id"]];
        }];
        
        self.choseInterstBlock([tagsArray copy]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - network -

- (void)getTagsRequest
{
    NSDictionary *params = @{ @"method" : @(MethodTypeChannelRecommendTags), @"channel_id" : self.channelDatailDTO.channelID };
    [ChannelManager getChannelParam:params success:^(id JSON) {
        NSDictionary *resultDic = JSON;
        if ([resultDic[@"status"] boolValue]) {
            [self.dataArray addObjectsFromArray:resultDic[@"allTags"]];
            [self.collectiveView reloadData];
            
            if (self.type == HomeChannelMyInterestViewControllerTypeNormalChoseInterest) {
                for (NSDictionary *dic in resultDic[@"myTags"]) {
                    for (NSDictionary *dict in self.dataArray) {
                        if ([[NSString stringWithFormat:@"%@", dic[@"parent_id"]] isEqualToString:[NSString stringWithFormat:@"%@", dict[@"id"]]]) {
                            [self.selectedInfoArray addObject:dict];
                        }
                    }
                }
            }
        }
    } failure:^(NSError *error, id JSON) {
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

- (void)setTagsRequest
{
    __block NSMutableArray *tagsArray = [NSMutableArray new];
    
    [self.selectedInfoArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
        [tagsArray addObject:dic[@"id"]];
    }];
    
    NSDictionary *params = @{ @"method" : @(MethodTypeChannelRecommendPostTags),
                              @"channel_id" : self.channelDatailDTO.channelID,
                              @"tags" : tagsArray };
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        NSDictionary *dic = JSON;
        if ([dic[@"success"] boolValue]) {
            [InfoAlertView showInfo:@"保存成功！" inView:self.view duration:2];
            if (self.updateBlock) {
                self.updateBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.type == HomeChannelMyInterestViewControllerTypeFirstChoseInterest) {
                    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
                    [viewControllers removeLastObject];
                    
                    HomeChannelViewController *vc = [[HomeChannelViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.channelDetailDTO = self.channelDatailDTO;
                    [viewControllers addObject:vc];
                    
                    [self.navigationController setViewControllers:[viewControllers copy] animated:YES];
                } else if (self.type == HomeChannelMyInterestViewControllerTypeNormalChoseInterest) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            });
        }
    } failure:^(NSError *error, id JSON) {
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

#pragma mark -
#pragma mark - setter and getter -

- (UICollectionView *)collectiveView
{
    if (!_collectiveView) {
        _collectiveView = ({
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            flowLayout.minimumInteritemSpacing = 5.0f;
            flowLayout.minimumLineSpacing = 5.0f;
            flowLayout.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10);
            
            CGFloat width = (GetScreenWidth - 20 - 15) / 3.0;
            flowLayout.itemSize = CGSizeMake(width, 35);
            
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                                  collectionViewLayout:flowLayout];
            collectionView.backgroundColor = [UIColor clearColor];
            [collectionView registerClass:[HomeChannelMyInterestCollectionViewCell class]
               forCellWithReuseIdentifier:HomeChannelMyInterestCollectionViewCellReuseID];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            
            collectionView;
        });
    }
    return _collectiveView;
}

@end
