//
//  NewFeedLikesCell.m
//  medtree
//
//  Created by 边大朋 on 15-4-12.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "FeedLikesCell.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "PairDTO.h"
#import "ColorUtil.h"
#import "NSString+Extension.h"

@interface FeedLikesCell ()
{
    /** 背景 */
    UIView           *likesView;
    /** 赞名字 */
    UILabel          *likesLabel;
    /** 赞 */
    UIImageView      *likeImgView;
    /** 箭头 */
    UIImageView      *arrowImgView;
    /** 分割线 */
    UILabel          *lineLabel;
}


@end

@implementation FeedLikesCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor whiteColor];
    
    footerLine.hidden = YES;
    
    likesView = [[UIView alloc] init];
    likesView.backgroundColor = [ColorUtil getColor:@"E4E4E8" alpha:1];
    [self.contentView addSubview:likesView];
    
    likesLabel = [[UILabel alloc] init];
    likesLabel.numberOfLines = 0;
    likesLabel.textColor = [ColorUtil getColor:@"005352" alpha:1];
    likesLabel.font = [MedGlobal getLittleFont];
    likesLabel.hidden = NO;
    [likesView addSubview: likesLabel];
    
    likeImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    likeImgView.image = GetImage(@"feed_likes.png");
    [likesView addSubview:likeImgView];
    
    arrowImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowImgView.image =  GetImage(@"feed_img_guide.png");
    [self.contentView addSubview:arrowImgView];
    
    lineLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    lineLabel.backgroundColor = [ColorUtil getColor:@"D0D0D2" alpha:1];
    lineLabel.hidden = YES;
    [likesView addSubview: lineLabel];
    
    [arrowImgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@75);
        make.height.equalTo(8);
    }];
    
    [likesView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@65);
        make.top.equalTo(arrowImgView.bottom).offset(-1);
        make.right.equalTo(@-15);
        make.bottom.equalTo(@0);
    }];
    
    [likeImgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.top.equalTo(5);
    }];
    
    [likesLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.top.equalTo(0);
        make.bottom.equalTo(0);
        make.right.lessThanOrEqualTo(@0);
    }];
    
    [lineLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@0);
    }];
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    likesLabel.text = [NSString stringWithFormat:@"    %@", dto.key];
    
    lineLabel.hidden = dto.isHideFootLine;
}

+ (CGFloat)getCellHeight:(PairDTO *)dto width:(CGFloat)width
{
    NSString *text = [NSString stringWithFormat:@"    %@", dto.key];
    CGFloat textHeight = [NSString sizeForString:text Size:CGSizeMake(GetScreenWidth - 85, MAXFLOAT) Font:[MedGlobal getLittleFont]].height;
    return textHeight + 7 + 6;
}

@end
