//
//  NSData+EncryptAndDecrypt.h
//  medtree
//
//  Created by 孙晨辉 on 15/7/10.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (EncryptAndDecrypt)

- (NSData *)AES256EncryptWithKey:(NSData *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSData *)key;   //解密
- (NSString *)newStringInBase64FromData;            //追加64编码
+ (NSString*)base64encode:(NSString*)str;           //同上64编码

@end

@interface NSString (HexToBytes)

- (NSData *)hexToBytes;

@end