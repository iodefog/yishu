//
//  DataManager+Cache.h
//  medtree
//
//  Created by tangshimi on 5/26/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DataManager.h"

@interface DataManager (Cache)

/**
 *  缓存数据
 *
 *  @param param 请求的参数
 *  @param json  数据
 */

+ (void)cache:(NSDictionary *)param data:(id)json;

/**
 *  读取缓存
 *
 *  @param param 请求的参数
 *
 *  @return 缓存数据
 */

+ (id)redaCache:(NSDictionary *)param;

/**
 *  缓存的字段
 *
 *  @param param 请求的参数
 *
 *  @return 缓存的字段
 */

+ (NSString *)cacheURL:(NSDictionary *)param;

@end
