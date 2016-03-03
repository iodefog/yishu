//
//  PersonInterestCell.m
//  medtree
//
//  Created by 无忧 on 14-11-8.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PersonInterestCell.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "CommonHelper.h"
#import "FontUtil.h"

@implementation PersonInterestCell

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
    
    titleLab = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [ColorUtil getColor:@"878787" alpha:1];
    titleLab.textAlignment = NSTextAlignmentRight;
    titleLab.font = [MedGlobal getMiddleFont];
    titleLab.text = @"兴趣爱好";
    titleLab.numberOfLines = 0;
    [self.contentView addSubview: titleLab];
    
    interestLab = [[UILabel alloc] initWithFrame: CGRectZero];
    interestLab.backgroundColor = [UIColor clearColor];
    interestLab.textColor = [UIColor blackColor];
    interestLab.font = [MedGlobal getMiddleFont];
    interestLab.numberOfLines = 0;
    [self.contentView addSubview: interestLab];
    
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
    titleLab.frame = CGRectMake(10, 14, 75, [FontUtil infoHeight:titleLab.text font:[MedGlobal getMiddleFont].pointSize width:80]);
    headerLine.frame = CGRectMake(0, 0, size.width, 1);
    nextImage.frame = CGRectMake(size.width-15, (size.height-10)/2, 5, 10);
    if (titleLab.hidden) {
        headerLine.hidden = YES;
        footerLine.hidden = YES;
        bgView.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        interestLab.textAlignment = NSTextAlignmentCenter;
        interestLab.frame = CGRectMake(15, 20, size.width-30, [FontUtil infoHeight:interestLab.text font:[MedGlobal getMiddleFont].pointSize width:size.width-30]);
    } else {
        headerLine.hidden = NO;
        footerLine.hidden = NO;
        bgView.hidden = NO;
        interestLab.frame = CGRectMake(90, 14, size.width-90-15, [FontUtil infoHeight:interestLab.text font:[MedGlobal getMiddleFont].pointSize width:size.width-90-15]);
    }
    
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    footerLine.frame = CGRectMake(0, size.height-1, size.width, 1);
}

- (void)setInfo:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    if ([dict objectForKey:@"interest"] == nil) {
        titleLab.hidden = YES;
        interestLab.text = [dict objectForKey:@"detail"];
    } else {
        interestLab.text = [dict objectForKey:@"interest"];
    }
    [self layoutSubviews];
}

+ (CGFloat)getCellHeight:(NSDictionary *)dict width:(CGFloat)width
{
    CGFloat height = 14;
    
    if ([dict objectForKey:@"interest"] == nil) {
        height = 40;
        height = height + [FontUtil infoHeight:[dict objectForKey:@"detail"] font:[MedGlobal getMiddleFont].pointSize width:width-30];
    } else {
        height = height + [FontUtil infoHeight:[dict objectForKey:@"interest"] font:[MedGlobal getMiddleFont].pointSize width:width-90-15];
    }
    
    return height+10;
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
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nextImage.hidden) {
        return;
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nextImage.hidden) {
        return;
    }
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nextImage.hidden) {
        return;
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)clickCell
{
    NSLog(@"qwqeqw");
    [self.parent clickCell:nil index:index];
}

@end
