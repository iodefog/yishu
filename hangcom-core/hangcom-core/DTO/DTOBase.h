//
//  DTOBase.h
//  mcare-core
//
//  Created by sam on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTOBase : NSObject {
    NSMutableDictionary *rawInfo;
}

@property (nonatomic, assign) CGFloat cellHeight;

- (id)init:(NSDictionary *)dict;
- (BOOL)parse:(NSDictionary *)dict;
- (BOOL)parse2:(NSDictionary *)result;
- (NSDictionary *)JSON;
- (void)setJSON:(NSDictionary *)JSON;


- (NSDate *)getDateValue:(id)date;
- (BOOL)getBoolValue:(NSNumber *)num;
- (double)getDoubleValue:(NSNumber *)num;
- (NSInteger)getIntValue:(NSNumber *)num;
- (float)getFloatValue:(NSNumber *)num;
- (NSString *)getStrValue:(NSString *)str;
- (NSArray *)getArrayValue:(NSArray *)arr;
- (NSString *)toParam;

- (void)updateInfo:(NSObject *)obj forKey:(NSString *)key;

@end
