//
//  NavigationBar.m
//  mcarepatient
//
//  Created by sam on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NavigationBar.h"
#import "ImageButton.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "FontUtil.h"

@interface NavigationBar ()

@property (nonatomic, strong) NSMutableArray *leftItems;

@end

@implementation NavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        barWidth = 320;
        barHeight = 48;
        [self createUI];
    }
    return self;
}

- (id)initWithSize:(CGSize)size
{
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self) {
        // Initialization code
        barWidth = size.width;
        barHeight = size.height;
        [self createUI];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)changeBackGroundImage:(NSString *)imageName
{
    backGroundImage.image = [ImageCenter getBundleImage:imageName];
    if (imageName.length == 0) {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setBackgroundImage:(NSString *)imageName
{
    backGroundImage.image = [ImageCenter getBundleCatenaImage:imageName];
}

- (void)createUI
{
    self.backgroundColor = [UIColor whiteColor];
    backGroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, barWidth, barHeight)];
    backGroundImage.image = [ImageCenter getBundleCatenaImage:@"naviBar_background.png"];
    backGroundImage.userInteractionEnabled = YES;
    [self addSubview:backGroundImage];
}

- (void)reloadBGImage
{
    backGroundImage.image = [ImageCenter getBundleCatenaImage:@"naviBar_background.png"];
}

- (void)setLeftButton:(UIView *)button
{
    for (UIView *view in self.subviews) {
        if ([view isEqual:rightButton] ||
            [view isEqual:topLabel] ||
            [view isEqual:topView] ||
            [view isEqual:backGroundImage]) continue;
        [view removeFromSuperview];
    }
    [self.leftItems removeAllObjects];
    [self.leftItems addObject:button];
    [self addSubview:button];
}

- (void)setLeftButtons:(NSArray *)buttons
{
    for (UIView *view in self.subviews) {
        if ([view isEqual:rightButton] ||
            [view isEqual:topLabel] ||
            [view isEqual:topView] ||
            [view isEqual:backGroundImage]) continue;
            
        [view removeFromSuperview];
    }
    [self.leftItems removeAllObjects];
    for (UIView *button in buttons) {
        [self.leftItems addObject:button];
        [self addSubview:button];
    }
}

- (void)setRightButton:(id)button
{
    if (rightButton != nil) {
        [rightButton removeFromSuperview];
        rightButton = nil;
    }
    if (button != nil) {
        rightButton = button;
        [self addSubview:rightButton];
    }
}

- (id)rightButton
{
    return rightButton;
}

- (id)leftButton
{
    return [self.leftItems firstObject];
}

- (NSString *)title
{
    return topLabel.text;
}

- (void)setTopTitle:(NSString *)title
{
    [self setTopTitle:title font:[UIFont systemFontOfSize:18]];
}

- (void)setTopTitle:(NSString *)title font:(UIFont *)font
{
    if (topLabel == nil) {
        topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        topLabel.backgroundColor = [UIColor clearColor];
        topLabel.textColor = [FontUtil getBarFontColor];
        if (font == nil) {
            [FontUtil setFont:topLabel size:18];
        } else {
            topLabel.font = font;
        }
        topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:topLabel];
    }
    topLabel.text = title;
}

- (void)setTopLabelColor:(UIColor *)color
{
    topLabel.textColor = color;
}

- (void)setTopView:(UIView *)view
{
    if (view == nil) {
        if (topView != nil) {
            [topView removeFromSuperview];
        }
    } else {
        if (topView == nil) {
            [self addSubview:view];
        }
    }
    topView = view;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    backGroundImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    __block CGFloat x = offset_left;
    [self.leftItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CGFloat y = (self.frame.size.height - view.frame.size.height) / 2;
        if (!view.hidden) {
            view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
            x += view.frame.size.width;
        }
    }];
    CGFloat rigthX = self.frame.size.width - rightButton.frame.size.width - offset_right;
    CGFloat rightY = (self.frame.size.height - rightButton.frame.size.height) / 2;
    rightButton.frame = CGRectMake(rigthX,
                                   rightY,
                                   rightButton.frame.size.width,
                                   rightButton.frame.size.height);
    
    CGFloat rightW = rightButton.frame.size.width + offset_right;
    CGFloat leftW = x + offset_left;
    
    CGFloat max = fmaxf(rightW, leftW);
    
    CGFloat topLabelW = self.frame.size.width - max * 2;
    CGFloat topLabelX = (self.frame.size.width - topLabelW) * 0.5;
    topLabel.frame = CGRectMake(topLabelX, 7, topLabelW, 30);
    //
    CGSize size = topView.frame.size;
    topView.frame = CGRectMake((self.frame.size.width-size.width) / 2, (self.frame.size.height - size.height) / 2, size.width, size.height);
}

