//
//  FindManager.m
//  medtree
//
//  Created by tangshimi on 7/15/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "FindManager.h"
#import "DataManager+Cache.h"
#import "FindDTO.h"
#import "EventDTO.h"

@implementation FindManager

+ (void)getFindParam:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSInteger method = [[dict objectForKey:@"method"] integerValue];

    switch (method) {
        case MethodTypeFindPage: {
            [IServices getFindInfoSuccess:^(id JSON){
                success([FindManager parseResult:JSON]);
                [DataManager cache:dict data:JSON];
            } failure:^(NSError *error, id JSON) {
                failure(error, JSON);
            }];
            
            break;
        }
        default:
            break;
    }
    
}

+ (void)getFindFromLocalParam:(NSDictionary *)dict success:(SuccessBlock)success
{
    id json = [DataManager redaCache:dict];
    
    NSInteger method = [[dict objectForKey:@"method"] integerValue];

    switch (method) {
        case MethodTypeFindPage: {
            if (json) {
                success([FindManager parseResult:json]);
            } else {
                success(json);
            }
            break;
        }
        default:
            break;
    }
}

+ (NSDictionary *)parseResult:(id)json
{
    NSMutableArray *eventArray = [NSMutableArray new];
    NSMutableArray *array = [NSMutableArray new];
    if ([json[@"success"] boolValue]) {
        NSDictionary *dict = json[@"result"];
        NSArray *infoArray =  [dict objectForKey:@"event"];
        for (NSDictionary *dic in infoArray) {
            EventDTO *dto = [[EventDTO alloc] init:dic];
            [eventArray addObject:dto];
        }
        
        NSArray *discoverArray = [dict objectForKey:@"discover"];
        for (NSDictionary *dic in discoverArray) {
            FindDTO *dto = [[FindDTO alloc] init:dic];
            [array addObject:dto];
        }
    }
    NSDictionary *resultDic = @{ @"success" : json[@"success"], @"event" : eventArray, @"discover":array};
    return resultDic;
}

@end
