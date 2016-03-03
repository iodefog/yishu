//
//  ExperienceDetailController.h
//  medtree
//
//  Created by 陈升军 on 15/6/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseController.h"
#import "ExperienceDTO.h"

@class ExperienceDTO;
@class UserDTO;

typedef NS_ENUM(NSUInteger, ExperienceDetailControllerComeFrom) {
    ExperienceDetailControllerComeFrom_Default = 1,
    ExperienceDetailControllerComeFrom_Resume
};

@protocol ExperienceDetailControllerDelegate <NSObject>

- (void)reloadParent:(UserDTO *)dto;

@end

@interface ExperienceDetailController : BaseController

@property (nonatomic, weak) id <ExperienceDetailControllerDelegate> parent;

@property (nonatomic, strong) NSString *actionType;
@property (nonatomic, assign) NSInteger parentCellIndex;

@property (nonatomic, copy) void(^dismissBlock)(NSDictionary *dict);
/** 经历类型 */
@property (nonatomic, assign) ExperienceType experienceType;
@property (nonatomic, strong) ExperienceDTO *experienceDto;
@property (nonatomic, assign) ExperienceDetailControllerComeFrom comeFrom;
- (void)updateInfo:(NSDictionary *)dict;

@end
