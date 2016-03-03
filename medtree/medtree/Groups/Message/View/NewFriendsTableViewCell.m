//
//  NewFriendsTableViewCell.m
//  medtree
//
//  Created by tangshimi on 8/28/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "NewFriendsTableViewCell.h"
#import "UIImageView+setImageWithURL.h"
#import "NotificationDTO.h"
#import "UserManager.h"
#import "UserDTO.h"
#import "OperationHelper.h"

@interface NewFriendsTableViewCell ()
{
    UIImageView *footLines;
}

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation NewFriendsTableViewCell

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.agreeButton];
    [self.contentView addSubview:self.statusLabel];
    
    [self.headImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
    [self.statusLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                    forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(10);
        make.top.equalTo(@10);
        make.right.lessThanOrEqualTo(self.statusLabel.left).offset(-10);
    }];
    
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(10);
        make.top.equalTo(self.nameLabel.bottom).offset(3);
        make.right.lessThanOrEqualTo(self.statusLabel.left).offset(-10);
    }];
    
    [self.agreeButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
    [footerLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    footerLine.hidden = YES;
    /** 6plus 显示问题重新画一条 */
    footLines = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame)-15*2, 0.5)];
    footLines.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    footLines.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_page_cell_line.png"]];
    [self addSubview:footLines];
}

- (void)setInfo:(NotificationDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    if (dto.target != nil) {
        [self loadUserInfo];
    } else {
        NSDictionary *param = @{@"userid": dto.userID};
        [UserManager getUserInfoFull:param success:^(id JSON) {
            [self loadUserDTO:JSON];
        } failure:^(NSError *error, id JSON) {
            
        }];
    }
    self.detailLabel.text = dto.message;
    if (dto.status == NewRelationStatus_Friend_Request) {
        self.statusLabel.hidden = YES;
        self.agreeButton.hidden = dto.processed;
    } else if (dto.status == NewRelationStatus_Friend_Request_Inivte) {
        self.statusLabel.hidden = YES;
        self.agreeButton.hidden = dto.processed;
    } else {
        self.detailLabel.hidden = NO;
        self.agreeButton.hidden = YES;
        self.statusLabel.hidden = NO;
        if (dto.status == NewRelationStatus_Friend_Request_Accept) {
            self.statusLabel.text = @"已添加";
        } else if (dto.status == NewRelationStatus_Friend_Request_Deny) {
            self.statusLabel.text = @"已拒绝";
        } else if (dto.status == NewRelationStatus_Friend_Request_Sent) {
            self.statusLabel.text = @"待验证";
        }
    }
}

- (void)loadUserDTO:(id)JSON
{
    UserDTO *udto = (UserDTO *)JSON;
    ((NotificationDTO *)idto).target = udto;
    [self loadUserInfo];
}

- (void)loadUserInfo
{
    UserDTO *udto = ((NotificationDTO *)idto).target;
    self.nameLabel.text = udto.name;
    
    if (self.detailLabel.text.length == 0) {
        self.detailLabel.text = [NSString stringWithFormat:@"我是%@",udto.name];
    }
    if (((NotificationDTO *)idto).status == NewRelationStatus_Friend_Request_Inivte) {
        if (((NotificationDTO *)idto).message.length == 0) {
            self.detailLabel.text = [NSString stringWithFormat:@"%@ %@",udto.department_name.length>0?udto.department_name:@"",udto.title.length>0?udto.title:@""];
        }
    } else {
        if (((NotificationDTO *)idto).status == NewRelationStatus_Friend_Request_Sent) {
            if (((NotificationDTO *)idto).message.length == 0) {
                self.detailLabel.text = [NSString stringWithFormat:@"%@ %@",udto.department_name.length>0?udto.department_name:@"",udto.title.length>0?udto.title:@""];
            }
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Small], udto.photoID];
    [self.headImageView med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:GetImage(@"img_head.png")];
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 60.0f;
}

#pragma mark -
#pragma mark - response event -

- (void)agreeButtonAction:(UIButton *)button
{
    if ([self.parent respondsToSelector:@selector(clickCell:index:action:)]) {
        [self.parent clickCell:idto index:index action: @(ClickAction_FriendRequestAccept)];
    }
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 20.0f;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
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

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:13];
            label;
        });
    }
    return _detailLabel;
}

- (UIButton *)agreeButton
{
    if (!_agreeButton) {
        _agreeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:GetImage(@"message_add_friend.png") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(agreeButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _agreeButton;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:13];
            label;
        });
    }
    return _statusLabel;
}

@end
