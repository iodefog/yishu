//
//  IServices+Job.h
//  medtree
//
//  Created by 孙晨辉 on 15/11/3.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Job)

+ (void)getJobDeliverys:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
