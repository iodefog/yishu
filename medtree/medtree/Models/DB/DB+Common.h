//
//  DB+Common.h
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB.h"

@class DTOBase;

@interface DB (Common)

- (void)createTable_Common;
- (void)insertCommon:(DTOBase *)dto key:(NSString *)key;
- (void)updateCommon:(DTOBase *)dto key:(NSString *)key;
- (void)selectCommon:(NSString *)key result:(ArrayBlock)result;
- (void)deleteCommon:(NSString *)key;

@end
