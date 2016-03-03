//
//  TreeManager.h
//  medtree
//
//  Created by 无忧 on 14-9-5.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "ServiceManager.h"
#import "DataManager.h"

typedef enum {
    MethodType_DegreeInfo_Start         = 2000,
    /*人脉*/
    MethodType_DegreeInfo_DegreeCount   = 2001,
    MethodType_DegreeInfo_Organization  = 2002,
    MethodType_DegreeInfo_Department    = 2003,
    MethodType_DegreeInfo_People        = 2004,
    MethodType_DegreeInfo_Region        = 2005,
    MethodType_DegreeInfo_POrganization = 2006,
    MethodType_DegreeInfo_PDepartment   = 2007,
    MethodType_DegreeInfo_StatesCount   = 2008,
//    MethodType_organizationSearch       = 2009,
    MethodType_DegreeInfo_Suggest       = 2010,
    MethodType_ConnectionPeople         = 2011,
    MethodType_Degree_UserProfile       = 2012,
    
    MethodType_Degree_LocationSearch    = 2013,
    MethodType_Degree_OrgSearch         = 2014,
    MethodType_Degree_DepSearch         = 2015,
    
    MethodType_DegreeInfo_End           = 2999,
} MethodType_DegreeInfo;

@interface DegreeManager : DataManager

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

+ (void)locationSearch:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)orgSearch:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)depSearch:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getSuggestFromLocal:(NSDictionary *)param success:(SuccessBlock)success;

@end
