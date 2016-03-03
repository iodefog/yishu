//
//  RelationCommonCell.m
//  medtree
//
//  Created by tangshimi on 6/10/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "RelationCommonCell.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "RelationDTO.h"

@interface RelationCommonCell ()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *peopleNumberLabel;
@property (nonatomic, strong)UIImageView *arrowImageView;
@property (nonatomic, strong)id DTO;

@end

@implementation RelationCommonCell

- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.peopleNumberLabel];
    [self.contentView addSubview:self.arrowImageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    footerLine.frame = CGRectMake(isLastCell ? 0 : 10, size.height + 0.5, size.width-(isLastCell ? 0 : 20), 1);
    self.titleLabel.frame = CGRectMake(10, 0, CGRectGetWidth(self.frame) - 90, CGRectGetHeight(self.frame));
    self.arrowImageView.frame = CGRectMake(CGRectGetWidth(self.frame) - 26, 0, 9, CGRectGetHeight(self.frame));
    self.peopleNumberLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - 26 - 8 - 50, 0, 50, CGRectGetHeight(self.frame));
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 60;
}

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{
    self.DTO = dto;
    RelationDTO *relationDTO = (RelationDTO *)dto;
    self.titleLabel.text = relationDTO.name;
    self.peopleNumberLabel.text = relationDTO.count;
}

- (void)clickCell
{
    if ([self.parent respondsToSelector:@selector(clickCell:index:)]) {
        [self.parent clickCell:self.DTO index:nil];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setter and getter -
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [MedGlobal getLargeFont];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)peopleNumberLabel
{
    if (!_peopleNumberLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [MedGlobal getLittleFont];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentRight;
        _peopleNumberLabel = label;
    }
    return _peopleNumberLabel;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [ImageCenter getBundleImage:@"setting_img_arrow.png"];
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImageView = arrowImageView;
    }
    return _arrowImageView;
}

@end
