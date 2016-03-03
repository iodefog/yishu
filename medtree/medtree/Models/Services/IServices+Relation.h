//
//  IServices+Relation.h
//  medtree
//
//  Created by tangshimi on 6/13/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Relation)

+ (void)getRealtionStatusSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getRealtionResultParams:(NSDictionary *)dict  Success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
