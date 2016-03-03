//
//  HomeArticleTableViewCell.m
//  medtree
//
//  Created by tangshimi on 8/24/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeArticleAndDiscussionTableViewCell.h"
#import "MedImageListView.h"
#import "UIColor+Colors.h"
#import "UIButton+setImageWithURL.h"
#import "NSString+Extension.h"
#import "HomeArticleAndDiscussionDTO.h"
#import "UserManager.h"
#import "UserDTO.h"
#import "UserHeadViewButton.h"
#import "UIImageView+setImageWithURL.h"

@interface HomeArticleAndDiscussionTableViewCell ()

@property (nonatomic, strong) UserHeadViewButton *headImageButton;
@property (nonatomic, strong) UIImageView *levelImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *relationLabel;
@property (nonatomic, strong) UILabel *departmentLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) MedImageListView *imageListView;
@property (nonatomic, strong) UIImageView *officeLogoImageView;
@property (nonatomic, strong) UILabel *officeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *commentLogoImageView;
@property (nonatomic, strong) UILabel *commentNumberLabel;
@property (nonatomic, strong) UIImageView *essenceLogoImageView;
@property (nonatomic, strong) UIImageView *eventLogoImageView;
@property (nonatomic, strong) UIView *articleAndEventGrayBackView;
@property (nonatomic, strong) UIImageView *articleAndEventLogoImageView;
@property (nonatomic, strong) UILabel *articleAndEventTitleLabel;
@property (nonatomic, strong) UILabel *articleAndEventDetailLabel;
@property (nonatomic, strong) UIView *topSpaceView;

@end

@implementation HomeArticleAndDiscussionTableViewCell

- (void)createUI
{
    [super createUI];
    [self.contentView addSubview:self.topSpaceView];
    [self.contentView addSubview:self.headImageButton];
    [self.headImageButton addSubview:self.levelImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.relationLabel];
    [self.contentView addSubview:self.departmentLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.imageListView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.officeLogoImageView];
    [self.contentView addSubview:self.officeLabel];
    [self.contentView addSubview:self.commentLogoImageView];
    [self.contentView addSubview:self.commentNumberLabel];
    [self.contentView addSubview:self.essenceLogoImageView];
    [self.contentView addSubview:self.eventLogoImageView];
    [self.contentView addSubview:self.articleAndEventGrayBackView];
    [self.articleAndEventGrayBackView addSubview:self.articleAndEventLogoImageView];
    [self.articleAndEventGrayBackView addSubview:self.articleAndEventTitleLabel];
    [self.articleAndEventGrayBackView addSubview:self.articleAndEventDetailLabel];
    
    [self.topSpaceView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(10);
    }];
    
    [self.headImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@20);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageButton.right).offset(10);
        make.top.equalTo(@20);
        make.right.lessThanOrEqualTo(self.typeLabel.left).offset(-10);
    }];
    
    [self.typeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                    forAxis:UILayoutConstraintAxisHorizontal];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.top.equalTo(25);
    }];
    
    [self.relationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.top.equalTo(self.typeLabel.bottom);
    }];
    
    [self.departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.top.equalTo(self.nameLabel.bottom).offset(5);
        make.right.lessThanOrEqualTo(self.relationLabel.left).offset(5);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
    }];
    
    [self.imageListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.bottom).offset(5);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
    }];
    
    [self.officeLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.bottom.equalTo(@-10);
    }];
    
    [self.officeLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                      forAxis:UILayoutConstraintAxisHorizontal];
    [self.officeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.officeLogoImageView.right);
        make.bottom.equalTo(@-10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.officeLabel.right).offset(10);
        make.bottom.equalTo(@-10);
        make.right.greaterThanOrEqualTo(self.commentLogoImageView.left).offset(10);
    }];
    
    [self.commentNumberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.bottom.equalTo(@-10);
    }];
    
    [self.commentLogoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentNumberLabel.centerY);
        make.right.equalTo(self.commentNumberLabel.left).offset(-5);
    }];
    
    [self.essenceLogoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.right.equalTo(-15);
    }];
    
    [self.eventLogoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(0);
        make.centerY.equalTo(self.topSpaceView.bottom);
    }];
    
    [self.articleAndEventGrayBackView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.departmentLabel.bottom).offset(10);
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(-15);
        make.height.equalTo(70);
    }];
    
    [self.articleAndEventLogoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(0);
        make.width.equalTo(70);
    }];
    
    [self.articleAndEventTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.articleAndEventLogoImageView.right).offset(8);
        make.top.equalTo(5);
        make.right.equalTo(-8);
    }];

    [self.articleAndEventDetailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.articleAndEventLogoImageView.right).offset(8);
        make.right.equalTo(-8);
        make.top.equalTo(self.articleAndEventTitleLabel.bottom);
        make.bottom.equalTo(0);
    }];
}

