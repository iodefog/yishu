//
//  ScanQRCodeViewController.m
//  medtree
//
//  Created by tangshimi on 6/24/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanQRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong)AVCaptureDevice *device;
@property (nonatomic, strong)AVCaptureDeviceInput *input;
@property (nonatomic, strong)AVCaptureMetadataOutput *output;
@property (nonatomic, strong)AVCaptureSession *session;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, strong)UIImageView *lineImageView;
@property (nonatomic, strong)UIButton *cancleButton;
@property (nonatomic, strong)UIButton *albumButton;
@property (nonatomic, strong)UIImageView *boxImageView;

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupCamera];
}

- (void)createUI
{
    [super createUI];
    [self.view addSubview:self.cancleButton];
    [self.view addSubview:self.albumButton];
    [self.view addSubview:self.boxImageView];
}

#pragma mark -
#pragma mark - AVCaptureMetadataOutputObjectsDelegate -

- (void)captureOutput:(AVCaptureOutput *)captureOutput
        didOutputMetadataObjects:(NSArray *)metadataObjects
        fromConnection:(AVCaptureConnection *)connection
{
    /*
    NSString *stringValue = nil;
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        stringValue = metadataObject.stringValue;
    }
     */
}


#pragma mark -
#pragma mark - response event -

- (void)cancleButtonAction:(UIButton *)button
{
    
}

- (void)albumButtonAction:(UIButton *)button
{

}

#pragma mark -
#pragma mark - helper -

- (void)setupCamera
{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    self.output.metadataObjectTypes = @[ AVMetadataObjectTypeQRCode ];
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.view.bounds;
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [self.session startRunning];
}

#pragma mark - 
#pragma mark - setter and getter -

- (UIImageView *)boxImageView
{
    if (!_boxImageView) {
        UIImageView *boxImageView = [[UIImageView alloc] init];
        boxImageView.image = [UIImage imageNamed:@"card_read_top.png"];
        _boxImageView = boxImageView;
    }
    return _boxImageView;
}

- (UIImageView *)lineImageView
{
    if (!_lineImageView) {
        UIImageView *lineImageview = [[UIImageView alloc] init];
        lineImageview.image = [UIImage imageNamed:@"my_scan_line.png"];
        _lineImageView = lineImageview;
    }
    return _lineImageView;
}

- (UIButton *)cancleButton
{
    if (!_cancleButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancleButton = button;
    }
    return _cancleButton;
}

- (UIButton *)albumButton
{
    if (!_albumButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"相册" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(albumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _albumButton = button;
    }
    return _albumButton;
}


@end
