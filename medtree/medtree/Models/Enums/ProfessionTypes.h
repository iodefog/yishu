//
//  ProfessionTypes.h
//  mcare-model
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumBase.h"

@interface ProfessionTypes : EnumBase

typedef enum {
    ProfessionTypes_Unknown = 0,
    ProfessionTypes_Doctor  = 10,
    ProfessionTypes_Nurse   = 20,
    ProfessionTypes_Student = 30,
    ProfessionTypes_Worker  = 90
} Profession_Types;

+ (NSString *)getLabel:(NSInteger)type;

@end
