//
//  SignDTO.m
//  medtree
//
//  Created by 陈升军 on 15/2/12.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "SignDTO.h"
#import "DateUtil.h"

@implementation SignDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.todayTime = [DateUtil convertTime:[self getStrValue:[dict objectForKey:@"today"]] formate:@"yyyy-MM-dd HH:mm:ss"];
    self.point = [self getIntValue:[dict objectForKey:@"point"]];
    self.total_amount = [self getIntValue:[dict objectForKey:@"total_amount"]];
    self.check_count = [self getIntValue:[dict objectForKey:@"check_count"]];
    self.today_check = [[dict objectForKey:@"today_check"] boolValue];
    if ([dict objectForKey:@"continuous_signin"]) {
        self.content = [self getStrValue:[dict objectForKey:@"continuous_signin"]];
    } else {
        self.content = @"";
    }
    
    
    NSDictionary *account = [dict objectForKey:@"account"];
    self.balance = [self getIntValue:[account objectForKey:@"balance"]];
    self.exchangeable = [[dict objectForKey:@"exchangeable"] boolValue];
    self.locked = [[dict objectForKey:@"locked"] boolValue];
    
    return YES;
}

@end
