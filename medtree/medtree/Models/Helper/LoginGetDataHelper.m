//
//  LoginGetDataHelper.m
//  medtree
//
//  Created by 陈升军 on 15/3/3.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "LoginGetDataHelper.h"
#import "ServiceManager.h"
#import "MessageManager.h"
#import "DTOBase.h"
#import "UserManager.h"
#import "UserDTO.h"
#import "JSONKit.h"
#import "ForumManager.h"
#import "MateUserDTO.h"


@implementation LoginGetDataHelper

static bool friendDataIsOver = NO;
static bool friendDataIsError = NO;
static bool contactDataIsOver = NO;
static bool contactDataIsError = NO;

+ (BOOL)getfriendDataIsOver
{
    return friendDataIsOver;
}

+ (BOOL)getfriendDataIsError
{
    return friendDataIsError;
}

+ (BOOL)getcontactDataIsOver
{
    return contactDataIsOver;
}

+ (BOOL)getcontactDataIsError
{
    return contactDataIsError;
}

+ (NSMutableArray *)mateData
{
    return [LoginGetDataHelper getContactData];
}

+ (void)getData
{
    [LoginGetDataHelper getCheckMarkContacts:^(id JSON) {
        [[LoginGetDataHelper getContactData] removeAllObjects];
        if (JSON) {
            [[LoginGetDataHelper getContactData] addObjectsFromArray:JSON];
            
        }
    }];
    [ForumManager getData:@{@"method":[NSNumber numberWithInt:MethodType_Forum_GetForumCategories]} success:^(id JSON) {
        [[NSUserDefaults standardUserDefaults] setObject:JSON forKey:@"ForumCategories"];
    } failure:^(NSError *error, id JSON) {
        
    }];
//    [LoginGetDataHelper getFriendData];
    [LoginGetDataHelper getContactData:[NSNumber numberWithInt:0]];
}

+ (void)getFriendData
{
    friendDataIsOver = NO;
    friendDataIsError = NO;
    [LoginGetDataHelper getLoginDataInfo:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ServiceManager getData:@{@"method": [NSNumber numberWithInteger:MethodType_FriendList], @"from": [NSNumber numberWithInt:0], @"size": [NSNumber numberWithInteger:50],@"timestamp":JSON?JSON:[NSNumber numberWithInt:0]} success:^(id JSON) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *array = (NSArray *)JSON;
                    if (array.count < 50) {
                        friendDataIsOver = YES;
                        [[NSNotificationCenter defaultCenter] postNotificationName:GetFriendDataOverNotification object:nil];
                    } else {
                        [LoginGetDataHelper getFriendData];
                        
                    }
                });
            } failure:^(NSError *error, id JSON) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    friendDataIsError = YES;
//                [LoginGetDataHelper performSelector:@selector(getFriendData) withObject:nil afterDelay:3];
                });
            }];
        });
    } key:@"friendTimeStamp"];
}

static NSInteger num = 0;

+ (void)getContactData:(NSNumber *)from
{
    contactDataIsOver = NO;
    contactDataIsError = NO;
    num = [from integerValue];
    [LoginGetDataHelper getLoginDataInfo:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ServiceManager getData:@{@"method": [NSNumber numberWithInteger:MethodType_Name_SameUser], @"from": from, @"size": [NSNumber numberWithInteger:50], @"timestamp":JSON?JSON:[NSNumber numberWithInt:0], @"matchType": @2} success:^(id JSON) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *dict = (NSDictionary *)JSON;
                    NSArray *array = [NSArray arrayWithArray:[dict objectForKey:@"data"]];
                    if (array.count > 0) {
                        [LoginGetDataHelper checkContactData:array];
                        if ([[dict objectForKey:@"offset"] integerValue] < [[dict objectForKey:@"total"] integerValue]) {
                            [LoginGetDataHelper getContactData:[dict objectForKey:@"offset"]];
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                contactDataIsOver = YES;
                                [[NSNotificationCenter defaultCenter] postNotificationName:MatchFriendOverNotification object:nil];
                            });
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            contactDataIsOver = YES;
                            [[NSNotificationCenter defaultCenter] postNotificationName:MatchFriendOverNotification object:nil];
                        });
                    }
                });
            } failure:^(NSError *error, id JSON) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    contactDataIsError = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:MatchFriendOverNotification object:nil];
//                    [LoginGetDataHelper performSelector:@selector(getContactData:) withObject:[NSNumber numberWithInteger:num] afterDelay:3];
                });
            }];
        });
    } key:@"contactTimeStamp"];
}

+ (NSMutableArray *)getContactData
{
    static NSMutableArray *array = nil;
    if (array == nil) {
        array = [[NSMutableArray alloc] init];
    }
    return array;
}

