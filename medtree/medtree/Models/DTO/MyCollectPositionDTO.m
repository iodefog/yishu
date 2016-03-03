//
//  MyCollectPositionDTO.m
//  medtree
//
//  Created by Jiangmm on 15/11/30.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "MyCollectPositionDTO.h"
#import <DateUtil.h>
@implementation MyCollectPositionDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.employmentID = [self getStrValue:[dict objectForKey:@"id"]];
    self.enterpriseName = [self getStrValue:[dict objectForKey:@"enterprise_name"]];
    self.enterpriseID = [self getStrValue:[dict objectForKey:@"enterprise_id"]];
    self.employmentTitle = [self getStrValue:[dict objectForKey:@"name"]];
    self.imageURL = [self getStrValue:[dict objectForKey:@"enterprise_logo"]];
    
    self.enterprisePlace = [self getStrValue:dict[@"province"]];
    
//    NSString *string = @"不限，应届毕业生，1年以上，2年以上，3年以上，5年以上，10年以上";
//    NSArray *workExperienceTitleArray = [string componentsSeparatedByString:@"，"];
    
    NSString *educationString = @"不限，大中专及以上，本科及以上，硕士及以上，博士及以上，其他";
    NSArray *educationArray = [educationString componentsSeparatedByString:@"，"];
    if (educationArray.count > [self getIntValue:[dict objectForKey:@"education"]]) {
        self.educationRequirements = educationArray[[self getIntValue:[dict objectForKey:@"education"]]];
    }
    
    NSString *natureString = @"不限，事业单位，国家行政机关，国有企业，国有控股企业，外资企业，合资企业，私营企业";
    NSArray *natureArray = [natureString componentsSeparatedByString:@"，"];
    if (natureArray.count > [self getIntValue:dict[@"enterprise_type"]]) {
        self.enterpriseNature = natureArray[[self getIntValue:dict[@"enterprise_type"]]];
    }
    
    NSString *levelString = @"不限，三级甲等，三级乙等，二级甲等，二级二等，一级，其他";
    NSArray *levelArray = [levelString componentsSeparatedByString:@"，"];
    if (levelArray.count > [self getIntValue:dict[@"enterprise_level"]]) {
        self.enterpriseLevel = levelArray[[self getIntValue:dict[@"enterprise_level"]]];
    }
    
    NSString *sizeString = @"不限，1-400人，400人以上，1000人以上，2000人以上，4000人以上";
    NSArray *sizeArray = [sizeString componentsSeparatedByString:@"，"];
    if (sizeArray.count > [self getIntValue:dict[@"enterprise_scale"]]) {
        self.enterpriseSize = sizeArray[[self getIntValue:dict[@"enterprise_scale"]]];
    }
    
    self.publishTime = [DateUtil getDisplayTime:[self getDateValue:[dict objectForKey:@"created"]]];
    
    self.employmentURL = [self getStrValue:[dict objectForKey:@"url"]];
    self.salaryID = [self getIntValue:[dict objectForKey:@"salary"]];
    NSString *salaryString = @"不限，2k-4k，4k-6k，6k-10k，10k-20k，20k以上，面议";
    NSArray *salaryArray = [salaryString componentsSeparatedByString:@"，"];
    if (salaryArray.count > [self getIntValue:[dict objectForKey:@"salary"]]) {
        self.salary = salaryArray[[self getIntValue:[dict objectForKey:@"salary"]]];
    }
    
    return YES;
}
@end
