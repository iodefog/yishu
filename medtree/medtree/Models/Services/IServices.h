//
//  IServices.h
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

@interface IServices : NSObject

/*header*/
+ (NSDictionary *)getLoginHeader;
+ (NSDictionary *)getLoginBody:(NSString *)account password:(NSString *)password;

@end
