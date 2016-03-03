//
//  DegreeDTO.m
//  medtree
//
//  Created by 无忧 on 14-9-5.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DegreeDTO.h"

@implementation DegreeDTO

- (BOOL)parse:(NSDictionary *)dict
{
    NSDictionary *first_degree_Dict = [dict objectForKey:@"first_degree"];
    self.first_degree_total_count = [self getIntValue:[first_degree_Dict objectForKey:@"total_count"]];
    NSDictionary *relationDict = [first_degree_Dict objectForKey:@"relation"];
    self.first_degree_Friend_count = [self getIntValue:[relationDict objectForKey:@"1"]];
    self.first_degree_Classmate_count = [self getIntValue:[relationDict objectForKey:@"12"]];
    self.first_degree_Colleague_count = [self getIntValue:[relationDict objectForKey:@"20"]];
    self.first_degree_Peer_count = [self getIntValue:[relationDict objectForKey:@"22"]];
    
    NSDictionary *second_degree_Dict = [dict objectForKey:@"second_degree"];
    self.second_degree_total_count = [self getIntValue:[second_degree_Dict objectForKey:@"total_count"]];
    NSDictionary *organization = [first_degree_Dict objectForKey:@"organization"];
    self.second_degree_Friend_count = [self getIntValue:[organization objectForKey:@"1"]];
    self.second_degree_Classmate_count = [self getIntValue:[organization objectForKey:@"10"]];
    self.second_degree_Colleague_count = [self getIntValue:[organization objectForKey:@"20"]];
    
    return YES;
}

@end
