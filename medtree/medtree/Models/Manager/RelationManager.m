//
//  RelationManager.m
//  medtree
//
//  Created by tangshimi on 6/13/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "RelationManager.h"
#import "DataManager+Cache.h"
#import "UserDTO.h"
#import "RelationDTO.h"
#import "RelationLocationDTO.h"

@implementation RelationManager

+ (void)getRelationParam:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];

    switch (method) {
        case MethodType_Relation_Status: {
            [IServices getRealtionStatusSuccess:^(id JSON) {
                success(JSON);
                [DataManager cache:dict data:JSON];
            } failure:^(NSError *error, id JSON) {
                failure(error, JSON);
            }];
            
            break;
        }
        case MethodType_Relation_result: {
            [IServices getRealtionResultParams:param Success:^(id JSON) {
                
                if ([JSON[@"success"] integerValue] == kRequestSuccessCode) {
                    success([RelationManager parseRelationResult:JSON]);
                    
                    [DataManager cache:dict data:JSON];
                } else {
                    success(JSON);
                }
            } failure:^(NSError *error, id JSON) {
                failure(error, JSON);
            }];
            break;
        }
        default:
            break;
    }
}

+ (void)getRelationFromLocalParam:(NSDictionary *)dict success:(SuccessBlock)success
{
    id json = [DataManager redaCache:dict];
    
    int method = [[dict objectForKey:@"method"] intValue];
    switch (method) {
        case MethodType_Relation_Status:
            success(json);
            break;
        case MethodType_Relation_result:
            if (json) {
                success([RelationManager parseRelationResult:json]);
            } else {
                success(json);
            }
            break;
        default:
            break;
    }
}

+ (NSDictionary *)parseRelationResult:(id)json
{
    NSDictionary *dict = json;
    
    NSMutableArray *peopleArray = [NSMutableArray new];
    if ([dict objectForKey:@"result"]) {
        for (NSDictionary *peopleDic in [dict objectForKey:@"result"]) {
            UserDTO *dto = [[UserDTO alloc] init:peopleDic];
            [peopleArray addObject:dto];
        }
    }
    
    NSMutableArray *departmentArray = [NSMutableArray new];
    NSDictionary *facetDic = [dict objectForKey:@"facets"];
    NSArray *facetArray = [facetDic objectForKey:[facetDic allKeys][0]];
    
    if (facetArray) {
        for (NSDictionary *departDic in facetArray) {
            RelationDTO *dto = [[RelationDTO alloc] init:departDic];
            [departmentArray addObject:dto];
        }
    }
    
    NSMutableArray *locationArray = [NSMutableArray new];
    NSDictionary *metaDic = [dict objectForKey:@"meta"];
    NSArray *metaArray = [metaDic objectForKey:[metaDic allKeys][0]];
    
    if (metaArray) {
        for (NSDictionary *locationDic in metaArray) {
            RelationLocationDTO *dto = [[RelationLocationDTO alloc] init:locationDic];
            [locationArray addObject:dto];
        }
    }
    
    NSDictionary *resultDic = @{ @"success" : dict[@"success"], @"people" : peopleArray, @"facets" : departmentArray, @"meta" : locationArray, @"total" : [dict objectForKey:@"total"] };

    return resultDic;
}

@end
