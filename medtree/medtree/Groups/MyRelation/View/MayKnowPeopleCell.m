//
//  MayKnowPeopleCell.m
//  medtree
//
//  Created by tangshimi on 6/9/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MayKnowPeopleCell.h"
#import "imageCenter.h"
#import "MedGlobal.h"
#import "UIColor+Colors.h"
#import "FontUtil.h"
#import "UserDTO.h"
#import "UIImageView+setImageWithURL.h"
#import "OperationHelper.h"

@interface MayKnowPeopleCell ()

@property (nonatomic, strong)UIImageView *headImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *recommendLabel;
@property (nonatomic, strong)UILabel *workUnitLabel;
@property (nonatomic, strong)UIButton *addFriendButton;
@property (nonatomic, strong)UserDTO *userDTO;
@property (nonatomic, strong)NSIndexPath *indextPath;

@end

@implementation MayKnowPeopleCell


- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.recommendLabel];
    [self.contentView addSubview:self.workUnitLabel];
    [self.contentView addSubview:self.addFriendButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    footerLine.frame = CGRectMake(isLastCell?0:10, size.height-2, size.width-(isLastCell?0:20), 1);
    self.headImageView.frame = CGRectMake(15, 15, 50, 50);
    CGFloat nameLableWidth = [FontUtil getTextWidth:self.nameLabel.text font:self.nameLabel.font];

    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 10, 20, nameLableWidth, 25);
    self.recommendLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 10,
                                           25,
                                           CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetMaxX(self.nameLabel.frame) - 60,
                                           15);
    self.workUnitLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame), CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetMaxX(self.headImageView.frame) - 60, 15);
    self.addFriendButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 40, (80 - 25) / 2.0, 25, 25);
}

#pragma mark -
#pragma mark - response event -

- (void)addFriendButtonAction:(UIButton *)button
{
    if ([self.parent respondsToSelector:@selector(clickCell:index:action:)]) {
        [self.parent clickCell:self.userDTO index:self.indextPath action:@(ClickAction_FirendAdd)];
    }
}

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{
    self.userDTO = dto;
    self.indextPath = indexPath;
    
    UserDTO *userDto = dto;
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Small], userDto.photoID];
    [self.headImageView med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:[ImageCenter getBundleImage:@"img_head.png"]];
    self.nameLabel.text = userDto.name;
    self.recommendLabel.text = userDto.common_friends_summary;
    self.workUnitLabel.text = userDto.organization_name;
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 80;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        UIImageView *headImageView = [[UIImageView alloc] init];
        headImageView.image = [ImageCenter getBundleImage:@"img_head.png"];
        headImageView.layer.cornerRadius = 25;
        headImageView.layer.masksToBounds = YES;
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

- (UILabel *)recommendLabel
{
    if (!_recommendLabel) {
        UILabel *recommendLabel = [[UILabel alloc] init];
        recommendLabel.textColor = [UIColor colorFromHexString:@"#c1c6d0"];
        recommendLabel.textAlignment = NSTextAlignmentLeft;
        recommendLabel.font = [MedGlobal getTinyLittleFont];
        _recommendLabel = recommendLabel;
    }
    return _recommendLabel;
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

- (UIButton *)addFriendButton
{
    if (!_addFriendButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[ImageCenter getBundleImage:@"relation_add_friend.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[ImageCenter getBundleImage:@"relation_add_friend_click.png"] forState: UIControlStateHighlighted];
        [button addTarget:self action:@selector(addFriendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _addFriendButton = button;
    }
    return _addFriendButton;
}

@end
