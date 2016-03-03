//
//  RegisterAddNewController.h
//  medtree
//
//  Created by 无忧 on 14-11-7.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"

typedef NS_ENUM(NSUInteger, EditUserInfoType) {
    EditUserInfoType_Interest = 1,
    EditUserInfoType_Honour,
    EditUserInfoType_Introduce
};

@protocol RegisterAddNewControllerDelegate <NSObject>
- (void)updateInfo:(NSDictionary *)dict;
@end

@interface RegisterAddNewController : MedTreeBaseController

@property (nonatomic, assign) id<RegisterAddNewControllerDelegate> parent;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) EditUserInfoType infoType;

@end
