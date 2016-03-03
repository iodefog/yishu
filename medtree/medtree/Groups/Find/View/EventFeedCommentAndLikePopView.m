//
//  EventFeedCommentAndLikePopView.m
//  medtree
//
//  Created by tangshimi on 8/6/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "EventFeedCommentAndLikePopView.h"

@interface EventFeedCommentAndLikePopView ()

@property (nonatomic, strong) UIView *destinationView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIView *midLineView;

@end

@implementation EventFeedCommentAndLikePopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.destinationView];
        [self.destinationView addSubview:self.containerView];
        [self.containerView addSubview:self.commentButton];
        [self.containerView addSubview:self.likeButton];
        [self.containerView addSubview:self.midLineView];
        
        self.destinationView.frame =  CGRectMake(0, 0, 120, 34);
        self.containerView.frame = CGRectMake(120, 0, 120, 34);
        
        self.likeButton.frame = CGRectMake(0, 0, (GetViewWidth(self.containerView) - 1) / 2.0, GetViewHeight(self.containerView));
        self.midLineView.frame = CGRectMake(GetViewWidth(self.containerView) / 2.0 - 0.5, 7, 1, 20);
        self.commentButton.frame = CGRectMake(CGRectGetMaxX(self.midLineView.frame), 0, GetViewWidth(self.likeButton), GetViewHeight(self.containerView));
    }
    return self;
}

#pragma mark -
#pragma mark - public -

- (void)showAtPoint:(CGPoint)point inView:(UIView *)inView
{
    self.destinationView.center = point;

    self.frame = inView.bounds;
    [inView addSubview:self];
    
    [self showWithAnimated:YES];
}

#pragma mark -
#pragma mark - response event -

- (void)commentButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(eventFeedCommentAndLikePopView:didSelectedType:)]) {
        [self.delegate eventFeedCommentAndLikePopView:self didSelectedType:EventFeedCommentAndLikePopViewCommentSelectedType];
    }
    
    [self hideWithAnimated:YES];
}

- (void)likeButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(eventFeedCommentAndLikePopView:didSelectedType:)]) {
        [self.delegate eventFeedCommentAndLikePopView:self didSelectedType:EventFeedCommentAndLikePopViewLikeSelectedType];
    }
    
    self.like = !self.like;

    [self hideWithAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self hideWithAnimated:YES];
}

#pragma mark -
#pragma mark - private -

- (void)showWithAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.containerView.frame = self.destinationView.bounds;
        } completion:nil];
        
    }
}

- (void)hideWithAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.containerView.frame = CGRectMake(120, 0, 120, 34);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
    }
}

#pragma mark -
#pragma mark - setter and getter -

- (UIView *)destinationView
{
    if (!_destinationView) {
        _destinationView = ({
            UIView *view = [[UIView alloc] init];
            view.clipsToBounds = YES;
            view.layer.cornerRadius = 8;
            view.userInteractionEnabled = YES;
            view;
        });
    }
    return _destinationView;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
            view.layer.cornerRadius = 8;
            view.layer.masksToBounds = YES;
            view;
        });
    }
    return _containerView;
}

- (UIButton *)commentButton
{
    if (!_commentButton) {
        _commentButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTintColor:[UIColor whiteColor]];
            [button setTitle:@"评论" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setImage:GetImage(@"feed_btn_comment.png") forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 30)];
            [button addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _commentButton;
}

- (UIButton *)likeButton
{
    if (!_likeButton) {
        _likeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTintColor:[UIColor whiteColor]];
            [button setTitle:@"赞" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setImage:GetImage(@"feed_btn_like.png") forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 30)];
            [button addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _likeButton;
}

- (UIView *)midLineView
{
    if (!_midLineView) {
        _midLineView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor blackColor];
            view;
        });
    }
    return _midLineView;
}

- (void)setLike:(BOOL)like
{
    if (_like == like) {
        return;
    }
    _like = like;
    if (like) {
        [self.likeButton setImage:GetImage(@"feed_btn_like_click.png") forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:GetImage(@"feed_btn_like.png") forState:UIControlStateNormal];
    }
}

@end
