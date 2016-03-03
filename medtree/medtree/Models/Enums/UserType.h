//
//  UserType.h
//  medtree
//
//  Created by 无忧 on 14-11-5.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "EnumBase.h"

@interface UserType : EnumBase

typedef enum {
    UserTypes_Unknown                       = 0,
    UserTypes_SystemUser                    = 1,
    UserTypes_Physicians                    = 2,        //  医生
    UserTypes_NursingStaff                  = 3,        //  护士
    UserTypes_Technician                    = 4,
    UserTypes_PharmaceuticalPersonnel       = 5,
    
    UserTypes_ManagementAndAdministrative   = 6,        //  其他医务人员
    UserTypes_MedicalTeaching               = 7,        //  卫生行政/医学教科研人员
    UserTypes_Students                      = 8,        //  医学学生
    UserTypes_Shadow                        = 9,
    UserTypes_AlwaysBecome                  = 10,       //  其他学医人员
    UserTypes_Anonymous                     = 11,
} User_Types;

+ (NSString *)getLabel:(NSInteger)type;
+ (NSInteger)getInteger:(NSString *)title;
+ (NSString *)getShortLabel:(NSInteger)type;

@end
