//
//  NotifyMessageContentView.m
//  medtree
//
//  Created by 孙晨辉 on 15/9/17.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NotifyMessageContentView.h"
#import "UserHeadViewButton.h"
// dto
#import "PostDTO.h"
#import "UserDTO.h"
// manager
#import "UserManager.h"
#import "UIImageView+setImageWithURL.h"
#import <ImageCenter.h>

@interface NotifyMessageContentView ()
{
    UIView              *feedView;
    UIView              *articleView;
    UserHeadViewButton  *headImageButton;
    UIImageView         *icon; // 配图
    UILabel             *nameLabel;
    UILabel             *organizationLabel;
    UILabel             *contentLabel;
    UILabel             *titleLabel;
}

@end

@implementation NotifyMessageContentView

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [ColorUtil getColor:@"f4f4f4" alpha:1.0];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [ColorUtil getColor:@"e4e4e8" alpha:1.0].CGColor;
    
    feedView = [[UIView alloc] init];
    feedView.userInteractionEnabled = YES;
    [self addSubview:feedView];
    
    articleView = [[UIView alloc] init];
    articleView.userInteractionEnabled = YES;
    [self addSubview:articleView];
    
    headImageButton = [[UserHeadViewButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [headImageButton addTarget:self action:@selector(clickHead) forControlEvents:UIControlEventTouchUpInside];
    [feedView addSubview:headImageButton];
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [ColorUtil getColor:@"6e727d" alpha:1.0];
    nameLabel.font = [MedGlobal getTinyLittleFont];
    [feedView addSubview:nameLabel];
    
    organizationLabel = [[UILabel alloc] init];
    organizationLabel.textColor = [ColorUtil getColor:@"787878" alpha:1.0];
    organizationLabel.font = [MedGlobal getTinyLittleFont];
    [feedView addSubview:organizationLabel];
    
    contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = [ColorUtil getColor:@"8d919e" alpha:1.0];
    
    icon = [[UIImageView alloc] init];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 2;
    titleLabel.font = [MedGlobal getLittleFont];
    titleLabel.textColor = [ColorUtil getColor:@"474a52" alpha:1.0];
    [articleView addSubview:titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;

    feedView.frame = self.bounds;
    articleView.frame = self.bounds;
    
    CGFloat iconOffset = 0;
    if (!icon.isHidden) {
        icon.frame = CGRectMake(0, 0, size.height, size.height);
        iconOffset = size.height;
    }
    if (!feedView.isHidden) {
        headImageButton.frame = CGRectMake(10 + iconOffset, 6, 30, 30);
        CGSize nameLabelS = [nameLabel.text sizeWithAttributes:@{NSFontAttributeName:nameLabel.font}];
        nameLabel.frame = CGRectMake(50 + iconOffset, 6, nameLabelS.width, nameLabelS.height);
        CGSize organizationLabelS = [organizationLabel.text sizeWithAttributes:@{NSFontAttributeName:organizationLabel.font}];
        organizationLabel.frame = CGRectMake(50 + iconOffset, CGRectGetMaxY(nameLabel.frame) + 3, size.width - 50 - iconOffset - 10, organizationLabelS.height);
        contentLabel.frame = CGRectMake(50 + iconOffset, CGRectGetMaxY(organizationLabel.frame) + 4, size.width - 50 - iconOffset - 10, size.height - 44);
    }
    if (!articleView.isHidden) {
        CGFloat titleOffset = 0;
        if (titleLabel.text.length > 0) {
            CGSize titleLabelS = [titleLabel sizeThatFits:CGSizeMake(size.width - 20 - iconOffset, CGFLOAT_MAX)];
            titleLabel.frame = CGRectMake(10 + iconOffset, 8, size.width - 20 - iconOffset, titleLabelS.height);
            titleOffset = titleLabelS.height + 9;
        }
        contentLabel.frame = CGRectMake(10 + iconOffset, titleOffset, size.width - 20 - iconOffset, size.height - titleOffset);
    }
}

#pragma mark - click
- (void)clickHead
{
    if ([self.delegate respondsToSelector:@selector(clickHead:)]) {
        [self.delegate clickHead:self.post.userDTO];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(clickPost:)]) {
        [self.delegate clickPost:self.post];
    }
}

#pragma mark - getter & setter
- (void)setPost:(PostDTO *)post
{
    _post = post;
    
    switch (post.type) {
        case PostRefTypeUnknown: {
            
            break;
        }
        case PostRefTypePosition:
        case PostRefTypeHomeEvent:
        case PostRefTypeEvent: {
            [self assembleEventPost:post];
            break;
        }
        case PostRefTypeDiscuss: {
            [self assembleDiscussPost:post];
            break;
        }
        case PostRefTypeArticle: {
            [self assembleArticlePost:post];
            break;
        }
        case PostRefTypeFriendFeed: {
            feedView.hidden = NO;
            articleView.hidden = YES;
            if (post.images.count > 0) {
                icon.hidden = NO;
                NSString *path = @"";
                if ([[post.images firstObject] isKindOfClass:[NSString class]]) {
                    path = [[MedGlobal getPicHost:ImageType_Orig] stringByAppendingPathComponent:[post.images firstObject]];
                }
                [icon med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:[ImageCenter getBundleImage:@"event_bg.png"]];
            } else {
                icon.hidden = YES;
            }
            contentLabel.font = [MedGlobal getLittleFont];
            contentLabel.text = post.content;
            [feedView addSubview:icon];
            [feedView addSubview:contentLabel];
            [UserManager getUserInfoFull:@{@"userid":post.userID} success:^(UserDTO *user) {
                post.userDTO = user;
                nameLabel.text = user.name;
                organizationLabel.text = user.organization_name;
                NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], user.photoID];
                headImageButton.headImageURL = path;
                headImageButton.certificate_user_type = user.certificate_user_type;
                if (user.isAnonymous) {
                    headImageButton.levelType = 0;
                } else {
                    headImageButton.levelType = user.user_type;
                }
                [self setNeedsLayout];
            } failure:nil];
            break;
        }
    }
}

