//
//  ImageCenter.m
//  TestTable
//
//  Created by sam on 12-12-1.
//  Copyright (c) 2012年 sam. All rights reserved.
//

#import "ImageCenter.h"

@implementation ImageCenter

+ (UIImage *)getImage:(NSString *)path
{
    return [ImageCenter getImage:path source:PhotoSource_Path];
}

+ (UIImage *)getBundleImage:(NSString *)name
{
    return [ImageCenter getImage:name source:PhotoSource_Bundle];
}

+ (UIImage *)getBundleCatenaImage:(NSString *)imageName
{
    return [ImageCenter getImage:[NSString stringWithFormat:@"%@_%@",[self getCatenaName],imageName] source:PhotoSource_Bundle];
}

+ (UIImage *)getNamedImage:(NSString *)name
{
    return [ImageCenter getImage:name source:PhotoSource_Named];
}

+ (UIImage *)getBundleImageFromName:(NSString *)name
{
    return [self getImage:name source:PhotoSource_Bundle];
}

+ (UIImage *)getImage:(NSString *)path source:(NSInteger)source
{
    NSCache *dict = [[ImageCenter shareInstance] getImageDict:source];
    UIImage *image = [dict objectForKey:path];
    if (image == nil) {
        image = [ImageCenter getImageFromPath:path source:source];
        if (image != nil && path != nil) {
            [dict setObject:image forKey:path];
        }
    }
    return image;
}

+ (void)releaseImage:(NSString *)path
{
    for (int i=0; i<PhotoSource_All; i++) {
        [[[ImageCenter shareInstance] getImageDict:i] removeObjectForKey:path];
    }
}

+ (void)releaseImages:(NSString *)key source:(NSInteger)source
{
    if (source == PhotoSource_All) {
        for (int i=0; i<PhotoSource_All; i++) {
            [[[ImageCenter shareInstance] getImageDict:i] removeAllObjects];
        }
    } else {
        [[[ImageCenter shareInstance] getImageDict:source] removeAllObjects];
    }
}

+ (UIImage *)getImageFromPath:(NSString *)path
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc] initWithData:data];
    return image;
}

Photo_Size  photoSize;

+ (void)setPhotoSize:(Photo_Size)size
{
    photoSize = size;
}

+ (Photo_Size)getSizeCopies
{
    return photoSize;
}

+ (UIImage *)getImageFromPath:(NSString *)path size:(Photo_Size)size
{
    NSRange range = [path rangeOfString:@"." options:NSBackwardsSearch];
    NSString *newPath;
    if (range.location != NSNotFound && size > PhotoSize_One) {
        NSString *path2 = [NSString stringWithFormat:@"%@@%dx.%@", [path substringToIndex:range.location], size, [path substringFromIndex:range.location+1]];
        newPath = [[NSBundle mainBundle] pathForResource:path2 ofType:nil];
    } else {
        newPath = [[NSBundle mainBundle] pathForResource:path ofType:nil];
    }
    UIImage *image = [ImageCenter getImageFromPath:newPath];
    return image;
}

+ (UIImage *)getImageFromPath:(NSString *)path source:(NSInteger)source
{
    UIImage *image = nil;
    if (path == nil || path.length == 0) {
        
    } else if (source == PhotoSource_Path) {
        image = [ImageCenter getImageFromPath:path];
    } else if (source == PhotoSource_Bundle) {
        switch (photoSize) {
            case PhotoSize_Three: {
                image = [ImageCenter getImageFromPath:path size:PhotoSize_Three];
                if (image != nil) {
                    break;
                }
            }
            case PhotoSize_Two: {
                image = [ImageCenter getImageFromPath:path size:PhotoSize_Two];
                if (image != nil) {
                    break;
                }
            }
            default: {
                image = [ImageCenter getImageFromPath:path size:PhotoSize_One];
            }
        }
    } else {
        image = [UIImage imageNamed:path];
    }
    return image;
}

+ (ImageCenter *)shareInstance
{
    static ImageCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[ImageCenter alloc] init];
            NSLog(@"%f", [[UIScreen mainScreen] scale]);
            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                [ImageCenter setPhotoSize:[[UIScreen mainScreen] scale]];
            } else {
                [ImageCenter setPhotoSize:PhotoSize_One];
            }
        }
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        nameDict = [[NSCache alloc] init];
        pathDict = [[NSCache alloc] init];
        bundleDict = [[NSCache alloc] init];
    }
    return self;
}

- (NSCache *)getImageDict:(NSInteger)source
{
    NSCache *dict = nil;
    if (source == PhotoSource_Bundle) {
        dict = bundleDict;
    } else if (source == PhotoSource_Named) {
        dict = nameDict;
    } else if (source == PhotoSource_Path) {
        dict = pathDict;
    }
    return dict;
}

+ (void)changeCatena:(NSString *)catena
{
    [[NSUserDefaults standardUserDefaults] setObject:catena forKey:@"catenaName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCatenaName
{
    NSString *catenaName = [[NSUserDefaults standardUserDefaults] objectForKey:@"catenaName"];
    if (catenaName == nil || (NSObject *)catenaName == [NSNull null]) {
        catenaName = @"NO0";
        [[NSUserDefaults standardUserDefaults] setObject:catenaName forKey:@"catenaName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return catenaName;
}

@end
