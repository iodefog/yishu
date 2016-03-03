//
//  MedEquivalentWidthView.m
//  medtree
//
//  Created by tangshimi on 10/30/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MedEquivalentWidthView.h"
#import "UIColor+Colors.h"
#import "UIImage+imageWithColor.h"

static const NSInteger kButtonBaseTag = 1000;

@interface MedEquivalentWidthView ()

@property (nonatomic, copy) NSArray *viewsArray;

@property (nonatomic, strong) NSDictionary *customViewDic;

@end

@implementation MedEquivalentWidthView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *topLineView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
            view;
        });
        [self addSubview:topLineView];
        
        [topLineView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.left.equalTo(0);
            make.top.equalTo(0);
            make.height.equalTo(0.5);
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
    if ([self.delegate respondsToSelector:@selector(equivalentWidthView:clickAtIndex:)]) {
        [self.delegate equivalentWidthView:self clickAtIndex:button.tag - kButtonBaseTag];
    }
}

#pragma mark -
#pragma mark - public -

- (void)setupView
{
    __block UIView *lastView = nil;
    
    [self.titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.stackView addArrangedSubview:[self singleSubViewWithIndex:idx]];
//        if (idx < self.titleArray.count - 1) {
//            MedEquivalentWidthViewSeperateView *view = [[MedEquivalentWidthViewSeperateView alloc] init];
//            [self.stackView addArrangedSubview:view];
//        }
        UIButton *button = [self singleSubViewWithIndex:idx];
        [self addSubview:button];
        
        [button makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.equalTo(lastView.right).offset(1);
                make.width.equalTo(lastView.width);
            } else {
                make.left.equalTo(0);
            }
            make.top.equalTo(0);
            make.bottom.equalTo(0);
            
            if (idx == self.titleArray.count - 1) {
                make.right.equalTo(0);
            }
        }];
        
        lastView = button;
        
        if (idx < self.titleArray.count - 1) {
            MedEquivalentWidthViewSeperateView *view = [[MedEquivalentWidthViewSeperateView alloc] init];
            [self addSubview:view];
            
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(button.right);
                make.centerY.equalTo(0);
            }];
        }
    }];
}

#pragma mark -
#pragma mark - helper -

- (UIButton *)singleSubViewWithIndex:(NSInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = kButtonBaseTag + index;
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#c5c5c5"] size:CGSizeMake(50, 44)]
                      forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

    [button setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = GetImage(self.imageArray[index]);
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.text = self.titleArray[index];
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[ imageView, label ]];
    stackView.userInteractionEnabled = NO;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    [button addSubview:stackView];
    
    [stackView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
    }];
    
    return button;
}

@end


@implementation MedEquivalentWidthViewSeperateView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    }
    
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(1, 20);
}

@end
