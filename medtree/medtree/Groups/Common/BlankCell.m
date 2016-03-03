//
//  BlankCell.m
//  renmai
//
//  Created by sam on 11/23/14.
//  Copyright (c) 2014 hangcom. All rights reserved.
//

#import "BlankCell.h"
#import "ColorUtil.h"
#import "Pair2DTO.h"
#import "DTOBase.h"

@implementation BlankCell

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
    self.backgroundColor = [ColorUtil getColor:@"767676" alpha:1];
    footerLine.hidden = YES;
    self.userInteractionEnabled = NO;
    
    titleLab = [[UILabel alloc] init];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.text = @"    请添加您忙碌的主题";
    titleLab.hidden = YES;
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.numberOfLines = 0;
    [self addSubview:titleLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    titleLab.frame = CGRectMake(0, 0, size.width, size.height);
    if ([idto isKindOfClass:[Pair2DTO class]]) {
        if (((Pair2DTO *)idto).title.length > 0) {
            if ([((Pair2DTO *)idto).label isEqualToString:@"shadow"]) {
                CGFloat w = 200;
                CGFloat h = 40;
                titleLab.textAlignment = NSTextAlignmentCenter;
                titleLab.frame = CGRectMake((size.width - w)/2, (size.height - h)/2, w, h);
            } else {
                titleLab.textAlignment = NSTextAlignmentLeft;
                titleLab.frame = CGRectMake(10, 0, size.width, size.height);
            }

        }
    }
}

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    if ([dto isKindOfClass:[Pair2DTO class]]) {
        titleLab.hidden = NO;
        if (((Pair2DTO *)dto).title.length > 0) {
            titleLab.font = [UIFont systemFontOfSize:14];
            titleLab.text = ((Pair2DTO *)dto).title;
            self.backgroundColor = [ColorUtil getColor:@"eeeeee" alpha:1];
            self.alpha = 0.5;
        } else {
            self.backgroundColor = [ColorUtil getColor:@"eeeeee" alpha:1];
            self.alpha = 0.5;
            titleLab.hidden = YES;
        }
    } else {
        titleLab.hidden = YES;
    }
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    if ([dto isKindOfClass:[Pair2DTO class]]) {
        if ([((Pair2DTO *)dto).label isEqualToString:@"shadow"]) {
            return 120;
        } else if (((Pair2DTO *)dto).title.length == 0) {
            return 10;
        }
        return 30;
    } else {
        return 20;
    }
}

@end
