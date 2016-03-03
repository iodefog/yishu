//
//  IServices+Job.m
//  medtree
//
//  Created by 孙晨辉 on 15/11/3.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "IServices+Job.h"

@implementation IServices (Job)

+ (void)getJobDeliverys:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"deliverys" method:@"POST" params:dict success:success failure:failure];
}

@end
