//
//  EmptyDTO.m
//  medtree
//
//  Created by 陈升军 on 15/4/22.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "EmptyDTO.h"

@implementation EmptyDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.height = [self getFloatValue:[dict objectForKey:@"height"]];
    return YES;
}

@end
