//
//  EventFeedTableViewCell.m
//  medtree
//
//  Created by tangshimi on 8/5/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "EventFeedTableViewCell.h"
#import "UIColor+Colors.h"
#import "MedImageListView.h"
#import "MedFeedDTO.h"
#import "MedGlobal.h"
#import "UserDTO.h"
#import "UIButton+setImageWithURL.h"
#import "NSString+Extension.h"
#import "DateUtil.h"
#import "UserManager.h"
#import "AccountHelper.h"
#import "OperationHelper.h"
#import "BrowseImagesController.h"
#import "RootViewController.h"
#import "UserHeadViewButton.h"

@interface EventFeedTableViewCell () <UIAlertViewDelegate>

@property (nonatomic, strong) UserHeadViewButton *headImageButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *hospitalLabel;
@property (nonatomic, strong) UITextView *detailTextView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *commentAndLikeButton;
@property (nonatomic, strong) MedImageListView *imageListView;
@property (nonatomic, strong) UserDTO *userDto;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation EventFeedTableViewCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

}

- (void)createUI
{
    self.backgroundColor = [UIColor whiteColor];
    headerLine.hidden = YES;
    footerLine.hidden = YES;
    [self.contentView addSubview:self.headImageButton];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.hospitalLabel];
    [self.contentView addSubview:self.detailTextView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.commentAndLikeButton];
    [self.contentView addSubview:self.imageListView];
    [self.contentView addSubview:self.deleteButton];
    
    self.headImageButton.frame = CGRectMake(15, 10, 40, 40);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageButton.frame) + 10, 8, GetViewWidth(self) - CGRectGetMaxX(self.headImageButton.frame), 20);
    self.hospitalLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 7, GetViewWidth(self.nameLabel), 15);
    self.detailTextView.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.hospitalLabel.frame) + 10, GetScreenWidth - CGRectGetMinX(self.nameLabel.frame) - 15, 0);
    self.timeLabel.frame = CGRectMake(65, GetViewHeight(self) - 15, 150, 12);
    self.timeLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    self.commentAndLikeButton.frame = CGRectMake(GetViewWidth(self) - 25 - 15, GetViewHeight(self) - 24, 30, 24);
    self.commentAndLikeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(longPressGestureAction:)];
    [self.detailTextView addGestureRecognizer:longPressGesture];
}

- (void)setInfo:(MedFeedDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    NSDictionary *param = @{@"userid" : dto.creatorID};
    
    [UserManager getUserInfoFull:param success:^(UserDTO *userDto) {
        self.userDto = userDto;
        NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], userDto.photoID];
        [self.headImageButton setHeadImageURL:path];
        self.headImageButton.certificate_user_type = userDto.certificate_user_type;
        self.headImageButton.levelType =  dto.anonymous ? 0 : userDto.user_type;
        self.nameLabel.text = userDto.name;
        self.hospitalLabel.text = userDto.organization_name;
    } failure:nil];
    
    self.detailTextView.text = dto.content;

    CGFloat height = [NSString sizeForString:dto.content
                                        Size:CGSizeMake(GetViewWidth(self.detailTextView), CGFLOAT_MAX)
                                        Font:self.detailTextView.font].height;
    CGRect detailTextViewFrame = self.detailTextView.frame;
    detailTextViewFrame.size.height = height;
    self.detailTextView.frame = detailTextViewFrame;
    
    self.imageListView.imageArray = dto.imageArray;
    
    if (dto.imageArray.count > 0) {
        CGFloat imageHeight = [MedImageListView  heightWithWidth:GetScreenWidth - 80
                                                            type:MedImageListViewTypeOnlyShow
                                                      imageArray:dto.imageArray];
        self.imageListView.frame = CGRectMake(50,
                                              CGRectGetMaxY(self.detailTextView.frame) + 5,
                                              GetScreenWidth - 80,
                                              imageHeight);
        self.imageListView.hidden = NO;
    } else {
        self.imageListView.hidden = YES;
    }

    self.timeLabel.text = dto.time;
    
    self.commentAndLikeButton.hidden = dto.searchFeed;
    
    if ([dto.creatorID isEqualToString:[AccountHelper getAccount].userID] || [dto.creatorID isEqualToString:[AccountHelper getAccount].anonymous_id]) {
        self.deleteButton.hidden = NO;
        CGFloat width = [dto.time getStringWithFont:self.timeLabel.font];
        
        self.deleteButton.frame = CGRectMake(65 + width + 5, CGRectGetMinY(self.timeLabel.frame), 30, 12);
    } else {
        self.deleteButton.hidden = YES;
    }
    
}

+ (CGFloat)getCellHeight:(MedFeedDTO *)dto width:(CGFloat)width
{
    CGFloat height = [NSString sizeForString:dto.content
                                        Size:CGSizeMake(GetScreenWidth - 80, CGFLOAT_MAX)
                                        Font:[UIFont systemFontOfSize:15]].height;
    CGFloat imageListHeight = [MedImageListView heightWithWidth:GetScreenWidth - 80
                                                           type:MedImageListViewTypeOnlyShow
                                                     imageArray:dto.imageArray];
    if (imageListHeight > 0) {
        imageListHeight += 10;
    }
    return 50 + height + 10 + imageListHeight + 25;
}

