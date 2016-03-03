//
//  HomeJobChannelUnitRelationTableViewCell.m
//  medtree
//
//  Created by tangshimi on 10/26/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelUnitRelationTableViewCell.h"
#import "UIImageView+setImageWithURL.h"
#import "UserDTO.h"
#import "UIColor+Colors.h"

@interface HomeJobChannelUnitRelationTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIButton *addFriendButton;

@end

@implementation HomeJobChannelUnitRelationTableViewCell

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor colorFromHexString:@"#F4F4F7"];
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.unitLabel];
    [self.contentView addSubview:self.addFriendButton];
    
    [self.headImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(15);
        make.bottom.equalTo(-15);
        make.width.equalTo(self.headImageView.height);
    }];
    
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(10);
        make.top.equalTo(self.headImageView.top).offset(5);
    }];
    
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.right).offset(10);
        make.baseline.equalTo(self.nameLabel.baseline);
        make.right.lessThanOrEqualTo(self.addFriendButton.left).offset(-10);
    }];

    [self.unitLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.unitLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.top.equalTo(self.nameLabel.bottom).offset(3);
        make.right.lessThanOrEqualTo(self.addFriendButton.left).offset(-10);
    }];

    [self.addFriendButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-30);
        make.centerY.equalTo(0);
    }];
}

- (void)setInfo:(UserDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], [dto photoID]];
    [self.headImageView med_setImageWithUrl:[NSURL URLWithString:path]
                           placeholderImage: GetImage(@"img_head.png")];

    self.nameLabel.text = dto.name;
    self.titleLabel.text = dto.title;
    self.unitLabel.text =  dto.department_name;
    
    if (dto.relation == 1) {
        [self.addFriendButton setImage:GetImage(@"home_enterprise_relation.png") forState:UIControlStateNormal];
        self.addFriendButton.userInteractionEnabled = NO;
    } else if (dto.relation == 0) {
        [self.addFriendButton setImage:GetImage(@"relation_add_friend.png") forState:UIControlStateNormal];
        self.addFriendButton.userInteractionEnabled = YES;
    }
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 80.0f;
}

#pragma mark -
#pragma mark - response event -

- (void)addFriendButtonAction:(UIButton *)button
{
    if ([self.parent respondsToSelector:@selector(clickCell:index:action:)]) {
        [self.parent clickCell:idto index:index action:@0];
    }
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 25;
            imageView.clipsToBounds = YES;
            imageView;
        });
    }
    return _headImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:18];
            label;
        });
    }
    return _nameLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:15];
            label;
        });
    }
    return _titleLabel;
}

- (UILabel *)unitLabel
{
    if (!_unitLabel) {
        _unitLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:15];
            label;
        });
    }
    return _unitLabel;
}

- (UIButton *)addFriendButton
{
    if (!_addFriendButton) {
        _addFriendButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:GetImage(@"relation_add_friend.png") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(addFriendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _addFriendButton;
}

@end
