//
//  ImagePicker.h
//  medtree
//
//  Created by sam on 9/4/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImagePickerDelegate <NSObject>

- (void)didSavePhoto:(NSDictionary *)userInfo;

@end
@interface ImagePicker : NSObject <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {

    UIViewController            *parent;
    id <ImagePickerDelegate>    delegate;
    NSMutableDictionary         *userInfo;
    NSString                    *uploadFile;
    BOOL                        isAllowsEditing;
}

+ (void)showSheet:(NSDictionary *)dict uvc:(UIViewController *)uvc delegate:(id <ImagePickerDelegate>)dele;
+ (void)showAlbum:(NSDictionary *)dict uvc:(UIViewController *)uvc delegate:(id <ImagePickerDelegate>)dele;
+ (void)showCamera:(NSDictionary *)dict uvc:(UIViewController *)uvc delegate:(id <ImagePickerDelegate>)dele;
+ (void)setAllowsEditing:(BOOL)tf;
//- (void)setInfo:(NSDictionary *)dict uvc:(UIViewController *)uvc delegate:(id <ImagePickerDelegate>)dele;
+ (void)changeImagePathOld:(NSString *)old new:(NSString *)new;
@end
