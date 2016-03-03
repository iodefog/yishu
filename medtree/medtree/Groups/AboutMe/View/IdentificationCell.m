//
//  IdentificationCell.m
//  medtree
//
//  Created by 无忧 on 14-10-31.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IdentificationCell.h"
#import "PairDTO.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "DateUtil.h"
#import "FontUtil.h"
#import "ImageCenter.h"
#import "JSONKit.h"
#import "TextAndNextImageView.h"

@implementation IdentificationCell

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

    // 图片
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageView];
    
    // 昵称
    titleLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [MedGlobal getMiddleFont];
    [self.contentView addSubview: titleLabel];
    
    // 时间
    timeLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [ColorUtil getColor:@"898989" alpha:1];
    timeLabel.font = [MedGlobal getTinyLittleFont];
    timeLabel.numberOfLines = 0;
    [self.contentView addSubview: timeLabel];
    
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.image = [ImageCenter getBundleImage:@"img_next.png"];
    nextImage.userInteractionEnabled = YES;
    [self addSubview:nextImage];
    
    viewArray = [[NSMutableArray alloc] init];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    [self resize:size];
}

- (void)resize:(CGSize)size
{
    [super resize:size];
    headerLine.frame = CGRectMake(0, 0, size.width, 1);
    footerLine.frame = CGRectMake(0, size.height-1, size.width, 1);
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    imageView.frame = CGRectMake(10, 10, 24, 24);
    nextImage.frame = CGRectMake(size.width-15, 10+7, 5, 10);
    titleLabel.frame = CGRectMake(10+24+10, 12, size.width-(10+24+10)-10, 20);
    timeLabel.frame = CGRectMake(10+24+10, 10+24+4, size.width-(10+24+10)-10, size.height-(10+24+10+4));
    for (int i = 0; i < viewArray.count; i ++) {
        TextAndNextImageView *view = [viewArray objectAtIndex:i];
        view.frame = CGRectMake(0, 44+i*44, size.width, 44);
    }
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        nextImage.hidden = YES;
    }
    index = indexPath;
    imageView.image = [ImageCenter getBundleImage:dto.imageName];
    titleLabel.text = dto.label;
    pairDTO = dto;
    
    if (dto.resourceArray.count > 0) {
        
        for (int i = 0; i < viewArray.count; i ++) {
            TextAndNextImageView *view = [viewArray objectAtIndex:i];
            [view removeFromSuperview];
        }
        [viewArray removeAllObjects];
        for (int i = 0; i < dto.resourceArray.count; i ++) {
            TextAndNextImageView *view = [[TextAndNextImageView alloc] init];
            [view setTitle:[dto.resourceArray objectAtIndex:i] tag:i];
            view.parent = self;
            [self addSubview:view];
            [viewArray addObject:view];
        }
        [self layoutSubviews];
    }
//    timeLabel.text = dto.type;
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

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    CGFloat height = 44+((PairDTO *)dto).resourceArray.count*44;
    return height;
}

- (void)clickCell
{
    [self.parent clickCell:nil index:index];
}

- (void)clickTextAndNextImageView:(NSInteger)tag
{
    pairDTO.cellType = tag;
    [self.parent clickCell:pairDTO index:index];
}

@end
