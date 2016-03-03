//
//  ExperienceDepSecondController.m
//  medtree
//
//  Created by 边大朋 on 15/6/14.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceDepSecondController.h"
#import "DepartmentNameDTO.h"
#import "DegreeManager.h"

@implementation ExperienceDepSecondController

#pragma mark - UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [naviBar setTopTitle:self.departDto.name];
    [naviBar setTopLabelColor:[UIColor whiteColor]];
}

#pragma mark - private
- (void)getDepartmentDataWithDict:(NSMutableDictionary *)dict
{
    [dict setObject:@2 forKey:@"level"];
    [dict setObject:self.departDto.departmentID forKey:@"parent_id"];
    [super getDepartmentDataWithDict:dict];
}

#pragma mark - ExperienceTableViewDelegate
- (void)selectTitle:(id)dto
{
    if ([dto isKindOfClass:[DepartmentNameDTO class]]) {
        DepartmentNameDTO *idto = (DepartmentNameDTO *)dto;
        idto.parent_name = self.departDto.name;
        if ([self.parent respondsToSelector:@selector(updateInfo:)]) {
            [self.parent updateInfo:@{@"data":@"department",@"department":idto}];
        }
        [self.navigationController popToViewController:self.fromVC animated:YES];
    }
}
@end
