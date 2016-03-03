//
//  ImageCenter.h
//  TestTable
//
//  Created by sam on 12-12-1.
//  Copyright (c) 2012年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    PhotoSource_Bundle,
    PhotoSource_Path,
    PhotoSource_Named,
    PhotoSource_All
} Photo_Source;

typedef enum
{
    PhotoSize_One   = 1,
    PhotoSize_Two   = 2,
    PhotoSize_Three = 3
} Photo_Size;

@interface ImageCenter : NSObject {
    NSCache *bundleDict;
    NSCache *pathDict;
    NSCache *nameDict;
}

+ (UIImage *)getBundleCatenaImage:(NSString *)imageName;
+ (UIImage *)getBundleImageFromName:(NSString *)name;
+ (UIImage *)getImage:(NSString *)path;
+ (UIImage *)getBundleImage:(NSString *)name;
+ (UIImage *)getNamedImage:(NSString *)name;
+ (UIImage *)getImage:(NSString *)path source:(NSInteger)source;
+ (UIImage *)getImageFromPath:(NSString *)path source:(NSInteger)source;
+ (Photo_Size)getSizeCopies;
+ (NSString *)getCatenaName;

+ (void)changeCatena:(NSString *)catena;
+ (void)releaseImage:(NSString *)path;
+ (void)releaseImages:(NSString *)key source:(NSInteger)source;

@end
