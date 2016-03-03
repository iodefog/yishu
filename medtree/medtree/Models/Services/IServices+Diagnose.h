//
//  IServices+Diagnose.h
//  medtree
//
//  Created by 无忧 on 14-9-14.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Diagnose)

+ (void)sendDiagnose:(NSDictionary *)param;

@end
