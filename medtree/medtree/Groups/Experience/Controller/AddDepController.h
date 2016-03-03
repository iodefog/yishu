//
//  AddDepController.h
//  medtree
//
//  Created by 孙晨辉 on 15/8/5.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"

@protocol AddDepControllerDelegate <NSObject>

- (void)updateInfo:(NSDictionary *)dict;

@end

@interface AddDepController : MedTreeBaseController

@property (nonatomic, weak) id parent;

@property (nonatomic, strong) UIViewController *fromVC;

@property (nonatomic, strong) NSString *depName;

@end
