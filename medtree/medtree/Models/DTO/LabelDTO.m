//
//  LabelDTO.m
//  medtree
//
//  Created by sam on 11/9/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "LabelDTO.h"

@implementation LabelDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.name = [self getStrValue:[dict objectForKey:@"name"]];
    self.image = [self getStrValue:[dict objectForKey:@"name"]];
    self.sort = [self getIntValue:[dict objectForKey:@"sort"]];
    return YES;
}

@end
