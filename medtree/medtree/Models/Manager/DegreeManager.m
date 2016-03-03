//
//  TreeManager.m
//  medtree
//
//  Created by 无忧 on 14-9-5.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DegreeManager.h"
#import "DegreeDTO.h"
#import "OrganizationMapDTO.h"
#import "DepartmentDTO.h"
#import "PeopleDTO.h"
#import "RegionDTO.h"
#import "OrganizationNameDTO.h"
#import "DepartmentNameDTO.h"
#import "UserDTO.h"
#import "UserManager.h"
#import "DepartmentNameDTO.h"
#import "ProvinceDTO.h"
#import "DataManager+Cache.h"

@implementation DegreeManager

//
+ (BOOL)isHit:(NSInteger)method
{
    if (method > MethodType_DegreeInfo_Start && method < MethodType_DegreeInfo_End) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    
    switch (method) {
        case MethodType_DegreeInfo_DegreeCount: {
            [DegreeManager getDegreeCount:param success:success failure:failure];
            break;
        }
        case MethodType_DegreeInfo_Suggest: {
            [DegreeManager getSuggest:param success:success failure:failure];
            break;
        }
        case MethodType_ConnectionPeople: {
            [DegreeManager getConnectionPeople:param success:success failure:failure];
            break;
        }
        case MethodType_DegreeInfo_Organization: {
            [DegreeManager getOrganizationList:param success:success failure:failure];
            break;
        }
        case MethodType_DegreeInfo_Department: {
            [DegreeManager getDepartmentList:param success:success failure:failure];
            break;
        }
//        case MethodType_organizationSearch: {
//            [DegreeManager organizationSearch:param success:success failure:failure];
//            break;
//        }
        case MethodType_DegreeInfo_People: {
            [DegreeManager getDepartmentPeopleList:param success:success failure:failure];
            break;
        }
        case MethodType_DegreeInfo_Region: {
            [DegreeManager getRegionList:param success:success failure:failure];
            break;
        }
        case MethodType_DegreeInfo_StatesCount: {
            [DegreeManager getOrganizationStatsCount:param success:success failure:failure];
            break;
        }
        case MethodType_DegreeInfo_POrganization: {
            [DegreeManager getPersonOrganizationList:param success:success failure:failure];
            break;
        }
        case MethodType_DegreeInfo_PDepartment: {
            [DegreeManager getPersonDepartmentList:param success:success failure:failure];
            break;
        }
        case MethodType_Degree_UserProfile: {
            [DegreeManager getUserProfileWithUserID:param success:success failure:failure];
        }
            
        case MethodType_Degree_LocationSearch: {
            [DegreeManager locationSearch:param success:success failure:failure];
            break;
        }
        case MethodType_Degree_OrgSearch: {
            [DegreeManager orgSearch:param success:success failure:failure];
            break;
        }
        case MethodType_Degree_DepSearch: {
            [DegreeManager depSearch:param success:success failure:failure];
            break;
        }
    }
}

+ (void)setData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    
    switch (method) {
            
    }
}


+ (void)getDegreeCount:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getDegreeCount:param success:^(id JSON) {
        
        DegreeDTO *dto = [[DegreeDTO alloc] init:[JSON objectForKey:@"result"]];
        success (dto);
    } failure:^(NSError *error, id JSON) {
        failure (error, JSON);
    }];
}

+ (void)getOrganizationList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getOrganizationList:param success:^(id JSON) {
        NSLog(@"getOrganizationList  %@",JSON);
        NSMutableArray *organizations = [NSMutableArray array];
        NSArray *result = [JSON objectForKey:@"result"];
        if (result.count == 0) {
            [IServices sendDiagnose:JSON];
        }
        for (int i=0; i<result.count; i++) {
            NSLog(@"getOrganizationList %d %@", i, @(result.count));
            OrganizationMapDTO *dto = [[OrganizationMapDTO alloc] init:[result objectAtIndex:i]];
            if ((NSObject *)[param objectForKey:@"degree"] != [NSNull null]) {
                dto.degree = [[param objectForKey:@"degree"] integerValue];
            }
            [organizations addObject:dto];
            //
        }
        success(organizations);
    } failure:^(NSError *error, id JSON) {
        
        failure (error, JSON);
    }];
}

