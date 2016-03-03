//
//  RelationPeopleCell.m
//  medtree
//
//  Created by tangshimi on 6/9/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "RelationPeopleCell.h"
#import "UIColor+Colors.h"
#import "ImageCenter.h"
#import "MedGlobal.h"
#import "FontUtil.h"
#import "UserDTO.h"
#import "UIImageView+setImageWithURL.h"
#import "UserHeadViewButton.h"

@interface RelationPeopleCell ()

@property (nonatomic, strong) UserHeadViewButton *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobTitleLabel;
@property (nonatomic, strong) UILabel *workUnitLabel;

@end

@implementation RelationPeopleCell

- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.jobTitleLabel];
    [self.contentView addSubview:self.workUnitLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    footerLine.frame = CGRectMake(isLastCell?0:10, size.height - 1, size.width - (isLastCell? 0 : 20), 1);
    self.headImageView.frame = CGRectMake(15, 15, 50, 50);
    CGFloat nameLableWidth = [FontUtil getTextWidth:self.nameLabel.text font:self.nameLabel.font];
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 10, 20, nameLableWidth, 25);
    self.jobTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 10,
                                           25,
                                           CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetMaxX(self.nameLabel.frame) - 15,
                                           15);
    self.workUnitLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame),
                                          CGRectGetMaxY(self.nameLabel.frame),
                                          CGRectGetWidth(self.frame) - CGRectGetMaxX(self.headImageView.frame) - 15,
                                          15);
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 80;
}

- (void)setInfo:(UserDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    self.nameLabel.text = dto.name;
    self.jobTitleLabel.text = dto.title;
    self.workUnitLabel.text = dto.organization_name;
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], [dto photoID]];
    self.headImageView.headImageURL = path;
    self.headImageView.certificate_user_type = dto.certificate_user_type;
    if (!dto.anonymous) {
        self.headImageView.levelType = dto.user_type;
    }
}

#pragma mark -
#pragma mark - setter and getter -

- (UserHeadViewButton *)headImageView
{
    if (!_headImageView) {
        UserHeadViewButton *headImageView = [[UserHeadViewButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        headImageView.userInteractionEnabled = NO;
        _headImageView = headImageView;
    }
    return _headImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [MedGlobal getMiddleFont];
        _nameLabel = nameLabel;
    }
    return _nameLabel;
}

- (UILabel *)jobTitleLabel
{
    if (!_jobTitleLabel) {
        UILabel *jobTitleLabel = [[UILabel alloc] init];
        jobTitleLabel.textColor = [UIColor colorFromHexString:@"#767676"];
        jobTitleLabel.textAlignment = NSTextAlignmentLeft;
        jobTitleLabel.font = [MedGlobal getLittleFont];
        _jobTitleLabel = jobTitleLabel;
    }
    return _jobTitleLabel;
}

- (UILabel *)workUnitLabel
{
    if (!_workUnitLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorFromHexString:@"#767676"];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [MedGlobal getLittleFont];
        _workUnitLabel = label;
    }
    return _workUnitLabel;
}

@end
