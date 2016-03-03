//
//  EnumBase.h
//  mcare-model
//
//  Created by sam on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnumBase : NSObject {
    NSInteger value;
    NSString *name;
    NSString *type;
}

@property (nonatomic, readonly) NSInteger value;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *type;

- (id)init:(NSInteger)v with:(NSString *)n type:(NSString *)t;

- (NSArray *)getEnums;
- (EnumBase *)getDefault;
- (EnumBase *)parse:(NSInteger)v;
- (EnumBase *)getType:(NSInteger)t;
- (EnumBase *)getType2:(NSString *)t;
- (EnumBase *)getName:(NSString *)n;

- (NSInteger)getValue;

+ (EnumBase *)sharedInstance;
- (NSDictionary *)JSON;

@end
