//
//  GenderTypes.h
//  mcare-model
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenderTypes : NSObject

typedef enum {
    GenderTypes_Secrecy = 0,
    GenderTypes_Male    = 1,
    GenderTypes_Female  = 2
} Gender_Types;

+ (NSString *)getLabel:(NSInteger)type;

@end
