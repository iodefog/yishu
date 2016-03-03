//
//  JobManager.m
//  medtree
//
//  Created by 孙晨辉 on 15/11/3.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "JobManager.h"
#import "IServices+Job.h"

@implementation JobManager

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    MethodTypeJob method = (MethodTypeJob)[dict[@"method"] integerValue];
    switch (method) {
        case MethodTypeJobDeliverys: {
            [JobManager getJobDeliverys:dict success:success failure:failure];
            break;
        }
    }
}

+ (void)getJobDeliverys:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getJobDeliverys:dict success:success failure:failure];
}

@end
