//
//  RelationDTO.m
//  medtree
//
//  Created by tangshimi on 6/14/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "RelationDTO.h"

@implementation RelationDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.name = [self getStrValue:[dict objectForKey:@"name"]];
    self.count = [NSString stringWithFormat:@"%@", @([self getIntValue:[dict objectForKey:@"count"]])];
    return YES;
}

@end
