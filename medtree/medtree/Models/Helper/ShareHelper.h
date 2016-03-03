//
//  ShareHelper.h
//  medtree
//
//  Created by sam on 1/22/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareHelper : NSObject

+ (void)registerApps;
+ (NSString *)getWeixinID;
+ (NSString *)getMedTreeID;
+ (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication source:(id)source;

@end
