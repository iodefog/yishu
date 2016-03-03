//
//  HomeJobChannelIntersetViewController.h
//  medtree
//
//  Created by tangshimi on 10/21/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MedBaseTableViewController.h"

typedef void(^HomeJobChannelIntersetViewControllerCompleteBlock)(NSString *, NSString *, NSString *);
typedef void(^HomeJobChannelIntersetViewControllerSureBlock)(NSDictionary *);

typedef NS_ENUM(NSInteger, HomeJobChannelIntersetViewControllerType) {
    HomeJobChannelIntersetViewControllerTypeFirstChoseInterest,
    HomeJobChannelIntersetViewControllerTypeChoseInterest,
    HomeJobChannelIntersetViewControllerTypeUnitFilter,
    HomeJobChannelIntersetViewControllerTypeEmploymentFilter,
    HomeJobChannelIntersetViewControllerTypeFunctionLevelOneMultiSelection,
    HomeJobChannelIntersetViewControllerTypeFunctionLevelOneSingleSelection,
    HomeJobChannelIntersetViewControllerTypeProfessionalQualifications, //职称要求
    HomeJobChannelIntersetViewControllerTypeEmploymentFilterFromWeb,
};

@interface HomeJobChannelIntersetViewController : MedBaseTableViewController

@property (nonatomic, assign) HomeJobChannelIntersetViewControllerType type;
@property (nonatomic, copy) dispatch_block_t updateBlock;
@property (nonatomic, copy) dispatch_block_t closeBlock;
@property (nonatomic, copy) HomeJobChannelIntersetViewControllerCompleteBlock completeBlock;
@property (nonatomic, copy) HomeJobChannelIntersetViewControllerSureBlock sureBlock;

@property (nonatomic, assign) NSInteger selectedProfessionalQualifiactionsIndex;
@property (nonatomic, copy) NSString *selectedProfessionalQualifiactionsString;

@property (nonatomic, copy) NSString *selectedFunctionLevelOneString;
@property (nonatomic, copy) NSString *selectedFunctionLevelTwoString;

@end
