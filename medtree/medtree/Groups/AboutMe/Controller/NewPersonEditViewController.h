//
//  NewPersonEditViewController.h
//  medtree
//
//  Created by 边大朋 on 15-3-30.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "TableController.h"
@class UserDTO;
@interface NewPersonEditViewController : TableController
{
    NSArray             *cellNames;
    NSString            *uploadFile;
}

- (void)setInfo:(UserDTO *)dto;

@end
