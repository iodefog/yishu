//
//  IServices+Featured.m
//  medtree
//
//  Created by 陈升军 on 15/4/1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "IServices+Featured.h"


@implementation IServices (Featured)

+ (void)getFeatured:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithString:@"featured"];
    if ([param objectForKey:@"timestamp"]) {
        [action appendFormat:@"?timestamp=%@", [param objectForKey:@"timestamp"]];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

@end
