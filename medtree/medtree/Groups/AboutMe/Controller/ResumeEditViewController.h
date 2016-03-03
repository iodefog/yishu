//
//  ResumeEditViewController.h
//  medtree
//
//  Created by 孙晨辉 on 15/11/10.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "TableController.h"
#import "ResumeDTO.h"
#import "GenderTypes.h"

@protocol ResumeEditViewControllerDelegate <NSObject>

- (void)updateType:(ResumeRowType)type key:(NSUInteger)key index:(NSIndexPath *)index;
- (void)updateType:(ResumeRowType)type value:(NSString *)value index:(NSIndexPath *)index;

@end

@interface ResumeEditViewController : TableController

@property (nonatomic, strong) NSString              *resumeId;
@property (nonatomic, assign) ResumeRowType         editType;
@property (nonatomic, strong) NSString              *naviTitle;
@property (nonatomic, assign) Gender_Types          genderType;
@property (nonatomic, assign) BOOL                  netRequest;
@property (nonatomic, strong) NSString              *value;
@property (nonatomic, assign) WorkExperienceType    workType;
@property (nonatomic, strong) NSDate                *birthday;
@property (nonatomic, assign) id<ResumeEditViewControllerDelegate> delegate;
@property (nonatomic, strong) NSIndexPath           *index;

@end
