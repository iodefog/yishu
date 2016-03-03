//
//  ShareHelper.m
//  medtree
//
//  Created by sam on 1/22/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "ShareHelper.h"
#import "UrlParsingHelper.h"
#import "OperationHelper.h"
#import "WXApi.h"


@implementation ShareHelper

+ (void)registerApps
{
    [WXApi registerApp:[ShareHelper getWeixinID] withDescription:@"demo 2.0"];
}

+ (NSString *)getWeixinID
{
    return @"wx0dfb8040a35093ee";
}

+ (NSString *)getMedTreeID
{
    return @"medtree";
}

+ (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication source:(id)source
{
    BOOL tf = YES;
    if ([url.absoluteString rangeOfString:[NSString stringWithFormat:@"%@://", [[self class] getMedTreeID]]].location == 0) {
        if (![sourceApplication isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]]) {
            NSString *prefix = [NSString stringWithFormat:@"%@://treeapp", [[self class] getMedTreeID]];
            if ([url.absoluteString rangeOfString:prefix].location == 0) {
                NSString *postfix = [url.absoluteString substringFromIndex:prefix.length+1];
                if ([postfix rangeOfString:@"openUrl"].location == 0) {
                    NSString *path = [postfix substringFromIndex:@"openUrl".length+1];
                    [UrlParsingHelper operationUrl:path controller:[OperationHelper getRootController] title:@"详情"];
                }
            }
        }
    } else if ([url.absoluteString rangeOfString:[NSString stringWithFormat:@"%@://", [[self class] getWeixinID]]].location == 0) {
        tf = [WXApi handleOpenURL:url delegate:source];
    }
    return tf;
}

@end
