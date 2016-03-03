//
//  MedHorizontalScrollTabView.m
//  medtree
//
//  Created by tangshimi on 12/4/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MedHorizontalScrollTabView.h"

static NSInteger const kButtonBaseTag = 100;

@interface MedHorizontalScrollTabView ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation MedHorizontalScrollTabView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backImageView];
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.stackView];
        
        [self.backImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.stackView makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(0);
            make.centerY.equalTo(self.scrollView.centerY);
        }];
        
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

#pragma mark -
#pragma mark - response event -

- (void)buttonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(horizontalScrollTabViewItemDidClick:)]) {
        [self.delegate horizontalScrollTabViewItemDidClick:button.tag - kButtonBaseTag];
    }
}

#pragma mark -
#pragma mark - setter and getter-

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *view = [[UIScrollView alloc] init];
            view.showsHorizontalScrollIndicator = NO;
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _scrollView;
}

- (UIStackView *)stackView
{
    if (!_stackView) {
        _stackView = ({
            UIStackView *view = [[UIStackView alloc] init];
            view.distribution = UIStackViewDistributionEqualSpacing;
            view.spacing = 20;
            
            view;
        });
    }
    return _stackView;
}

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
    }
    return _backImageView;
}

- (void)setItemSpace:(CGFloat)itemSpace
{
    _itemSpace = itemSpace;
    self.stackView.spacing = itemSpace;
}

- (void)setEdgeSpace:(CGFloat)edgeSpace
{
    _edgeSpace = edgeSpace;
    
    [self.stackView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(edgeSpace);
        make.centerY.equalTo(self.scrollView.centerY);
    }];
    
    if (self.stackView.arrangedSubviews.count > 0) {
        [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(0);
            make.right.equalTo(self.stackView.right).offset(self.edgeSpace);
        }];
    }
}

- (void)setItemFont:(UIFont *)itemFont
{
    _itemFont = itemFont;
    
    if (self.stackView.arrangedSubviews.count > 0) {
        for (UIButton *button in self.stackView.arrangedSubviews) {
            button.titleLabel.font = itemFont;
        }
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    
    self.backImageView.image = backgroundImage;
}

- (void)setItemsArray:(NSArray *)itemsArray
{
    _itemsArray = [itemsArray copy];
    
    if (self.stackView.arrangedSubviews.count > 0) {
        for (UIView *view in self.stackView.arrangedSubviews) {
            [self.stackView removeArrangedSubview:view];
        }
    }
    
    NSInteger i = 0;
    for (NSString *string in itemsArray) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font =  self.itemFont ? : [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = kButtonBaseTag + i;
        
        [self.stackView addArrangedSubview:button];
        i ++;
    }
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(0);
        make.right.equalTo(self.stackView.right).offset(self.edgeSpace);
    }];
}

@end
