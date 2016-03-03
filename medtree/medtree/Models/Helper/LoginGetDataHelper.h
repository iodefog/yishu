//
//  LoginGetDataHelper.h
//  medtree
//
//  Created by 陈升军 on 15/3/3.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserDTO;

@interface LoginGetDataHelper : NSObject

+ (void)getData;

+ (void)getFriendData;
+ (void)getContactData:(NSNumber *)from;

+ (BOOL)getfriendDataIsOver;
+ (BOOL)getcontactDataIsOver;
+ (BOOL)getcontactDataIsError;
+ (BOOL)getfriendDataIsError;

+ (NSMutableArray *)mateData;
+ (void)updateMateData:(NSString *)mateID user:(UserDTO *)user overlook:(BOOL)overlook;

+ (void)setIsMatch:(BOOL)sender;
+ (BOOL)getIsMatch;

@end
