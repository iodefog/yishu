//
//  ImagePairView.m
//  medtree
//
//  Created by 无忧 on 14-10-10.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "ImagePairView.h"
#import "PairDTO.h"
#import "ImageCenter.h"
#import "MedGlobal.h"

@implementation ImagePairView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    titleLab.text = dto.label;
    iconImage.image = [ImageCenter getBundleImage:dto.imageName];
}

- (void)updateTitle:(NSString *)title
{
    titleLab.text = title;
}

- (void)setInfo:(NSDictionary *)dict
{
    isTouch = YES;
    nextImage.hidden = ![[dict objectForKey:@"showNext"] boolValue];
    if (nextImage.hidden) {
        titleLab.placeholder = [dict objectForKey:@"title"];
    } else {
        titleLab.text = [dict objectForKey:@"title"];
    }
    idxNum = [dict objectForKey:@"tag"];
    
    NSArray *array = [dict allKeys];
    for (NSString *key in array)
    {
        if (  [@"detail" isEqualToString:key ] )
        {
            detailLab.text = [dict objectForKey:@"detail"];
            detailLab.hidden = NO;
            break;
        }
    }
    
    if (detailLab.text.length == 0) {
        detailLab.hidden = YES;
    }
    
    iconImage.image = [ImageCenter getBundleImage:[dict objectForKey:@"image"]];
    headerLine.hidden = NO;
    footerLine.hidden = NO;
    [self layoutSubviews];
}

- (void)createUI
{
    isTouch = NO;
//    self.backgroundColor = [UIColor whiteColor];
    // 昵称
    titleLab = [[UITextField alloc] initWithFrame: CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [MedGlobal getMiddleFont];
    titleLab.enabled = NO;
    [self addSubview: titleLab];
    
    detailLab = [[UILabel alloc] initWithFrame: CGRectZero];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.textColor = [UIColor lightGrayColor];
    detailLab.textAlignment = NSTextAlignmentLeft;
    detailLab.font = [MedGlobal getTinyLittleFont];
    detailLab.enabled = NO;
    detailLab.hidden = YES;
    [self addSubview: detailLab];
    
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.image = [ImageCenter getBundleImage:@"img_next.png"];
    nextImage.userInteractionEnabled = YES;
    [self addSubview:nextImage];
    
    headerLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    headerLine.hidden = YES;
    headerLine.image = [ImageCenter getBundleImage:@"img_line.png"];
    [self addSubview:headerLine];
    
    footerLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    footerLine.hidden = YES;
    footerLine.image = [ImageCenter getBundleImage:@"img_line.png"];
    [self addSubview:footerLine];
    
    iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    iconImage.userInteractionEnabled = YES;
    [self addSubview:iconImage];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    if (nextImage.hidden) {
        iconImage.frame = CGRectMake(0, 0, 48, 48);
    } else {
        iconImage.frame = CGRectMake(10, (size.height-24)/2, 24, 24);
    }
    if (detailLab.hidden) {
        titleLab.frame = CGRectMake(iconImage.frame.origin.x+iconImage.frame.size.width+10, (size.height-20)/2, size.width-(iconImage.frame.origin.x+iconImage.frame.size.width+10), 20);
    } else {
        titleLab.frame = CGRectMake(iconImage.frame.origin.x+iconImage.frame.size.width+10, 5, size.width-(iconImage.frame.origin.x+iconImage.frame.size.width+10), 30);
        detailLab.frame = CGRectMake(iconImage.frame.origin.x+iconImage.frame.size.width+10, 26, size.width-(iconImage.frame.origin.x+iconImage.frame.size.width+10), 18);
    }
    
    nextImage.frame = CGRectMake(size.width-15, (size.height-10)/2, 5, 10);
    headerLine.frame = CGRectMake(0, 0, size.width, 1);
    footerLine.frame = CGRectMake(0, size.height-1, size.width, 1);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!isTouch) {
        return;
    }
    self.backgroundColor = [UIColor lightGrayColor];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (!isTouch) {
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if (!isTouch) {
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (!isTouch) {
        return;
    }
    [self.parent clickImagePairView:idxNum];
    self.backgroundColor = [UIColor whiteColor];
}

@end
