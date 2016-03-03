//
//  BrowseImagesController.m
//  medtree
//
//  Created by 陈升军 on 14/12/26.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BrowseImagesController.h"
#import "BrowseImageView.h"

@interface BrowseImagesController () <UIScrollViewDelegate>
{
    UIScrollView            *scroll;
    NSMutableArray          *dataArray;
    NSMutableArray          *viewArray;
    NSInteger               idxNum;
}
@end

@implementation BrowseImagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIButton *)createBackButton
{
    UIButton *backButton = [NavigationBar createNormalButton:@"关闭" target:self action:@selector(clickBack)];
    [naviBar setLeftButton:backButton];
    return backButton;
}

- (void)clickBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createUI
{
    [super createUI];
    
    [self createBackButton];
    
    self.view.backgroundColor = [UIColor blackColor];
    [naviBar changeBackGroundImage:@""];
    
    dataArray = [[NSMutableArray alloc] init];
    viewArray = [[NSMutableArray alloc] init];
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scroll.backgroundColor = [UIColor blackColor];
    scroll.userInteractionEnabled = YES;
    scroll.delegate = self;
    scroll.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.pagingEnabled = YES;
    [self.view addSubview:scroll];
    
    for (int i = 0; i < 3; i ++) {
        BrowseImageView *newsList = [[BrowseImageView alloc] initWithFrame:CGRectZero];
        [scroll addSubview:newsList];
        [viewArray addObject:newsList];
    }
    
    idxNum = 0;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGSize size = self.view.frame.size;
    scroll.frame = CGRectMake(0, 0, size.width, size.height);
    for (int i=0; i<viewArray.count; i++) {
        //加载数据
        if (dataArray.count > 0) {
            BrowseImageView *newsList = [viewArray objectAtIndex:i];
            newsList.frame = CGRectMake(0, 0, scroll.frame.size.width, scroll.frame.size.height);
            newsList.frame = CGRectOffset(newsList.frame, i*scroll.frame.size.width, 0);
            [scroll addSubview:newsList];
        }
    }
    scroll.contentSize = CGSizeMake((dataArray.count>=3? 3:dataArray.count)*scroll.frame.size.width, scroll.frame.size.height);
    if (idxNum == 0) {
        [scroll setContentOffset:CGPointMake(0, 0)];
    } else if (idxNum == dataArray.count-1) {
        if (dataArray.count>2) {
            [scroll setContentOffset:CGPointMake(2*size.width, 0)];
        } else {
            [scroll setContentOffset:CGPointMake(size.width,0)];
        }
    } else {
        [scroll setContentOffset:CGPointMake(size.width, 0)];
    }
    
    [self.view bringSubviewToFront:naviBar];
}

- (void)setDataInfo:(NSArray *)array
{
    idxNum = 0;
    [dataArray removeAllObjects];
    //    [viewArray removeAllObjects];
    if (array.count > 0) {
        [dataArray addObjectsFromArray:array];
        for (int i = 0; i < viewArray.count; i ++) {
            //加载数据
            BrowseImageView *newsList = [viewArray objectAtIndex:i];
            newsList.hidden = NO;
            if (i < (dataArray.count>=3? 3:dataArray.count)) {
                [newsList setImageURL:[dataArray objectAtIndex:i]];
                newsList.frame = CGRectMake(0, 0, scroll.frame.size.width, scroll.frame.size.height);
                newsList.frame = CGRectOffset(newsList.frame, i*scroll.frame.size.width, 0);
            } else {
                newsList.hidden = YES;
            }
            
        }
        [self viewDidLayoutSubviews];
        [self refreshScrollView:[NSNumber numberWithInteger:0]];
    }
}

- (void)setNumberInfo:(NSNumber *)number
{
    [self refreshScrollView:number];
    [self setNaviTitle];
}