+ (void)getDepartmentList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getDepartmentList:param success:^(id JSON) {
        NSLog(@"getDepartmentList%@",JSON);
        NSMutableArray *departments = [NSMutableArray array];
        NSArray *result = [JSON objectForKey:@"result"];
        if (result.count == 0) {
            [IServices sendDiagnose:JSON];
        }
        for (int i=0; i<result.count; i++) {
            DepartmentDTO *dto = [[DepartmentDTO alloc] init:[result objectAtIndex:i]];
            dto.degree = [[param objectForKey:@"degree"] integerValue];
            [departments addObject:dto];
            //
        }
        success(departments);
    } failure:^(NSError *error, id JSON) {
        NSLog(@"getDepartmentList%@",JSON);
        failure (error, JSON);
    }];
}

+ (void)getDepartmentPeopleList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getDepartmentPeopleList:param success:^(id JSON) {
        NSLog(@"getDepartmentPeopleList%@",JSON);
        NSMutableArray *peoples = [NSMutableArray array];
        NSArray *result = [JSON objectForKey:@"result"];
        if (result.count == 0) {
            [IServices sendDiagnose:JSON];
        }
        for (int i=0; i<result.count; i++) {
            PeopleDTO *dto = [[PeopleDTO alloc] init:[result objectAtIndex:i]];
            [peoples addObject:dto];
            //
        }
        success(peoples);
    } failure:^(NSError *error, id JSON) {
        failure (error, JSON);
    }];
}

+ (void)getRegionList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getRegionList:param success:^(id JSON) {
        NSLog(@"getRegionList%@",JSON);
        NSArray *region = [NSArray arrayWithArray:[JSON objectForKey:@"result"]];
        NSMutableArray  *regionArray = [NSMutableArray array];
//        NSArray *region = [regionDict objectForKey:@"region"];
        if (region.count == 0) {
            [IServices sendDiagnose:JSON];
        }
        for (int i=0; i<region.count; i++) {
            RegionDTO *dto = [[RegionDTO alloc] init:[region objectAtIndex:i]];
            [regionArray addObject:dto];
            //
        }
        success(regionArray);
    } failure:^(NSError *error, id JSON) {
        NSLog(@"getRegionList%@",JSON);
        failure (error, JSON);
    }];
}

+ (void)getPersonOrganizationList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getPersonOrganizationList:param success:^(id JSON) {
        NSLog(@"getPersonOrganizationList   %@",JSON);
        
        NSMutableArray  *regionArray = [NSMutableArray array];
        NSArray *region = [JSON objectForKey:@"result"];
        if (region.count == 0) {
            [IServices sendDiagnose:JSON];
        }
        for (int i=0; i<region.count; i++) {
            OrganizationNameDTO *dto = [[OrganizationNameDTO alloc] init:[region objectAtIndex:i]];
            [regionArray addObject:dto];
            //
        }
        success(regionArray);
        
    } failure:^(NSError *error, id JSON) {
        failure (error, JSON);
    }];
}

+ (void)getPersonDepartmentList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getPersonDepartmentList:param success:^(id JSON) {
        NSLog(@"getPersonOrganizationList   %@",JSON);
        
        NSMutableArray  *regionArray = [NSMutableArray array];
        NSArray *region = [JSON objectForKey:@"result"];
        if (region.count == 0) {
            [IServices sendDiagnose:JSON];
        }
        for (int i=0; i<region.count; i++) {
            DepartmentNameDTO *dto = [[DepartmentNameDTO alloc] init:[region objectAtIndex:i]];
            [regionArray addObject:dto];
            
        }
        success(regionArray);
        
    } failure:^(NSError *error, id JSON) {
        failure (error, JSON);
    }];
}

