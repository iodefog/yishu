//
//  MyRelationMayKnowPeopleTableViewCell.m
//  medtree
//
//  Created by tangshimi on 8/4/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MyRelationMayKnowPeopleTableViewCell.h"
#import "UserDTO.h"
#import "MedGlobal.h"
#import "UIButton+setImageWithURL.h"
#import "NSString+Extension.h"
#import "UIColor+Colors.h"
#import "UserHeadViewButton.h"

@interface MyRelationMayKnowPeopleTableViewCell ()

@property (nonatomic, strong) UserHeadViewButton *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *organizationLabel;
@property (nonatomic, strong) UIButton *addFriendButton;
@property (nonatomic, strong) UserDTO *userDTO;

@end

@implementation MyRelationMayKnowPeopleTableViewCell

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.organizationLabel];
    [self.contentView addSubview:self.addFriendButton];
    
    [self.headImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    
    [self.addFriendButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(10);
        make.top.equalTo(@10);
        make.right.lessThanOrEqualTo(self.addFriendButton.left).offset(-5);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.centerY);
        make.left.equalTo(self.nameLabel.right).offset(10);
        make.right.lessThanOrEqualTo(self.addFriendButton.left).offset(-5);
    }];
    
    [self.organizationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(10);
        make.top.equalTo(self.nameLabel.bottom);
        make.width.lessThanOrEqualTo(GetScreenWidth - 75 - 54 - 15 - 10);
    }];
    
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(10);
        make.top.equalTo(self.organizationLabel.bottom);
        make.width.lessThanOrEqualTo(GetScreenWidth - 75 - 54 - 15 - 10);
    }];
}

- (void)setInfo:(UserDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    idto = dto;
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Small], dto.photoID];
    self.headImageView.headImageURL = path;
    self.headImageView.levelType = dto.user_type;
    self.headImageView.certificate_user_type = dto.certificate_user_type;
    
    self.nameLabel.text = dto.name;
    self.titleLabel.text =  dto.title;
    self.organizationLabel.text = dto.organization_name;
    
    NSString *str = nil;
    
    switch (dto.relation) {
        case 0:
            str = @"陌生人";
            break;
        case 1:
            str = @"好友";
            break;
        case 2:
            str = @"自己";
            break;
        case 3:
            str = @"私密好友";
            break;
        case 10:
            str = @"同学";
            break;
        case 12:
            str = @"校友";
            break;
        case 13:
            str = @"导师";
            break;
        case 20:
            str = @"同事";
            break;
        case 22:
            str = @"同行";
            break;
        case 30:
            str = @"学会会员";
            break;
        case 90:
            str = @"好友的好友";
            break;
        case 100:
            break;
        default:
            break;
    }
    self.detailLabel.text = str;
    
    footerLine.frame = CGRectMake(15, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame) - 30, 0.5);
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 70.0f;
}

#pragma mark -
#pragma mark - response event -

- (void)addFriendButtonAction:(UIButton *)button
{
    if ([self.parent respondsToSelector:@selector(clickCell:index:action:)]) {
        [self.parent clickCell:idto index:index action:0];
    }
}

#pragma mark -
#pragma mark - setter and getter -

- (UserHeadViewButton *)headImageView
{
    if (!_headImageView) {
        _headImageView = ({
            UserHeadViewButton *imageView = [[UserHeadViewButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
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
            label.textColor = [UIColor colorFromHexString:@"#207878"];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:16];
            label;
        });
    }
    return _nameLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:13];
            label;
         });
    }
    return _detailLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:13];
            label;
        });
    }
    return _titleLabel;
}

- (UILabel *)organizationLabel
{
    if (!_organizationLabel) {
        _organizationLabel =  ({
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:13];
            label;
        });
    }
    return _organizationLabel;
}

- (UIButton *)addFriendButton
{
    if (!_addFriendButton) {
        _addFriendButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(addFriendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:GetImage(@"myrelation_add_friend.png") forState:UIControlStateNormal];
            button;
        });
    }
    return _addFriendButton;
}

@end
