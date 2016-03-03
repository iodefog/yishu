//
//  ChatTableViewCell.m
//  medtree
//
//  Created by tangshimi on 8/25/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "UIColor+Colors.h"
#import "SessionDTO.h"
#import "UIImageView+setImageWithURL.h"
#import "UserManager.h"
#import "DateUtil.h"
#import "UserDTO.h"

@interface MessageTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageNumberLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation MessageTableViewCell

- (void)createUI
{
    [super createUI];
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.messageNumberLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.headImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(10);
        make.top.equalTo(@15);
        make.right.lessThanOrEqualTo(self.timeLabel.left).offset(-10);
    }];
    
    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                    forAxis:UILayoutConstraintAxisHorizontal];

    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.right.equalTo(@-15);
    }];
    
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(10);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
        make.right.lessThanOrEqualTo(self.timeLabel.left).offset(-10);
    }];
    
    [self.messageNumberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.bottom).equalTo(8);
        make.right.equalTo(@-15);
    }];
    
    [footerLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.right.equalTo(@-15);
        make.left.equalTo(@15);
        make.height.equalTo(@0.5);
    }];
}

- (void)setInfo:(SessionDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    if (dto.type == 1) {
        [self.titleLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.centerY);
            make.left.equalTo(self.headImageView.right).offset(10);
        }];
        
        self.headImageView.image = GetImage([dto.ext objectForKey:@"image"]);
        self.titleLabel.text = [dto.ext objectForKey:@"title"];
        self.detailLabel.text = @"";
        self.timeLabel.text = @"";
        
        if (dto.unreadCount > 0) {
            self.messageNumberLabel.text = [NSString stringWithFormat:@"%@", @(dto.unreadCount)];
            [self.messageNumberLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(@0);
                make.right.equalTo(@-15);
                make.width.greaterThanOrEqualTo(@20);
                make.height.equalTo(@20);
            }];
        } else {
            self.messageNumberLabel.text = @"";
            [self.messageNumberLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.timeLabel.bottom).equalTo(8);
                make.right.equalTo(@-15);
            }];
        }
    } else if (dto.type == 0) {
        [self.titleLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImageView.right).offset(10);
            make.top.equalTo(@13);
            make.right.lessThanOrEqualTo(self.timeLabel.left).offset(-10.5);
        }];
    
        if (dto.target != nil) {
            NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], dto.target.photoID];
            
            [self.headImageView med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:GetImage(@"img_head.png")];
        } else {
            NSDictionary *param = @{@"userid": dto.remoteUserID};
            [UserManager getUserInfoFull:param success:^(id JSON) {
                UserDTO *udto = (UserDTO *)JSON;
                ((SessionDTO *)idto).target = udto;
                self.titleLabel.text = udto.name;
                
                NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], dto.target.photoID];
                [self.headImageView med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:GetImage(@"img_head.png")];
            } failure:^(NSError *error, id JSON) {
                
            }];
        }
        
        switch (dto.content.type) {
            case MessageTypeInstanceImage:
                self.detailLabel.text = @"[图片]";
                break;
            case MessageTypeInstanceVoice:
                self.detailLabel.text = @"[语音]";
                break;
            case MessageTypeInstanceText:
                self.detailLabel.text = dto.content.content;
                break;
            default:
                self.detailLabel.text = @"[当前版本暂不支持]";
                break;
        }
        
        self.timeLabel.text = [DateUtil getDisplayTime:dto.updateTime];
        
        if (dto.unreadCount > 0) {
            self.messageNumberLabel.text = [NSString stringWithFormat:@"%@", @(dto.unreadCount)];
            
            [self.messageNumberLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.timeLabel.bottom).equalTo(8);
                make.right.equalTo(@-15);
                make.width.greaterThanOrEqualTo(@20);
                make.height.equalTo(@20);
            }];
        } else {
            self.messageNumberLabel.text = @"";
            
            [self.messageNumberLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.timeLabel.bottom).equalTo(8);
                make.right.equalTo(@-15);
            }];
        }
    }
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 70.0f;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 25;
            view;
        });
    }
    return _headImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:18];
            label;
        });
    }
    return _titleLabel;
}

- (UILabel *)messageNumberLabel
{
    if (!_messageNumberLabel) {
        _messageNumberLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];
            label.backgroundColor = [UIColor colorFromHexString:@"#ec553b"];
            label.layer.cornerRadius = 10.0f;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;

            label;
        });
    }
    return _messageNumberLabel;
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

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:12];
            label;
        });
    }
    return _timeLabel;
}

@end
