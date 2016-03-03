//
//  Request.h
//  find
//
//  Created by sam on 13-5-13.
//  Copyright (c) 2013年 sam. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "DataManager.h"

@interface Request : NSObject

- (MKNetworkEngine *)getEngine:(NSInteger)type;

- (MKNetworkOperation *)requestAction:(NSString *)action
                               method:(NSString *)method
                               params:(NSDictionary *)params
                              success:(void (^)(id JSON))success
                              failure:(void (^)(NSError *error, id JSON))failure;

- (MKNetworkOperation *)requestAction:(NSString *)action
                               method:(NSString *)method
                               params:(NSDictionary *)params
                              version:(NSInteger)version
                              success:(void (^)(id JSON))success
                              failure:(void (^)(NSError *error, id JSON))failure;

+ (void)setHeader:(NSDictionary *)dict;
+ (NSMutableDictionary *)getHeader;

@end
