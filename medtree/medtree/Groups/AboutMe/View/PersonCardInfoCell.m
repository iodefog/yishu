//
//  PersonCardInfoCell.m
//  medtree
//
//  Created by 陈升军 on 15/8/3.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "PersonCardInfoCell.h"
#import "UserDTO.h"
//#import "PersonCardInfoAcademicTagsView.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "MedGlobal.h"
#import "FontUtil.h"
#import "AccountHelper.h"
#import "UIImageView+setImageWithURL.h"

@implementation PersonCardInfoCell

- (void)createUI
{
    /**个人基本信息视图**/
    [self createUserView];
    
    /**个人成就信息label**/
    
    userInfoLab = [[UILabel alloc] init];
    userInfoLab.textColor = [ColorUtil getColor:@"626262" alpha:1];
    userInfoLab.backgroundColor = [UIColor clearColor];
    userInfoLab.text = @"个人成就";
    userInfoLab.numberOfLines = 0;
    userInfoLab.font = [MedGlobal getLittleFont];
    [self addSubview:userInfoLab];
    
//    /***底部灰色视图***/
//    footColorView = [[UIView alloc] init];
//    footColorView.backgroundColor = [ColorUtil getColor:@"E9E9E9" alpha:1];
//    [self addSubview:footColorView];
}

- (void)createUserView
{
    userView = [[UIView alloc] init];
    [self addSubview:userView];
    
    userPhotoView = [[UIImageView alloc] initWithImage:[ImageCenter getNamedImage:@"img_head.png"]];
    userPhotoView.layer.cornerRadius = 30;
    userPhotoView.layer.masksToBounds = YES;
    userPhotoView.userInteractionEnabled = YES;
    [userView addSubview:userPhotoView];
    
    vImageView = [[UIImageView alloc] initWithImage:[ImageCenter getNamedImage:@"image_v1.png"]];
    [userView addSubview:vImageView];
    
    nameLab = [[UILabel alloc] init];
    nameLab.textColor = [ColorUtil getColor:@"19233B" alpha:1];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.text = @"姓名";
    nameLab.font = [MedGlobal getLargeFont];
    [userView addSubview:nameLab];
    
    titleLab = [[UILabel alloc] init];
    titleLab.textColor = [ColorUtil getColor:@"616161" alpha:1];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.text = @"职称＋医院";
    titleLab.font = [MedGlobal getLittleFont];
    [userView addSubview:titleLab];
    
    sexImageView = [[UIImageView alloc] initWithImage:[ImageCenter getNamedImage:@"person_gender_icon_man.png"]];
    [userView addSubview:sexImageView];
    
    relationLab = [[UILabel alloc] init];
    relationLab.textColor = [ColorUtil getColor:@"8D919E" alpha:1];
    relationLab.backgroundColor = [UIColor clearColor];
    relationLab.font = [MedGlobal getTinyLittleFont];
    relationLab.text = @"好友关系";
    relationLab.textAlignment = NSTextAlignmentRight;
    [userView addSubview:relationLab];
    
    nextView = [[UIImageView alloc] init];
    nextView.image = [ImageCenter getBundleImage:@"img_next.png"];
    [self addSubview:nextView];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    [self setUserViewSize:size];
//    footColorView.frame = CGRectMake(0, size.height-10, size.width, 10);
    if (((UserDTO *)idto).achievement.length > 0) {
        CGFloat userInfoHeight = [FontUtil getTextHeight:userInfoLab.text font:userInfoLab.font width:size.width-30];
        userInfoLab.frame = CGRectMake(15, userView.frame.size.height, size.width - 30, userInfoHeight);
    }
}

