//
//  TitleAndDetailView.m
//  medtree
//
//  Created by 无忧 on 14-9-1.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "TitleAndDetailView.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "ColorUtil.h"
#import "FontUtil.h"

@implementation TitleAndDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)createUI
{
    [super createUI];
    
    isCanSelect = NO;
    self.backgroundColor = [UIColor whiteColor];
    
    bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:bgView];
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [ColorUtil getColor:@"878787" alpha:1];
    titleLab.font = [MedGlobal getMiddleFont];
    titleLab.textAlignment = NSTextAlignmentRight;
    titleLab.text = @"";
    [self addSubview: titleLab];
    
    detailLab = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.textColor = [UIColor blackColor];
    detailLab.font = [MedGlobal getMiddleFont];
    detailLab.textAlignment = NSTextAlignmentLeft;
    detailLab.text = @"";
    detailLab.numberOfLines = 0;
    [self addSubview: detailLab];
    
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.userInteractionEnabled = YES;
    nextImage.hidden = YES;
    nextImage.image = [ImageCenter getBundleImage:@"img_next.png"];
    [self addSubview:nextImage];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    titleLab.frame = CGRectMake(10, 13, 75, 20);
    detailLab.frame = CGRectMake(80+10, 13, size.width-80-10-20, [FontUtil infoHeight:detailLab.text font:[[MedGlobal getMiddleFont] pointSize] width:size.width-80-10-20]>20?[FontUtil infoHeight:detailLab.text font:[[MedGlobal getMiddleFont] pointSize] width:size.width-80-10-20]:20);
    nextImage.frame = CGRectMake(size.width-15, (size.height-10)/2, 5, 10);
}

- (void)setIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag
{
    index = indexPath;
    integer = tag;
}

- (void)setInfo:(NSDictionary *)dict
{
    titleLab.text = @"";
    detailLab.text = @"";
    titleLab.text = [dict objectForKey:@"title"];
    if ((NSObject *)[dict objectForKey:@"detail"] != [NSNull null]) {
        detailLab.text = [dict objectForKey:@"detail"];
    } else {
        detailLab.text = @"";
    }
    if ([titleLab.text isEqualToString:@"共同好友"]) {
        detailLab.textColor = [ColorUtil getColor:@"365c8a" alpha:1];
    }
}

- (void)setIsCanSelect
{
    isCanSelect = YES;
}

- (void)setIsShowNext
{
    nextImage.hidden = NO;
}

+ (CGFloat)getHeight:(NSString *)text width:(CGFloat)width
{
    CGFloat height = [FontUtil infoHeight:text font:[[MedGlobal getLittleFont] pointSize] width:width];
    return height>40?height:40;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isCanSelect == NO) {
        return;
    }
    [super touchesBegan:touches withEvent:event];
    [UIView animateWithDuration:0.5 animations:^{
        bgView.backgroundColor = [UIColor lightGrayColor];
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [UIView animateWithDuration:0.5 animations:^{
        bgView.backgroundColor = [UIColor clearColor];
    }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [UIView animateWithDuration:0.5 animations:^{
        bgView.backgroundColor = [UIColor clearColor];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isCanSelect == NO) {
        return;
    }
    [super touchesEnded:touches withEvent:event];
    [self.parent clickiViewIndexPath:index tag:integer-100];
    [UIView animateWithDuration:0.5 animations:^{
        bgView.backgroundColor = [UIColor clearColor];
    }];
}

@end
