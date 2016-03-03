//
//  BadgeView.h
//  mcare-ui
//
//  Created by sam on 12-10-8.
//
//

#import <UIKit/UIKit.h>

@interface BadgeView : UIView {
    UIImageView *imageView;
    UILabel *label;
    UIView  *roundView;
    NSString *imageText;
    
    CGFloat width;
    CGFloat height;
}

- (void)changeBGImage:(NSString *)imageName textColor:(NSString *)textColor;
- (void)setBadge:(NSString *)badge;
- (void)setIsShowRoundView:(BOOL)isShow;

@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

/** 气泡粘性系数，越大拉的越长，还未实现 */
@property (nonatomic,assign)CGFloat viscosity;
@property (nonatomic,assign)CGFloat breakViscosity;

/** 允许拖拽，还未实现 */
@property (nonatomic,assign)BOOL allowPan;

@end
