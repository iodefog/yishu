//
//  IServices+Tree.m
//  medtree
//
//  Created by 无忧 on 14-9-5.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices+Degree.h"

@implementation IServices (Degree)

+ (void)getDegreeCount:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"connection/stats" method:@"GET" params:param success:success failure:failure];
}

+ (void)getOrganizationList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"connection/organization"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%zi&size=%zi", from, size];
    }
    if ((NSObject *)[param objectForKey:@"degree"] != [NSNull null]) {
        [action appendFormat:@"&degree=%zi",[[param objectForKey:@"degree"] integerValue]];
    }
    if ((NSObject *)[param objectForKey:@"org_type"] != [NSNull null]) {
        [action appendFormat:@"&org_type=%zi",[[param objectForKey:@"org_type"] integerValue]];
        if ((NSObject *)[param objectForKey:@"region"] != [NSNull null]) {
            [action appendFormat:@"&region=%@",[param objectForKey:@"region"]];
        }
    } else {
        if ((NSObject *)[param objectForKey:@"region"] != [NSNull null]) {
            [action appendFormat:@"&region=%@",[param objectForKey:@"region"]];
        }
    }
    if ((NSObject *)[param objectForKey:@"relation"] != [NSNull null]) {
        [action appendFormat:@"&relation=%zi",[[param objectForKey:@"relation"] integerValue]];
    }
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getDepartmentList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"connection/department?org_id=%@",[param objectForKey:@"organization_id"]];
    
    if ([[param objectForKey:@"relation"] integerValue] == 1000) {
        [action appendFormat:@"&degree=%zi",[[param objectForKey:@"degree"] integerValue]];
    } else {
        [action appendFormat:@"&relation=%zi",[[param objectForKey:@"relation"] integerValue]];
    }
    if (from >= 0 && size > 0) {
        [action appendFormat:@"&from=%zi&size=%zi", from, size];
    }
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getDepartmentPeopleList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    
    NSMutableString *action = [NSMutableString stringWithFormat:@"connection/people?dpt_id=%@",[param objectForKey:@"department_id"]];
    if ((NSObject *)[param objectForKey:@"org_id"] != [NSNull null]) {
        [action appendFormat:@"&org_id=%@",[param objectForKey:@"org_id"]];
    }
    if ([[param objectForKey:@"relation"] integerValue] == 1000) {
        [action appendFormat:@"&degree=%zi",[[param objectForKey:@"degree"] integerValue]];
    } else {
        [action appendFormat:@"&relation=%zi",[[param objectForKey:@"relation"] integerValue]];
    }
    if (from >= 0 && size > 0) {
        [action appendFormat:@"&from=%zi&size=%zi", from, size];
    }
    if ((NSObject *)[param objectForKey:@"org_type"] != [NSNull null]) {
        [action appendFormat:@"&org_type=%zi",[[param objectForKey:@"org_type"] integerValue]];
    }
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getRegionList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"connection/stats/region"];
    [action appendFormat:@"?degree=%zi",[[param objectForKey:@"degree"] integerValue]];
    if ((NSObject *)[param objectForKey:@"org_type"] != [NSNull null]) {
        [action appendFormat:@"&org_type=%zi",[[param objectForKey:@"org_type"] integerValue]];
    }
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getPersonOrganizationList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"org/_search"];
    if ((NSObject *)[param objectForKey:@"org_type"] != [NSNull null]) {
        [action appendFormat:@"?type=%zi",[[param objectForKey:@"org_type"] integerValue]];
    }
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"&from=%zi&size=%zi", from, size];
    }
    if ((NSObject *)[param objectForKey:@"mate"] != [NSNull null] && [param objectForKey:@"mate"] != nil) {
        [action appendFormat:@"&q=%@",[param objectForKey:@"mate"]];
    }
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getPersonDepartmentList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"dept/_search"];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%zi&size=%zi", from, size];
    }
    if ((NSObject *)[param objectForKey:@"org_id"] != [NSNull null]) {
        [action appendFormat:@"&org_id=%@",[param objectForKey:@"org_id"]];
    }
    if ([param objectForKey:@"level"]) {
        [action appendFormat:@"&level=%zi",[[param objectForKey:@"level"] integerValue]];
    }
    if ([param objectForKey:@"parent_id"]) {
        [action appendFormat:@"&parent_id=%@",[param objectForKey:@"parent_id"]];
    }
    if ([param objectForKey:@"org_type"]) {
        [action appendFormat:@"&org_type=%zi",[[param objectForKey:@"org_type"] integerValue]];
    }
    if ([param objectForKey:@"org_name"]) {
        [action appendFormat:@"&org_name=%@",[[param objectForKey:@"org_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    if ((NSObject *)[param objectForKey:@"mate"] != [NSNull null] && [param objectForKey:@"mate"] != nil) {
        [action appendFormat:@"&q=%@",[param objectForKey:@"mate"]];
    }
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getOrganizationStatsCount:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"connection/organization/stats" method:@"GET" params:nil success:success failure:failure];
}

/**查找地区**/
+ (void)locationSearch:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
//
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"province/_search"];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%zi&size=%zi", from, size];
    }
    
    if ([param objectForKey:@"keyword"]) {
        [action appendFormat:@"&keyword=%@",[param objectForKey:@"keyword"]];
    }
    
    if ([param objectForKey:@"org_type"]) {
        [action appendFormat:@"&org_type=%zi",[[param objectForKey:@"org_type"] integerValue]];
    }
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

