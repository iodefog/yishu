//
//  MyConcernEnterpriseCell.m
//  medtree
//
//  Created by 边大朋 on 15/10/21.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "MyConcernEnterpriseCell.h"
#import "ImageCenter.h"
#import "PairDTO.h"
#import "UIImageView+setImageWithURL.h"

#define MARGIN 15
#define HEADER 34

@interface MyConcernEnterpriseCell ()
{
    UILabel *keyLabel;
    UILabel *valueLabel;
    UIImageView *headerView;
    UILabel *experienceTimeLabel;
}
@end

@implementation MyConcernEnterpriseCell

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    self.backgroundColor = [ColorUtil getColor:@"F1F1F5" alpha:1];
    
    keyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    keyLabel.backgroundColor = [UIColor clearColor];
    keyLabel.textColor = [ColorUtil getColor:@"141A2D" alpha:1];
    keyLabel.textAlignment = NSTextAlignmentLeft;
    keyLabel.font = [MedGlobal getMiddleFont];
    [self addSubview: keyLabel];
    
    valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.textColor = [ColorUtil getColor:@"606060" alpha:1];
    valueLabel.textAlignment = NSTextAlignmentLeft;
    valueLabel.font = [MedGlobal getTinyLittleFont];
    [self addSubview: valueLabel];
    
    headerView = [[UIImageView alloc] init];
    headerView.layer.cornerRadius = HEADER / 2;
    headerView.layer.masksToBounds = YES;
    headerView.userInteractionEnabled = YES;
    [self addSubview:headerView];
    
    experienceTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    experienceTimeLabel.backgroundColor = [UIColor clearColor];
    experienceTimeLabel.textColor = [ColorUtil getColor:@"606060" alpha:1];
    experienceTimeLabel.textAlignment = NSTextAlignmentLeft;
    experienceTimeLabel.font = [MedGlobal getTinyLittleFont];
    [self addSubview: experienceTimeLabel];
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Big], dto.imageName];
    [headerView med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:[ImageCenter getBundleImage:@"img_head.png"]];

    keyLabel.text = dto.key;
    valueLabel.text = dto.value;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    CGSize keySize = [keyLabel.text sizeWithAttributes:@{NSFontAttributeName:keyLabel.font}];
    CGSize valueSize = [valueLabel.text sizeWithAttributes:@{NSFontAttributeName:valueLabel.font}];
    
    footerLine.frame = CGRectMake(MARGIN, size.height - 0.5, size.width - MARGIN * 2, 0.5);
    headerView.frame = CGRectMake(MARGIN, (size.height - HEADER) / 2, HEADER, HEADER);
    keyLabel.frame = CGRectMake(CGRectGetMaxX(headerView.frame) + 5, (keySize.height + valueSize.height + 5) / 2, keySize.width, keySize.height);
    valueLabel.frame = CGRectMake(MARGIN, CGRectGetMaxY(keyLabel.frame) + 5, valueSize.width, valueSize.height);
}

+ (CGFloat)getCellHeight:(PairDTO *)dto width:(CGFloat)width
{
    return 65;
}
@end
