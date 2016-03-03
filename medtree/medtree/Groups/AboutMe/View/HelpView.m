//
//  HelpView.m
//  xhjxhd
//
//  Created by sam on 7/24/14.
//  Copyright (c) 2014 wuyou. All rights reserved.
//

#import "HelpView.h"
#import "ImageCenter.h"
#import "ImageButton.h"
#import "MedGlobal.h"

@implementation PageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:imageView];
}

- (void)setImage:(UIImage *)image
{
    imageView.image = image;
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    imageView.frame = CGRectMake(0, 0, size.width, size.height);
    UIView *button = [self viewWithTag:101];
    button.frame = CGRectMake((size.width-240)/2,size.height > 480 ? size.height-120: size.height-90, 240, 56);
}

@end

@implementation HelpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
    scroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scroll.delegate = self;
    scroll.pagingEnabled = YES;
    [self addSubview:scroll];
    
    pageCount = 5;
    for (int i=0; i<pageCount; i++) {
        PageView *view = [[PageView alloc] initWithFrame:CGRectZero];
        if (pageCount-i == 1) {
            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            closeButton.tag = 101;
            [closeButton setImage:[ImageCenter getBundleImage:@"btn_help_close.png"] forState:UIControlStateNormal];
            [closeButton setImage:[ImageCenter getBundleImage:@"btn_help_close_click.png"] forState:UIControlStateHighlighted];
            [closeButton addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:closeButton];
        }
        [scroll addSubview:view];
    }
    [self setTotal:pageCount];
}

- (void)clickClose
{
    [self.parent setIsShowHelp:NO];
}

- (NSString *)getPhone
{
    NSString *phone = @"iPhone4";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize size = [[UIScreen mainScreen] currentMode].size;
        if (size.width == 320) {
            phone = @"iPhone3";
        } else if (size.width == 640) {
            if (size.height > 960) {
                phone = @"iPhone5";
            } else {
                phone = @"iPhone4";
            }
        } else if (size.width == 750) {
            phone = @"iPhone6";
        } else {
            phone = @"iPhone6plus";
        }
    }
    return phone;
}

- (void)showHelp
{
    CGSize size = self.frame.size;
    NSString *suffix = @"";
    if (size.height > size.width) {
        suffix = @"v";
    } else {
        suffix = @"h";
    }
    for (int i=0; i<pageCount; i++) {
        UIView *view = [scroll.subviews objectAtIndex:i];
        if ([view isKindOfClass:[PageView class]]) {
            PageView *pageView = (PageView *)view;
            
            NSString *path = [NSString stringWithFormat:@"%@_help_%02d_%@.jpg",[MedGlobal getPhone], i+1, suffix];
            [pageView setImage:[ImageCenter getBundleImage:path]];
        }
    }
    pageIndex = 0;
    scroll.contentOffset = CGPointMake(0, 0);
    [self setIndex:pageIndex];
}

- (void)setTotal:(NSInteger)total
{
    for (int i=0; i<total; i++) {
        UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectZero];
        dotView.image = [ImageCenter getBundleImage:@"help_dot.png"];
        dotView.tag = 200+1+i;
        [self addSubview:dotView];
    }
}

- (void)setIndex:(NSInteger)idx
{
    for (int i=0; i<pageCount; i++) {
        UIImageView *dotView = (UIImageView *)[self viewWithTag:200+i+1];
        if (i == idx) {
            dotView.image = [ImageCenter getBundleImage:@"help_dot_enable.png"];
        } else {
            dotView.image = [ImageCenter getBundleImage:@"help_dot.png"];
        }
    }
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    scroll.frame = CGRectMake(0, 0, size.width, size.height);
    scroll.contentSize = CGSizeMake(size.width*pageCount, size.height);
    scroll.contentOffset = CGPointMake(size.width*pageIndex, 0);
    for (int i=0; i<pageCount; i++) {
        UIView *view = [scroll.subviews objectAtIndex:i];
        view.frame = CGRectMake(size.width*i, 0, size.width, size.height);
    }
    for (int i=0; i<pageCount; i++) {
        UIImageView *dotView = (UIImageView *)[self viewWithTag:200+i+1];
        dotView.frame = CGRectMake((size.width-(pageCount*20))/2+20*i, size.height-20, 10, 10);
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x>(pageCount-1)*self.frame.size.width) {
        [self.parent setIsShowHelp:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageIndex = (NSInteger)((scrollView.contentOffset.x+scrollView.frame.size.width/2)/scrollView.frame.size.width);
    [self setIndex:pageIndex];
}

@end
