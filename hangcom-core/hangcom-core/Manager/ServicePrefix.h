//
//  ServicePrefix.h
//  hangcom-core
//
//  Created by sam on 11/7/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(id JSON);
typedef void (^FailureBlock)(NSError *error, id JSON);

@interface ServicePrefix : NSObject

@end
