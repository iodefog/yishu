//
//  HomeChannelWriteGuideView.m
//  medtree
//
//  Created by tangshimi on 9/30/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeChannelWriteGuideView.h"

@interface HomeChannelWriteGuideView ()

@property (nonatomic, strong) UIImageView *writeImageView;

@end

@implementation HomeChannelWriteGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.writeImageView];
        
        [self.writeImageView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-15);
            make.bottom.equalTo(@-45);
        }];
    }
    return self;
}

+ (void)showInView:(UIView *)inView
{
    if (![BaseGuideView showGuideView:[NSString stringWithUTF8String:object_getClassName(self)]]) {
        return;
    }
    [BaseGuideView setAlreadyShow:[NSString stringWithUTF8String:object_getClassName(self)]];
    
    HomeChannelWriteGuideView *view = [[self alloc] initWithFrame:inView.bounds];
    view.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        view.alpha = 1.0;
        [inView addSubview:view];
    }];
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)writeImageView
{
    if (!_writeImageView) {
        _writeImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"home_channel_write_guide.png");
            imageView;
        });
    }
    return _writeImageView;
}

@end
