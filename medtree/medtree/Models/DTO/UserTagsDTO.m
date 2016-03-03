//
//  UserTagsDTO.m
//  medtree
//
//  Created by 边大朋 on 15-4-4.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "UserTagsDTO.h"
#import "UserDTO.h"
@implementation UserTagsDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.maxWidth = [self getIntValue:[dict objectForKey:@"maxWidth"]];
    self.type = [self getIntValue:[dict objectForKey:@"type"]];
    self.pageType = [self getIntValue:[dict objectForKey:@"pageType"]];
    self.clearCache = [[dict objectForKey:@"clearCache"] boolValue];
    //
    {
        if (self.tags == nil) {
            self.tags = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"tags"] != [NSNull null] && [dict objectForKey:@"tags"] != nil) {
            NSArray *array = [dict objectForKey:@"tags"];
            [self.tags addObjectsFromArray:array];
        }
    }
    return YES;
}

- (NSMutableArray *)tags
{
    if (!_tags)
    {
        _tags = [[NSMutableArray alloc] init];
    }
    return _tags;
}

@end
