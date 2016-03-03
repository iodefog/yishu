//
//  Request+Error.h
//  medtree
//
//  Created by 无忧 on 14-10-27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "Request.h"

@interface Request (Error)

- (void)checkError:(id)JSON action:(NSString *)action error:(NSError *)error failure:(void (^)(NSError *error, id JSON))failure;;
- (void)sendException:(NSDictionary *)dict action:(NSString *)action;

@end
