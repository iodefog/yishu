//
//  AcademicTagController.m
//  medtree
//
//  Created by 边大朋 on 15/8/7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "AcademicTagController.h"
#import "AcademicTagLayout.h"
#import "AcademicTagCell.h"
#import "UserManager.h"
#import "AddAcademicTagController.h"
#import "AcademicTagDTO.h"
#import "NSString+Extension.h"
#import "InfoAlertView.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "EditPersonCardInfoController.h"

#define TagMargin 15
#define CellH 32

@interface AcademicTagController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AcademicTagDelegate>
{
    UICollectionView *collection;
    NSMutableArray *dataArray;
    /**缓存用户标签，用在下一级页面对比*/
    NSMutableArray *userTags;
    /**右侧编辑保存按钮*/
    UIButton *editButton;
    /**navBar rightBtn type. 0 save ; 1 edit*/
    NSInteger rightBtnType;
    /**删除标签数组*/
    NSMutableArray *delArray;
    /** 存放标签背景色，防止点赞操作刷新cell时候，获取重用cell的时候index.item取出来的与初始值不对应 */
    NSMutableArray *colorArray;
    UserDTO *udto;
}
@end

@implementation AcademicTagController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"学术标签"];
    
    AcademicTagLayout *layout = [[AcademicTagLayout alloc] init];
    layout.minimumLineSpacing = 5;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor whiteColor];
    [collection registerClass:[AcademicTagCell class] forCellWithReuseIdentifier:@"AcademicTagCell"];
    [self.view addSubview:collection];
    
    editButton = [NavigationBar createNormalButton:@"编辑" target:self action:@selector(clickEdit)];
    [naviBar setRightButton:editButton];
    
    [self createBackButton];
}

- (UIButton *)createBackButton
{
    UIButton *backButton = [NavigationBar createImageButton:@"btn_back.png" selectedImage:@"btn_back_click.png" target:self action:@selector(clickBack)];
    [naviBar setLeftButton:backButton];
    return backButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userTags = [[NSMutableArray alloc] init];
    dataArray = [[NSMutableArray alloc] init];
    delArray = [[NSMutableArray alloc] init];
    rightBtnType = 0;
    colorArray = [[NSMutableArray alloc] init];
    CGRect frame = self.view.bounds;
    collection.frame = CGRectMake(0, [self getOffset] + 44, frame.size.width, frame.size.height);
    udto = [AccountHelper getAccount];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadFromNet];
}

#pragma mark - action
- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

//编辑状态
- (void)clickEdit
{
    if (dataArray.count > 0) {
        UIButton *right = [naviBar rightButton];
        NSArray *subView = right.subviews;
        UILabel *titleLab = [subView lastObject];
        if (delArray.count > 0) {
            NSDictionary *param = @{@"tags":delArray};
            [UserManager delAcademicTag:param success:^(id JSON) {
                
                if ([JSON[@"success"] boolValue]) {
                    [dataArray enumerateObjectsUsingBlock:^(AcademicTagDTO *obj, NSUInteger idx, BOOL *stop) {
                        obj.isDelStatus = NO;
                    }];
                    rightBtnType = 0;
                    titleLab.text = @"编辑";
                    
                    //更新
                    NSMutableArray *academicTagArray = udto.academic_tags;
                    if (delArray.count == academicTagArray.count) {
                        [academicTagArray removeAllObjects];
                    } else {
                        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
                        [academicTagArray enumerateObjectsUsingBlock:^(NSMutableDictionary *tagDict, NSUInteger idx, BOOL *stop) {
                            [delArray enumerateObjectsUsingBlock:^(NSString *tag, NSUInteger index, BOOL *stop) {
                                if ([tagDict[@"tag"] isEqualToString:tag]) {
                                    [indexSet addIndex:idx];
                                }
                            }];
                        }];
                        [academicTagArray removeObjectsAtIndexes:indexSet];
                    }
                    [udto updateInfo:academicTagArray forKey:@"academic_tags"];
                    [UserManager checkUser:udto];
                    //初始化
                    [userTags removeObjectsInArray:delArray];
                    [delArray removeAllObjects];
                    [self.delegate updateParentVC:udto];
                    [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
                    [InfoAlertView showInfo:@"删除成功" inView:self.view duration:1];
                    [collection reloadData];
                }
            } failure:^(NSError *error, id JSON) {
                
            }];
        } else {
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                AcademicTagDTO *dto = (AcademicTagDTO *)obj;
                dto.isDelStatus = !dto.isDelStatus;
            }];
            rightBtnType = rightBtnType == 0 ? 1 : 0;
            titleLab.text = rightBtnType == 0 ? @"编辑" : @"保存";
            [collection reloadData];
        }
    }
}

