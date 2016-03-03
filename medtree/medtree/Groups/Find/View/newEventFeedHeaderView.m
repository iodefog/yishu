//
//  newEventFeedHeaderView.m
//  medtree
//
//  Created by tangshimi on 5/28/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "newEventFeedHeaderView.h"
#import "UIImageView+setImageWithURL.h"
#import "MedGlobal.h"
#import "FXBlurView.h"

@interface newEventFeedHeaderView () <UISearchBarDelegate>

@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)FXBlurView *blurView;
@property (nonatomic, strong)UIImageView *activityImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *placeLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, strong)UIButton *joinSubActivityButton;
@property (nonatomic, strong)UISearchBar *searchBar;

@end

@implementation newEventFeedHeaderView

- (void)createUI
{
    self.userInteractionEnabled = YES;
    self.backImageView.userInteractionEnabled = YES;
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.blurView];
    [self.backImageView addSubview:self.activityImageView];
    [self.backImageView addSubview:self.titleLabel];
    [self.backImageView addSubview:self.placeLabel];
    [self.backImageView addSubview:self.timeLabel];
    [self.backImageView addSubview:self.detailLabel];
    [self.backImageView addSubview:self.joinSubActivityButton];
    [self addSubview:self.searchBar];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.isOnlyShowSearchBar) {
        self.backImageView.hidden = NO;
        self.backImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 45);
        self.blurView.frame = self.backImageView.bounds;
        self.activityImageView.frame = CGRectMake(15, 80, 110, 90);
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.activityImageView.frame) + 12,
                                           80,
                                           CGRectGetWidth(self.frame) - CGRectGetMaxX(self.activityImageView.frame) - 15,
                                           20);
        self.placeLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                           CGRectGetMaxY(self.titleLabel.frame),
                                           CGRectGetWidth(self.titleLabel.frame),
                                           18);
        self.timeLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                          CGRectGetMaxY(self.placeLabel.frame),
                                          CGRectGetWidth(self.titleLabel.frame),
                                          18);
        self.detailLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                            CGRectGetMaxY(self.timeLabel.frame),
                                            CGRectGetWidth(self.titleLabel.frame) - 15,
                                            CGRectGetHeight(self.activityImageView.frame) - CGRectGetHeight(self.titleLabel.frame) - 36);
        self.joinSubActivityButton.frame = CGRectMake(GetViewWidth(self) - 115, CGRectGetMaxY(self.activityImageView.frame) + 10, 100, 20);
        self.searchBar.frame = CGRectMake(0, CGRectGetMaxY(self.backImageView.frame) + 5, CGRectGetWidth(self.frame), 35);
    } else {
        self.backImageView.hidden = YES;
        self.searchBar.frame = CGRectMake(0, 5, CGRectGetWidth(self.frame), 35);
    }
}

#pragma mark -
#pragma mark - UISearchBarDelegate -

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if ([self.delegate respondsToSelector:@selector(eventFeedHeaderViewClickSearchBar)]) {
        [self.delegate eventFeedHeaderViewClickSearchBar];
    }
    return NO;
}

#pragma mark -
#pragma mark - event response -

- (void)joinSubActivityButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(eventFeedHeaderViewJionSubActivity)]) {
        [self.delegate eventFeedHeaderViewJionSubActivity];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(eventFeedHeaderViewSeeAbouActivityDetail)]) {
        [self.delegate eventFeedHeaderViewSeeAbouActivityDetail];
    }
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        UIImageView *backImageView = [[UIImageView alloc] init];
        backImageView.backgroundColor = [UIColor clearColor];
        backImageView.contentMode = UIViewContentModeScaleAspectFill;
        backImageView.clipsToBounds = YES;
        _backImageView = backImageView;
    }
    return _backImageView;
}

- (FXBlurView *)blurView
{
    if (!_blurView) {
        FXBlurView *view = [[FXBlurView alloc] init];
        view.tintColor = [UIColor blackColor];
        view.dynamic = YES;
        view.blurRadius = 30;
        _blurView = view;
    }
    return _blurView;
}

- (UIImageView *)activityImageView
{
    if (!_activityImageView) {
        UIImageView *activityImageView = [[UIImageView alloc] init];
        activityImageView.contentMode = UIViewContentModeScaleAspectFit;
        _activityImageView = activityImageView;
    }
    return _activityImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)placeLabel
{
    if (!_placeLabel) {
        UILabel *placeLabel = [[UILabel alloc] init];
        placeLabel.textColor = [UIColor grayColor];
        placeLabel.font = [UIFont systemFontOfSize:13];
        placeLabel.textAlignment = NSTextAlignmentLeft;
        placeLabel.text = @"地点：";
        _placeLabel = placeLabel;
    }
    return _placeLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.text = @"时间：";
        _timeLabel = timeLabel;
    }
    return _timeLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.font = [UIFont systemFontOfSize:13];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.numberOfLines = 2;
        _detailLabel = detailLabel;
    }
    return _detailLabel;
}

- (UIButton *)joinSubActivityButton
{
    if (!_joinSubActivityButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"参与子活动" forState:UIControlStateNormal];
        [button setImage:GetImage(@"setting_img_arrow.png") forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 90, 0, 0)];
        [button addTarget:self action:@selector(joinSubActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _joinSubActivityButton = button;
    }
    return _joinSubActivityButton;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        searchBar.autocorrectionType        = UITextAutocorrectionTypeNo;
        searchBar.placeholder               = @"搜索姓名/动态";
        searchBar.autocapitalizationType    = UITextAutocapitalizationTypeNone;
        searchBar.delegate                  = self;
        searchBar.backgroundColor           = [UIColor clearColor];
        searchBar.alpha                     = 1;
        searchBar.userInteractionEnabled    = YES;
        searchBar.autoresizesSubviews       = YES;
        searchBar.showsCancelButton         = NO;
        for (UIView *view in searchBar.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
        _searchBar = searchBar;
    }
    return _searchBar;
}

- (void)setEventDTO:(EventDTO *)eventDTO
{
    if (!eventDTO) {
        return;
    }
    
    _eventDTO = nil;
    _eventDTO = eventDTO;
    
    NSString *imageURL = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_120_90], eventDTO.small_image_id];
    NSString *bimageURL = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_120_90], eventDTO.large_image_id];
    [self.backImageView med_setImageWithUrl:[NSURL URLWithString:bimageURL]];
    [self.activityImageView med_setImageWithUrl:[NSURL URLWithString:imageURL]];
    self.titleLabel.text = eventDTO.title;
    
    NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
    [dataFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *startTime = [dataFormat stringFromDate:eventDTO.start_time];
    NSString *endTime = [dataFormat stringFromDate:eventDTO.end_time];
    self.timeLabel.text = [NSString stringWithFormat:@"时间：%@ - %@", startTime, endTime];
    self.detailLabel.text = [NSString stringWithFormat:@"简介：%@", eventDTO.summary];
    self.placeLabel.text = [NSString stringWithFormat:@"地点：%@", eventDTO.place];
}

@end
