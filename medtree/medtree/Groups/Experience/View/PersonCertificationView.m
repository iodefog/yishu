//
//  PersonCertificationView.m
//  medtree
//
//  Created by 无忧 on 14-11-24.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PersonCertificationView.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "CommonHelper.h"
#import "FontUtil.h"
#import "CertificationDTO.h"
#import "UserType.h"
#import "CertificationStatusType.h"

@implementation PersonCertificationView

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
    
    bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bgView.contentMode = UIViewContentModeScaleToFill;
    [self showBgView:NO];
    bgView.image = [ImageCenter getBundleImage:@"img_trans_cover.png"];
    [self addSubview:bgView];
    
    titleLab = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [MedGlobal getMiddleFont];
    titleLab.numberOfLines = 0;
    [self addSubview:titleLab];
    
    footerLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    footerLine.image = [ImageCenter getBundleImage:@"img_line.png"];
    [self addSubview:footerLine];
    
    detailLab = [[UILabel alloc] initWithFrame: CGRectZero];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.textColor = [ColorUtil getColor:@"777777" alpha:1];
    detailLab.font = [MedGlobal getLittleFont];
    detailLab.numberOfLines = 0;
    [self addSubview: detailLab];
    
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.image = [ImageCenter getBundleImage:@"img_next.png"];
    nextImage.userInteractionEnabled = YES;
//    nextImage.hidden = YES;
    [self addSubview:nextImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    nextImage.frame = CGRectMake(size.width-15, (size.height-10)/2, 5, 10);
    titleLab.frame = CGRectMake(0, 10, [FontUtil getLabelWidth:titleLab labelFont:titleLab.font.pointSize], size.height-20);
    detailLab.frame = CGRectMake([FontUtil getLabelWidth:titleLab labelFont:titleLab.font.pointSize], 10, size.width-15, size.height-20);
    footerLine.frame = CGRectMake(0, size.height-1, size.width-10, 1);
}

- (void)setInfo:(CertificationDTO *)dto indexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag
{
    index = indexPath;
    tagNum = tag;
    if (dto.userType == UserTypes_MedicalTeaching) {
        titleLab.text = @"医学教学/科研/行政";
    } else {
        titleLab.text = [UserType getShortLabel:dto.userType];
    }
    if (dto.status == 0) {
        detailLab.textColor = [ColorUtil getColor:@"f2a30b" alpha:1];
    } else if (dto.status == 1) {
        detailLab.textColor = [ColorUtil getColor:@"22cc0b" alpha:1];
    } else {
        detailLab.textColor = [ColorUtil getColor:@"c87a7a" alpha:1];
    }
    detailLab.text = [NSString stringWithFormat:@" (%@)",[CertificationStatusType getLabel:dto.status]];
    [self layoutSubviews];
}

+ (CGFloat)getCellHeight:(CertificationDTO *)dto width:(CGFloat)width
{
//    CGFloat height = 0;
//    height = 20 + [FontUtil infoHeight:[NSString stringWithFormat:@"%@ (%@)",[UserType getLabel:dto.userType],[CertificationStatusType getLabel:dto.status]] font:[MedGlobal getLittleFont].pointSize width:width-10-15-10];
    return 46;
}

- (void)setIsShowFootLine:(BOOL)isShow
{
    footerLine.hidden = !isShow;
}

- (void)showNext
{
    nextImage.hidden = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self showBgView:YES];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self showBgView:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self showBgView:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self showBgView:NO];
    [self clickCell];
}

- (void)clickCell
{
    NSLog(@"qwqeqw");
    [self.parent clickiViewIndexPath:index tag:tagNum];
}

- (void)showBgView:(BOOL)tf
{
    bgView.alpha = tf ? 0.5 : 0;
}

@end
