//
//  IdentificationController.h
//  medtree
//
//  Created by 无忧 on 14-10-31.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "TableController.h"

@interface IdentificationController : TableController

- (void)setisPerson:(BOOL)sender;
- (void)setDataInfo:(NSArray *)array;
- (void)getCertificationInfo;

@end
