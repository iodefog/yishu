//
//  GradeAlertView.m
//  zhihuhd
//
//  Created by 无忧 on 13-12-16.
//  Copyright (c) 2013年 mobimac. All rights reserved.
//

#import "GradeAlertView.h"
#import "ImageCenter.h"

#import "DateUtil.h"
#import "GradeHelper.h"

@implementation GradeAlertView

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
    coverView = [[UIView alloc] initWithFrame:CGRectZero];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.25;
    [self addSubview:coverView];
    
    bgImage = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"zh_gradeBG.png"]];
    bgImage.userInteractionEnabled = YES;
    [self addSubview:bgImage];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:[ImageCenter getNamedImage:@"later_zh.png"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[ImageCenter getNamedImage:@"later_zh_c.png"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    [bgImage addSubview:closeButton];
    
    gradeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gradeButton setBackgroundImage:[ImageCenter getNamedImage:@"stars_zh.png"] forState:UIControlStateNormal];
    [gradeButton setBackgroundImage:[ImageCenter getNamedImage:@"stars_zh_c.png"] forState:UIControlStateHighlighted];
    [gradeButton addTarget:self action:@selector(clickGrade) forControlEvents:UIControlEventTouchUpInside];
    [bgImage addSubview:gradeButton];
}

- (void)showChineseTextImage:(BOOL)isChinese
{
    if (isChinese) {
        bgImage.image = [ImageCenter getBundleImage:@"zh_gradeBG.png"];
        [gradeButton setBackgroundImage:[ImageCenter getNamedImage:@"stars_zh.png"] forState:UIControlStateNormal];
        [gradeButton setBackgroundImage:[ImageCenter getNamedImage:@"stars_zh_c.png"] forState:UIControlStateHighlighted];
        [closeButton setBackgroundImage:[ImageCenter getNamedImage:@"later_zh.png"] forState:UIControlStateNormal];
        [closeButton setBackgroundImage:[ImageCenter getNamedImage:@"later_zh_c.png"] forState:UIControlStateHighlighted];
    } else {
        bgImage.image = [ImageCenter getBundleImage:@"en_gradeBG.png"];
        [gradeButton setBackgroundImage:[ImageCenter getNamedImage:@"stars_en.png"] forState:UIControlStateNormal];
        [gradeButton setBackgroundImage:[ImageCenter getNamedImage:@"stars_en_c.png"] forState:UIControlStateHighlighted];
        [closeButton setBackgroundImage:[ImageCenter getNamedImage:@"later_en.png"] forState:UIControlStateNormal];
        [closeButton setBackgroundImage:[ImageCenter getNamedImage:@"later_en_c.png"] forState:UIControlStateHighlighted];
    }
}

- (void)clickClose
{
    if (self.parent != nil && [self.parent respondsToSelector:@selector(hiddenGradeAlert)]) {
        [self.parent performSelector:@selector(hiddenGradeAlert)];
    }
}

- (void)clickGrade
{
    [GradeHelper goToGrade];
    [self clickClose];
}

- (void)resize:(CGSize)size
{
    NSString* deviceType = [UIDevice currentDevice].model;
    NSRange range = [deviceType rangeOfString:@"iPad"];
    
    coverView.frame = CGRectMake(0, 0, size.width, size.height);
    if (range.location != NSNotFound) {
        bgImage.frame = CGRectMake((size.width-344)/2, (size.height-200)/2, 344, 200);
        gradeButton.frame = CGRectMake(bgImage.frame.size.width/2, bgImage.frame.size.height-54, bgImage.frame.size.width/2, 54);
        closeButton.frame = CGRectMake(0, bgImage.frame.size.height-54, bgImage.frame.size.width/2, 54);
    } else {
        bgImage.frame = CGRectMake((size.width-310)/2, (size.height-220)/2, 310, 220);
        gradeButton.frame = CGRectMake(155, bgImage.frame.size.height-44, 150, 44);
        closeButton.frame = CGRectMake(5, bgImage.frame.size.height-44, 150, 44);
    }
    
}

@end
