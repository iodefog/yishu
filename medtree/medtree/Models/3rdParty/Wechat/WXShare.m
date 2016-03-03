//
//  WXShare.m
//  medtree
//
//  Created by 陈升军 on 15/1/5.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "WXShare.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "PhotoHelper.h"
#import "ImageCenter.h"

@implementation WXShare

+ (void)WXMediaWithDict:(NSDictionary *)dictInfo
{
//    [WXShare sendWXMedia:dict image:nil];
    if ([dictInfo objectForKey:@"imageID"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [PhotoHelper getPhoto:[NSString stringWithFormat:@"%@/%@",[dictInfo objectForKey:@"imageType"],[dictInfo objectForKey:@"imageID"]] completionHandler:^(NSDictionary *dict1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [WXShare sendWXMedia:dictInfo image:[dict1 objectForKey:@"fetchedImage"]];
                });
            } errorHandler:^(NSDictionary *dict) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [WXShare sendWXMedia:dictInfo image:[ImageCenter getBundleImage:@"icon.png"]];
                });
            } progressHandler:^(NSDictionary *dict) {
                
            }];
        });
    } else {
        [WXShare sendWXMedia:dictInfo image:[ImageCenter getBundleImage:@"icon.png"]];
    }
}

+ (void)sendWXMedia:(NSDictionary *)dict image:(UIImage *)image
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
    message.description = [NSString stringWithFormat:@"%@",[dict objectForKey:@"description"]];
    [message setThumbImage:image];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [dict objectForKey:@"share_url"];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = [[dict objectForKey:@"type"] intValue];
    [WXApi sendReq:req];
    
    req = nil;
}

/**微信选择渠道分享多媒体信息*/
+ (void)WeChatShareWithTitle:(NSString *)title //标题
                 description:(NSString *)description //简介
                     imageID:(NSString *)imageID //图标id
                    shareURL:(NSString *)shareURL //分享地址
                   shareType:(WeChatShareType)shareType //内容type
                  weChatType:(WeChatChannelType)weChatType //wechat渠道
{
    if (imageID.length > 0) {
        [PhotoHelper getPhoto:[NSString stringWithFormat:@"%@/%@",[MedGlobal getPicHost:ImageType_Small],imageID] completionHandler:^(NSDictionary *dict) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WXShare WeChatShareWithTitle:title
                                  description:description
                                        image:[dict objectForKey:@"fetchedImage"]
                                     shareURL:shareURL
                                    shareType:shareType
                                   weChatType:weChatType];
            });
        } errorHandler:^(NSDictionary *dict) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WXShare WeChatShareWithTitle:title
                                  description:description
                                        image:[UIImage imageNamed:[WXShare getImageNameWithType:shareType]]
                                     shareURL:shareURL
                                    shareType:shareType
                                   weChatType:weChatType];
            });
        } progressHandler:^(NSDictionary *dict) {
            
        }];
    } else {
        [WXShare WeChatShareWithTitle:title
                          description:description
                                image:[UIImage imageNamed:[WXShare getImageNameWithType:shareType]]
                             shareURL:shareURL
                            shareType:shareType
                           weChatType:weChatType];
    }
}

/**根据分享内容类型获取图标*/
+ (NSString *)getImageNameWithType:(WeChatShareType)type
{
    NSString *imageName = @"";
    switch (type) {
        case WeChatType_Share_Article:
            imageName = @"wechat_share_article.png";
            break;
        case WeChatType_Share_Event:
            imageName = @"wechat_share_event.png";
            break;
        case WeChatType_Share_UserCard:
            imageName = @"wechat_share_usercard.png";
            break;
        case WeChatType_Share_Invite:
            imageName = @"wechat_share_invite.png";
            break;
        case WeChatType_Share_Job:
            imageName = @"hospital_default_icon.png";
            break;
        default:
            break;
    }
    return imageName;
}

+ (void)WeChatShareWithTitle:(NSString *)title //标题
                 description:(NSString *)description //简介
                     image:(UIImage *)image //图标
                    shareURL:(NSString *)shareURL //分享地址
                   shareType:(WeChatShareType)shareType //内容type
                  weChatType:(WeChatChannelType)weChatType //wechat渠道
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:image];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareURL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = weChatType;
    [WXApi sendReq:req];
    
    req = nil;
}

/**微信选择渠道分享纯文本信息*/
+ (void)WeChatShareForTextWithWeChatType:(WeChatChannelType)type text:(NSString *)text
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = text;
    req.bText = YES;
    req.scene = type;
    [WXApi sendReq:req];
    req = nil;
}

+ (void)SendMessageToWXReqWithDict:(NSDictionary *)dict
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    if ([dict objectForKey:@"text"]) {
        req.text = [dict objectForKey:@"text"];
    } else {
        req.text = [NSString stringWithFormat:@"我正在用医树，既可以做职业发展还可以管理自己的人脉，你也试试。注册时请在邀请人处填写我的医树号:%@，我们就能加为好友了。下载地址 http://m.medtree.cn/page/share",[[AccountHelper getAccount] userID]];
    }
    req.bText = YES;
    if ([dict objectForKey:@"type"]) {
        req.scene = [[dict objectForKey:@"type"] intValue];
    }
    [WXApi sendReq:req];
    req = nil;
}

@end
