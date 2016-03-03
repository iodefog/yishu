//
//  PersonExperienceView.m
//  medtree
//
//  Created by 无忧 on 14-11-24.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PersonExperienceView.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "CommonHelper.h"
#import "FontUtil.h"

@implementation PersonExperienceView

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
 
    bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bgView.contentMode = UIViewContentModeScaleToFill;
    [self showBgView:NO];
    bgView.image = [ImageCenter getBundleImage:@"img_trans_cover.png"];
    [self addSubview:bgView];
    
    footerLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    footerLine.image = [ImageCenter getBundleImage:@"img_line.png"];
    [self addSubview:footerLine];
//    footerLine.hidden = YES;
    // 昵称
    hosLab = [[UILabel alloc] initWithFrame: CGRectZero];
    hosLab.backgroundColor = [UIColor clearColor];
    hosLab.textColor = [UIColor blackColor];
    hosLab.font = [MedGlobal getMiddleFont];
    hosLab.numberOfLines = 0;
    [self addSubview: hosLab];
    
    // 时间
    depLab = [[UILabel alloc] initWithFrame: CGRectZero];
    depLab.backgroundColor = [UIColor clearColor];
    depLab.textColor = [ColorUtil getColor:@"777777" alpha:1];
    depLab.font = [MedGlobal getLittleFont];
    [self addSubview: depLab];
    
    detailLab = [[UILabel alloc] initWithFrame: CGRectZero];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.textColor = [ColorUtil getColor:@"777777" alpha:1];
    detailLab.font = [MedGlobal getLittleFont];
    [self addSubview: detailLab];
    
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.image = [ImageCenter getBundleImage:@"img_next.png"];
    nextImage.userInteractionEnabled = YES;
    nextImage.hidden = YES;
    [self addSubview:nextImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    nextImage.frame = CGRectMake(size.width-15, (size.height-10)/2, 5, 10);
    hosLab.frame = CGRectMake(0, 14, size.width-15, [FontUtil infoHeight:hosLab.text font:[MedGlobal getMiddleFont].pointSize width:size.width-15]);
    depLab.frame = CGRectMake(0, 9+14+hosLab.frame.size.height, size.width-15, [FontUtil infoHeight:depLab.text font:[MedGlobal getLittleFont].pointSize width:size.width-15]);
    detailLab.frame = CGRectMake(0, depLab.frame.origin.y+depLab.frame.size.height+4, size.width-15, [FontUtil infoHeight:detailLab.text font:[MedGlobal getLittleFont].pointSize width:size.width-15]);
    footerLine.frame = CGRectMake(0, size.height-1, size.width-10, 1);
}

- (void)setInfo:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag
{
    index = indexPath;
    tagNum = tag;
    if ((NSObject *)[dict objectForKey:@"organization"] == [NSNull null]) {
        hosLab.text = @"未填写";
    } else {
        hosLab.text = [dict objectForKey:@"organization"];
    }
    
    if ((NSObject *)[dict objectForKey:@"department"] == [NSNull null]) {
        depLab.text = @"未填写";
    } else {
        depLab.text = [dict objectForKey:@"department"];
    }
    
    if ((NSObject *)[dict objectForKey:@"start_time"] == [NSNull null]) {
        if ((NSObject *)[dict objectForKey:@"title"] == [NSNull null]) {
            detailLab.text = [NSString stringWithFormat:@"未填写"];
        } else {
            if ([[dict objectForKey:@"title"] rangeOfString:@"null"].location !=NSNotFound) {
                detailLab.text = [NSString stringWithFormat:@"%@ 未填写时间",[dict objectForKey:@"title"]];
            } else {
                detailLab.text = [NSString stringWithFormat:@"未填写"];
            }
        }
    } else {
        NSString *title = @"";
        if ((NSObject *)[dict objectForKey:@"title"] != [NSNull null]) {
            title = [dict objectForKey:@"title"];
        }
        NSString *startTime = [CommonHelper getDateWithStringToMonth:[dict objectForKey:@"start_time"]];
        if ((NSObject *)[dict objectForKey:@"end_time"] == [NSNull null] || [[dict objectForKey:@"end_time"] length] == 0) {
            detailLab.text = [NSString stringWithFormat:@"%@ %@--至今",title,startTime];
        } else {
            NSString *endTime = [CommonHelper getDateWithStringToMonth:[dict objectForKey:@"end_time"]];
            detailLab.text = [NSString stringWithFormat:@"%@ %@--%@",title,startTime,endTime];
        }
    }
    [self layoutSubviews];
}

+ (CGFloat)getCellHeight:(NSDictionary *)dict width:(CGFloat)width
{
    CGFloat height = 14;
    NSString *hos = @"";
    if ((NSObject *)[dict objectForKey:@"organization"] == [NSNull null]) {
        hos = @"未填写";
    } else {
        hos = [dict objectForKey:@"organization"];
    }
    NSString *dep = @"";
    if ((NSObject *)[dict objectForKey:@"department"] == [NSNull null]) {
        dep = @"未填写";
    } else {
        dep = [dict objectForKey:@"department"];
    }
    height = height + [FontUtil infoHeight:hos font:[MedGlobal getMiddleFont].pointSize width:width];
    height = height + 9 + [FontUtil infoHeight:dep font:[MedGlobal getLittleFont].pointSize width:width];
    NSString *detail = @"";
    if ((NSObject *)[dict objectForKey:@"start_time"] == [NSNull null]) {
        if ((NSObject *)[dict objectForKey:@"title"] == [NSNull null]) {
            detail = [NSString stringWithFormat:@"未填写"];
        } else {
            detail = [NSString stringWithFormat:@"%@ 未填写时间",[dict objectForKey:@"title"]];
        }
    } else {
        NSString *title = @"";
        if ((NSObject *)[dict objectForKey:@"title"] != [NSNull null]) {
            title = [dict objectForKey:@"title"];
        }
        NSString *startTime = [CommonHelper getDateWithStringToMonth:[dict objectForKey:@"start_time"]];
        if ([dict objectForKey:@"end_time"] == [NSNull null]) {
            detail = [NSString stringWithFormat:@"%@ %@--至今",title,startTime];
        } else {
            NSString *endTime = [CommonHelper getDateWithStringToMonth:[dict objectForKey:@"end_time"]];
            detail = [NSString stringWithFormat:@"%@ %@--%@",title,startTime,endTime];
        }
    }
    height = height + 4 + [FontUtil infoHeight:detail font:[MedGlobal getLittleFont].pointSize width:width];
    return height+10;
}

- (void)setIsShowFootLine:(BOOL)isShow
{
    footerLine.hidden = !isShow;
}

- (void)showNext
{
    nextImage.hidden = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nextImage.hidden) {
        return;
    }
    [super touchesBegan:touches withEvent:event];
    [self showBgView:YES];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nextImage.hidden) {
        return;
    }
    [super touchesMoved:touches withEvent:event];
    [self showBgView:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nextImage.hidden) {
        return;
    }
    [super touchesCancelled:touches withEvent:event];
    [self showBgView:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nextImage.hidden) {
        return;
    }
    [super touchesEnded:touches withEvent:event];
    [self showBgView:NO];
    [self clickCell];
}

- (void)clickCell
{
    NSLog(@"qwqeqw");
    [self.parent clickiViewIndexPath:index tag:tagNum];
}

- (void)showBgView:(BOOL)tf
{
    bgView.alpha = tf ? 0.5 : 0;
}

@end
