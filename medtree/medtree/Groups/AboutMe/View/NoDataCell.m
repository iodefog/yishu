//
//  noDataCell.m
//  medtree
//
//  Created by 边大朋 on 15/12/3.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "NoDataCell.h"
#import "ImageCenter.h"

@interface NoDataCell ()
{
    UIImageView *imageView;
}
@end

@implementation NoDataCell

- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor clearColor];
    imageView = [[UIImageView alloc] init];
    imageView.image = [ImageCenter getBundleImage:@"img_no_data.png"];
    footerLine.hidden = YES;
    [self addSubview:imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    NSString *phone = [MedGlobal getPhone];
    CGFloat height = 40;
    if ([phone isEqualToString: @"iPhone4"]) {
        height = 15;
    }
    imageView.frame = CGRectMake((size.width - 259 / 2) / 2, height, 259 / 2, 184 / 2);
}

#pragma mark - cell height
+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 184 / 2;
}

@end
