//
//  HomeJobChannelInterestDetialViewController.h
//  medtree
//
//  Created by tangshimi on 10/21/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MedBaseTableViewController.h"

typedef void(^HomeJobChannelInterestDetialViewControllerCompleteBlock)(NSString *, NSArray*);

typedef NS_ENUM(NSInteger, HomeJobChannelInterestDetialViewControllerType) {
    HomeJobChannelInterestDetialViewControllerTypeRegionMultiSelection, //所属地区多选
    HomeJobChannelInterestDetialViewControllerTypeRegionSingalSelection, //所属地区单选
    HomeJobChannelInterestDetialViewControllerTypeFunctionLevelTwoMultiSelection, //职能类别2级 多选
    HomeJobChannelInterestDetialViewControllerTypeFunctionLevelTwoSingalSelection, //职能能别2级 单选
    HomeJobChannelInterestDetialViewControllerTypeEducation, //学历要求
    HomeJobChannelInterestDetialViewControllerTypeWorkExperience, //工作经验
    HomeJobChannelInterestDetialViewControllerTypeUnitNatureSingalSelection, //单位性质
    HomeJobChannelInterestDetialViewControllerTypeUnitNatureMultiSelection,// 单位规模多选
    HomeJobChannelInterestDetialViewControllerTypeUnitSize, //单位规模
    HomeJobChannelInterestDetialViewControllerTypeUnitLevel, //单位级别
    HomeJobChannelInterestDetialViewControllerTypePublishTime, //发布时间
    HomeJobChannelInterestDetialViewControllerTypeSalary, //月薪范围
    HomeJobChannelInterestDetialViewControllerTypeProfessionalQualifications, //职称要求
};

@interface HomeJobChannelInterestDetialViewController : MedBaseTableViewController

@property (nonatomic, assign) HomeJobChannelInterestDetialViewControllerType type;

@property (nonatomic, copy) NSArray *titleArray;

@property (nonatomic, assign) NSInteger functionLevelOneID;

@property (nonatomic, copy) HomeJobChannelInterestDetialViewControllerCompleteBlock completeBlock;

@property (nonatomic, copy) NSArray *selectedIndexArray;

@property (nonatomic, assign) NSInteger lastLevelIndex; //上一级选择的下标

@property (nonatomic, copy) NSString *selectedProvinceString;

@property (nonatomic, copy) NSString *selectedFunctionLevelTwoString;

@end
