//
//  WXShare.h
//  medtree
//
//  Created by 陈升军 on 15/1/5.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

//微信分享内容来源
typedef enum {
    WeChatType_Share_Article                      = 0,
    WeChatType_Share_Event                        = 1,
    WeChatType_Share_UserCard                     = 2,
    WeChatType_Share_Invite                       = 3,
    WeChatType_Share_Job                          = 4,
} WeChatShareType;

//微信分享渠道
typedef enum {
    WeChatType_Channel_Moments                       = 0,
    WeChatType_Channel_Frined                        = 1,
} WeChatChannelType;

@interface WXShare : NSObject <WXApiDelegate>

+ (void)WXMediaWithDict:(NSDictionary *)dictInfo;

/**微信选择渠道分享多媒体信息 需下载图片*/
+ (void)WeChatShareWithTitle:(NSString *)title //标题
                 description:(NSString *)description //简介
                     imageID:(NSString *)imageID //图标id
                    shareURL:(NSString *)shareURL //分享地址
                   shareType:(WeChatShareType)shareType //内容type
                  weChatType:(WeChatChannelType)weChatType; //wechat渠道

/**微信选择渠道分享多媒体信息 已有图片*/
+ (void)WeChatShareWithTitle:(NSString *)title //标题
                 description:(NSString *)description //简介
                       image:(UIImage *)image //图标
                    shareURL:(NSString *)shareURL //分享地址
                   shareType:(WeChatShareType)shareType //内容type
                  weChatType:(WeChatChannelType)weChatType; //wechat渠道

/**微信选择渠道分享纯文本信息*/
+ (void)WeChatShareForTextWithWeChatType:(WeChatChannelType)type text:(NSString *)text;


+ (void)SendMessageToWXReqWithDict:(NSDictionary *)dict;

@end
