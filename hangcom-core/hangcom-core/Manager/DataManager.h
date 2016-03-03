//
//  DataManager.h
//  hangcom-core
//
//  Created by sam on 6/16/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServicePrefix.h"

@interface DataManager : NSObject

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)setData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (BOOL)isHit:(NSInteger)method;

@end
