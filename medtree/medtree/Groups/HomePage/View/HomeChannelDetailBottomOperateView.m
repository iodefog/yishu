//
//  HomeChannelDetailBottomOperateView.m
//  medtree
//
//  Created by tangshimi on 8/21/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeChannelDetailBottomOperateView.h"
#import "UIImage+imageWithColor.h"
#import "UIColor+Colors.h"
#import "NSString+Extension.h"

NSInteger const kHomeChannelDetailBottomOperateViewButtonBaseTag = 1000;

@interface HomeChannelDetailBottomOperateView ()

@property (nonatomic, assign) HomeChannelDetailBottomOperateViewType type;
@property (nonatomic, strong) UILabel *favourNumberLabel;
@property (nonatomic, strong) UIButton *favourButton;
@property (nonatomic, strong) UILabel *speakCountLabel;

@end

@implementation HomeChannelDetailBottomOperateView

- (instancetype)initWithFrame:(CGRect)frame type:(HomeChannelDetailBottomOperateViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
        _type = type;
        
        [self addSubview:({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GetViewWidth(self), 0.5)];
            view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
            view;
        })];
        
        NSInteger buttonNumber = (self.type == HomeChannelDetailBottomOperateViewTypeArticle ? 3 : 3 );
        
        for (NSInteger i = 0; i < buttonNumber; i ++) {
            CGFloat width = (CGRectGetWidth(frame) - (buttonNumber - 1) * 0.5) / buttonNumber;
            CGFloat height = CGRectGetHeight(frame);
            CGFloat x = i * (width + 0.5);
            CGFloat y = 0;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.tag = kHomeChannelDetailBottomOperateViewButtonBaseTag + i;
            button.frame = CGRectMake(x, y, width, height);
            [button setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
            [button setTitle:[self titlesArray][i] forState:UIControlStateNormal];
            [button setImage:GetImage([self imagesArray][i]) forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, - 3, 0, 0)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, - 12, 0, 0)];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#c5c5c5"] size:CGSizeMake(width, height)]
                              forState:UIControlStateHighlighted];
            
            if (i == 1) {
                [button setImage:GetImage(@"home_favour_yes.png") forState:UIControlStateSelected | UIControlStateNormal];
                self.favourButton = button;
            }
    
            [self addSubview:button];

            if (i != buttonNumber - 1) {
                UIView *verticalView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), 10, 0.5, 25)];
                verticalView.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:verticalView];
            }
            
            if (i == 1) {
                [self addSubview:self.favourNumberLabel];
                self.favourNumberLabel.frame = CGRectMake(CGRectGetMidX(button.frame) + 20, 8, 0, 12);
            }
            
            if(self.type == HomeChannelDetailBottomOperateViewTypeArticle && i == 0) {
                [self addSubview:self.speakCountLabel];
                self.speakCountLabel.frame = CGRectMake(CGRectGetMidX(button.frame) + 26, 8, 0, 12);
            }
        }
    }
    return self;
}

#pragma mark -
#pragma mark - response event -

- (void)buttonAction:(UIButton *)button
{
    if (![self.delegate respondsToSelector:@selector(homeChannelDetailBottomOperateViewDidSelectWithType:)]) {
        return;
    }
    
    HomeChannelDetailBottomOperateViewOperationType type = 0;
    
    if (self.type == HomeChannelDetailBottomOperateViewTypeDiscussion) {
        switch (button.tag - kHomeChannelDetailBottomOperateViewButtonBaseTag) {
            case 0:
                type = HomeChannelDetailBottomOperateViewOperationTypeRespond;
                break;
            case 1:
                type = HomeChannelDetailBottomOperateViewOperationTypeFavour;
                break;
            case 2:
                type = HomeChannelDetailBottomOperateViewOperationTypeInvite;
                break;
        }
        
    } else  if (self.type == HomeChannelDetailBottomOperateViewTypeArticle) {
        switch (button.tag - kHomeChannelDetailBottomOperateViewButtonBaseTag) {
            case 0:
                type = HomeChannelDetailBottomOperateViewOperationTypeRespond;
                break;
            case 1:
                type = HomeChannelDetailBottomOperateViewOperationTypeFavour;
                break;
            case 2:
                type = HomeChannelDetailBottomOperateViewOperationTypeShare;
                break;
        }
    }
    
    [self.delegate homeChannelDetailBottomOperateViewDidSelectWithType:type];
}

#pragma mark -
#pragma mark - helper -

- (NSArray *)titlesArray
{
    if (self.type == HomeChannelDetailBottomOperateViewTypeDiscussion) {
        return @[ @"发言", @"赞", @"邀请" ];
    } else  if (self.type == HomeChannelDetailBottomOperateViewTypeArticle ){
        return @[ @"发言", @"赞", @"分享" ];
    }
    return nil;
}

- (NSArray *)imagesArray
{
    if (self.type == HomeChannelDetailBottomOperateViewTypeDiscussion) {
        return @[ @"home_response", @"home_favour_no", @"home_invite" ];
    } else  if (self.type == HomeChannelDetailBottomOperateViewTypeArticle){
        return @[ @"home_response", @"home_favour_no", @"home_share" ];
    }
    return nil;
}

#pragma mark -
#pragma mark - setter and getter -

- (UILabel *)favourNumberLabel
{
    if (!_favourNumberLabel) {
        _favourNumberLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:11];
            label.layer.cornerRadius = 6.0f;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor colorFromHexString:@"#22e2c9"];
            label;
        });
    }
    return _favourNumberLabel;
}

- (UILabel *)speakCountLabel
{
    if (!_speakCountLabel) {
        _speakCountLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = [UIColor whiteColor];
            label.layer.cornerRadius = 6.0f;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor colorFromHexString:@"#22e2c9"];
            label;
        });
    }
    return _speakCountLabel;
}

- (void)setFavourNumber:(NSInteger)favourNumber
{
    _favourNumber = favourNumber;
    
    CGFloat width = [NSString sizeForString:[NSString stringWithFormat:@"%@", @(favourNumber)]
                                       Size:CGSizeMake(MAXFLOAT, 15)
                                       Font:self.favourNumberLabel.font
                                      Lines:1].width;
    
    CGRect frame = self.favourNumberLabel.frame;
    frame.size.width = width + 2;
    
    self.favourNumberLabel.text = [NSString stringWithFormat:@"%@", @(favourNumber)];
    self.favourNumberLabel.frame = frame;
}

- (void)setFavour:(BOOL)favour
{
    _favour = favour;
    
    self.favourButton.selected = favour;    
}

- (void)setSpeakCountNumber:(NSInteger)speakCountNumber
{
    _speakCountNumber = speakCountNumber;
    
    CGFloat width = [NSString sizeForString:[NSString stringWithFormat:@"%@", @(speakCountNumber)]
                                       Size:CGSizeMake(MAXFLOAT, 15)
                                       Font:self.speakCountLabel.font
                                      Lines:1].width;
    
    CGRect frame = self.speakCountLabel.frame;
    frame.size.width = width + 2;
    
    self.speakCountLabel.text = [NSString stringWithFormat:@"%@", @(speakCountNumber)];
    self.speakCountLabel.frame = frame;
}

@end