- (void)setInfo:(HomeArticleAndDiscussionDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    idto = dto;
    
    if (dto.type == HomeArticleAndDiscussionTypeArticle){
        self.typeLabel.text = [NSString stringWithFormat:@"%@·%@", dto.channelName, @"文章"];
    } else if (dto.type == HomeArticleAndDiscussionTypeDiscussion) {
        self.typeLabel.text = [NSString stringWithFormat:@"%@·%@", dto.channelName, @"讨论"];
    } else if (dto.type == HomeArticleAndDiscussionTypeEvent) {
        self.typeLabel.text = [NSString stringWithFormat:@"%@·%@", dto.channelName, @"活动"];
    }
    
    self.eventLogoImageView.hidden = dto.type != HomeArticleAndDiscussionTypeEvent;
    
    NSDictionary *param = @{@"userid" : dto.createrID};
    [UserManager getUserInfoFull:param success:^(UserDTO *userDto) {
        ((HomeArticleAndDiscussionDTO *)idto).userDTO = userDto;
        NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], userDto.photoID];
        self.headImageButton.headImageURL = path;
        self.headImageButton.certificate_user_type = userDto.certificate_user_type;
        self.headImageButton.levelType =  dto.anonymous ? 0 : userDto.user_type;
        self.nameLabel.text = userDto.name;
        self.departmentLabel.text = userDto.organization_name;
        self.relationLabel.text = userDto.relation_summary;
    } failure:^(NSError *error, id JSON) {
        
    }];
    
    if (dto.type == HomeArticleAndDiscussionTypeDiscussion) {
        self.articleAndEventGrayBackView.hidden = YES;
        self.detailLabel.hidden = NO;
        self.imageListView.hidden = NO;
        self.essenceLogoImageView.hidden = !dto.isEssence;
        
        self.detailLabel.attributedText = nil;
        
        CGFloat height = [NSString labelSizeForString:dto.content
                                                 Size:CGSizeMake(GetScreenWidth - 80, CGFLOAT_MAX)
                                                 Font:self.detailLabel.font
                                                Lines:5].height;
        
        self.detailLabel.text = dto.content;
        
        [self.detailLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.left);
            make.top.equalTo(self.departmentLabel.bottom).offset(10);
            make.right.equalTo(@-15);
            make.height.equalTo(@(height));
        }];
        
        [self.imageListView setImageArray:dto.images];
        CGFloat imageListHeight = [MedImageListView  heightWithWidth:GetScreenWidth - 90 type:MedImageListViewTypeOnlyShow imageArray:dto.images];
        
        [self.imageListView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.left).offset(-15);
            make.right.equalTo(-25);
            make.top.equalTo(self.detailLabel.bottom).offset(10);
            make.height.equalTo(@(imageListHeight));
        }];
    } else if (dto.type == HomeArticleAndDiscussionTypeArticle || dto.type == HomeArticleAndDiscussionTypeEvent) {
        self.articleAndEventGrayBackView.hidden = NO;
        self.detailLabel.hidden = YES;
        self.imageListView.hidden = YES;
        
        if (dto.type == HomeArticleAndDiscussionTypeArticle) {
            self.essenceLogoImageView.hidden = !dto.isEssence;
        } else {
            self.essenceLogoImageView.hidden = YES;
        }
        
        UIImage *image = dto.type == HomeArticleAndDiscussionTypeArticle ? GetImage(@"home_article_default.png") : GetImage(@"home_event_default.png");
        
        NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], [dto.images firstObject]];
        [self.articleAndEventLogoImageView med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:image];
        self.articleAndEventTitleLabel.text = dto.title;
        self.articleAndEventDetailLabel.text = dto.summary;
    }
    
    NSMutableString *tagString = [[NSMutableString alloc] init];
    [dto.tags enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL *stop) {
        [tagString appendString:string];
        [tagString appendString:@" "];
    }];
    
    self.officeLabel.text = tagString;
    self.timeLabel.text = dto.createdTime;
    
    BOOL tagStringEmpty = NO;
    if (tagString.length == 0 || [tagString isEqualToString:@""]) {
        tagStringEmpty = YES;
    }
    
    [self.officeLogoImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.bottom.equalTo(@-10);
        
        if (tagStringEmpty) {
            make.width.equalTo(@0);
        }
    }];
    
    [self.timeLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.officeLabel.right).offset(((tagStringEmpty) ? @0 : @10));
        make.bottom.equalTo(@-10);
        make.right.lessThanOrEqualTo(self.commentLogoImageView.left).offset(-10);
    }];
    
    if (dto.type == HomeArticleAndDiscussionTypeDiscussion) {
        self.commentLogoImageView.image = GetImage(@"home_discussion_comment.png");
        
        NSString *commentCountString = [NSString stringWithFormat:@"%@", @(dto.commentCount)];
        self.commentNumberLabel.text = commentCountString;
    } else if (dto.type == HomeArticleAndDiscussionTypeArticle ||
               dto.type == HomeArticleAndDiscussionTypeEvent) {
        self.commentLogoImageView.image = GetImage(@"home_article.png");
        
        NSString *clickCountString = [NSString stringWithFormat:@"%@", @(dto.virtualCount)];
        self.commentNumberLabel.text = clickCountString;
    }
}

