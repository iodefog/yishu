//
//  CommonWebView.h
//  medtree
//
//  Created by 陈升军 on 15/9/11.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseView.h"

@protocol CommonWebViewDelegate <NSObject>

- (void)isCanShowClose:(BOOL)isShow;
- (void)isCanShowLoading:(BOOL)isShow;
- (void)isCanShowError:(BOOL)isShow;

@end

@interface CommonWebView : BaseView <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView   *commonWebView;
/**所属Controller*/
@property (nonatomic, strong) UIViewController *parentVC;

/**是否循环使用*/
@property (nonatomic, assign) BOOL  isCanCyclic;

@property (nonatomic, assign) id<CommonWebViewDelegate> delegate;

- (void)loadRequestURL:(NSString *)url;

@end
