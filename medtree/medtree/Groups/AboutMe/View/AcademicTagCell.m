//
//  AcademicTabCell.m
//  medtree
//
//  Created by 边大朋 on 15/8/7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "AcademicTagCell.h"
#import "ColorUtil.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "FontUtil.h"
#import "AcademicTagDTO.h"

#define LikeImgW 32
#define BgImgW 46
#define BgImgH LikeImgW

@interface AcademicTagCell ()
{
    UIView          *bgView;
    UIImageView     *likeImgView;
    UILabel         *tagLab;
    UILabel         *likeCountLab;
    UIButton        *delBtn;
    UIImageView     *addView;
    
    AcademicTagDTO  *acDTO;
    NSIndexPath     *index;
}
@end

@implementation AcademicTagCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    bgView = [[UIView alloc] init];
    bgView.backgroundColor = [self getRandomColor];
    bgView.userInteractionEnabled = YES;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = LikeImgW / 2;
    bgView.layer.borderColor = [ColorUtil getColor:@"ECECEC" alpha:1].CGColor;
    bgView.layer.borderWidth = 1;
    [self.contentView addSubview:bgView];
    
    likeImgView = [[UIImageView alloc] init];
    [bgView addSubview:likeImgView];
    
    tagLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tagLab.textColor = [ColorUtil getColor:@"000000" alpha:1];
    tagLab.textAlignment = NSTextAlignmentCenter;
    tagLab.font = [MedGlobal getLittleFont];
    [bgView addSubview: tagLab];
    
    likeCountLab = [[UILabel alloc] initWithFrame:CGRectZero];
    likeCountLab.textColor = [ColorUtil getColor:@"000000" alpha:1];
    likeCountLab.textAlignment = NSTextAlignmentCenter;
    likeCountLab.font = [MedGlobal getLittleFont];
    [bgView addSubview: likeCountLab];
    tagLab.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.hidden = YES;
    [delBtn addTarget:self action:@selector(delTags) forControlEvents:UIControlEventTouchUpInside];
    [delBtn setImage:[ImageCenter getBundleImage:@"btn_academic_delete.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:delBtn];
    
    addView = [[UIImageView alloc] init];
    addView.hidden = YES;
    addView.userInteractionEnabled = YES;
    addView.backgroundColor = [UIColor whiteColor];
    addView.image = [ImageCenter getBundleImage:@"btn_manage_academic.png"];
    [self.contentView addSubview:addView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    likeImgView.frame = CGRectMake(0, 0, LikeImgW, LikeImgW);
    CGFloat tagWidth = [FontUtil getTextWidth:acDTO.tagName font:tagLab.font];
    CGFloat likeCountWidth = [FontUtil getTextWidth:acDTO.tagCount font:likeCountLab.font];
    if (acDTO.showType == AcademicTagShowType_Show) {
        bgView.frame = CGRectMake(bounds.origin.x, 0, bounds.size.width, bounds.size.height);
        CGFloat tagHeight = [FontUtil getTextHeight:acDTO.tagName font:tagLab.font width:tagWidth];
        tagLab.frame = CGRectMake(CGRectGetMaxX(likeImgView.frame), (bounds.size.height-tagHeight)/2, tagWidth, tagHeight);
        CGFloat likeCountWidth = [FontUtil getTextWidth:acDTO.tagCount font:likeCountLab.font];
        CGFloat likeCountHeight = [FontUtil getTextHeight:acDTO.tagCount font:likeCountLab.font width:likeCountWidth];
        likeCountLab.frame = CGRectMake(CGRectGetMaxX(tagLab.frame) + 5, (bounds.size.height-likeCountHeight)/2, likeCountWidth, likeCountHeight);
    } else if (acDTO.showType == AcademicTagShowType_Edit) {
        bgView.frame = CGRectMake(bounds.origin.x, 18 / 2, bounds.size.width, bounds.size.height - 18 / 2);
        tagLab.frame = CGRectMake(CGRectGetMaxX(likeImgView.frame), 5, tagWidth, 20);
        likeCountLab.frame = CGRectMake(CGRectGetMaxX(tagLab.frame) + 5, 5, likeCountWidth, 20);
        delBtn.frame = CGRectMake((CGRectGetMaxX(bgView.frame) - 18), 0, 18, 18);
        addView.frame = CGRectMake(0, 18 / 4, 94, 32);
    }
}

- (void)setInfo:(AcademicTagDTO *)dto index:(NSIndexPath *)indexPatch;
{
    acDTO = dto;
    index = indexPatch;
    
    tagLab.text = dto.tagName;
    likeCountLab.text = dto.tagCount;

    addView.hidden = !dto.isAdd;
    bgView.hidden = dto.isAdd;
    self.layer.masksToBounds = !dto.isAdd;
    delBtn.hidden = !dto.isDelStatus;
    
    if (addView.hidden == NO) {
        delBtn.hidden = YES;
    }

    if (dto.isLike) {
        likeImgView.image = [ImageCenter getBundleImage:@"academic_tag_like_clicked.png"];
    } else {
        likeImgView.image = [ImageCenter getBundleImage:@"academic_tag_like.png"];
    }
}

- (UIColor *)getRandomColor
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"fef7f4", @"f7fef8", @"f8f7fc", @"f1fcfe", @"fefeef", nil];
    NSString *color = [array objectAtIndex:arc4random() % array.count];
    return [ColorUtil getColor:color alpha:1];
}

#pragma mark - action
- (void)delTags
{
    if ([self.parent respondsToSelector:@selector(delTag:index:)]) {
        [self.parent delTag:acDTO.tagName index:index];
    }
}

- (void)likeTag
{
    if ([self.parent respondsToSelector:@selector(likeTag:index:)]) {
        [self.parent likeTag:acDTO.tagName index:index];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (!acDTO.isAdd) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        if (CGRectContainsPoint(likeImgView.frame, point)) {
            [self likeTag];
        }
    }
}

#pragma mark - getter
- (UIView *)getBgView
{
    return bgView;
}
@end
