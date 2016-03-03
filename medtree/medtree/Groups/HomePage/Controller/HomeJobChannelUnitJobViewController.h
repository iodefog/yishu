//
//  HomeJobChannelUnitJobViewController.h
//  medtree
//
//  Created by tangshimi on 11/2/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MedTreeBaseController.h"
@class HomeJobChannelEmploymentDTO;

@interface HomeJobChannelUnitJobViewController : MedTreeBaseController

@property (nonatomic, strong) HomeJobChannelEmploymentDTO *employmentDTO;

@property (nonatomic, copy) NSString *employmentID;

@end