#pragma mark - private
- (void)assembleEventPost:(PostDTO *)dto
{
    feedView.hidden = YES;
    articleView.hidden = NO;
    icon.hidden = NO;
    titleLabel.text = dto.title;
    contentLabel.font = [MedGlobal getLittleFont];
    contentLabel.numberOfLines = 2;
    contentLabel.text = dto.content;
    [articleView addSubview:icon];
    [articleView addSubview:contentLabel];
    NSString *path = [[MedGlobal getPicHost:ImageType_Orig] stringByAppendingPathComponent:[dto.images firstObject]];
    [icon med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:[ImageCenter getBundleImage:@"home_event_default.png"]];
    [self setNeedsLayout];
}

- (void)assembleArticlePost:(PostDTO *)dto
{
    feedView.hidden = YES;
    articleView.hidden = NO;
    icon.hidden = NO;
    titleLabel.text = dto.title;
    contentLabel.font = [MedGlobal getLittleFont];
    contentLabel.numberOfLines = 2;
    contentLabel.text = dto.content;
    [articleView addSubview:icon];
    [articleView addSubview:contentLabel];
    icon.image = [ImageCenter getBundleImage:@"article_bg.png"];
    [self setNeedsLayout];
}

- (void)assembleDiscussPost:(PostDTO *)dto
{
    feedView.hidden = YES;
    articleView.hidden = NO;
    icon.hidden = NO;
    titleLabel.text = dto.title;
    contentLabel.font = [MedGlobal getLittleFont];
    contentLabel.numberOfLines = 2;
    contentLabel.text = dto.content;
    [articleView addSubview:icon];
    [articleView addSubview:contentLabel];
    icon.image = [ImageCenter getBundleImage:@"discuss_bg.png"];
    [self setNeedsLayout];
}

#pragma mark - touch
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(headImageButton.frame, point)) {
        return headImageButton;
    } else if (CGRectContainsPoint(self.bounds, point)) {
        return self;
    } else {
        return nil;
    }
}

#pragma mark - cell height
+ (CGFloat)getHeight
{
    return 70;
}

@end
