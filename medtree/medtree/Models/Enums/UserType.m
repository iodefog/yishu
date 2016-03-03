//
//  UserType.m
//  medtree
//
//  Created by 无忧 on 14-11-5.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "UserType.h"

@implementation UserType

+ (NSString *)getLabel:(NSInteger)type
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        //
        [dict setObject:@"未设置" forKey:[NSNumber numberWithInteger:UserTypes_Unknown]];
        [dict setObject:@"系统内部用户" forKey:[NSNumber numberWithInteger:UserTypes_SystemUser]];
        
        [dict setObject:@"医院在职医生" forKey:[NSNumber numberWithInteger:UserTypes_Physicians]];
        [dict setObject:@"医院在职护士" forKey:[NSNumber numberWithInteger:UserTypes_NursingStaff]];
        
        [dict setObject:@"医院其他医务人员" forKey:[NSNumber numberWithInteger:UserTypes_Technician]];
        [dict setObject:@"医院其他医务人员" forKey:[NSNumber numberWithInteger:UserTypes_PharmaceuticalPersonnel]];
        [dict setObject:@"医院其他医务人员" forKey:[NSNumber numberWithInteger:UserTypes_ManagementAndAdministrative]];
        
        [dict setObject:@"卫生行政/医学教科研人员" forKey:[NSNumber numberWithInteger:UserTypes_MedicalTeaching]];
        
        [dict setObject:@"医学院在读学生" forKey:[NSNumber numberWithInteger:UserTypes_Students]];
        
        [dict setObject:@"影子用户" forKey:[NSNumber numberWithInteger:UserTypes_Shadow]];
        
        [dict setObject:@"其他学医人员" forKey:[NSNumber numberWithInteger:UserTypes_AlwaysBecome]];
        
        [dict setObject:@"匿名用户" forKey:[NSNumber numberWithInteger:UserTypes_Anonymous]];
    }
    NSString *label = [dict objectForKey:[NSNumber numberWithInteger:type]];
    return label ? label : @"";
}

+ (NSString *)getShortLabel:(NSInteger)type
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        //
        [dict setObject:@"未设置" forKey:[NSNumber numberWithInteger:UserTypes_Unknown]];
        [dict setObject:@"系统内部用户" forKey:[NSNumber numberWithInteger:UserTypes_SystemUser]];
        [dict setObject:@"医院在职医生" forKey:[NSNumber numberWithInteger:UserTypes_Physicians]];
        [dict setObject:@"医院在职护士" forKey:[NSNumber numberWithInteger:UserTypes_NursingStaff]];
        
        [dict setObject:@"医院其他医务人员" forKey:[NSNumber numberWithInteger:UserTypes_Technician]];
        [dict setObject:@"医院其他医务人员" forKey:[NSNumber numberWithInteger:UserTypes_PharmaceuticalPersonnel]];
        [dict setObject:@"医院其他医务人员" forKey:[NSNumber numberWithInteger:UserTypes_ManagementAndAdministrative]];
        
        [dict setObject:@"卫生行政/医学教科研人员" forKey:[NSNumber numberWithInteger:UserTypes_MedicalTeaching]];
        [dict setObject:@"医学院在读学生" forKey:[NSNumber numberWithInteger:UserTypes_Students]];
        [dict setObject:@"影子用户" forKey:[NSNumber numberWithInteger:UserTypes_Shadow]];
        [dict setObject:@"其他学医人员" forKey:[NSNumber numberWithInteger:UserTypes_AlwaysBecome]];
        [dict setObject:@"匿名用户" forKey:[NSNumber numberWithInteger:UserTypes_Anonymous]];
    }
    NSString *label = [dict objectForKey:[NSNumber numberWithInteger:type]];
    return label ? label : @"";
}

+ (NSInteger)getInteger:(NSString *)title
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];

        [dict setObject:@"未设置" forKey:[NSNumber numberWithInteger:UserTypes_Unknown]];
        [dict setObject:@"系统内部用户" forKey:[NSNumber numberWithInteger:UserTypes_SystemUser]];
        [dict setObject:@"医院在职医生" forKey:[NSNumber numberWithInteger:UserTypes_Physicians]];
        [dict setObject:@"医院在职护士" forKey:[NSNumber numberWithInteger:UserTypes_NursingStaff]];
        
        [dict setObject:@"医院其他医务人员" forKey:[NSNumber numberWithInteger:UserTypes_Technician]];
        [dict setObject:@"医院其他医务人员" forKey:[NSNumber numberWithInteger:UserTypes_PharmaceuticalPersonnel]];
        [dict setObject:@"医院其他医务人员" forKey:[NSNumber numberWithInteger:UserTypes_ManagementAndAdministrative]];
        
        [dict setObject:@"卫生行政/医学教科研人员" forKey:[NSNumber numberWithInteger:UserTypes_MedicalTeaching]];
        [dict setObject:@"医学院在读学生" forKey:[NSNumber numberWithInteger:UserTypes_Students]];
        [dict setObject:@"影子用户" forKey:[NSNumber numberWithInteger:UserTypes_Shadow]];
        [dict setObject:@"其他学医人员" forKey:[NSNumber numberWithInteger:UserTypes_AlwaysBecome]];
        [dict setObject:@"匿名用户" forKey:[NSNumber numberWithInteger:UserTypes_Anonymous]];
    }
    
    NSArray *array = [dict allKeys];
    NSInteger keyNum = 0;
    for (NSString *key in array)
    {
        if (  [title isEqualToString:[dict objectForKey:key] ] )
        {
            keyNum = [key integerValue];
            break;
        }
    }
    return keyNum;
}

@end
