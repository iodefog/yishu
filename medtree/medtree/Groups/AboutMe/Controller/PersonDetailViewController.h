//
//  PersonDetailViewController.h
//  medtree
//
//  Created by 边大朋 on 15/12/2.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "TableController.h"

@class UserDTO;

@interface PersonDetailViewController : TableController

@property (nonatomic, strong) UserDTO *udto;
@property (nonatomic, strong) NSString *userID;
@end
