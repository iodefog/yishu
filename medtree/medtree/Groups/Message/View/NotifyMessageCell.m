//
//  NotifyMessageCell.m
//  medtree
//
//  Created by 孙晨辉 on 15/9/16.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NotifyMessageCell.h"
#import "UserHeadViewButton.h"
#import "NotifyMessageContentView.h"
#import "CHContentTextView.h"
// dto
#import "NotifyMessageDTO.h"
#import "UserDTO.h"
#import "PostDTO.h"
#import "CHSpecialDTO.h"
// manager
#import "UserManager.h"
#import "PostManager.h"
#import "DateUtil.h"
#import "AccountHelper.h"
#import "NSString+Extension.h"

const NSInteger kClickHeadAction = 10000;
const NSInteger kClickPostAction = 20000;

@interface NotifyMessageCell () <NotifyMessageContentViewDelegate>
{
    NotifyMessageDTO        *notifyDTO;
}

@property (nonatomic, strong) UserHeadViewButton *headImageButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *relationLabel;
@property (nonatomic, strong) CHContentTextView *contentLabel;
@property (nonatomic, strong) UILabel *organizationLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NotifyMessageContentView *messageContentView;

@end

@implementation NotifyMessageCell

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    [self.contentView addSubview:self.headImageButton];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.relationLabel];
    [self.contentView addSubview:self.organizationLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.messageContentView];
    [self.contentView addSubview:self.timeLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize nameLabelS = [self.nameLabel.text sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}];
    self.nameLabel.frame = CGRectMake(65, 10, nameLabelS.width, self.nameLabel.font.lineHeight);
    CGFloat typeLabelW = [self.typeLabel.text getStringWidthInWidth:(self.frame.size.width - CGRectGetMaxX(self.nameLabel.frame) - 15) font:self.typeLabel.font];
    self.typeLabel.frame = CGRectMake(GetViewWidth(self) - typeLabelW - 15, 10, typeLabelW, self.typeLabel.font.lineHeight);
    CGSize relationLabelS = [self.relationLabel.text sizeWithAttributes:@{NSFontAttributeName:self.relationLabel.font}];
    self.relationLabel.frame = CGRectMake(GetViewWidth(self) - relationLabelS.width - 15, 30, relationLabelS.width, self.relationLabel.font.lineHeight);
    self.organizationLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame), GetScreenWidth - 65 - 15 - relationLabelS.width, self.organizationLabel.font.lineHeight);
    CGSize contentLabelS = [self.contentLabel.attributedText boundingRectWithSize:CGSizeMake(self.frame.size.width - 65 - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.contentLabel.frame = CGRectMake(65, CGRectGetMaxY(self.organizationLabel.frame) + 10, self.frame.size.width - 65 - 15, contentLabelS.height);
    self.timeLabel.frame = CGRectMake(65, GetViewHeight(self) - 20, 100, 15);
    CGFloat messageContentViewW = self.frame.size.width - 65 - 15;
    self.messageContentView.frame = CGRectMake(65, GetViewHeight(self) - [NotifyMessageContentView getHeight] - 25, messageContentViewW, [NotifyMessageContentView getHeight]);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

#pragma mark - click
- (void)clickHeader
{
    [self.parent clickCell:notifyDTO.fromUser action:@(kClickHeadAction)];
}

#pragma mark - data
- (void)setInfo:(NotifyMessageDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    notifyDTO = dto;
    
    switch (dto.replyType) {
        case MessageReplyTypeUnknown: {
            self.contentLabel.text = dto.content;
            break;
        }
        case MessageReplyTypeReply: {
            self.contentLabel.text = dto.content;
            break;
        }
        case MessageReplyTypeLike: {
            self.contentLabel.text = @"赞了这条信息";
            break;
        }
        case MessageReplyTypeInvite: {
            self.contentLabel.text = @"邀请您参加";
            break;
        }
    }
    
    self.timeLabel.text = [DateUtil getDisplayTime:dto.createTime];
    [UserManager getUserInfoFull:@{@"userid": dto.fromUserID} success:^(UserDTO *user) {
        dto.fromUser = user;
        [self loadUserDTO:user];
    } failure:nil];
    [PostManager getPostByPostID:dto.refID success:^(PostDTO *post) {
        if (post.channelName.length > 0) {
            self.typeLabel.text = [NSString stringWithFormat:@"%@●%@", post.channelName, dto.refStr];
        } else {
            self.typeLabel.text = [NSString stringWithFormat:@"%@", dto.refStr];
        }
        dto.post = post;
        self.messageContentView.post = post;
    }];
}

#pragma mark - private
- (void)loadUserDTO:(UserDTO *)dto
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], dto.photoID];
    self.headImageButton.headImageURL = path;
    self.headImageButton.certificate_user_type = dto.certificate_user_type;
    if (dto.isAnonymous) {
        self.headImageButton.levelType = 0;
    } else {
        self.headImageButton.levelType = dto.user_type;
    }
    self.nameLabel.text = dto.name;
    self.organizationLabel.text = dto.organization_name;
    self.relationLabel.text = dto.relation_summary;
    [self setNeedsLayout];
}

