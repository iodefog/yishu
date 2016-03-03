//
//  CoreLabelDelegate.h
//
//  Created by sam on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CoreLabelDelegate

@optional

- (void)clickURL:(NSString *)url;
- (void)clickText:(NSString *)text;
- (void)clickTextView:(id)view;

@end

