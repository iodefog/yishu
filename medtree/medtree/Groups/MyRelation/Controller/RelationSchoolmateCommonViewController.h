//
//  RelationSchoolmateCommonViewController.h
//  medtree
//
//  Created by tangshimi on 6/11/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MedTreeBaseController.h"

typedef enum {
    RelationSchoolmateCommonViewControllerSchoolType, //学校
    RelationSchoolmateCommonViewControllerClassmatePeopleType, //同学 人
    RelationSchoolmateCommonViewControllerSchoolmateGradeType, //校友 年级
    RelationSchoolmateCommonViewControllerSchoolmateAcademicYearType, //校友 学制
    RelationSchoolmateCommonViewControllerSchoolmateMajorType, //校友 专业
    RelationSchoolmateCommonViewControllerSchoolmatePeopleType //校友 人
} RelationSchoolmateCommonViewControllerType ;

typedef enum {
    RelationSchoolmateCommonViewControllerClassmateSelectType,
    RelationSchoolmateCommonViewControllerSchoolmateSelectType
}RelationSchoolmateCommonViewControllerSelectType;

@interface RelationSchoolmateCommonViewController : MedTreeBaseController

@property (nonatomic, assign)RelationSchoolmateCommonViewControllerType type;
@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, strong)NSDictionary *params;

@property (nonatomic, assign)NSInteger totalPeopleNumber;

@end