+ (void)getOrganizationStatsCount:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getOrganizationStatsCount:param success:^(id JSON) {
        
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

//+ (void)organizationSearch:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
//{
//    [IServices organizationSearch:param success:success failure:failure];
//}

+ (void)locationSearch:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices locationSearch:param success:^(id JSON) {
        if ([JSON[@"success"] boolValue]) {
            NSArray *result = JSON[@"result"];
            NSMutableArray *data = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in result) {
                ProvinceDTO *dto = [[ProvinceDTO alloc] init:dict];
                [data addObject:dto];
            }
            success(data);
        }
    } failure:^(NSError *error, id JSON) {
        failure(error, JSON);
    }];
}

+ (void)orgSearch:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices orgSearch:param success:^(id JSON) {
        if ([JSON objectForKey:@"success"]) {
            NSMutableArray *dtoArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in [JSON objectForKey:@"result"]) {
                OrganizationNameDTO *dto = [[OrganizationNameDTO alloc] init:dict];
                [dtoArray addObject:dto];
            }
            success(dtoArray);
        }
    } failure:^(NSError *error, id JSON) {
         failure(error, JSON);
    }];
}

+ (void)depSearch:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices depSearch:param success:^(id JSON) {
        if ([JSON objectForKey:@"success"]) {
            NSMutableArray *dtoArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in [JSON objectForKey:@"result"]) {
                DepartmentNameDTO *dto = [[DepartmentNameDTO alloc] init:dict];
                [dtoArray addObject:dto];
            }
            success(dtoArray);
        }
    } failure:^(NSError *error, id JSON) {
        failure(error, JSON);
    }];
}

+ (void)getSuggest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getSuggest:param success:^(id JSON) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *result = [NSArray arrayWithArray:[JSON objectForKey:@"result"]];
        for (int i = 0; i < result.count; i ++) {
            UserDTO *dto = [[UserDTO alloc] init:[result objectAtIndex:i]];
            [UserManager checkUser:dto];
            [array addObject:dto];
        }
        success(array);
        
        NSMutableDictionary *dic = param.mutableCopy;
        dic[@"medthod"] = @(MethodType_DegreeInfo_Suggest);
        
        [DataManager cache:dic data:JSON];
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (void)getConnectionPeople:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getConnectionPeople:param success:^(id JSON) {
        NSLog(@"getConnectionPeople%@",JSON);
        NSArray *region = [NSArray arrayWithArray:[JSON objectForKey:@"result"]];
        NSMutableArray  *regionArray = [NSMutableArray array];
        //        NSArray *region = [regionDict objectForKey:@"region"];
        if (region.count == 0) {
            [IServices sendDiagnose:JSON];
        }
        for (int i=0; i<region.count; i++) {
            NSLog(@"getConnectionPeople %@  %d", @(region.count), i);
            PeopleDTO *dto = [[PeopleDTO alloc] init:[region objectAtIndex:i]];
            [regionArray addObject:dto];
            //
        }
        success(regionArray);
    } failure:^(NSError *error, id JSON) {
        NSLog(@"getConnectionPeople%@",JSON);
        failure(error,JSON);
    }];
}

+ (void)getUserProfileWithUserID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getUserProfileWithUserID:param success:^(id JSON) {
        NSLog(@"11111");
    } failure:^(NSError *error, id JSON) {
        
    }];
}

+ (void)getSuggestFromLocal:(NSDictionary *)param success:(SuccessBlock)success
{
    id json = [DataManager redaCache:param];
    
    NSMutableArray *array = [NSMutableArray array];
    NSArray *result = [NSArray arrayWithArray:[json objectForKey:@"result"]];
    for (int i = 0; i < result.count; i ++) {
        UserDTO *dto = [[UserDTO alloc] init:[result objectAtIndex:i]];
        [UserManager checkUser:dto];
        [array addObject:dto];
    }
    success(array);
}

@end
