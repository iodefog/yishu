//
//  MorePairCell.m
//  medtree
//
//  Created by 无忧 on 14-9-16.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "MorePairCell.h"
#import "TitleAndDetailView.h"
#import "ImageCenter.h"
#import "FontUtil.h"
#import "MedGlobal.h"

@implementation MorePairCell

- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor clearColor];
    
    dataArray = [[NSMutableArray alloc] init];
    pairArray = [[NSMutableArray alloc] init];
    lineArray = [[NSMutableArray alloc] init];
    
    commonView = [[UIView alloc] init];
    commonView.backgroundColor = [UIColor clearColor];
    [self addSubview:commonView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)];
    [commonView addGestureRecognizer:tap];
    
    bgView.backgroundColor = [UIColor clearColor];
}

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    NSArray *array = [NSArray arrayWithArray:dto];
    [dataArray removeAllObjects];
    [dataArray addObjectsFromArray:array];
    if (pairArray.count == array.count) {
        for (int i = 0; i < pairArray.count; i ++) {
            NSMutableDictionary *dict = [pairArray objectAtIndex:i];
            TitleAndDetailView *view = [dict objectForKey:@"view"];
            [view setInfo:[array objectAtIndex:i]];
            [view setIndexPath:indexPath tag:100+i];
            view.parent = self.parent2;
        }
    } else {
        for (int i = 0; i < pairArray.count; i ++) {
            NSMutableDictionary *dict = [pairArray objectAtIndex:i];
            TitleAndDetailView *view = [dict objectForKey:@"view"];
            [view removeFromSuperview];
            
            UIImageView *line = [dict objectForKey:@"lineImage"];
            [line removeFromSuperview];
        }

        [lineArray removeAllObjects];
        [pairArray removeAllObjects];
        
        for (int i = 0; i < array.count; i ++) {
            
            TitleAndDetailView *view = [[TitleAndDetailView alloc] init];
            [view setInfo:[array objectAtIndex:i]];
            [view setIndexPath:indexPath tag:100+i];
            view.parent = self.parent2;
            [self addSubview:view];
            
            UIImageView *lineLab = [[UIImageView alloc] init];
            lineLab.image = [ImageCenter getBundleImage:@"img_line.png"];
            [view addSubview:lineLab];
            
            [pairArray addObject:@{@"view":view,@"lineImage":lineLab}];
        }
        lineImage = [[UIImageView alloc] init];
        lineImage.image = [ImageCenter getBundleImage:@"img_line.png"];
        [self addSubview:lineImage];
    }
    [self layoutSubviews];
}

- (void)clickTap
{
    if (isAllShowNext) {
        return;
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            self.backgroundColor = [UIColor lightGrayColor];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.backgroundColor = [UIColor whiteColor];
            }];
        }];
        [self.parent clickCell:nil index:index];
    }
}

- (void)allShowNext:(BOOL)sender
{
    isAllShowNext = sender;
    if (isAllShowNext) {
        for (int i = 0; i < pairArray.count; i ++) {
            NSMutableDictionary *dict = [pairArray objectAtIndex:i];
            TitleAndDetailView *view = [dict objectForKey:@"view"];
            [view setIsShowNext];
            [view setIsCanSelect];
        }
    } else {
        for (int i = 0; i < pairArray.count; i ++) {
            NSMutableDictionary *dict = [pairArray objectAtIndex:i];
            TitleAndDetailView *view = [dict objectForKey:@"view"];
            if (i == 0) {
                [view setIsShowNext];
            }
            break;
        }
        [self bringSubviewToFront:commonView];
    }
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    bgView.frame = CGRectMake(0, 0, size.width, size.height>46*4?46*4:size.height);
    lineImage.frame = CGRectMake(0, 0, size.width, 1);
    CGFloat height = 0;

    for (int i = 0; i < pairArray.count; i ++) {
        NSMutableDictionary *dict = [pairArray objectAtIndex:i];
        TitleAndDetailView *view = [dict objectForKey:@"view"];
        UIImageView *line = [dict objectForKey:@"lineImage"];
        
        NSMutableDictionary *tdict = [dataArray objectAtIndex:i];
        if (i == 0) {
            view.frame = CGRectMake(0, height, size.width, [self getHeight:[tdict objectForKey:@"detail"] width:size.width-80-10-20]);
            line.frame = CGRectMake((pairArray.count > 1)?90:0, view.frame.size.height-0.5, size.width-90, 1);
        } else {
            view.frame = CGRectMake(0, height, size.width, [self getHeight:[tdict objectForKey:@"detail"] width:size.width-80-10-20]);
            CGFloat width = 90;
            if (i == pairArray.count-1) {
                width = 0;
            }
            line.frame = CGRectMake(width, view.frame.size.height-0.5, size.width-width, 1);
        }
        height = height+[self getHeight:[tdict objectForKey:@"detail"] width:size.width-80-10-20];
    }
    commonView.frame = CGRectMake(0, 0, size.width, size.height);
}

- (CGFloat)getHeight:(NSString *)text width:(CGFloat)width
{
    CGFloat height = 0;
    if ((NSObject *)text != [NSNull null]) {
        height = [FontUtil infoHeight:text font:[[MedGlobal getMiddleFont] pointSize] width:width]+20;
    }
    return height>46?height:46;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
    [super touchesBegan:touches withEvent:event];
    [UIView animateWithDuration:0.5 animations:^{
        bgView.backgroundColor = [UIColor lightGrayColor];
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
    [super touchesMoved:touches withEvent:event];
    [UIView animateWithDuration:0.5 animations:^{
        bgView.backgroundColor = [UIColor clearColor];
    }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
    [super touchesCancelled:touches withEvent:event];
    [UIView animateWithDuration:0.5 animations:^{
        bgView.backgroundColor = [UIColor clearColor];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
    [super touchesEnded:touches withEvent:event];
    [self.parent clickCell:nil index:index];
    [UIView animateWithDuration:0.5 animations:^{
        bgView.backgroundColor = [UIColor clearColor];
    }];
}

@end
