//
//  BadgeView.m
//  mcare-ui
//
//  Created by sam on 12-10-8.
//
//

#import "BadgeView.h"
#import "ImageCenter.h"
#import "ColorUtil.h"

@implementation BadgeView

@synthesize width;
@synthesize height;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageText = @"NO0_bg_badge.png";
    //[self addSubview:imageView];

    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    roundView = [[UIView alloc] init];
    roundView.layer.cornerRadius = 4;
    roundView.backgroundColor = [UIColor redColor];
    roundView.hidden = YES;
    [self addSubview:roundView];
    
    width = 16;
    height = 16;
}

- (void)changeBGImage:(NSString *)imageName textColor:(NSString *)textColor
{
    roundView.backgroundColor = [ColorUtil getColor:@"FFF10D" alpha:1];
    imageText = imageName;
    label.textColor = [ColorUtil getColor:textColor alpha:1];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // do nothing
    CGSize size = CGSizeMake(16, 16);
    CGSize size2 = [label.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingMiddle];
    imageView.image = [[ImageCenter getNamedImage:imageText] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    width = size2.width+2;
    CGFloat offsetx = 1;
    if (width < 16) {
        width = 16;
        offsetx = 0;
    }
    height = size2.height;
    if (height < 16) {
        height = 16;
    }
    
    CGSize size3 = self.frame.size;
    roundView.frame = CGRectMake(0, (size3.height-8)/2, 8, 8);
    imageView.frame = CGRectMake(0, (size3.height-height)/2, width, height);
    label.frame = CGRectMake(offsetx, (size3.height-height)/2, width, height);
}

- (void)setBadge:(NSString *)badge
{
    label.text = badge;

    if (badge != nil) {
        roundView.hidden = YES;
        if ([self.subviews containsObject:imageView] == NO) {
            [self addSubview:imageView];
        }
        if ([self.subviews containsObject:label] == NO) {
            [self addSubview:label];
        }
    } else {
        if ([self.subviews containsObject:imageView] == YES) {
            [imageView removeFromSuperview];
        }
        if ([self.subviews containsObject:label] == YES) {
            [label removeFromSuperview];
        }
    }
    [self layoutSubviews];
}

- (void)setIsShowRoundView:(BOOL)isShow
{
    if (isShow) {
        if ([self.subviews containsObject:imageView] == YES) {
            roundView.hidden = YES;
        } else {
            roundView.hidden = NO;
        }
    } else {
        roundView.hidden = YES;
    }
}

@end