/**查找机构**/
+ (void)orgSearch:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    //
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"org/_search"];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%zi&size=%zi", from, size];
    }
    if ([param objectForKey:@"province"]) {
        [action appendFormat:@"&province=%@",[param objectForKey:@"province"]];
    }
    if ([param objectForKey:@"q"]) {
        [action appendFormat:@"&q=%@",[param objectForKey:@"q"]];
    }
    if ([param objectForKey:@"type"]) {
        [action appendFormat:@"&type=%zi",[[param objectForKey:@"type"] integerValue]];
    }
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

/**查找科室**/
+ (void)depSearch:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    //
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"dept/_search"];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%zi&size=%zi", from, size];
    }
    if ([param objectForKey:@"parent_id"]) {
        [action appendFormat:@"&parent_id=%@",[param objectForKey:@"parent_id"]];
    }
    if ([param objectForKey:@"org_id"]) {
        [action appendFormat:@"&org_id=%@",[param objectForKey:@"org_id"]];
    }
    if ([param objectForKey:@"org_name"]) {
        [action appendFormat:@"&org_name=%@",[param objectForKey:@"org_name"]];
    }
    if ([param objectForKey:@"org_type"]) {
        [action appendFormat:@"&org_type=%zi",[[param objectForKey:@"org_type"] integerValue]];
    }
    if ([param objectForKey:@"q"]) {
        [action appendFormat:@"&q=%@",[param objectForKey:@"q"]];
    }
    if ([param objectForKey:@"level"]) {
        [action appendFormat:@"&level=%@",[param objectForKey:@"level"]];
    }
    if ([param objectForKey:@"user_type"]) {
        [action appendFormat:@"&user_type=%@",[param objectForKey:@"user_type"]];
    }

    
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}


+ (void)getSuggest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"discovery/people/_suggest"];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    [action appendFormat:@"?from=%zi&size=%zi", from, size];
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getConnectionPeople:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"connection/people"];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%zi&size=%zi", from, size];
    }
    if ((NSObject *)[param objectForKey:@"relation"] != [NSNull null]) {
        [action appendFormat:@"&relation=%zi",[[param objectForKey:@"relation"] integerValue]];
    }
    if ((NSObject *)[param objectForKey:@"organization_id"] != [NSNull null]) {
        [action appendFormat:@"&org_id=%@",[param objectForKey:@"organization_id"]];
    }
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getUserProfileWithUserID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"user/profile/%@/cofriends",[param objectForKey:@"user_id"]];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%zi&size=%zi", from, size];
    }
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

@end
