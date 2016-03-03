//
//  StatusTypes.h
//  mcare-model
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumBase.h"

@interface StatusTypes : EnumBase

typedef enum {
    StatusTypes_Offline     = 0,
    StatusTypes_Online      = 1,
    StatusTypes_Operating   = 2,
    StatusTypes_Clinic      = 3,
    StatusTypes_Working     = 4,
    StatusTypes_Vacation    = 5
} Status_Types;

+ (NSString *)getLabel:(NSInteger)type;

@end
