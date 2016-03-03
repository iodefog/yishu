//
//  RegisterSelectTimeController.h
//  medtree
//
//  Created by 无忧 on 14-11-6.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"

@protocol RegisterSelectTimeControllerDelegate <NSObject>

- (void)updateTime:(NSDictionary *)dict;

@end

@interface RegisterSelectTimeController : MedTreeBaseController

@property (nonatomic, assign) id<RegisterSelectTimeControllerDelegate> parent;

@property (nonatomic, assign) NSInteger orgType;
@property (nonatomic, assign) NSInteger experienceType;
@property (nonatomic, assign) NSInteger userType;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
/** 生日 */
@property (nonatomic, assign) NSInteger birthday;

@end