+ (void)checkContactData:(NSArray *)result
{
    NSMutableDictionary *checkDataDict = [NSMutableDictionary dictionary];
    NSMutableArray *checkArray = [NSMutableArray array];
    [checkArray addObjectsFromArray:[LoginGetDataHelper getContactData]];
    
    for (int i = 0; i < checkArray.count; i ++) {
        NSDictionary *dto = [checkArray objectAtIndex:i];
        [checkDataDict setObject:@{@"dto":dto,@"index":[NSNumber numberWithInt:i]} forKey:[dto objectForKey:@"id"]];
    }
    
    if (checkArray.count == 0) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < result.count; i ++) {
            NSDictionary *dict = [result objectAtIndex:i];
            if ([[dict objectForKey:@"marked_user_id"] isEqualToString:@"-404"] == NO) {
                [array addObject:dict];
            }
        }
        [[LoginGetDataHelper getContactData] addObjectsFromArray:array];
    } else {
        for (int i = 0; i < result.count; i ++) {
            NSDictionary *dto = [result objectAtIndex:i];
            if ([checkDataDict objectForKey:[dto objectForKey:@"id"]]) {
                
                if ([[dto objectForKey:@"marked_user_id"] isEqualToString:@"-404"] == NO) {
                    [[LoginGetDataHelper getContactData] replaceObjectAtIndex:[[[checkDataDict objectForKey:[dto objectForKey:@"id"]] objectForKey:@"index"] integerValue] withObject:dto];
                } else {
                    [[LoginGetDataHelper getContactData] removeObjectAtIndex:[[[checkDataDict objectForKey:[dto objectForKey:@"id"]] objectForKey:@"index"] integerValue]];
                }
            } else {
                if ([[dto objectForKey:@"marked_user_id"] isEqualToString:@"-404"] == NO) {
                    [[LoginGetDataHelper getContactData] addObject:dto];
                }
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [LoginGetDataHelper setCheckMarkContacts];
    });
}

+ (void)getCheckMarkContacts:(SuccessBlock)success
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"matchContacts"} success:^(id JSON) {
        NSArray *array = [NSArray arrayWithArray:JSON];
        if (array.count > 0) {
            NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:0]];
            success ([dataDict objectForKey:@"data"]);
        } else {
            success (nil);
        }
    } failure:^(NSError *error, id JSON) {
        success (nil);
    }];
}
     
+ (void)setCheckMarkContacts
{
    DTOBase *dto = [[DTOBase alloc] init:@{@"data":[LoginGetDataHelper getContactData]}];
    [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"matchContacts",@"info":dto} success:^(id JSON) {
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}

+ (void)getLoginDataInfo:(SuccessBlock)success key:(NSString *)key
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":key} success:^(id JSON) {
        NSArray *array = [NSArray arrayWithArray:JSON];
        if (array.count > 0) {
            NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:0]];
            success ([dataDict objectForKey:key]);
        } else {
            success (nil);
        }
    } failure:^(NSError *error, id JSON) {
        success (nil);
    }];
}

+ (void)setLoginDataInfo:(NSDictionary *)dict key:(NSString *)key
{
    DTOBase *dto = [[DTOBase alloc] init:dict];
    [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":key,@"info":dto} success:^(id JSON) {
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}

+ (void)updateMateData:(NSString *)mateID user:(UserDTO *)user overlook:(BOOL)overlook
{
    NSMutableDictionary *checkDataDict = [NSMutableDictionary dictionary];
    NSMutableArray *checkArray = [NSMutableArray array];
    [checkArray addObjectsFromArray:[LoginGetDataHelper getContactData]];
    
    for (int i = 0; i < checkArray.count; i ++) {
        NSDictionary *dto = [checkArray objectAtIndex:i];
        [checkDataDict setObject:@{@"dto":dto,@"index":[NSNumber numberWithInt:i]} forKey:[NSString stringWithFormat:@"%@",[dto objectForKey:@"id"]]];
    }
    
    if ([checkDataDict objectForKey:mateID]) {
        if (overlook) {
            [[LoginGetDataHelper getContactData] removeObjectAtIndex:[[[checkDataDict objectForKey:mateID] objectForKey:@"index"] integerValue]];
        } else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[checkDataDict objectForKey:mateID] objectForKey:@"dto"]];
            [dict setObject:[NSArray arrayWithObjects:[user JSON], nil] forKey:@"matched_users"];
            [dict setObject:[NSNumber numberWithInt:3] forKey:@"status"];
            [dict setObject:[NSNumber numberWithInt:0] forKey:@"same_name_count"];
            [dict setObject:user.userID forKey:@"marked_user_id"];
            [[LoginGetDataHelper getContactData] replaceObjectAtIndex:[[[checkDataDict objectForKey:mateID] objectForKey:@"index"] integerValue] withObject:dict];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [LoginGetDataHelper setCheckMarkContacts];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_mate_friend_over" object:nil];
    });
}

static BOOL isMatch;

+ (void)setIsMatch:(BOOL)sender
{
    isMatch = sender;
}

+ (BOOL)getIsMatch
{
    return isMatch;
}

@end
