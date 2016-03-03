//
//  InfoAlertView.m
//  mcare-ui
//
//  Created by sam on 12-10-11.
//
//

#import "InfoAlertView.h"

@implementation ProgressHUD2

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
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hide:YES];
    [self removeFromSuperview];
}

@end

@implementation InfoAlertView

- (void)showInfo:(BOOL)tf inView:(UIView *)inView info:(NSString *)info
{
    if (tf == YES) {
        if (hud != nil) {
            hud = nil;
        }
        if (hud == nil) {
            hud = [[ProgressHUD2 alloc] initWithView:inView];
            [inView addSubview:hud];
        }
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16.f];
        hud.detailsLabelText = info;
        [hud show:YES];
    } else {
        if (hud != nil) {
            [hud hide:YES];
            [hud removeFromSuperview];
            hud = nil;
        }
    }
}

- (BOOL)hudIsHidden
{
    return hud ? YES : NO;
}

- (void)hideInfo
{
    [self showInfo:NO inView:inView info:nil];
}

+ (id)instance
{
    static InfoAlertView *ph;
    if (ph == nil) {
        ph = [[InfoAlertView alloc] init];
    }
    return ph;
}

static UIView *inView = nil;

+ (void)setInView:(UIView *)view
{
    inView = view;
}

+ (void)showInfo:(NSString *)info duration:(CGFloat)duration
{
    if ([[InfoAlertView instance] hudIsHidden]) return;
    if (!inView || ![inView isKindOfClass:[UIView class]]) {
        inView = [UIApplication sharedApplication].keyWindow;
    }
    [[InfoAlertView instance] showInfo:YES inView:inView info:info];
    [[InfoAlertView instance] performSelector:@selector(hideInfo) withObject:nil afterDelay:duration];
}

+ (void)showInfo:(NSString *)info inView:(UIView *)inView duration:(CGFloat)duration
{
    if ([[InfoAlertView instance] hudIsHidden]) return;
    [[InfoAlertView instance] showInfo:YES inView:inView info:info];
    [[InfoAlertView instance] performSelector:@selector(hideInfo) withObject:nil afterDelay:duration];
}

@end
