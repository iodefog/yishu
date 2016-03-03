//
//  UrlParsingHelper.h
//  medtree
//
//  Created by 陈升军 on 15/9/11.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServicePrefix.h"

typedef enum {
    UrlParsingTypeNative         = 1,
    UrlParsingTypeSpecialWeb     = 2,
    UrlParsingTypeOtherWeb       = 3,
    UrlParsingTypeCallPhone      = 4,
} UrlParsingType;

@interface UrlParsingHelper : NSObject

/**判断url类型*/
+ (UrlParsingType)getUrlParsingTypeWithUrl:(NSString *)url;
/**根据url类型做相应跳转  app内部打开的链接除外*/
+ (void)operationUrl:(NSString *)url type:(UrlParsingType)type controller:(UIViewController *)controller;
/**判断url类型做相应跳转（通用WebController外做判断使用）*/
+ (void)operationUrl:(NSString *)url controller:(UIViewController *)controller title:(NSString *)title;
/**追加url信息*/
+ (void)addUrlInfo:(NSString *)url success:(SuccessBlock)success;

+ (void)pushToEnterpriseMap:(NSString *)url controller:(UIViewController *)controller;

@end