#pragma mark -
#pragma mark - about UIMenuController -

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(menuControllerCopy:) ||
        action == @selector(menuControllerReport:)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark -
#pragma mark - response event -

- (void)headImageButtonAction:(UIButton *)button
{
    MedFeedDTO *feedDTO = (MedFeedDTO *)idto;
    if (feedDTO.anonymous) {
        return;
    }
    
    if ([self.parent respondsToSelector:@selector(clickCell:index:action:)]) {
        [self.parent clickCell:idto index:index action:@(EventFeedTableViewCellActionTypeHeadView)];
    }
}

- (void)commentAndLikeButtonAction:(UIButton *)button
{
    if ([self.parent respondsToSelector:@selector(clickCell:index:action:)]) {
        [self.parent clickCell:idto index:index action:@(EventFeedTableViewCellActionTypeCommentView)];
    }
}

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        if ([self becomeFirstResponder]) {
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [menuController setMenuVisible:NO animated:YES];
            
            UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuControllerCopy:)];
            UIMenuItem *copyMenuItem1 = nil;
            if ([[[AccountHelper getAccount] userID] isEqualToString:[NSString stringWithFormat:@"%@", ((MedFeedDTO *)idto).creatorID]] || [[AccountHelper getAccount].anonymous_id isEqualToString:((MedFeedDTO *)idto).creatorID]) {
                [menuController setMenuItems: @[ copyMenuItem ]];
            } else {
                copyMenuItem1 = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(menuControllerReport:)];
                [menuController setMenuItems: @[ copyMenuItem, copyMenuItem1 ]];
            }
            
            [menuController setArrowDirection:UIMenuControllerArrowDown];
            [menuController setTargetRect:CGRectMake(CGRectGetWidth(self.detailTextView.frame) / 2.0, 10, 0, 0) inView:self.detailTextView];
            [menuController setMenuVisible:YES animated:YES];
        }
    }
}

- (void)menuControllerCopy:(UIMenuItem *)item
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:((MedFeedDTO *)idto).content];
}

- (void)menuControllerReport:(UIMenuItem *)itme
{
    if ([self.parent respondsToSelector:@selector(clickCell:index:action:)]) {
        [self.parent clickCell:idto index:index action:@(EventFeedTableViewCellActionTypeReport)];
    }
}

- (void)deleteButtonAction:(UIButton *)button
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"是否确认删除"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认", nil];
    [alert show];
}

#pragma mark -
#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([self.parent respondsToSelector:@selector(clickCell:index:action:)]) {
            [self.parent clickCell:idto index:index action:@(EventFeedTableViewCellActionTypeDelete)];
        }
    }
}

#pragma mark -
#pragma mark - ImageListView -

- (void)clickImage:(NSNumber *)idx
{
    BrowseImagesController *vc = [[BrowseImagesController alloc] init];
    [[RootViewController shareRootViewController] presentViewController:vc animated:YES completion:^{
        [vc setDataInfo:((MedFeedDTO *)idto).imageArray];
        [vc setNumberInfo:idx];
    }];
}

#pragma mark -
#pragma mark - setter and getter -

- (UserHeadViewButton *)headImageButton
{
    if (!_headImageButton) {
        _headImageButton = ({
            UserHeadViewButton *button = [[UserHeadViewButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [button addTarget:self action:@selector(headImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _headImageButton;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor colorFromHexString:@"#256666"];
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _nameLabel;
}

- (UILabel *)hospitalLabel
{
    if (!_hospitalLabel) {
        _hospitalLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment =NSTextAlignmentLeft;
            label.textColor = [UIColor colorFromHexString:@"#8d919e"];
            label;
        });
    }
    return _hospitalLabel;
}

- (UITextView *)detailTextView
{
    if (!_detailTextView) {
        _detailTextView = ({
            UITextView *textView = [[UITextView alloc] init];
            textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
            textView.backgroundColor = [UIColor clearColor];
            textView.scrollEnabled = NO;
            textView.font = [UIFont systemFontOfSize:15];
            textView.dataDetectorTypes = UIDataDetectorTypeLink;
            textView.editable = NO;
            textView.selectable = YES;
            textView;
        });
    }
    return _detailTextView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor colorFromHexString:@"#9B9B9C"];
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _timeLabel;
}

- (UIButton *)commentAndLikeButton
{
    if (!_commentAndLikeButton) {
        _commentAndLikeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:GetImage(@"feed_btn_unfold.png") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(commentAndLikeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _commentAndLikeButton;
}

- (MedImageListView *)imageListView
{
    if (!_imageListView) {
        _imageListView = ({
            MedImageListView *listView = [[MedImageListView alloc] init];
            listView.type = MedImageListViewTypeOnlyShow;
            listView;
        });
    }
    return _imageListView;
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
