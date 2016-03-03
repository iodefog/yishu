//
//  FriendRecommandDTO.m
//  medtree
//
//  Created by tangshimi on 7/5/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "FriendRecommandDTO.h"
#import "UserDTO.h"

@implementation FriendRecommandDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.title = [self getStrValue:[dict objectForKey:@"title"]];
    NSArray *arr =  [self getArrayValue:[[dict objectForKey:@"meta"] objectForKey:@"profiles"]];
    
    NSMutableArray *friendArray = [NSMutableArray new];
    for (NSDictionary *dic in arr) {
        UserDTO *dto = [[UserDTO alloc] init:dic];
        [friendArray addObject:dto];
    }
    
    self.friendArray = friendArray;
    
    return YES;
}

@end
