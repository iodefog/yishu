//
//  Global.h
//  find
//
//  Created by sam on 13-5-13.
//  Copyright (c) 2013年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ImageType_Small     = 1,
    ImageType_Big       = 2,
    ImageType_Orig      = 3,
    ImageType_Map       = 4,
    ImageType_200_150   = 5,
    ImageType_224_168   = 6,
    ImageType_Config    = 7,
    ImageType_120_90    = 8,
} Image_Type;

extern NSString *const TESTENVIRONMENT;

@interface MedGlobal : NSObject

+ (CGFloat)getSysVer;
+ (CGFloat)getOffset;
/** 12字号 */
+ (UIFont *)getTinyLittleFont;
/** 10字号 */
+ (UIFont *)getTinyLittleFont_10;
/** 14字号 */
+ (UIFont *)getLittleFont;
/** 16字号 */
+ (UIFont *)getMiddleFont;
/** 18字号 */
+ (UIFont *)getLargeFont;
/** 18粗体字号 */
+ (UIFont *)getBoldLargeFont;
+ (NSString *)getHost;
+ (NSString *)getHost0;
+ (NSString *)getCollectHost;
+ (NSString *)getJobUrl;
+ (BOOL)checkNetworkStatus;
+ (NSString *)getPicHost:(Image_Type)type;
+ (NSString *)getVoiceHostWithCompacted:(BOOL)compacted;
+ (void)setPicHost:(NSString *)host;
+ (void)setSplashImages:(NSArray *)array;
+ (NSArray *)getSplashImages;


+ (UIColor *)getNameLableTextCommonColor;
+ (UIColor *)getTitleTextCommonColor;
+ (void)checkBigPhone;
+ (NSString *)getPhone;

+ (BOOL)isBigPhone;
+ (BOOL)isPhone6Plus;
+ (UIFont *)getMiddleLittleFont;

/* GCD QUEUE */
+ (void)initQueue;
+ (dispatch_queue_t)getDbQueue;
+ (dispatch_queue_t)getNetQueue;

@end
