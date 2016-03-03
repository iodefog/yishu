//
//  EnterpriseDTO.m
//  medtree
//
//  Created by 边大朋 on 15/10/21.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "EnterpriseDTO.h"

@implementation EnterpriseDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.enterpriseId = [self getStrValue:[dict objectForKey:@"enterpriseId"]];
    self.name = [self getStrValue:[dict objectForKey:@"name"]];
    self.logo = [self getStrValue:[dict objectForKey:@"logo"]];
    self.location = [self getStrValue:[dict objectForKey:@"location"]];
    self.companyType = [self getStrValue:[dict objectForKey:@"companyType"]];
    self.peopleScope = [self getStrValue:[dict objectForKey:@"peopleScope"]];
    self.baseInfoFormat = [NSString stringWithFormat:@"%@ | %@ | %@", self.location, self.companyType, self.peopleScope];
    return YES;
}

@end
