//
//  MyCareerCell.m
//  medtree
//
//  Created by 边大朋 on 15/10/21.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "MyCareerCell.h"
#import "ImageCenter.h"
#import "Pair2DTO.h"

@interface MyCareerCell ()
{
    UILabel *keyLabel;
    UILabel *valueLabel;
    UIImageView *nextView;
    UIImageView *headerView;
    UILabel *experienceTimeLabel;
}
@end

#define MARGIN 15
#define HEADER 34
#define NEXT_IMAGE_WIDTH 5
#define NEXT_IMAGE_HEIGHT 10

@implementation MyCareerCell

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor whiteColor];
    
    keyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    keyLabel.backgroundColor = [UIColor clearColor];
    keyLabel.textColor = [ColorUtil getColor:@"141A2D" alpha:1];
    keyLabel.textAlignment = NSTextAlignmentLeft;
    keyLabel.font = [MedGlobal getMiddleFont];
    [self.contentView addSubview: keyLabel];
    
    headerView = [[UIImageView alloc] init];
    headerView.layer.cornerRadius = HEADER / 2;
    headerView.layer.masksToBounds = YES;
    headerView.userInteractionEnabled = YES;
    [self.contentView addSubview:headerView];
    
    nextView = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextView.userInteractionEnabled = YES;
    nextView.image = [ImageCenter getBundleImage:@"img_next.png"];
    [self.contentView addSubview:nextView];
    
    experienceTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    experienceTimeLabel.backgroundColor = [UIColor clearColor];
    experienceTimeLabel.textColor = [ColorUtil getColor:@"606060" alpha:1];
    experienceTimeLabel.textAlignment = NSTextAlignmentLeft;
    experienceTimeLabel.font = [MedGlobal getTinyLittleFont];
    [self.contentView addSubview: experienceTimeLabel];
}

- (void)setInfo:(Pair2DTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    keyLabel.text = dto.title;
    footerLine.hidden = NO;
    if (indexPath.row == 0) {
        headerView.image = [ImageCenter getBundleImage:@"icon_position.png"];
    } else if (indexPath.row == 1) {
        isLastCell = YES;
        headerView.image = [ImageCenter getBundleImage:@"icon_resume.png"];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    CGSize keySize = [keyLabel.text sizeWithAttributes:@{NSFontAttributeName:keyLabel.font}];
    footerLine.frame = CGRectMake(isLastCell ? 0 : 15, size.height - 0.5, size.width - 2 * (isLastCell ? 0 : 15), 0.5);

    nextView.frame = CGRectMake(size.width - MARGIN -NEXT_IMAGE_WIDTH, (size.height - NEXT_IMAGE_HEIGHT) / 2, NEXT_IMAGE_WIDTH, NEXT_IMAGE_HEIGHT);
    headerView.frame = CGRectMake(MARGIN, (size.height - HEADER) / 2, HEADER, HEADER);
    keyLabel.frame = CGRectMake(CGRectGetMaxX(headerView.frame) + 5, (size.height - keySize.height) / 2, keySize.width, keySize.height);
}

+ (CGFloat)getCellHeight:(Pair2DTO *)dto width:(CGFloat)width
{
    return 65;
}

- (void)clickCell
{
    [self.parent clickCell:idto index:index];
}
@end
