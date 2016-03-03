//
//  MyCollectPositionDTO.h
//  medtree
//
//  Created by jiangmm on 15/11/30.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface MyCollectPositionDTO : DTOBase

@property (nonatomic, copy) NSString *employmentID;
@property (nonatomic, copy) NSString *employmentTitle;
@property (nonatomic, copy) NSString *enterpriseID;
@property (nonatomic, copy) NSString *enterpriseName;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *educationRequirements;
@property (nonatomic, copy) NSString *enterprisePlace;
@property (nonatomic, copy) NSString *enterpriseNature;
@property (nonatomic, copy) NSString *enterpriseLevel;
@property (nonatomic, copy) NSString *enterpriseSize;
@property (nonatomic, assign) NSInteger salaryID;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *employmentURL;
@property (nonatomic, assign) BOOL isFromWeb;
@property (nonatomic, strong) NSString *publishTime;


@end