#pragma mark - AcademicTagDelegate
- (void)delTag:(NSString *)tag index:(NSIndexPath *)indexPatch
{
    [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (indexPatch.item == idx) {
            [delArray addObject:tag];
            [dataArray removeObjectAtIndex:idx];
        }
    }];
    [collection reloadData];
}

- (void)likeTag:(NSString *)tag index:(NSIndexPath *)indexPatch
{
    NSDictionary *param = @{@"to_user":udto.userID,@"tag":tag};
    [UserManager likeAcademicTag:param success:^(id JSON) {
        if ([JSON[@"success"] boolValue]) {
            NSDictionary *result = JSON[@"result"];
            AcademicTagDTO *dto = [dataArray objectAtIndex:indexPatch.item];
            dto.isLike = [result[@"is_liked"] boolValue];
            dto.tagCount = [result[@"count"] stringValue];
        }
        [collection reloadData];
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark - load data
- (void)loadFromNet
{
    [dataArray removeAllObjects];
    [delArray removeAllObjects];
    [userTags removeAllObjects];
    NSDictionary *param = @{};
    rightBtnType = 0;
    [UserManager getAcademicTag:param success:^(id JSON) {
        dataArray = JSON;
        if (dataArray.count > 0) {
            UIButton *right = [naviBar rightButton];
            NSArray *subView = right.subviews;
            UILabel *titleLab = [subView lastObject];
            titleLab.text = @"编辑";
            [dataArray enumerateObjectsUsingBlock:^(AcademicTagDTO *obj, NSUInteger idx, BOOL *stop) {
                [userTags addObject:obj.tagName];
            }];
        }
        AcademicTagDTO *dto = [[AcademicTagDTO alloc] init];
        dto.showType = AcademicTagShowType_Edit;
        dto.isAdd = YES;
        [dataArray addObject:dto];
        [collection reloadData];
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AcademicTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AcademicTagCell" forIndexPath:indexPath];
    if (colorArray.count != dataArray.count) {
        [colorArray addObject:[cell getBgView].backgroundColor];
    }
    [cell getBgView].backgroundColor = [colorArray objectAtIndex:indexPath.item];
    
    [cell setInfo:dataArray[indexPath.row] index:indexPath];
    cell.parent = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataArray.count - 1 == indexPath.item) {
        if (dataArray.count - 1 >= 9) {
            [InfoAlertView showInfo:@"最多只能添加9个学术标签" inView:self.view duration:1];
            return;
        }
        AddAcademicTagController *vc = [[AddAcademicTagController alloc] init];
        vc.userTagArray = userTags;
        vc.delegate = self.delegate;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -  UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //添加按钮
    if (dataArray.count - 1 == indexPath.item) {
        return CGSizeMake(96, 32);
    } else {
        
        AcademicTagDTO *dto = dataArray[indexPath.row];
        CGSize tagNameSize = [NSString sizeForString:dto.tagName Size:CGSizeMake(CGFLOAT_MAX, CellH)
                                                Font:[UIFont systemFontOfSize:14]];
        CGSize tagCountSize = [NSString sizeForString:dto.tagCount Size:CGSizeMake(CGFLOAT_MAX, CellH)
                                                 Font:[UIFont systemFontOfSize:14]];
        
        CGFloat textW = tagNameSize.width + tagCountSize.width + 12 + CellH;
        
        if (textW > CGRectGetWidth(self.view.frame) - TagMargin * 2) {
            textW = CGRectGetWidth(self.view.frame) - TagMargin * 2;
        }
        return CGSizeMake(textW, 32+9);
    }
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(TagMargin, TagMargin, TagMargin, TagMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return TagMargin;
}

@end
