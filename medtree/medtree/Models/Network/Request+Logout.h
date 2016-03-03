//
//  Request+Logout.h
//  medtree
//
//  Created by 孙晨辉 on 15/6/27.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "Request.h"

@interface Request (Logout)

- (void)closeEngineWithType:(NSInteger)type
                    success:(void (^)(id JSON))success
                    failure:(void (^)(NSError *error, id JSON))failure;

@end
