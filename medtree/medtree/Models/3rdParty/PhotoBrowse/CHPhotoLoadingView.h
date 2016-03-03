//
//  CHPhotoLoadingView.h
//  medtree
//
//  Created by 孙晨辉 on 15/11/3.
//  Copyright © 2015年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHPhotoLoadingView : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)showLoading;
- (void)showFailure;

@end