- (void)headImageButtonAction:(UIButton *)button
{
    HomeArticleAndDiscussionDTO *dto = (HomeArticleAndDiscussionDTO *)idto;
    if (dto.anonymous) {
        return;
    }
    
    if ([self.parent respondsToSelector:@selector(clickCell:action:)]) {
        [self.parent clickCell:idto action:@(HomeArticleAndDiscussionTableViewCellActionTypeHeadImage)];
    }
}

+ (CGFloat)getCellHeight:(HomeArticleAndDiscussionDTO *)dto width:(CGFloat)width
{
    if (dto.type == HomeArticleAndDiscussionTypeDiscussion) {
        CGFloat height = [NSString labelSizeForString:dto.content
                                                 Size:CGSizeMake(GetScreenWidth - 80, CGFLOAT_MAX)
                                                 Font:[UIFont systemFontOfSize:15]
                                                Lines:5].height;
        height += 10;
        
        CGFloat imageListHeight = [MedImageListView heightWithWidth:GetScreenWidth - 90
                                                               type:MedImageListViewTypeOnlyShow
                                                         imageArray:dto.images];
        if (imageListHeight > 0) {
            imageListHeight += 10;
        }
        return 60 + height + imageListHeight + 25 + 10;
    } else if (dto.type == HomeArticleAndDiscussionTypeArticle || dto.type == HomeArticleAndDiscussionTypeEvent) {
        return 60 + 70 + 20 + 25 + 10;
    }
    return 0;
}

#pragma mark -
#pragma mark - setter and getter -

