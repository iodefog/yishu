//
//  HomeJobChannelSearchViewController.h
//  medtree
//
//  Created by tangshimi on 10/26/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MedBaseTableViewController.h"

typedef NS_ENUM(NSInteger, HomeJobChannelUnitAndEmploymentSearchViewControllerType) {
    HomeJobChannelUnitAndEmploymentSearchViewControllerTypeUnit,
    HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmployment,
    HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmploymentFromWeb,
    HomeJobChannelUnitAndEmploymentSearchViewControllerTypeAll
};

@interface HomeJobChannelUnitAndEmploymentSearchViewController : MedBaseTableViewController

@property (nonatomic, assign) HomeJobChannelUnitAndEmploymentSearchViewControllerType type;

//网页进入，一个企业的在招职位
@property (nonatomic, copy) NSString *enterpriseID;

@end
