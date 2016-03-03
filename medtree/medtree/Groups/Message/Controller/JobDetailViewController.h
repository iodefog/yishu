//
//  JobDetailViewController.h
//  medtree
//
//  Created by 孙晨辉 on 15/10/21.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"

@interface JobDetailViewController : MedTreeBaseController 

@property (nonatomic, strong) NSString *organization;
@property (nonatomic, strong) NSString *positionId;

@property (nonatomic, strong) NSString *imageID;
@property (nonatomic, strong) NSString *shareInfo;

@end