- (UserHeadViewButton *)headImageButton
{
    if (!_headImageButton) {
        _headImageButton = ({
            UserHeadViewButton *button = [[UserHeadViewButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            [button addTarget:self action:@selector(headImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _headImageButton;
}

- (UIImageView *)levelImageView
{
    if (!_levelImageView) {
        _levelImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 8.0f;
            imageView.clipsToBounds = YES;
            imageView;
        });
    }
    return _levelImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor colorFromHexString:@"#207878"];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _nameLabel;
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor lightGrayColor];
            label.textAlignment = NSTextAlignmentRight;
            label;
        });
    }
    return _typeLabel;
}

- (UILabel *)relationLabel
{
    if (!_relationLabel) {
        _relationLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentRight;
            label;
        });
    }
    return _relationLabel;
}

- (UILabel *)departmentLabel
{
    if (!_departmentLabel) {
        _departmentLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _departmentLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor blackColor];
            label.numberOfLines = 5;
            label;
        });
    }
    return _detailLabel;
}

- (MedImageListView *)imageListView
{
    if (!_imageListView) {
        _imageListView = ({
            MedImageListView *listView = [[MedImageListView alloc] initWithFrame:CGRectMake(0, 0, GetScreenWidth - 65, 0)];
            listView.type = MedImageListViewTypeOnlyShow;
            listView;
        });
    }
    return _imageListView;
}

- (UIImageView *)officeLogoImageView
{
    if (!_officeLogoImageView) {
        _officeLogoImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"home_office_logo.png");
            imageView;
        });
    }
    return _officeLogoImageView;
}

- (UILabel *)officeLabel
{
    if (!_officeLabel) {
        _officeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _officeLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _timeLabel;
}

- (UIImageView *)commentLogoImageView
{
    if (!_commentLogoImageView) {
        _commentLogoImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"home_article.png");
            imageView;
        });
    }
    return _commentLogoImageView;
}

- (UILabel *)commentNumberLabel
{
    if (!_commentNumberLabel) {
        _commentNumberLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor lightGrayColor];
            label.textAlignment = NSTextAlignmentRight;
            label;
        });
    }
    return _commentNumberLabel;
}

- (UIImageView *)essenceLogoImageView
{
    if (!_essenceLogoImageView) {
        _essenceLogoImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"home_discussin_essence_logo.png");
            imageView;
        });
    }
    return _essenceLogoImageView;
}

- (UIImageView *)eventLogoImageView
{
    if (!_eventLogoImageView) {
        _eventLogoImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"home_event_logo.png");
            imageView;
        });
    }
    return _eventLogoImageView;
}

- (UIView *)articleAndEventGrayBackView
{
    if (!_articleAndEventGrayBackView) {
        _articleAndEventGrayBackView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorFromHexString:@"f4f4f7"];
            
            view;
        });
    }
    return _articleAndEventGrayBackView;
}

- (UILabel *)articleAndEventTitleLabel
{
    if (!_articleAndEventTitleLabel) {
        _articleAndEventTitleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor blackColor];
            label.numberOfLines = 2;
            label;
        });
    }
    return _articleAndEventTitleLabel;
}

- (UILabel *)articleAndEventDetailLabel
{
    if (!_articleAndEventDetailLabel) {
        _articleAndEventDetailLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor grayColor];
            label.numberOfLines = 2;
            label;
        });
    }
    return _articleAndEventDetailLabel;
}

- (UIImageView *)articleAndEventLogoImageView
{
    if (!_articleAndEventLogoImageView) {
        _articleAndEventLogoImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView;
        });
    }
    return _articleAndEventLogoImageView;
}

- (UIView *)topSpaceView
{
    if (!_topSpaceView) {
        _topSpaceView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorFromHexString:@"#F4F4F7"];
            
            view;
        });
    }
    return _topSpaceView;
}

@end
