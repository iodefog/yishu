//
//  CertificationStatusType.h
//  medtree
//
//  Created by 无忧 on 14-11-8.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "EnumBase.h"

@interface CertificationStatusType : EnumBase

typedef enum {
    CertificationStatusType_No              = 0,
    CertificationStatusType_Pass            = 1,
    CertificationStatusType_Wait            = 2,
    CertificationStatusType_NotPass         = 3,
    CertificationStatusType_Screen          = 4,
} CertificationStatus_Types;

+ (NSString *)getLabel:(NSInteger)type;
+ (NSInteger)getInteger:(NSString *)title;

@end
