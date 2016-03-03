//
//  ServiceManager.h
//  zhihu
//
//  Created by lyuan on 14-3-10.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IServices+Public.h"
#import "ServiceManager+Public.h"

typedef enum {
    /*默认无获取*/
    MethodType_Unknown                  = 1,
    MethodType_Unknown_More             = 2,
    MethodType_Unknown_Local            = 3,
    
} Method_Type;

@interface ServiceManager : NSObject
{
    NSMutableDictionary *dataDict;
}

+ (ServiceManager *)shareInstance;

+ (void)setObject:(id)json key:(NSString *)key;
+ (id)getObject:(NSString *)key;

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)setData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)loadCacheData;

@end
