//
//  ProvienceDTO.m
//  medtree
//
//  Created by 孙晨辉 on 15/7/31.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ProvinceDTO.h"

@implementation ProvinceDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.name = [self getStrValue:dict[@"name"]];
    self.count = [self getIntValue:dict[@"count"]];
    
    return YES;
}

@end
