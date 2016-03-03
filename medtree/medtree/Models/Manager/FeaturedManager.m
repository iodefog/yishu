//
//  FeaturedManager.m
//  medtree
//
//  Created by 陈升军 on 15/4/1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "FeaturedManager.h"
#import "IServices+Public.h"
#import "FeaturedDTO.h"
#import "PairDTO.h"
#import "SlideDTO.h"
#import "ServiceManager.h"
#import "FriendRecommandDTO.h"

@implementation FeaturedManager

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    //
    switch (method) {
        case MethodType_Featured_GetFeatured:{
            [IServices getFeatured:param success:^(id JSON) {
                if ([[JSON objectForKey:@"success"] boolValue]) {
                    
                    NSMutableDictionary *result = [NSMutableDictionary dictionary];
                    NSMutableArray *array = [NSMutableArray array];
                    
                    if ([[JSON objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
                        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[JSON objectForKey:@"result"]];
                        
                        for (int j = 0; j < dataArray.count; j ++) {
                            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[dataArray objectAtIndex:j]];
                            
                            NSArray *data = [NSArray arrayWithArray:[dict objectForKey:@"data"]];
                            for (int i = 0; i < data.count; i ++) {
                                NSDictionary *subData = [data objectAtIndex:i];
                                
                                NSInteger style = [[subData objectForKey:@"style"] integerValue];
                                
                                if (style < 2) {
                                    FeaturedDTO *fdto = [[FeaturedDTO alloc] init:subData];
                                    if (fdto.style == 1) {
                                        fdto.name = [dict objectForKey:@"name"];
                                    }
                                    [array addObject:fdto];
                                } else if (style == 3) {
                                    SlideDTO *sdto = [[SlideDTO alloc] init:@{}];
                                    sdto.slideType = 1;
                                    sdto.name = [subData objectForKey:@"category"];
                                    [sdto.images addObjectsFromArray:[subData objectForKey:@"images"]];
                                    [sdto.urls addObjectsFromArray:[subData objectForKey:@"urls"]];
                                    [array addObject:sdto];
                                } else if(style == 2) {
                                    PairDTO *pdto = [[PairDTO alloc] init:@{}];
                                    pdto.label = [subData objectForKey:@"category"];
                                    [pdto.resourceArray addObjectsFromArray:[subData objectForKey:@"images"]];
                                    [pdto.selectResourceArray addObjectsFromArray:[subData objectForKey:@"urls"]];
                                    [array addObject:pdto];
                                } else if (style == 4) {
                                    FriendRecommandDTO *dto = [[FriendRecommandDTO alloc] init:JSON];
                                    [array addObject:dto];
                                }
                            }
                            if (j == dataArray.count-1) {
                                if ([dict objectForKey:@"timestamp"]) {
                                    [result setObject:[dict objectForKey:@"timestamp"] forKey:@"timestamp"];
                                }
                            }
                        }
                    }
                    if ([[param objectForKey:@"timestamp"] integerValue] == 0) {

                        dispatch_async(dispatch_get_main_queue(), ^{
                            DTOBase *baseDTO = [[DTOBase alloc] init:JSON];
                            NSDictionary *param = @{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree], @"key": @"MethodType_Featured_GetFeatured", @"info": baseDTO};
                            [ServiceManager setData:param success:^(id JSON) {
                                NSLog(@"update %@", JSON);
                            } failure:^(NSError *error, id JSON) {
                                
                            }];
                        });
                    }
                    [result setObject:array forKey:@"data"];
                    success(result);
                }
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        default:
            break;
    }
}

+ (void)setData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    /*
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    */
    //
}

+ (BOOL)isHit:(NSInteger)method
{
    if (method > MethodType_Featured_Start && method < MethodType_Featured_End) {
        return YES;
    } else {
        return NO;
    }
}

@end
