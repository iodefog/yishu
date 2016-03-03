//
//  QRCardController.m
//  medtree
//
//  Created by 无忧 on 14-12-3.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "QRCardController.h"
#import "InfoAlertView.h"

#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>
#import "ZXingObjC.h"

@interface QRCardController () <AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>
{
    UIView                    *headerView;
    UIView                    *leftView;
    UIView                    *rightView;
    UIView                    *footView;
    UIImageView               *topImage;
    UIButton                  *myCard;
    UIButton                  *cancelButton;
    UIButton                  *albumButton;
    
    BOOL                      isHave;
}

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation QRCardController

- (void)createUI
{
    [super createUI];
    
    statusBar.hidden = YES;
    naviBar.hidden = YES;
    isHave = NO;

    headerView = [[UIView alloc] init];
    headerView.alpha = 0.6;
    headerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:headerView];
    
    footView = [[UIView alloc] init];
    footView.alpha = 0.6;
    footView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:footView];
    
    leftView = [[UIView alloc] init];
    leftView.alpha = 0.6;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    rightView = [[UIView alloc] init];
    rightView.alpha = 0.6;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_read_top.png"]];
    [self.view addSubview:topImage];
    
    myCard = [UIButton buttonWithType:UIButtonTypeCustom];
    [myCard setTitle:@"我的二维码" forState:UIControlStateNormal];
    [myCard addTarget:self action:@selector(clickMyCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myCard];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [albumButton setTitle:@"相册" forState:UIControlStateNormal];
    [albumButton addTarget:self action:@selector(clickAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:albumButton];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.frame.size;
    
    if (size.height > 480) {
        headerView.frame = CGRectMake(0, 0, size.width, (size.height-300)/2);
        footView.frame = CGRectMake(0, size.height-(size.height-300)/2, size.width, (size.height-300)/2);
        myCard.frame = CGRectMake(100, size.height-110, size.width-200, 30);
        topImage.frame = CGRectMake((size.width-300)/2, (size.height-300)/2, 300, 300);
        leftView.frame = CGRectMake(0, (size.height-300)/2, (size.width-300)/2, 300);
        rightView.frame = CGRectMake(size.width-(size.width-300)/2, (size.height-300)/2, (size.width-300)/2, 300);
    } else {
        headerView.frame = CGRectMake(0, 0, size.width, (size.height-300)/2-20);
        footView.frame = CGRectMake(0, size.height-(size.height-300)/2-20, size.width, (size.height-300)/2+20);
        leftView.frame = CGRectMake(0, (size.height-300)/2-20, (size.width-300)/2, 300);
        rightView.frame = CGRectMake(size.width-(size.width-300)/2, (size.height-300)/2-20, (size.width-300)/2, 300);
        topImage.frame = CGRectMake((size.width-300)/2, (size.height-300)/2-20, 300, 300);
        myCard.frame = CGRectMake(100, size.height-90, size.width-200, 30);
    }
    
    cancelButton.frame = CGRectMake(40, size.height-60, 100, 40);
    albumButton.frame = CGRectMake(size.width-140, size.height-60, 100, 40);
}

- (void)startQRCard
{
    // 1.实例化拍摄设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 2.设置输入设备
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    NSLog(@"error --- %@", error);
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:error.userInfo[@"NSLocalizedFailureReason"]
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    // 3.设置元数据输出
    // 3.1实例化拍摄元数据输出
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 3.2 设置输出数据代理(queue:主线程，子线程都可以)
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 4. 添加拍摄会话
    // 4.1 实例化拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    // 4.2 添加会话输入
    [session addInput:input];
    // 4.3 添加会话输出
    [session addOutput:output];
    // 4.4 设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    self.session = session;
    
    // 5. 视频预览图层
    // 5.1 实例化预览图层
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.frame;
    // 5.2 将图层插入当前视图
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
    self.previewLayer = previewLayer;
    
    // 6. 启动会话
    [self.session startRunning];
}

- (void)setQRCode:(NSString *)code
{
    if (isHave) {
        return;
    }
    [self.parent setQRCode:code];
    [self dismissViewControllerAnimated:YES completion:nil];
    isHave = YES;
}

- (void)showInfoAlert:(NSString *)info
{
    [InfoAlertView showInfo:info inView:self.view duration:1];
    [self performSelector:@selector(clickCancel) withObject:nil afterDelay:1];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 会频繁的扫描，调用此代理方法
    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    // 2. 删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    // 3. 设置界面显示扫描结果
    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *obj = [metadataObjects firstObject];
        // 如果需要对url或者名片等信息进行扫描，可以再次进行扩展
        NSLog(@"扫描结果：%@", obj.stringValue);
        [self setQRCode:obj.stringValue];
    }
}

#pragma mark - click
#pragma mark 我的明信片
- (void)clickMyCard
{    
    __unsafe_unretained typeof(self) vc = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [vc.parent showMyQRCard];
    }];
}

#pragma mark 取消
- (void)clickCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 相册
- (void)clickAlbum
{
    [self showAlbum];
}

#pragma mark - private
- (void)showAlbum
{
    //创建图像选取控制器
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //允许用户进行编辑
    imagePickerController.allowsEditing = NO;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *photo = [info objectForKey:UIImagePickerControllerEditedImage];
    if (photo == nil) {
        photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    }

    CGImageRef imageToDecode = photo.CGImage;

    ZXLuminanceSource* source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode] ;
    ZXBinaryBitmap* bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError* error = nil;

    ZXDecodeHints* hints = [ZXDecodeHints hints];
    hints.encoding = NSUTF8StringEncoding;// StringEncoding;
    
    ZXMultiFormatReader* reader = [ZXMultiFormatReader reader];
    ZXResult* result = [reader decode:bitmap
                                hints:nil
                                error:&error];
    
    if (result) {
        [picker dismissViewControllerAnimated:YES completion:^{
            [self setQRCode:result.text];
        }];
    } else {
        [picker dismissViewControllerAnimated:YES completion:^{
            [self showInfoAlert:@"未发现二维码！"];
        }];
    }
}

#pragma mark - public 
- (void)setIsFromPersonQRCard
{
    myCard.hidden = YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
