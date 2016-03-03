//
//  NewCountDTO.m
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewCountDTO.h"
#import "DateUtil.h"

@implementation NewCountDTO

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    self.key = [self getStrValue:[dict objectForKey:@"key"]];
    self.value = [self getIntValue:[dict objectForKey:@"value"]];
    self.unread = [self getIntValue:[dict objectForKey:@"unread"]];
    self.type = [self getIntValue:[dict objectForKey:@"type"]];
    //
    return tf;
}

@end
