//
//  ExperienceDTO.m
//  medtree
//
//  Created by 陈升军 on 15/6/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceDTO.h"
#import "DepartmentNameDTO.h"

@implementation ExperienceDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.experienceType = (ExperienceType)[self getIntValue:[dict objectForKey:@"experience_type"]];
    self.org = [self getStrValue:[dict objectForKey:@"organization"]];
    self.title = [self getStrValue:[dict objectForKey:@"title"]];
    self.startDate = [self getStrValue:[dict objectForKey:@"start_time"]];
    self.endDate = [self getStrValue:[dict objectForKey:@"end_time"]];
    
    self.experienceId = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"id"] longLongValue]];
    self.organization_id = [self getStrValue:[dict objectForKey:@"organization_id"]];
    self.title_type = [self getIntValue:[dict objectForKey:@"title_type"]];
    self.experienceCertStatus = (CertificationStatus_Types)[self getIntValue:[dict objectForKey:@"certification_status"]];
    self.orgType = (OrgType)[self getIntValue:[dict objectForKey:@"org_type"]];
    
    if (self.departments == nil) {
        self.departments = [[NSMutableArray alloc] init];
    }
    if ([dict objectForKey:@"departments"]) {
        NSArray *array = [dict objectForKey:@"departments"];
        [self.departments addObjectsFromArray:array];

        DepartmentNameDTO *dto = [[DepartmentNameDTO alloc] init];
        dto.departmentID = [[self.departments lastObject] objectForKey:@"department_id"];
        dto.name = [[self.departments lastObject] objectForKey:@"department"];
        if (self.departments.count == 2) {
            dto.parent_id = [[self.departments firstObject] objectForKey:@"department_id"];
            dto.parent_name = [[self.departments firstObject] objectForKey:@"department"];
        }
        self.department = dto;
    }

    return YES;
}
@end
