//
//  ImagePicker.m
//  medtree
//
//  Created by sam on 9/4/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "ImagePicker.h"
#import "FileUtil.h"

@implementation ImagePicker

+ (ImagePicker *)sharedInstance
{
    static ImagePicker *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImagePicker alloc] init];
    });
    return sharedInstance;
}

+ (void)showAlbum:(NSDictionary *)dict uvc:(UIViewController *)uvc delegate:(id <ImagePickerDelegate>)dele
{
    [[ImagePicker sharedInstance] setInfo:dict uvc:uvc delegate:dele];
    [[ImagePicker sharedInstance] showAlbum];
}

+ (void)showCamera:(NSDictionary *)dict uvc:(UIViewController *)uvc delegate:(id <ImagePickerDelegate>)dele
{
    [[ImagePicker sharedInstance] setInfo:dict uvc:uvc delegate:dele];
    [[ImagePicker sharedInstance] showCamera];
}

+ (void)showSheet:(NSDictionary *)dict uvc:(UIViewController *)uvc delegate:(id <ImagePickerDelegate>)dele
{
    [[ImagePicker sharedInstance] setInfo:dict uvc:uvc delegate:dele];
    [[ImagePicker sharedInstance] showSheet];
}

+ (void)setAllowsEditing:(BOOL)tf
{
    [[ImagePicker sharedInstance] setAllowsEditing:tf];
}

- (void)setAllowsEditing:(BOOL)tf
{
    isAllowsEditing = tf;
}

- (void)setInfo:(NSDictionary *)dict uvc:(UIViewController *)uvc delegate:(id <ImagePickerDelegate>)dele
{
    if (userInfo == nil) {
        userInfo = [[NSMutableDictionary alloc] init];
    }
    [userInfo removeAllObjects];
    [userInfo addEntriesFromDictionary:dict];
    uploadFile = nil;
    //
    parent = uvc;
    delegate = dele;
}

/*显示actionSheet*/
- (void)showSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"拍照"
                                  otherButtonTitles:@"从图片库选", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:((UIViewController *)parent).view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self showCamera];
    } else if (buttonIndex == 1) {
        [self showAlbum];
    }
}

/*显示相机*/
- (void)showCamera
{
    //检查相机模式是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"sorry, no camera or camera is unavailable.");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您的设备不支持拍照" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
    } else {
        //创建图像选取控制器
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        //设置图像选取控制器的来源模式为相机模式
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //显示功能控制栏
        imagePickerController.showsCameraControls = YES;
        //设置默认摄像头
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //允许用户进行编辑
        imagePickerController.allowsEditing = isAllowsEditing;
        //设置委托对象
        imagePickerController.delegate = self;
        //以模视图控制器的形式显示
        [parent presentViewController:imagePickerController animated:YES completion:nil];
    }
}

/*显示相册*/
- (void)showAlbum
{
    //创建图像选取控制器
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //允许用户进行编辑
    imagePickerController.allowsEditing = isAllowsEditing;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [parent presentViewController:imagePickerController animated:YES completion:nil];
}

- (UIImage *)getImage:(NSDictionary *)info
{
    UIImage *photo = [info objectForKey:UIImagePickerControllerEditedImage];
    if (photo == nil) {
        photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    return photo;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //打印出字典中的内容
    NSDictionary *dict = nil;
    UIImage *photo = [self getImage:info];
    CGFloat min = MIN(photo.size.width, photo.size.height);
    NSLog(@"src info: (%f %f)", photo.size.width, photo.size.height);
    //
    if (min > 640) {
        CGFloat bei = min/640;
        photo = [self imageWithImage:photo scaledToSize:CGSizeMake(photo.size.width/bei, photo.size.height/bei)];
        UIImage *represent = [UIImage imageWithData:UIImageJPEGRepresentation(photo, 1)];
        NSLog(@"dst info: (%f %f)", represent.size.width, represent.size.height);
        uploadFile = [self saveImage:represent];
        dict = @{@"file": uploadFile, @"image": represent};
    } else {
        uploadFile = [self saveImage:photo];
        dict = @{@"file": uploadFile, @"image": photo};
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [delegate didSavePhoto:dict];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

/*保存图片*/
- (NSString *)saveImage:(UIImage *)image
{
    NSString *path = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *name = [NSString stringWithFormat:@"%@.jpg", [userInfo objectForKey:@"name"]];
    path = [[FileUtil getPicPath] stringByAppendingPathComponent:name];
    if ([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:nil];
    }
    [fm createFileAtPath:path contents:UIImageJPEGRepresentation(image, 0.6) attributes:nil];
    NSLog(@"path=%@", path);
    return path;
}

/** 更换图片地址 */
+ (void)changeImagePathOld:(NSString *)oldPath new:(NSString *)newPath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    [fm moveItemAtPath:oldPath toPath:newPath error:&error];
    if (error) {
        NSLog(@"change error --- %@", error.localizedDescription);
    }
}

/*清空提交完毕的混存文件*/
- (void)cleanImages
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *files = [fm subpathsAtPath:[FileUtil getPicPath]];
    
    for (NSInteger i = 0; i < files.count; i++) {
        NSString *filePath = [[FileUtil getPicPath] stringByAppendingPathComponent:[files objectAtIndex:i]];
        [fm removeItemAtPath:filePath error:nil];
    }
    //
    uploadFile = nil;
}

@end
