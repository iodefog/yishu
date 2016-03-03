//
//  MedShareManager.h
//  medtree
//
//  Created by tangshimi on 12/21/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedShareManager : NSObject

+ (MedShareManager *)sharedInstance;

/**
 *  分享一个网址
 *
 *  @param inView       显示的view
 *  @param title        title
 *  @param detail       detail
 *  @param image        本地图片或网络图片
 *  @param defaultImage 网络图片加载失败时的默认图
 *  @param shareURL     分享的网址
 */

- (void)showInView:(UIView *)inView
             title:(NSString *)title
           deatail:(NSString *)detail
             image:(NSString *)image
      defaultImage:(NSString *)defaultImage
          shareURL:(NSString *)shareURL;

/**
 *  分享文本
 *
 *  @param inView 显示的view
 *  @param text   分享的文本
 */

- (void)showInView:(UIView *)inView text:(NSString *)text;

@end
