//
//  JobManager.h
//  medtree
//
//  Created by 孙晨辉 on 15/11/3.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "DataManager.h"

typedef NS_ENUM(NSUInteger, MethodTypeJob) {
    MethodTypeJobDeliverys = 8000,
//    MethodTypeJobDeliveryDetail,
};

@interface JobManager : DataManager

@end
