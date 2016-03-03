//
//  IServices+Common.m
//  medtree
//
//  Created by 陈升军 on 15/11/13.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "IServices+Common.h"
#import <JSONKit.h>
#import <InfoAlertView.h>

@implementation IServices (Common)

+ (void)appEventCollect:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/appevent/collect", [MedGlobal getCollectHost]]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url]; // 默认就是GET请求
    request.timeoutInterval = 5; // 设置请求超时
    request.HTTPMethod = @"POST"; // 设置为POST请求
    
    // 通过请求头告诉服务器客户端的类型
    [request setValue:@"ios" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 设置请求体
    request.HTTPBody = [[param JSONString] dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2.3.发送请求
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {  // 当请求结束的时候调用 (拿到了服务器的数据, 请求失败)
        if (data) { // 请求成功
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dict[@"success"]) {
                
            } else {
                if (dict[@"message"]) {
                    [InfoAlertView showInfo:dict[@"message"] inView:[UIApplication sharedApplication].keyWindow duration:1.5];
                }
            }
        }
    }];
}

@end