- (void)refreshScrollView:(NSNumber *)number
{
    int refreshIdx = [number intValue];
    if (dataArray.count >= 3) {
        if (0 < idxNum && idxNum < dataArray.count) {
            idxNum = refreshIdx;
            if (refreshIdx == dataArray.count-1) {
                //重新调整page页面位置
                [self changePageLocation:2];
                //对page页面传值
                [self refreshViewArray:2];
                
            } else if (refreshIdx == 0) {
                [self changePageLocation:0];
                [self refreshViewArray:0];
            } else {
                [self refreshViewArray:1];
            }
        } else if (idxNum == 0) {
            idxNum = refreshIdx;
            if (refreshIdx == dataArray.count-1) {
                for (int i = 0; i < 2; i++) {
                    [self changePageLocation:2];
                }
                [self refreshViewArray:2];
                
            } else if (refreshIdx == 0) {
                return;
            } else {
                [self changePageLocation:2];
                [self refreshViewArray:1];
            }
        } else if (idxNum == dataArray.count -1) {
            idxNum = refreshIdx;
            if (refreshIdx == 0) {
                for (int i = 0; i < 2; i++) {
                    [self changePageLocation:0];
                }
                [self refreshViewArray:0];
            } else if (refreshIdx == dataArray.count-1) {
                return;
            } else {
                [self changePageLocation:0];
                [self refreshViewArray:1];
            }
        }
    } else {
        if (idxNum == refreshIdx) {
            return;
        } else if (refreshIdx == dataArray.count-1) {
            idxNum = refreshIdx;
            [self changePageLocation:3];
            [self refreshViewArray:1];
        } else if (refreshIdx == 0) {
            idxNum = refreshIdx;
            [self changePageLocation:1];
            [self refreshViewArray:0];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollview
{
    int x = scrollview.contentOffset.x;
    if(dataArray.count >= 3) {
        if (x == scroll.frame.size.width && idxNum == 0) {
            idxNum++;
        } else if (x == scroll.frame.size.width && idxNum+1 == dataArray.count) {
            idxNum--;
        }
        // 往下翻一张
        if(x >= (2*scroll.frame.size.width)) {
            if (idxNum +1 == dataArray.count) {
                return;
            } else if (idxNum +2 < dataArray.count) {
                [self refreshPage:YES];
            }
            idxNum++;
        }
        //往上翻一张
        if(x <= 0) {
            if (idxNum == 0) {
                return;
            } else if (idxNum > 1) {
                [self refreshPage:NO];
            }
            idxNum --;
        }
    } else {
        // 往下翻一张
        if(x == scroll.frame.size.width) {
            if (idxNum == dataArray.count-1) {
                return;
            }
            idxNum++;
        }
        //往上翻一张
        if(x == 0) {
            if (idxNum == 0) {
                return;
            }
            idxNum--;
        }
    }
    [self setNaviTitle];
}

- (void)setNaviTitle
{
    [naviBar setTopTitle:[NSString stringWithFormat:@"%@/%@", @(idxNum + 1), @(dataArray.count)]];
}

- (void)changePageLocation:(int)locationNum
{
    switch (locationNum) {
        case 2:
        {
            BrowseImageView *tmp = [viewArray objectAtIndex:2];
            [viewArray removeObject:tmp];
            [viewArray insertObject:tmp atIndex:0];
            break;
        }
        case 0:
        {
            BrowseImageView *tmp = [viewArray objectAtIndex:0];
            [viewArray removeObject:tmp];
            [viewArray addObject:tmp];
            break;
        }
        case 1:
        {
            BrowseImageView *tmp = [viewArray objectAtIndex:0];
            [viewArray removeObject:tmp];
            [viewArray addObject:tmp];
            break;
        }
        case 3:
        {
            BrowseImageView *tmp = [viewArray objectAtIndex:1];
            [viewArray removeObject:tmp];
            [viewArray insertObject:tmp atIndex:0];
            break;
        }
        default:
            break;
    }
}

- (void)refreshViewArray:(int)initNum
{
    for (int i=0; i< viewArray.count; i++) {
        BrowseImageView *consult = [viewArray objectAtIndex:i];
        if (i == initNum) {
            [consult setImageURL:[dataArray objectAtIndex:idxNum]];
        } else {
            if (idxNum+i-initNum < 0 || idxNum+i-initNum == dataArray.count) {
                continue;
            }
            [consult setImageURL:[dataArray objectAtIndex:idxNum+i-initNum]];
        }
        consult.frame = CGRectMake(0, 0, scroll.frame.size.width, scroll.frame.size.height);
        consult.frame = CGRectOffset(consult.frame, i*scroll.frame.size.width, 0);
    }
    //    isResize = NO;
    [scroll setContentOffset:CGPointMake(initNum*scroll.frame.size.width, 0)];
}

- (void)refreshPage:(BOOL)isRight
{
    NSInteger count = dataArray.count>=3? 3:dataArray.count;
    
    //交换页面
    if(count > 0) {
        if(isRight) {
            UIImageView *tmp = [viewArray objectAtIndex:0];
            [viewArray removeObject:tmp];
            [viewArray addObject:tmp];
        } else {
            UIImageView *tmp = [viewArray objectAtIndex:count-1];
            [viewArray removeObject:tmp];
            [viewArray insertObject:tmp atIndex:0];
        }
    }
    
    for (int i=0; i<count; i++) {
        //加载数据
        BrowseImageView *consult = [viewArray objectAtIndex:i];
        consult.frame = CGRectMake(0, 0, scroll.frame.size.width, scroll.frame.size.height);
        consult.frame = CGRectOffset(consult.frame, i*scroll.frame.size.width, 0);
        if(isRight) {
            if(count-1 == i) {
                //                [consult showDetail:NO];
                [consult setImageURL:[dataArray objectAtIndex:idxNum+2]];
            } else if (i == 0) {
                [consult setImageURL:[dataArray objectAtIndex:idxNum]];
            }
        } else {
            if(0 == i) {
                
                [consult setImageURL:[dataArray objectAtIndex:idxNum-2]];
            } else if (i == count-1) {
                [consult setImageURL:[dataArray objectAtIndex:idxNum]];
            }
        }
    }
    //    [ImageCenter releaseImages:nil source:PhotoSource_All];
    CGFloat off = count>=3? scroll.frame.size.width:0;
    [scroll setContentOffset:CGPointMake(off, 0)];
}

@end
