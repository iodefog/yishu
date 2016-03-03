//
//  IServices+Featured.h
//  medtree
//
//  Created by 陈升军 on 15/4/1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Featured)

+ (void)getFeatured:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