#pragma mark - NotifyMessageContentViewDelegate
- (void)clickHead:(UserDTO *)dto
{
    [self.parent clickCell:dto action:@(kClickHeadAction)];
}

- (void)clickPost:(PostDTO *)dto
{
    [self.parent clickCell:dto action:@(kClickPostAction)];
}

#pragma mark - cell height
+ (CGFloat)getCellHeight:(NotifyMessageDTO *)dto width:(CGFloat)width
{
    CGFloat height = 78;
    height += [NotifyMessageContentView getHeight];
    NSString *content = dto.content;
    switch (dto.replyType) {
        case MessageReplyTypeLike: {
            content = @"赞了这条信息";
            break;
        }
        case MessageReplyTypeInvite: {
            content = @"邀请您参加";
            break;
        }
        default: {
            
        }
    }
    CGSize size = [content boundingRectWithSize:CGSizeMake(width - 65 - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[MedGlobal getLittleFont]} context:nil].size;
    height = height + size.height + 10;
    return height;
}

#pragma mark - getter & setter
- (UserHeadViewButton *)headImageButton
{
    if (!_headImageButton) {
        _headImageButton = [[UserHeadViewButton alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        [_headImageButton addTarget:self action:@selector(clickHeader) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headImageButton;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [ColorUtil getColor:@"207878" alpha:1.0];
        _nameLabel.font = [MedGlobal getMiddleFont];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [MedGlobal getTinyLittleFont];
        _typeLabel.textColor = [ColorUtil getColor:@"acb3c0" alpha:1.0];
        _typeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _typeLabel;
}

- (UILabel *)relationLabel
{
    if (!_relationLabel) {
        _relationLabel = [[UILabel alloc] init];
        _relationLabel.textColor = [ColorUtil getColor:@"acb3c0" alpha:1.0];
        _relationLabel.font = [MedGlobal getTinyLittleFont];
        _relationLabel.textAlignment = NSTextAlignmentRight;
    }
    return _relationLabel;
}

- (UILabel *)organizationLabel
{
    if (!_organizationLabel) {
        _organizationLabel = [[UILabel alloc] init];
        _organizationLabel.font = [MedGlobal getTinyLittleFont];
        _organizationLabel.textColor = [ColorUtil getColor:@"acb3c0" alpha:1.0];
        _organizationLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _organizationLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [MedGlobal getTinyLittleFont];
        _timeLabel.textColor = [ColorUtil getColor:@"acb3c0" alpha:1.0];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (NotifyMessageContentView *)messageContentView
{
    if (!_messageContentView) {
        _messageContentView = [[NotifyMessageContentView alloc] init];
        _messageContentView.userInteractionEnabled = YES;
        _messageContentView.delegate = self;
    }
    return _messageContentView;
}

- (CHContentTextView *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[CHContentTextView alloc] init];
        _contentLabel.font = [MedGlobal getLittleFont];
    }
    return _contentLabel;
}

@end
