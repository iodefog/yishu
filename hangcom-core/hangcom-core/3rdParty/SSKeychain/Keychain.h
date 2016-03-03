//
//  Keychain.h
//  hangcom-core
//
//  Created by lyuan on 14-6-10.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keychain : NSObject

+ (void)setValue:(NSString *)value key:(NSString *)key;
+ (NSString *)getValue:(NSString *)key;

@end
