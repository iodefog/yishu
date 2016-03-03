//
//  CognitionPeopleController.h
//  medtree
//
//  Created by 陈升军 on 15/3/30.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MedBaseTableViewController.h"

typedef void(^CognitionPeopleControllerUpdateBlock)(NSInteger);

@interface CognitionPeopleController : MedBaseTableViewController
{

}

@property (nonatomic, copy) CognitionPeopleControllerUpdateBlock updateBlock;

@end
