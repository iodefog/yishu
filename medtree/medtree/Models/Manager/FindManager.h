//
//  FindManager.h
//  medtree
//
//  Created by tangshimi on 7/15/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DataManager.h"
#import "IServices+Find.h"

typedef NS_ENUM(NSInteger, MethodType_Find) {
    MethodTypeFindPage = 6000
};

@interface FindManager : DataManager

+ (void)getFindParam:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getFindFromLocalParam:(NSDictionary *)dict success:(SuccessBlock)success;

+ (NSDictionary *)parseResult:(id)json;

@end
