//
//  MessageBody.m
//  jiayi-common
//
//  Created by sam on 6/5/15.
//  Copyright (c) 2015 孙晨辉. All rights reserved.
//

#import "MessageBody.h"
#import "MessageBase.h"
#import "Messages.h"
#import "IMUtil.h"
#import "NSData+EncryptAndDecrypt.h"
#import "Base64.h"
#import "Keychain.h"


//#define OrigPassWord @"medtree-im-passwmedtree-im-passw"
#define OrigPassWord @"medtree-im-passw"

@implementation MessageBody

+ (NSData *)encode:(MessageBody *)msg
{
    NSMutableData *data = [NSMutableData data];
    if (msg) {
        NSInteger ver = CFSwapInt16BigToHost(1);
        NSInteger type = CFSwapInt16BigToHost((u_int16_t)msg.type);
        NSData *encodeData = nil;
        
#ifdef IM_ENCRYPT
        // AES对内容部分加密
        NSData *dataBytes = nil;

#ifndef IM_ENCRYPT_DYNCMIC
        
        dataBytes = [OrigPassWord dataUsingEncoding:NSUTF8StringEncoding];
        Byte *myByte = (Byte *)[dataBytes bytes];
        NSData *keyData = [[NSData alloc] initWithBytes:myByte length:32];
        encodeData = [msg.data AES256EncryptWithKey:keyData];

#else
        if (msg.type == AUTH_REQUEST) { // auth授权，获取aes密码
            dataBytes = [OrigPassWord dataUsingEncoding:NSUTF8StringEncoding];
            Byte *myByte = (Byte *)[dataBytes bytes];
            NSData *keyData = [[NSData alloc] initWithBytes:myByte length:32];
            encodeData = [msg.data AES256EncryptWithKey:keyData];
        } else {
            NSString *pwd = [Keychain getValue:@"password"];
            if (pwd.length > 0) {
                dataBytes = [pwd base64DecodedData];
                encodeData = [msg.data AES256EncryptWithKey:dataBytes];
            } else {
                return nil;
            }
        }
#endif
        
#else
        encodeData = msg.data;
#endif
        NSInteger length = CFSwapInt32BigToHost((u_int32_t)[encodeData length]);
        
        [data appendBytes:&ver length:2];
        [data appendBytes:&type length:2];
        [data appendBytes:&length length:4];
        [data appendData:encodeData];
    } else {
        data = nil;
    }
    return data;
}

+ (MessageBody *)decode:(NSData *)data
{
    MessageBody *msg = nil;
    if (data.length > 8) {
        msg = [[MessageBody alloc] init];
        //
        NSInteger type = 0;
        [data getBytes:&type range:NSMakeRange(2, 2)];
        type = CFSwapInt16HostToBig((u_int16_t)type);
        msg.type = type;
        //
        NSInteger length = 0;
        [data getBytes:&length range:NSMakeRange(4, 4)];
        length = CFSwapInt32HostToBig((u_int32_t)length);
        msg.length = length;
        //
        NSLog(@"length = %ld, data.length = %ld", (long)length, (long)data.length);
        
        if (length + 8 <= data.length) {
            NSData *decodeData = [data subdataWithRange:NSMakeRange(8, length)];
#ifdef IM_ENCRYPT
            
            NSData *dataBytes = nil;

#ifndef IM_ENCRYPT_DYNCMIC

            dataBytes = [OrigPassWord dataUsingEncoding:NSUTF8StringEncoding];
            Byte *myByte = (Byte *)[dataBytes bytes];
            NSData *keyData = [[NSData alloc] initWithBytes:myByte length:32];
            msg.data = [decodeData AES256DecryptWithKey:keyData];
            
#else
            // AES对内容解密
            /*
            if (type == AUTH_RESPONSE) { // auth授权返回数据解密
                dataBytes = [OrigPassWord dataUsingEncoding:NSUTF8StringEncoding];
                Byte *myByte = (Byte *)[dataBytes bytes];
                NSData *keyData = [[NSData alloc] initWithBytes:myByte length:32];
                msg.data = [decodeData AES256DecryptWithKey:keyData];
            } else {
//                NSString *pwd = OrigPassWord;
                NSString *pwd = [Keychain getValue:@"im_token"];
                if (pwd.length > 0) {
                    dataBytes = [pwd base64DecodedData];
                    msg.data = [decodeData AES256DecryptWithKey:dataBytes];
                } else {
                    return nil;
                }
            }
             */
            
            NSString *pwd = [Keychain getValue:@"password"];
            if (pwd.length > 0) {
                dataBytes = [pwd base64DecodedData];
                msg.data = [decodeData AES256DecryptWithKey:dataBytes];
            } else {
                return nil;
            }
            NSLog(@"msg.data ------- %@", [[NSString alloc] initWithData:msg.data encoding:NSUTF8StringEncoding]);
#endif
            
#else
            msg.data = decodeData;
#endif
        } else { // 包的拆分
            msg = nil;
//            NSLog(@"msg.data - %@", [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(8, data.length-8)] encoding:NSUTF8StringEncoding]);
        }
    }
    return msg;
}

+ (NSInteger)getType:(NSData *)data
{
    NSInteger type = 0;
    if (data.length > 8) {
        [data getBytes:&type range:NSMakeRange(2, 2)];
        type = CFSwapInt16HostToBig((u_int16_t)type);
    }
    return type;
}

@end
