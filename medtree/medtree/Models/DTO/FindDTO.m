//
//  FindDTO.m
//  medtree
//
//  Created by tangshimi on 7/15/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "FindDTO.h"

@implementation FindDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.title = [self getStrValue:[dict objectForKey:@"title"]];
    self.iconImageURL = [self getStrValue:[dict objectForKey:@"icon"]];
    self.webURL = [self getStrValue:[dict objectForKey:@"url"]];
    
    return YES;
}

@end
