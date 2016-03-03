//
//  RelationManager.h
//  medtree
//
//  Created by tangshimi on 6/13/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DataManager.h"
#import "IServices+Relation.h"

#define kRequestSuccessCode 1

typedef enum {
    MethodType_Relation_Status = 5000,
    MethodType_Relation_result
}MethodType_Relation;

@interface RelationManager : DataManager

+ (void)getRelationParam:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getRelationFromLocalParam:(NSDictionary *)dict success:(SuccessBlock)success;

+ (NSDictionary *)parseRelationResult:(id)json;

@end
