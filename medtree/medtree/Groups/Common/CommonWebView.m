//
//  CommonWebView.m
//  medtree
//
//  Created by 陈升军 on 15/9/11.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "CommonWebView.h"
#import "UrlParsingHelper.h"

@implementation CommonWebView

- (UIWebView *)commonWebView
{
    if (!_commonWebView) {
        UIWebView *web = [[UIWebView alloc] init];
        
        NSString *secretAgent = [web stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString *str = secretAgent;
        if ([secretAgent rangeOfString:@"MedTree (iPhone"].location == NSNotFound) {
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSInteger revision = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"revision"] integerValue];
             str = [NSString stringWithFormat:@"%@ MedTree (iPhone %@/%@;)", secretAgent, version, @(revision)];
        }
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:str, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
        web = nil;
        
        _commonWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _commonWebView.delegate = self;
        _commonWebView.opaque = NO;
        _commonWebView.scalesPageToFit = YES;
        _commonWebView.dataDetectorTypes = UIDataDetectorTypeNone;
        _commonWebView.backgroundColor = [UIColor whiteColor];
        _commonWebView.scrollView.backgroundColor = [UIColor clearColor];
    }
    return _commonWebView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.commonWebView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)createUI
{
    [self addSubview:self.commonWebView];
}

- (void)loadRequestURL:(NSString *)url
{
    if (url.length == 0) {
        return;
    }
    if ([url rangeOfString:@"m.medtree.cn/daily/personalcard?id="].location != NSNotFound) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.commonWebView loadRequest:request];
    } else {
        [UrlParsingHelper addUrlInfo:url success:^(id JSON) {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:JSON]];
            [self.commonWebView loadRequest:request];
        }];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL tf = YES;
    NSString *decodePath = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UrlParsingType type = [UrlParsingHelper getUrlParsingTypeWithUrl:decodePath];
    if (self.isCanCyclic) {
        if (type != UrlParsingTypeSpecialWeb) {
            
            [UrlParsingHelper operationUrl:decodePath type:type controller:self.parentVC];
            
            tf = NO;
        }
    } else {
        if (type != UrlParsingTypeSpecialWeb) {
            [UrlParsingHelper operationUrl:decodePath type:type controller:self.parentVC];
            tf = NO;
        } else {
            if (self.commonWebView.canGoBack) {
                [UrlParsingHelper operationUrl:decodePath controller:self.parentVC title:@"详情"];
                tf = NO;
            }
        }
    }
    return tf;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [self.delegate isCanShowClose:self.commonWebView.canGoBack];
    [self.delegate isCanShowLoading:NO];
    [self.delegate isCanShowError:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.delegate isCanShowClose:self.commonWebView.canGoBack];
    [self.delegate isCanShowLoading:NO];
    [self.delegate isCanShowError:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.delegate isCanShowClose:self.commonWebView.canGoBack];
    [self.delegate isCanShowLoading:YES];
    [self.delegate isCanShowError:NO];
}

@end
