//
//  HomeJobChannelHotEmploymentDetailDTO.m
//  medtree
//
//  Created by tangshimi on 11/2/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelHotEmploymentDetailDTO.h"

@implementation HomeJobChannelHotEmploymentDetailDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.enterpriseID = [self getStrValue:[dict objectForKey:@"enterprise_id"]];
    self.enterpriseName = [self getStrValue:[dict objectForKey:@"name"]];
    self.enterpriseImage = [self getStrValue:[dict objectForKey:@"logo"]];
    self.enterpriseURL = [self getStrValue:[dict objectForKey:@"url"]];
    self.enterprisePlace = [self getStrValue:[dict objectForKey:@"address"]];
    self.enterpriseEmploymentCount = [self getIntValue:[dict objectForKey:@"job_count"]];
    NSString *string = @"不限，事业单位，国家行政机关，国有企业，国有控股企业，外资企业，合资企业，私营企业";
   
    NSArray *natureArray = [string componentsSeparatedByString:@"，"];
    if (natureArray.count > [self getIntValue:[dict objectForKey:@"type"]]) {
        self.enterpriseNature = natureArray[[self getIntValue:[dict objectForKey:@"type"]]];
    }
        
    NSString *sizeString = @"不限，1-400人，400人以上，1000人以上，2000人以上，4000人以上";
    NSArray *sizeArray = [sizeString componentsSeparatedByString:@"，"];
    if (sizeArray.count > [self getIntValue:[dict objectForKey:@"scale"]]) {
        self.enterpriseSize = sizeArray[[self getIntValue:[dict objectForKey:@"scale"]]];
    }
    
    self.shareInfo = [self getStrValue:dict[@"welfare"]];
    
    return YES;
}

@end