+ (UIButton *)createButton:(NSString *)title type:(NSInteger)type target:(id)target action:(SEL)action
{
    if (type == NavigationButton_Back) {
        return [NavigationBar createBackButton:title target:target action:action];
    } else {
        return [NavigationBar createNormalButton:title target:target action:action];
    }
}

+ (UIButton *)createImageButton:(NSString *)imageName selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [ImageCenter getNamedImage:imageName];
    UIImage *img2 = [ImageCenter getNamedImage:selectedImage];
    button.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [button setImage:img forState:UIControlStateNormal];
    if (img2 != nil) {
        [button setImage:img2 forState:UIControlStateHighlighted];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createBackButton:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [ImageButton createBackButton:title];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createNormalButton:(NSString *)title target:(id)target action:(SEL)action
{
    CGSize size = CGSizeMake(100, 20);
    CGSize labelsize = [title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    UIButton *button = [ImageButton createButton:title size:CGSizeMake(labelsize.width+26, 32)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createIconButton:(NSString *)iconName target:(id)target action:(SEL)action
{
    UIButton *button = [ImageButton createButton:iconName];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createImageButton:(NSString *)imageName selectedImage:(NSString *)selectedImage topImage:(NSString *)topImage size:(CGSize)size target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [ImageCenter getNamedImage:imageName];
    UIImage *img2 = [ImageCenter getNamedImage:selectedImage];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    [button setBackgroundImage:img forState:UIControlStateNormal];
    if (img2 != nil) {
        [button setBackgroundImage:img2 forState:UIControlStateHighlighted];
    }
    UIImage *top = [UIImage imageNamed:topImage];
    if (top != nil) {
        UIImageView *topView = [[UIImageView alloc] initWithImage:top];
        topView.frame = CGRectMake((size.width-top.size.width)/2, (size.height-top.size.height)/2, top.size.width, top.size.height);
        [button addSubview:topView];
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;    
}

+ (UIButton *)createImageButton:(NSString *)imageName selectedImage:(NSString *)selectedImage topTitle:(NSString *)topTitle size:(CGSize)size target:(id)target action:(SEL)action
{
    return [NavigationBar createImageButton:imageName selectedImage:selectedImage topTitle:topTitle fontSize:16 size:size target:target action:action];
}

+ (UIButton *)createImageButton:(NSString *)imageName selectedImage:(NSString *)selectedImage topTitle:(NSString *)topTitle fontSize:(CGFloat)fontSize size:(CGSize)size target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [ImageCenter getNamedImage:imageName];
    UIImage *img2 = [ImageCenter getNamedImage:selectedImage];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    [button setBackgroundImage:img forState:UIControlStateNormal];
    if (img2 != nil) {
        [button setBackgroundImage:img2 forState:UIControlStateHighlighted];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (size.height-20)/2, size.width, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [FontUtil getBarFontColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = topTitle;
    label.font = [UIFont systemFontOfSize:fontSize];
    [button addSubview:label];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createLeftButton:(NSInteger)type target:(id)target action:(SEL)action
{
    NSString *topImage = @"naviBar_btn_normal_back.png";
    if (type == 1) {
        topImage = @"naviBar_btn_normal_close.png";
    }
    UIButton *button = [NavigationBar createImageButton:@"naviBar_btn_normal.png" selectedImage:@"naviBar_btn_normal_select.png" topImage:topImage size:CGSizeMake(44, 44) target:target action:action];
    return button;
}

+ (UIButton *)createRightButton:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [NavigationBar createImageButton:@"naviBar_btn_normal.png" selectedImage:@"naviBar_btn_normal_select.png" topTitle:title size:CGSizeMake(60, 44) target:target action:action];
    return button;
}

+ (UIButton *)createImageButton:(NSString *)topImage target:(id)target action:(SEL)action
{
    UIButton *button = [NavigationBar createImageButton:@"naviBar_btn_normal.png" selectedImage:@"naviBar_btn_normal_select.png" topImage:topImage size:CGSizeMake(44, 44) target:target action:action];
    return button;
}

- (void)setLeftOffset:(CGFloat)offset
{
    offset_left = offset;
}

- (void)setRightOffset:(CGFloat)offset
{
    offset_right = offset;
}

- (NSMutableArray *)leftItems
{
    if (!_leftItems) {
        _leftItems = [[NSMutableArray alloc] init];
    }
    return _leftItems;
}

@end
