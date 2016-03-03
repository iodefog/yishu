//
//  Request+Logout.m
//  medtree
//
//  Created by 孙晨辉 on 15/6/27.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "Request+Logout.h"
#import "MedGlobal.h"

@implementation Request (Logout)

- (void)closeEngineWithType:(NSInteger)type success:(void (^)(id))success failure:(void (^)(NSError *, id))failure
{
    MKNetworkEngine *engine = [self getEngine:type];
    [engine setValue:[MedGlobal getHost] forKey:@"hostName"];
    success(nil);
}

@end