- (void)setUserViewSize:(CGSize)size
{
    userView.frame = CGRectMake(0, 10, size.width, 80);
    userPhotoView.frame = CGRectMake(15, 0, 60, 60);
    vImageView.frame = CGRectMake(15+40, 60-12, 12, 12);
    CGSize nameSize = [nameLab.text sizeWithAttributes:@{NSFontAttributeName:nameLab.font}];
    CGSize relateionSize = [relationLab.text sizeWithAttributes:@{NSFontAttributeName:relationLab.font}];
    CGFloat nameMaxWidth = size.width-(15+60+10)-relateionSize.width-15-16-5-5 - 10;
    CGFloat nameWidth = nameSize.width;
    if (nameSize.width >= nameMaxWidth) {
        nameWidth = nameMaxWidth;
    }
    nameLab.frame = CGRectMake(15+60+10, 10, nameWidth, nameSize.height);
    sexImageView.frame = CGRectMake(CGRectGetMaxX(nameLab.frame) + 5, 14, 16, 16);
    titleLab.frame = CGRectMake(15+60+10, 35, size.width-(15+60+10+15), 20);
    relationLab.frame = CGRectMake(CGRectGetMaxX(sexImageView.frame) + 5, 17, relateionSize.width, relateionSize.height);
    nextView.frame = CGRectMake(size.width - 15 - 5, (size.height - 10) / 2, 5, 10);
}

- (void)setInfo:(UserDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    vImageView.hidden = YES;
    if (dto.user_type == 1) {
        vImageView.hidden = NO;
        vImageView.image = [ImageCenter getBundleImage:@"image_v4.png"];
    } else {
        if (dto.certificate_user_type == 0) {
            vImageView.hidden = YES;
        } else {
            if (dto.certificate_user_type == 1) {
                vImageView.image = [ImageCenter getBundleImage:@"image_v4.png"];
            } else if (dto.certificate_user_type > 1 && dto.certificate_user_type < 7) {
                vImageView.image = [ImageCenter getBundleImage:@"image_v1.png"];
            } else if (dto.certificate_user_type == 7) {
                vImageView.image = [ImageCenter getBundleImage:@"image_v2.png"];
            } else if (dto.certificate_user_type == 8) {
                vImageView.image = [ImageCenter getBundleImage:@"image_v3.png"];
            } else {
                vImageView.image = [ImageCenter getBundleImage:@"image_v5.png"];
            }
            vImageView.hidden = NO;
        }
    }
    nameLab.text = dto.name;
    titleLab.text = [NSString stringWithFormat:@"%@  %@",dto.title,dto.organization_name];

    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Big], dto.photoID];
    [userPhotoView med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:[ImageCenter getBundleImage:@"img_head.png"]];
    
    
    if ([[[AccountHelper getAccount] userID] isEqualToString:dto.userID]) {
        relationLab.text = @"自己";
    } else {
        relationLab.text = dto.relation_summary;
    }
    //下载头像
//    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Big], dto.photoID];
//    [userPhotoView med_setImageWithUrl:[NSURL URLWithString:path]];
    //设置性别图标
    if (dto.gender == 0) {
        sexImageView.hidden = YES;
    } else if (dto.gender == 1) {
        sexImageView.image = [ImageCenter getNamedImage:@"person_gender_icon_man.png"];
    } else {
        sexImageView.image = [ImageCenter getNamedImage:@"person_gender_icon_woman.png"];
    }
    if (indexPath.row > 0) {
        relationLab.hidden = YES;
    }
    NSString *achievementStr;
    if (dto.achievement.length > 90) {
        achievementStr = [NSString stringWithFormat:@"%@...", [dto.achievement substringFromIndex:90]];
    } else {
        achievementStr = dto.achievement;
    }
    userInfoLab.text = achievementStr;
}

+ (CGFloat)getCellHeight:(UserDTO *)dto width:(CGFloat)width
{
    CGFloat height = 80;
    if (dto.achievement.length > 0) {
        NSString *achievementStr;
        if (dto.achievement.length > 90) {
            achievementStr = [NSString stringWithFormat:@"%@...", [dto.achievement substringFromIndex:90]];
        } else {
            achievementStr = dto.achievement;
        }

        height = height + [FontUtil getTextHeight:achievementStr font:[MedGlobal getLittleFont] width:width-30] + 10;
    }
    return height;
}

@end
