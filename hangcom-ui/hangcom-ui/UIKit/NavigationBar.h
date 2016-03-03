//
//  NavigationBar.h
//  mcarepatient
//
//  Created by sam on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    NavigationButton_Normal,
    NavigationButton_Back,
    NavigationButton_Forward
} NavigationButton;

@interface NavigationBar : UIView {
    UILabel *topLabel;
    UIView *topView;
    UIView *rightButton;
    
    UIImageView *backGroundImage;

    CGFloat         barWidth;
    CGFloat         barHeight;

    CGFloat         offset_left;
    CGFloat         offset_right;
}

- (id)initWithSize:(CGSize)size;

- (void)reloadBGImage;
- (void)setBackgroundImage:(NSString *)imageName;
- (void)changeBackGroundImage:(NSString *)imageName;
- (void)setLeftButton:(UIView *)button;
- (void)setLeftButtons:(NSArray *)buttons;
- (void)setRightButton:(id)button;
- (void)setTopTitle:(NSString *)title;
- (void)setTopTitle:(NSString *)title font:(UIFont *)font;
- (void)setTopView:(UIView *)view;
- (void)setLeftOffset:(CGFloat)offset;
- (void)setRightOffset:(CGFloat)offset;
- (void)setTopLabelColor:(UIColor *)color;

- (id)rightButton;
- (id)leftButton;

- (NSString *)title;

+ (UIButton *)createButton:(NSString *)title type:(NSInteger)type target:(id)target action:(SEL)action;
+ (UIButton *)createImageButton:(NSString *)imageName selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action;
+ (UIButton *)createBackButton:(NSString *)title target:(id)target action:(SEL)action;
+ (UIButton *)createNormalButton:(NSString *)title target:(id)target action:(SEL)action;
+ (UIButton *)createIconButton:(NSString *)iconName target:(id)target action:(SEL)action;
+ (UIButton *)createImageButton:(NSString *)imageName selectedImage:(NSString *)selectedImage topImage:(NSString *)topImage size:(CGSize)size target:(id)target action:(SEL)action;
+ (UIButton *)createImageButton:(NSString *)imageName selectedImage:(NSString *)selectedImage topTitle:(NSString *)topTitle size:(CGSize)size target:(id)target action:(SEL)action;
+ (UIButton *)createImageButton:(NSString *)imageName selectedImage:(NSString *)selectedImage topTitle:(NSString *)topTitle fontSize:(CGFloat)fontSize size:(CGSize)size target:(id)target action:(SEL)action;

+ (UIButton *)createLeftButton:(NSInteger)type target:(id)target action:(SEL)action;
+ (UIButton *)createRightButton:(NSString *)title target:(id)target action:(SEL)action;
+ (UIButton *)createImageButton:(NSString *)topImage target:(id)target action:(SEL)action;

@end
