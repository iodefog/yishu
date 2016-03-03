//
//  IServices+Find.h
//  medtree
//
//  Created by tangshimi on 7/15/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Find)

+ (void)getFindInfoSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

@end
