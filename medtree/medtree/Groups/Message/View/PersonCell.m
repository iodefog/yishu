//
//  PersonCell.m
//  medtree
//
//  Created by sam on 8/9/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "PersonCell.h"
#import "DateUtil.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "UserDTO.h"
#import "ColorUtil.h"
#import "OperationHelper.h"
#import "RelationTypes.h"
#import "StatusTypes.h"
#import "FontUtil.h"

@interface PersonCell ()
{
    UserDTO *userDto;
}

@end

@implementation PersonCell

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.isShowIndexs = YES;
    
    depAndTitleLab = [[UILabel alloc] initWithFrame: CGRectZero];
    depAndTitleLab.backgroundColor = [UIColor clearColor];
    depAndTitleLab.textColor = [ColorUtil getColor:@"767676" alpha:1];
    depAndTitleLab.font = [MedGlobal getLittleFont];
    depAndTitleLab.hidden = YES;
    [self addSubview: depAndTitleLab];
    
    vImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    vImage.image = [ImageCenter getBundleImage:@"image_v1.png"];
    vImage.userInteractionEnabled = YES;
    vImage.hidden = YES;
    [self addSubview:vImage];
    
}

- (void)setInfo:(UserDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    userDto = dto;
    //
    //headerView.image = [ImageCenter getBundleImage:@"img_head.png"];
    //
    vImage.hidden = YES;
    if (dto.user_type == 1) {
        vImage.hidden = NO;
        vImage.image = [ImageCenter getBundleImage:@"image_v4.png"];
    } else {
        if (dto.certificate_user_type == 0) {
            vImage.hidden = YES;
        } else {
            if (dto.certificate_user_type == 1) {
                vImage.image = [ImageCenter getBundleImage:@"image_v4.png"];
            } else if (dto.certificate_user_type > 1 && dto.certificate_user_type < 7) {
                vImage.image = [ImageCenter getBundleImage:@"image_v1.png"];
            } else if (dto.certificate_user_type == 7) {
                vImage.image = [ImageCenter getBundleImage:@"image_v2.png"];
            } else if (dto.certificate_user_type == 8) {
                vImage.image = [ImageCenter getBundleImage:@"image_v3.png"];
            } else {
                vImage.image = [ImageCenter getBundleImage:@"image_v5.png"];
            }
            vImage.hidden = NO;
        }
    }
    depAndTitleLab.hidden = NO;
    depAndTitleLab.text = [NSString stringWithFormat:@"%@ %@",dto.department_name.length>0?dto.department_name:@"",dto.title.length>0?dto.title:@""];
    [self setPhoto:dto.photoID imageView:headerView];
    nameLabel.text = dto.name;
    descLabel.text = [NSString stringWithFormat:@"%@", [RelationTypes getLabel:dto.relation]];
    contentLabel.text = dto.organization_name;
    [self setNeedsLayout];
}

- (void)clickHeader
{
//    [self.parent clickCell:idto index:index];
}

- (void)resize:(CGSize)size
{
    [super resize:size];
    CGFloat offsetx = self.isShowIndexs ? 10 : 0;
    descLabel.frame = CGRectMake(size.width/2+40, 10, size.width/2-50-offsetx, 20);
    vImage.frame = CGRectMake(headerView.frame.origin.x+headerView.frame.size.width-12, headerView.frame.origin.y+headerView.frame.size.height-12, 12, 12);
    CGFloat name = [FontUtil getTextWidth:nameLabel.text font:nameLabel.font];
    CGFloat nameLabelW = nameLabel.frame.size.width;
    if (name <= nameLabelW) {
        depAndTitleLab.frame = CGRectMake(70+name+10, 10, size.width-(70+name+10)-10, 20);
    } else {
        depAndTitleLab.frame = CGRectMake(70+nameLabelW+10, 10, size.width-(70+nameLabelW+10)-10, 20);
    }
}

@end
