//
//  IServices+Find.m
//  medtree
//
//  Created by tangshimi on 7/15/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "IServices+Find.h"

@implementation IServices (Find)

+ (void)getFindInfoSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"discovery/page" method:@"GET" params:nil success:success failure:failure];
}

@end
