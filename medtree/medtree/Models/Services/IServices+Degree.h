//
//  IServices+Tree.h
//  medtree
//
//  Created by 无忧 on 14-9-5.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Degree)

+ (void)getDegreeCount:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getOrganizationList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getDepartmentList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getDepartmentPeopleList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getRegionList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getPersonOrganizationList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getPersonDepartmentList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getOrganizationStatsCount:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
//+ (void)organizationSearch:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getSuggest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getConnectionPeople:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getUserProfileWithUserID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;


/**查找地区**/
+ (void)locationSearch:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**查找机构**/
+ (void)orgSearch:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**查找科室**/
+ (void)depSearch:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
