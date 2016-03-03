//
//  HomeChannelHelpDetailTableViewCell.m
//  medtree
//
//  Created by tangshimi on 8/21/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeChannelDetailTableViewCell.h"
#import "MedImageListView.h"
#import "UIColor+Colors.h"
#import "UIImageView+setImageWithURL.h"
#import "NSString+Extension.h"
#import "Masonry.h"
#import "HomeArticleAndDiscussionDTO.h"
#import "UserManager.h"
#import "UserDTO.h"
#import "UserHeadViewButton.h"
#import "UIButton+setImageWithURL.h"
#import "AccountHelper.h"

@interface HomeChannelDetailTableViewCell () <UIAlertViewDelegate>

@property (nonatomic, strong) UserHeadViewButton *headImageButton;
@property (nonatomic, strong) UIImageView *levelImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *departmentLabel;
@property (nonatomic, strong) UILabel *relationLabel;
@property (nonatomic, strong) UITextView *detailTextView;
@property (nonatomic, strong) MedImageListView *imageListView;
@property (nonatomic, strong) UIImageView *officeLogoImageView;
@property (nonatomic, strong) UILabel *officeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation HomeChannelDetailTableViewCell

- (void)createUI
{
    [super createUI];
    
    [self.contentView addSubview:self.headImageButton];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.departmentLabel];
    [self.contentView addSubview:self.relationLabel];
    [self.contentView addSubview:self.detailTextView];
    [self.contentView addSubview:self.imageListView];
    [self.contentView addSubview:self.officeLogoImageView];
    [self.contentView addSubview:self.officeLabel];
    [self.contentView addSubview:self.deleteButton];
    [self.contentView addSubview:self.timeLabel];
    
    [self.headImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.top.equalTo(15);
    }];
    
    [self.typeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                    forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageButton.right).offset(10);
        make.top.equalTo(@10);
        make.right.lessThanOrEqualTo(self.typeLabel.left).offset(-10);
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
    
    [self.detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
    }];
    
    [self.imageListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailTextView.bottom).offset(5);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
    }];
    
    [self.officeLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.bottom.equalTo(@-10);
    }];
    
    [self.officeLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                      forAxis:UILayoutConstraintAxisHorizontal];
    [self.officeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.officeLogoImageView.right);
        make.bottom.equalTo(@-10);
        make.right.lessThanOrEqualTo(self.timeLabel.left).offset(-10);
    }];
    
    [self.deleteButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.bottom.equalTo(@-3.5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteButton.left).offset(-5);
        make.bottom.equalTo(@-10);
    }];
}

- (void)setInfo:(HomeArticleAndDiscussionDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    idto = dto;
    
    self.typeLabel.text = [NSString stringWithFormat:@"%@·%@", dto.channelName, (dto.type == HomeArticleAndDiscussionTypeArticle ? @"文章" : @"讨论")];
    
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
    
    self.detailTextView.text = dto.content;
    [self.imageListView setImageArray:dto.images];
    
    NSMutableString *tagString = [[NSMutableString alloc] init];
    [dto.tags enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL *stop) {
        [tagString appendString:string];
        [tagString appendString:@" "];
    }];
    
    self.officeLabel.text = tagString;
    
    BOOL tagEmpty = NO;
    if (!tagString || [tagString isEqualToString:@""]) {
        tagEmpty = YES;
    }
    
    self.officeLabel.hidden = tagEmpty;
    self.officeLogoImageView.hidden = tagEmpty;
    
    self.timeLabel.text = dto.createdTime;
    
    CGFloat height = [NSString sizeForString:dto.content
                                        Size:CGSizeMake(GetScreenWidth - 30, CGFLOAT_MAX)
                                        Font:self.detailTextView.font].height;

    [self.detailTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageButton.bottom).offset(10);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@(height));
    }];
    
    CGFloat imageListHeight = [MedImageListView heightWithWidth:GetScreenWidth type:MedImageListViewTypeOnlyShow imageArray:dto.images];
    [self.imageListView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailTextView.bottom).offset(5);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(@(imageListHeight));
    }];
    
    if ([dto.createrID isEqualToString:[AccountHelper getAccount].userID] || [dto.createrID isEqualToString:[AccountHelper getAccount].anonymous_id]) {
        [self.deleteButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-15);
            make.bottom.equalTo(@-3.5);
        }];
    } else {
        [self.deleteButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-15);
            make.bottom.equalTo(@-3.5);
            make.width.equalTo(0);
        }];
    }
}

+ (CGFloat)getCellHeight:(HomeArticleAndDiscussionDTO *)dto width:(CGFloat)width
{
    CGFloat height = [NSString sizeForString:dto.content
                                        Size:CGSizeMake(GetScreenWidth - 30, CGFLOAT_MAX)
                                        Font:[UIFont systemFontOfSize:15]].height;
    
    CGFloat imageListHeight = [MedImageListView heightWithWidth:GetScreenWidth type:MedImageListViewTypeOnlyShow imageArray:dto.images];
    
    return 60 + height + 10 + imageListHeight + 25;
}

#pragma mark -
#pragma mark - response event -

- (void)deleteButtonAction:(UIButton *)button
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"确定删除？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)headImageButtonAction:(UserHeadViewButton *)button
{
    HomeArticleAndDiscussionDTO *dto = (HomeArticleAndDiscussionDTO *)idto;
    if (dto.anonymous) {
        return;
    }
    
    if ([self.parent respondsToSelector:@selector(clickCell:index:action:)]) {
        [self.parent clickCell:idto index:index action:@(HomeChannelDetailTableViewCellActionTypeHeadImage)];
    }
}

#pragma mark -
#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([self.parent respondsToSelector:@selector(clickCell:index:action:)]) {
            [self.parent clickCell:idto index:index action:@(HomeChannelDetailTableViewCellActionTypeDelete)];
        }
    }
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

- (UITextView *)detailTextView
{
    if (!_detailTextView) {
        _detailTextView = ({
            UITextView *textView = [[UITextView alloc] init];
            textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
            textView.textColor = [UIColor blackColor];
            textView.font = [UIFont systemFontOfSize:15];
            textView.selectable = YES;
            textView.editable = NO;
            textView.dataDetectorTypes = UIDataDetectorTypeLink;
            textView.scrollEnabled = NO;
            textView;
        });
    }
    return _detailTextView;
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

- (MedImageListView *)imageListView
{
    if (!_imageListView) {
        _imageListView = ({
            MedImageListView *listView = [[MedImageListView alloc] init];
            listView;
        });
    }
    return _imageListView;
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

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"删除" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setTitleColor:[UIColor colorFromHexString:@"#8593b0"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _deleteButton;
}

@end
