//
//  NewCommonCell.m
//  medtree
//
//  Created by 边大朋 on 15-4-17.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewCommonCell.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "UserDTO.h"
#import "UserManager.h"
#import "ImageCenter.h"
#import "UIImageView+setImageWithURL.h"

@interface NewCommonCell ()
{
    UserDTO *userDTO;
    UIImageView *footLines;
}
@end

@implementation NewCommonCell

- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor clearColor];
    // 头像
    headImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 25;
    headImage.userInteractionEnabled = YES;
    [self addSubview:headImage];
    
    // 昵称
    nameLab = [[UILabel alloc] initWithFrame: CGRectZero];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.textColor = [ColorUtil getColor:@"00001F" alpha:1];
    nameLab.font = [MedGlobal getLargeFont];
    [self addSubview: nameLab];
    
    //描述
    descLab = [[UILabel alloc] initWithFrame: CGRectZero];
    descLab.backgroundColor = [UIColor clearColor];
    descLab.textAlignment = NSTextAlignmentLeft;
    descLab.textColor = [ColorUtil getColor:@"909091" alpha:1];
    descLab.font = [MedGlobal getLittleFont];
    descLab.numberOfLines = 0;
    [self addSubview: descLab];
    
    footerLine.hidden = YES;
    /** 6plus 显示问题重新画一条 */
    footLines = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame)-15*2, 0.5)];
    footLines.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    footLines.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_page_cell_line.png"]];
    [self addSubview:footLines];
}

- (void)layoutSubviews
{
    CGFloat sideSpace = 15;
    CGFloat space = 10;
    CGFloat topSpace = 15;
    
    CGSize size = self.frame.size;
    headImage.frame = CGRectMake(sideSpace,topSpace, 50, 50);
    nameLab.frame = CGRectMake(CGRectGetMaxX(headImage.frame)+space, topSpace+5, size.width-36-2*sideSpace-space, 20);
    descLab.frame = CGRectMake(nameLab.frame.origin.x, CGRectGetMaxY(nameLab.frame)+5, nameLab.frame.size.width, 20);
}

- (void)setInfo:(UserDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    nameLab.text = dto.name;
    descLab.text = dto.organization_name;
    [self setPhoto:dto.photoID imageView:headImage];
    
}

- (void)setPhoto:(NSString *)photoID imageView:(UIImageView *)imageView
{
    headImage.image = [ImageCenter getBundleImage:@"img_head.png"];
    if (photoID.length > 0) {
        NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Small], photoID];
        [imageView med_setImageWithUrl:[NSURL URLWithString:path]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self showBgView:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.parent clickCell:idto index:index];
    [self showBgView:NO];
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 80;
}


@end
