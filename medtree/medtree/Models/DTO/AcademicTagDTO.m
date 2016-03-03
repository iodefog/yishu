
//
//  AcademicTagDTO.m
//  medtree
//
//  Created by 边大朋 on 15/8/7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "AcademicTagDTO.h"

@implementation AcademicTagDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.tagName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"tag"]];
    self.tagCount = [self getStrValue:[[dict objectForKey:@"count"] stringValue]];
    self.isLike = [self getBoolValue:dict[@"is_liked"]];
    return YES;
}

@end
