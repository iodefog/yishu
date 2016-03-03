//
//  PersonPushToNextInfoCell.m
//  medtree
//
//  Created by 陈升军 on 15/8/5.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "PersonPushToNextInfoCell.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "MedGlobal.h"
#import "PairDTO.h"


@implementation PersonPushToNextInfoCell

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
    
    self.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
    
    titleLab = [[UILabel alloc] init];
    titleLab.textColor = [ColorUtil getColor:@"19233B" alpha:1];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.text = @"标题";
    titleLab.font = [MedGlobal getMiddleFont];
    [self addSubview:titleLab];
    
    contentLab = [[UILabel alloc] init];
    contentLab.textColor = [ColorUtil getColor:@"737373" alpha:1];
    contentLab.backgroundColor = [UIColor clearColor];
    contentLab.text = @"";
    contentLab.textAlignment = NSTextAlignmentRight;
    contentLab.font = [MedGlobal getLittleFont];
    [self addSubview:contentLab];
    
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.userInteractionEnabled = YES;
    nextImage.hidden = NO;
    nextImage.image = [ImageCenter getBundleImage:@"img_next.png"];
    [self addSubview:nextImage];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    [self checkLine];
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    titleLab.frame = CGRectMake(15, 0, size.width-30, size.height);
    contentLab.frame = CGRectMake(15, 0, size.width-35-10, size.height);
    nextImage.frame = CGRectMake(size.width-20, (size.height-10)/2, 5, 10);
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    titleLab.text = dto.key;
    if (dto.value.length > 0) {
        contentLab.text = dto.value;
    }
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 62;
}

@end
