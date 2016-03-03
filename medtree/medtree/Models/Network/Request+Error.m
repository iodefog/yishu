//
//  Request+Error.m
//  medtree
//
//  Created by 无忧 on 14-10-27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "Request+Error.h"
#import "JSONKit.h"
#import "InfoAlertView.h"
#import "UserManager.h"

@implementation Request (Error)

- (void)checkError:(id)JSON action:(NSString *)action error:(NSError *)error failure:(void (^)(NSError *error, id JSON))failure;
{
    if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
        NSDictionary *result = [JSON objectFromJSONString];
        if ([result objectForKey:@"message"] != nil) {
            if ([[result objectForKey:@"code"] integerValue] != 999) {
                if ([action isEqualToString:@"diagnose/exception"] == NO) {
                    [self sendException:@{@"error":error,@"json":JSON,@"action":action} action:@"diagnose/exception"];
                }
                failure(error, JSON);
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:ShowInfoAlertView object:[result objectForKey:@"message"]];
            }
        } else {
            failure(error, JSON);
        }
    } else {
        failure(error, JSON);
    }
}

- (void)sendException:(NSDictionary *)dict action:(NSString *)action
{
    [self requestAction:action method:@"POST" params:dict success:^(id JSON) {
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}

@end
