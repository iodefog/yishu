//
//  FeaturedManager.h
//  medtree
//
//  Created by 陈升军 on 15/4/1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DataManager.h"

@interface FeaturedManager : DataManager

typedef enum {
    MethodType_Featured_Start                      = 9000,
    MethodType_Featured_GetFeatured                = 9001,
    MethodType_Featured_End                        = 9999,
} Method_Featured;

@end

