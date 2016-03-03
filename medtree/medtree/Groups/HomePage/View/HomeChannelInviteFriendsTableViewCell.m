//
//  HomeChannelInviteFriendsTableViewCell.m
//  medtree
//
//  Created by tangshimi on 9/21/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeChannelInviteFriendsTableViewCell.h"
#import "UserDTO.h"
#import "MedGlobal.h"
#import "UIImageView+setImageWithURL.h"

@interface HomeChannelInviteFriendsTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *departmentLabel;
@property (nonatomic, strong) UIImageView *selectImageView;

@end

@implementation HomeChannelInviteFriendsTableViewCell

- (void)createUI
{
    [super createUI];
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.departmentLabel];
    [self.contentView addSubview:self.selectImageView];
    
    [self.headImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
        make.size.equalTo(CGSizeMake(45, 45));
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(10);
        make.top.equalTo(self.headImageView.top);
        if ([MedGlobal isBigPhone]) {
           make.right.equalTo(self.selectImageView).offset(-20);
        } else {
           make.right.equalTo(self.selectImageView).offset(-30);
        }
    }];
    
    [self.selectImageView makeConstraints:^(MASConstraintMaker *make) {
        if ([MedGlobal isBigPhone]) {
            make.right.equalTo(@-25);
        } else {
            make.right.equalTo(@-5);
        }
        make.centerY.equalTo(@0);
    }];
    
    [self.departmentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(10);
        make.top.equalTo(self.nameLabel.bottom);
        make.right.lessThanOrEqualTo(self.selectImageView.left).offset(-10);
    }];
    
    [footerLine makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(64.5, 15, 0, 15));
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
    self.departmentLabel.text = dto.organization_name;
    
    self.selectImageView.image = dto.isSelect ? GetImage(@"home_selected.png") : GetImage(@"home_unselected.png");
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 65;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"img_head.png");
            imageView.layer.cornerRadius = 22.5;
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
            label.font = [UIFont systemFontOfSize:16];
            label;
        });
    }
    return _nameLabel;
}

- (UILabel *)departmentLabel
{
    if (!_departmentLabel) {
        _departmentLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:13];
            label;
        });
    }
    return _departmentLabel;
}

- (UIImageView *)selectImageView
{
    if (!_selectImageView) {
        _selectImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"home_unselected.png");
            imageView;
        });
    }
    return _selectImageView;
}

@end
