//
//  PersonExperienceCell.m
//  medtree
//
//  Created by 无忧 on 14-11-8.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PersonExperienceCell.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "CommonHelper.h"
#import "FontUtil.h"
#import "PersonAddView.h"
#import "PersonExperienceView.h"
#import "BaseView.h"
#import "PersonCertificationView.h"

@implementation PersonExperienceCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    [super createUI];
    bgView.hidden = YES;
    
    viewArray = [[NSMutableArray alloc] init];
    dataArray = [[NSMutableArray alloc] init];
    // 昵称
    titleLab = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [ColorUtil getColor:@"878787" alpha:1];
    titleLab.textAlignment = NSTextAlignmentRight;
    titleLab.font = [MedGlobal getMiddleFont];
    titleLab.numberOfLines = 0;
    [self.contentView addSubview: titleLab];
    
    numLab = [[UILabel alloc] initWithFrame: CGRectZero];
    numLab.backgroundColor = [UIColor clearColor];
    numLab.textColor = [ColorUtil getColor:@"ECEFF3" alpha:1];
    numLab.textAlignment = NSTextAlignmentRight;
    numLab.font = [UIFont systemFontOfSize:70];
    numLab.font = [UIFont boldSystemFontOfSize:70];
    [self.contentView addSubview: numLab];
    
    addView = [[PersonAddView alloc] init];
    addView.hidden = YES;
    [self addSubview:addView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    titleLab.frame = CGRectMake(10, 14, 75, [FontUtil infoHeight:titleLab.text font:[MedGlobal getMiddleFont].pointSize width:80]);
    headerLine.frame = CGRectMake(0, 0, size.width, 1);
    if (viewArray.count > 0) {
        CGFloat height = 0;
        for (int i = 0; i < viewArray.count; i ++) {
            if (type == 0) {
                if (i == 1) {
                    numLab.frame = CGRectMake(0, height-40, 80, [FontUtil infoHeight:numLab.text font:70 width:80]);
                }
                PersonExperienceView *view = [viewArray objectAtIndex:i];
                view.frame = CGRectMake(90, height, size.width-90, [PersonExperienceView getCellHeight:[dataArray objectAtIndex:i] width:size.width-90-15]);
                height = height+view.frame.size.height;
            } else if (type == 1) {
                if (i == 1) {
                    numLab.frame = CGRectMake(0, height-20, 80, [FontUtil infoHeight:numLab.text font:70 width:80]);
                }
                PersonCertificationView *view = [viewArray objectAtIndex:i];
                view.frame = CGRectMake(90, height, size.width-90, [PersonCertificationView getCellHeight:[dataArray objectAtIndex:i] width:size.width-90-15]);
                height = height+view.frame.size.height;
            }
        }
    }
    addView.frame = CGRectMake(90, size.height-46, size.width-90, 46);
    footerLine.frame = CGRectMake(0, size.height-1, size.width, 1);
}

- (void)setInfo:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    [dataArray removeAllObjects];
    addView.hidden = YES;
    for (int i = 0; i < viewArray.count; i ++) {
        BaseView *view = [viewArray objectAtIndex:i];
        [view removeFromSuperview];
        view = nil;
    }
    [viewArray removeAllObjects];
    titleLab.text = [dict objectForKey:@"title"];
    numLab.hidden = YES;
    
    if ((NSObject *)[dict objectForKey:@"array"] != [NSNull null]) {
        [dataArray addObjectsFromArray:[dict objectForKey:@"array"]];
        if (dataArray.count > 1) {
            numLab.hidden = NO;
            numLab.text = [NSString stringWithFormat:@"%@", @(dataArray.count)];
        }
        if ([[dict objectForKey:@"type"] intValue] == 0) {
            type = 0;
            for (int i = 0; i < dataArray.count; i ++) {
                PersonExperienceView *view = [[PersonExperienceView alloc] init];
                view.parent = self.parent2;
                [view setInfo:[dataArray objectAtIndex:i] indexPath:index tag:i];
                if ([[dict objectForKey:@"isAdd"] boolValue]) {
                    [view showNext];
                } else {
                    if (i == dataArray.count-1) {
                        [view setIsShowFootLine:NO];
                    }
                }
                [self addSubview:view];
                [viewArray addObject:view];
            }
        } else if ([[dict objectForKey:@"type"] intValue] == 1) {
            type = 1;
            for (int i = 0; i < dataArray.count; i ++) {
                PersonCertificationView *view = [[PersonCertificationView alloc] init];
                view.parent = self.parent2;
                [view setInfo:[dataArray objectAtIndex:i] indexPath:index tag:i];
                if ([[dict objectForKey:@"isAdd"] boolValue]) {
                    [view showNext];
                } else {
                    if (i == dataArray.count-1) {
                        [view setIsShowFootLine:NO];
                    }
                }
                [self addSubview:view];
                [viewArray addObject:view];
            }
        }
    }
    if ([[dict objectForKey:@"isAdd"] boolValue]) {
        addView.parent = self.parent2;
        addView.hidden = NO;
        [addView setInfo:[dict objectForKey:@"add"] indexPath:index tag:dataArray.count+1];
    }
    [self layoutSubviews];
}

+ (CGFloat)getCellHeight:(NSDictionary *)dict width:(CGFloat)width
{
    CGFloat height = 0;
    if ((NSObject *)[dict objectForKey:@"array"] != [NSNull null]) {
        NSArray *array = [dict objectForKey:@"array"];
        for (int i = 0; i < array.count; i ++) {
            if ([[dict objectForKey:@"type"] intValue] == 0) {
                height = height + [PersonExperienceView getCellHeight:[array objectAtIndex:i] width:width-10-15-10];
            } else if ([[dict objectForKey:@"type"] intValue] == 1) {
                height = height + [PersonCertificationView getCellHeight:[array objectAtIndex:i] width:width-10-15-10];
            }
        }
        if ([[dict objectForKey:@"isAdd"] boolValue]) {
            height = height + 46;
        }
    } else {
        height = 46;
    }
    return height;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
    [super touchesEnded:touches withEvent:event];
}

@end
