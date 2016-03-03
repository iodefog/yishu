//
//  TrimContact.h
//  contactutil
//
//  Created by sam on 13-5-29.
//  Copyright (c) 2013年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactUtil.h"

typedef enum  {
    TrimContact_All = 0,
    TrimContact_Phone = 1,
    TrimContact_Name = 2,
    TrimContact_PhoneFormat = 4,
    TrimContact_NameFormat = 8,
    TrimContact_Delete = 16
} TrimContact_Type;

@interface TrimContact : NSObject

+ (NSMutableDictionary *)trimContactNames:(NSDictionary *)dict process:(TransGroup)process;
+ (NSMutableDictionary *)trimContactPhones:(NSDictionary *)dict process:(TransGroup)process;
+ (NSMutableArray *)getTrimContactByPhone:(NSDictionary *)dict process:(TransInfo)process;
+ (NSMutableArray *)getTrimContactByName:(NSDictionary *)dict process:(TransInfo)process;

@end
