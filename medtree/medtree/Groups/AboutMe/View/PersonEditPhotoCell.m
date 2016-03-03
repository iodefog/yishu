//
//  PersonEditPhotoCell.m
//  medtree
//
//  Created by 无忧 on 14-9-16.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PersonEditPhotoCell.h"
#import "ImageCenter.h"
#import "UserDTO.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "UIImageView+setImageWithURL.h"

@implementation PersonEditPhotoCell

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
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [ColorUtil getColor:@"878787" alpha:1];
    titleLab.textAlignment = NSTextAlignmentRight;
    titleLab.font = [MedGlobal getMiddleFont];
    titleLab.text = @"编辑头像";
    [self addSubview: titleLab];
    
    photoImage = [[UIImageView alloc] init];
    photoImage.layer.cornerRadius = 17;
    photoImage.layer.masksToBounds = YES;
    photoImage.userInteractionEnabled = YES;
    photoImage.image = [ImageCenter getBundleImage:@"img_head.png"];
    photoImage.userInteractionEnabled = YES;
    [self addSubview:photoImage];
    
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
    titleLab.frame = CGRectMake(10, 0, 75, size.height);
    headerLine.frame = CGRectMake(0, 0, size.width, 0.5);
    footerLine.frame = CGRectMake(0, size.height-0.5, size.width, 0.5);
    photoImage.frame = CGRectMake(size.width-40, (size.height-34)/2, 34, 34);
    nextImage.frame = CGRectMake(size.width-15, (size.height-10)/2, 5, 10);
}

- (void)setInfo:(UserDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    if ([imagePath isEqualToString:dto.photoID] == NO) {
        NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Small], dto.photoID];
        [photoImage med_setImageWithUrl:[NSURL URLWithString:path]];
        imagePath = dto.photoID;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self clickHeader];
}

- (void)clickHeader
{
    [self.parent clickCell:nil index:index];
}

@end
