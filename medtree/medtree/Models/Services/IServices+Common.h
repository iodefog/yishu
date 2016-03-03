//
//  IServices+Common.h
//  medtree
//
//  Created by 陈升军 on 15/11/13.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Common)

+ (void)appEventCollect:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
