//
//  MessageBody.h
//  jiayi-common
//
//  Created by sam on 6/5/15.
//  Copyright (c) 2015 孙晨辉. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IM_ENCRYPT
#define IM_ENCRYPT_DYNCMIC

@interface MessageBody : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, strong) NSData    *data;

+ (NSData *)encode:(MessageBody *)msg;
+ (MessageBody *)decode:(NSData *)data;
+ (NSInteger)getType:(NSData *)data;

@end
