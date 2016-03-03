//
//  HomePageCommonCell.m
//  medtree
//
//  Created by 陈升军 on 15/3/26.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "HomePageCommonCell.h"
#import "PairDTO.h"
#import "BadgeView.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "FontUtil.h"
#import "UIImageView+setImageWithURL.h"

@implementation HomePageCommonCell

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor clearColor];
    
    headerImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    headerImage.userInteractionEnabled = YES;
    [self addSubview:headerImage];
    
    titleLab = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [MedGlobal getTitleTextCommonColor];
    titleLab.font = [MedGlobal getLargeFont];
    [self.contentView addSubview: titleLab];
    
    bgDetailLab = [[UILabel alloc] initWithFrame: CGRectZero];
    bgDetailLab.backgroundColor = [UIColor lightGrayColor];
    bgDetailLab.layer.cornerRadius = 4;
    bgDetailLab.layer.masksToBounds = YES;
    [self.contentView addSubview:bgDetailLab];
    
    detailLab = [[UILabel alloc] initWithFrame: CGRectZero];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.textColor = [UIColor whiteColor];
    detailLab.font = [MedGlobal getTinyLittleFont];
  //  detailLab.textAlignment = NSTextAlignmentRight;
    [bgDetailLab addSubview: detailLab];
    
    userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    userImage.image = [ImageCenter getBundleImage:@"image_v1.png"];
    userImage.userInteractionEnabled = YES;
    userImage.hidden = YES;
    userImage.layer.cornerRadius = 15;
    userImage.layer.masksToBounds = YES;
    [self addSubview:userImage];
    
    badgeView = [[BadgeView alloc] initWithFrame:CGRectZero];
    [self addSubview:badgeView];
    
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.image = [ImageCenter getBundleImage:@"setting_img_arrow.png"];
    nextImage.userInteractionEnabled = YES;
    [self addSubview:nextImage];
    
    decLab = [[UILabel alloc] initWithFrame: CGRectZero];
    decLab.backgroundColor = [UIColor clearColor];
    decLab.textColor = [UIColor lightGrayColor];
    decLab.font = [MedGlobal getTinyLittleFont];
    [self addSubview:decLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    isLastCell = [self.parent isLastCell:index];
    headerLine.frame = CGRectMake(10, 0, size.width-20, 1);
    footerLine.frame = CGRectMake(isLastCell?0:10, size.height-0.5, size.width-(isLastCell?0:20), 0.5);
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    headerImage.frame = CGRectMake(15, (size.height-46)/2, 46, 46);
    nextImage.frame = CGRectMake(size.width-24-5, (size.height-10)/2, 9, 14);
    
    CGFloat off = 25;
    
    if (!badgeView.hidden) {
        if ([((PairDTO *)idto).badge isEqualToString:@"round_red_label"]) {
            nextImage.hidden = NO;
            badgeView.frame = CGRectMake(size.width-30-15, (size.height-16)/2, 16, 16);
        } else {
            off = 25 + 30;
            nextImage.hidden = YES;
            userImage.frame = CGRectMake(size.width-off, (size.height-30)/2, 30, 30);
            badgeView.frame = CGRectMake(userImage.frame.origin.x+28, userImage.frame.origin.y-2, 16, 16);
        }
    } else {
        nextImage.hidden = NO;
    }
    if (decLab.hidden) {
        titleLab.frame = CGRectMake(headerImage.frame.origin.x+headerImage.frame.size.width+10, (size.height-30)/2, size.width-(headerImage.frame.origin.x+headerImage.frame.size.width+10+off), 30);
    } else {
        titleLab.frame = CGRectMake(headerImage.frame.origin.x+headerImage.frame.size.width+10, (size.height-30-20)/2, size.width-(headerImage.frame.origin.x+headerImage.frame.size.width+10+off), 30);
        decLab.frame = CGRectMake(headerImage.frame.origin.x+headerImage.frame.size.width+10, titleLab.frame.origin.y+titleLab.frame.size.height, size.width-(headerImage.frame.origin.x+headerImage.frame.size.width+10+off), 20);
    }
    
    
    bgDetailLab.frame = CGRectMake(size.width-15-9-12-[FontUtil getLabelWidth:detailLab labelFont:detailLab.font.pointSize], size.height/2-(14/2), [FontUtil getLabelWidth:detailLab labelFont:detailLab.font.pointSize]+4, 18);
    detailLab.frame = CGRectMake(2, bgDetailLab.frame.size.height/2-[FontUtil getLabelHeight:detailLab labelFont:detailLab.font.pointSize]/2, [FontUtil getLabelWidth:detailLab labelFont:detailLab.font.pointSize], [FontUtil getLabelHeight:detailLab labelFont:detailLab.font.pointSize]);
    
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    if (dto.cellType == 1) {
        headerLine.hidden = NO;
    } else {
        headerLine.hidden = YES;
        if (dto.isShowHeaderLine) {
            headerLine.hidden = NO;
        } else {
            headerLine.hidden = YES;
        }
    }
    
    if (dto.isHideFootLine) {
        footerLine.hidden = YES;
    } else {
        footerLine.hidden = NO;
    }
    
    headerImage.image = [ImageCenter getBundleImage:dto.imageName];
    titleLab.text = dto.key;
    detailLab.text = dto.value;
    decLab.text = dto.label;
    if (dto.label.length > 0) {
        decLab.hidden = NO;
    } else {
        decLab.hidden = YES;
    }
    if (dto.badge.length == 0) {
        userImage.hidden = YES;
        badgeView.hidden = YES;
    } else {
        if ([dto.badge isEqualToString:@"round_red_label"]) {
            
        } else {
            userImage.hidden = NO;
            [self setPhoto:dto.badge imageView:userImage];
        }
        badgeView.hidden = NO;
        [badgeView setIsShowRoundView:YES];
    }
    if (dto.value.length == 0) {
        bgDetailLab.hidden = YES;
    }
}

- (void)setPhoto:(NSString *)photoID imageView:(UIImageView *)imageView
{
    if (photoID.length > 0) {
        NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Small], photoID];
        [userImage med_setImageWithUrl:[NSURL URLWithString:path]];
    }
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    if ([MedGlobal isBigPhone]) {
        return 80;
    }
    return 70;
}

- (void)clickCell
{
    if (((PairDTO *)idto).badge.length > 0) {
        userImage.hidden = YES;
        badgeView.hidden = YES;
        [badgeView setIsShowRoundView:NO];
        userImage.image = [ImageCenter getBundleImage:@""];
        [self layoutSubviews];
    }
    [self.parent clickCell:idto index:index];
}

- (id)getDTO
{
    return idto;
}

@end
