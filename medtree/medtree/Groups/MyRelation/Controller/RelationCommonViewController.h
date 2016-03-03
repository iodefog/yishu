//
//  RelationCommonViewController.h
//  medtree
//
//  Created by tangshimi on 6/10/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "SearchBarTableViewController.h"

typedef enum {
    RelationCommonViewControllerClassmateSchoolType = 1,//同学学校
    RelationCommonViewControllerSchoolmateSchoolType,//校友学校
    RelationCommonViewControllerSchoolmateGradeType, //校友年级
    RelationCommonViewControllerSchoolmateAcademicYearType,//校友学制
    RelationCommonViewControllerSchoolmateMajorType,//校友专业
    RelationCommonViewControllerColleagueHospitalType,//同事医院
    RelationCommonViewControllerColleagueFirstGradeDepartmentType,//同事一级科室
    RelationCommonViewControllerColleagueSecondGradeDepartmentType,//同事二级科室
    RelationCommonViewControllerPeerCityType,//同行城市
    RelationCommonViewControllerPeerHospitalType,//同行医院
    RelationCommonViewControllerPeerFirstGradeDepartmentType,//同行一级科室
    RelationCommonViewControllerFriendOfFriendHospitalType,//好友的好友医院
    RelationCommonViewControllerFriendOfFriendFirstGradeDepartmentType,//好友的好友一级科室
    RelationCommonViewControllerFriendOfFriendSecondGradeDepartmentType,//好友的好友二级科室
    
    RelationCommonViewControllerMapFirstGradeDepartmentType,//地图一级科室
    RelationCommonViewControllerMapSecondGradeDepartmentType
}RelationCommonViewControllerType;

@interface RelationCommonViewController : SearchBarTableViewController

@property (nonatomic, assign) RelationCommonViewControllerType type;

@property (nonatomic, strong) NSDictionary *params;

/**
 *  一级列表 同事，显示提示框
 */
@property (nonatomic, assign) NSInteger totalPeopleNumber;

@property (nonatomic, copy) NSString *navigationTitle;

- (void)setTopTitle:(NSString *)title;

@end
