//
//  PairDTO.m
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PairDTO.h"
#import "DateUtil.h"

@implementation PairDTO

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    self.date = [DateUtil convertTime:[dict objectForKey:@"date"]];
    self.label = [self getStrValue:[dict objectForKey:@"label"]];
    self.key = [self getStrValue:[dict objectForKey:@"key"]];
    self.value = [self getStrValue:[dict objectForKey:@"value"]];
    self.type = [self getIntValue:[dict objectForKey:@"type"]];
    self.imageName = [self getStrValue:[dict objectForKey:@"imageName"]];
    self.badge = [self getStrValue:[dict objectForKey:@"badge"]];
    self.isShowRoundView = [self getIntValue:[dict objectForKey:@"isShowRoundView"]];
    //
    if (self.resourceArray == nil) {
        self.resourceArray = [[NSMutableArray alloc] init];
    }
    if ((NSObject *)[dict objectForKey:@"resource"] != [NSNull null] && [dict objectForKey:@"resource"] != nil) {
        NSArray *array = [dict objectForKey:@"resource"];
        [self.resourceArray addObjectsFromArray:array];
    }
    if (self.selectResourceArray == nil) {
        self.selectResourceArray = [[NSMutableArray alloc] init];
    }
    if ((NSObject *)[dict objectForKey:@"selectResource"] != [NSNull null] && [dict objectForKey:@"selectResource"] != nil) {
        NSArray *array = [dict objectForKey:@"selectResource"];
        [self.selectResourceArray addObjectsFromArray:array];
    }
    
    if (self.resourceDict == nil) {
        self.resourceDict = [[NSMutableDictionary alloc] init];
    }
    [self.resourceDict removeAllObjects];
    [self.resourceDict addEntriesFromDictionary:[dict objectForKey:@"resourceDict"]];
    
    return tf;
}

@end


@implementation SectionDTO

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    self.name = [self getStrValue:[dict objectForKey:@"name"]];
    {
        if (self.items == nil) {
            self.items = [[NSMutableArray alloc] init];
        }
        NSArray *array = [dict objectForKey:@"items"];
        for (int i=0; i<array.count; i++) {
            PairDTO *dto = [[PairDTO alloc] init:[array objectAtIndex:i]];
            [self.items addObject:dto];
        }
    }
    //
    return tf;
}

@end
