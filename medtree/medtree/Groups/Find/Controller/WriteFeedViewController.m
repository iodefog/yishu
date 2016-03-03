//
//  WriteFeedViewController.m
//  medtree
//
//  Created by tangshimi on 8/11/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "WriteFeedViewController.h"
#import <FontUtil.h>
#import <ColorUtil.h>
#import "SZTextView.h"
#import <InfoAlertView.h>
#import "MedImageListView.h"
#import "ImagePicker.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "UploadUtil.h"
#import "MedGlobal.h"
#import "Request.h"
#import "LoadingView.h"
#import "ServiceManager.h"

NSInteger const kWriteFeedViewControllerGiveUpFeedAlertViewTag = 1000;
NSInteger const kWriteFeedViewControllerReUploadImageAlertViewTag = 1001;

@interface WriteFeedViewController () <UITextViewDelegate, UIAlertViewDelegate, ImagePickerDelegate, UploadDelegate>

@property (nonatomic, strong) SZTextView *inputTextView;
@property (nonatomic, strong) MedImageListView *imageListView;
@property (nonatomic, copy) NSString *imageFile;

@end

@implementation WriteFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [naviBar setTopTitle:self.navigationTitle];
    
    self.inputTextView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), GetViewWidth(self.view), 100);
    
    CGFloat height = [MedImageListView heightWithWidth:GetScreenWidth type:MedImageListViewTypeShowAndAdd imageArray:nil] ;
    self.imageListView.frame = CGRectMake(0, CGRectGetMaxY(self.inputTextView.frame) + 5, GetViewWidth(self.view), height);
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"动态"];
    
    [naviBar setLeftButton:({
        UIButton *button = [NavigationBar createNormalButton:@"取消" target:self action:@selector(cancleButtonAction:)];
        button;
    })];
    
    [naviBar setRightButton:({
        UIButton *button = [NavigationBar createNormalButton:@"发送" target:self action:@selector(sendButtonAction:)];
        button;
    })];
    
    [self.view addSubview:self.inputTextView];
    [self.view addSubview:self.imageListView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark - uploadImage -

- (void)uploadImage
{
    [UploadUtil setHost:[MedGlobal getHost]];
    [UploadUtil setAction:@"file/upload"];
    [UploadUtil uploadFile:self.imageFile header:[Request getHeader] params:nil delegate:self];
    
    [LoadingView setOffset:self.inputTextView.frame.origin.y+50];
    [LoadingView showProgress:YES inView:self.view];
}

#pragma mark -
#pragma mark - publish feed -

- (void)publishFeedRequest
{
    NSDictionary *param = nil;
    if (self.navigationTitle) {
        if (self.imageListView.imageArray.count > 0) {
            param = @{ @"content" : self.inputTextView.text,
                       @"image_id" : self.imageListView.imageArray,
                       @"tag" : @[ self.navigationTitle ],
                       @"method" : @(MethodType_Feed_Send) };
        } else {
            param = @{ @"content" : self.inputTextView.text,
                       @"tag" : @[ self.navigationTitle ],
                       @"method" : @(MethodType_Feed_Send) };
        }
    } else {
        if (self.imageListView.imageArray.count > 0) {
            param = @{ @"content" : self.inputTextView.text,
                       @"image_id" :self.imageListView.imageArray,
                       @"method" : @(MethodType_Feed_Send) };
        } else {
            param = @{ @"content" : self.inputTextView.text,
                       @"method" : @(MethodType_Feed_Send) };
        }
    }
    
    UIButton *btn = (UIButton *)naviBar.rightButton;
    btn.enabled = NO;
    self.view.userInteractionEnabled = NO;
    naviBar.userInteractionEnabled = NO;
    
    [LoadingView setOffset:self.inputTextView.frame.origin.y + 150];
    [LoadingView showProgress:YES inView:self.view];
    
    [ServiceManager setData:param success:^(id JSON) {
        [LoadingView showProgress:NO inView:self.view];
        if ([[JSON objectForKey:@"success"] boolValue]) {
            if (self.publishFeedSuccessBlock) {
                self.publishFeedSuccessBlock();
            }
            [InfoAlertView showInfo:@"发表成功" inView:[UIApplication sharedApplication].keyWindow duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        } else {
            [self showErrorAlert:[JSON objectForKey:@"message"]];
        }
        btn.enabled = YES;
        naviBar.userInteractionEnabled = YES;
        self.view.userInteractionEnabled = YES;
    } failure:^(NSError *error, id JSON) {
        btn.enabled = YES;
        self.view.userInteractionEnabled = YES;
        naviBar.userInteractionEnabled = YES;
        [LoadingView showProgress:NO inView:self.view];
    }];
}

#pragma mark -
#pragma mark - response event -

- (void)cancleButtonAction:(UIButton *)button
{
    [self.view endEditing:YES];
    if (self.inputTextView.text.length <= 0 || self.imageListView.imageArray.count < 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"放弃此次编辑？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alertView.tag = kWriteFeedViewControllerGiveUpFeedAlertViewTag;
        [alertView show];
    }
}

- (void)sendButtonAction:(UIButton *)button
{
    if (self.imageListView.imageArray.count < 1 && (self.inputTextView.text.length == 0 || [self.inputTextView.text isEqualToString:@""])) {
        return;
    }
    
    [self.view endEditing:YES];
    
    [self publishFeedRequest];
}

#pragma mark -
#pragma mark - UITextViewDelegate -

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""] && range.length > 0) {
        return YES;
    } else {
        if (textView.text.length - range.length + text.length > 500) {
            [InfoAlertView showInfo:@"动态目前最多能有500字" inView:self.view duration:2.0f];

            return NO;
        } else {
            return YES;
        }
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    CGFloat caretY = MAX(rect.origin.y - textView.frame.size.height + rect.size.height, 0);
    if (textView.contentOffset.y < caretY && rect.origin.y != INFINITY) {
        textView.contentOffset = CGPointMake(0, caretY);
    }
}

#pragma mark -
#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case kWriteFeedViewControllerGiveUpFeedAlertViewTag: {
            if (buttonIndex == 1) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
        case kWriteFeedViewControllerReUploadImageAlertViewTag: {
            if (buttonIndex == 1) {
                [self uploadImage];
            }
            break;
        }
    }
}

#pragma mark -
#pragma mark - ImagePickerDelegate -

- (void)didSavePhoto:(NSDictionary *)userInfo
{
    self.imageFile = [userInfo objectForKey:@"file"];
    [self uploadImage];
}

#pragma mark -
#pragma mark - UploadDelegate -

- (void)unreachableHost:(NSString *)theFilePath error:(NSError *)error
{
    [LoadingView showProgress:NO inView:self.view];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络连接失败，请选择重传或放弃" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"重传", nil];
    alert.tag = kWriteFeedViewControllerReUploadImageAlertViewTag;
    [alert show];
}

- (void)uploadSucceeded:(NSString *)theFilePath ret:(NSDictionary *)ret
{
    [LoadingView showProgress:NO inView:self.view];
    
    NSArray *result = [ret objectForKey:@"result"];
    if (result != nil && result.count > 0) {
        NSString *image_id = [[result objectAtIndex:0] objectForKey:@"file_id"];
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.imageListView.imageArray];
        [newArray addObject:image_id];
        [self.imageListView setImageArray:newArray];
        
        CGRect frame = self.imageListView.frame;
        CGFloat height   = [MedImageListView heightWithWidth:GetScreenWidth type:MedImageListViewTypeShowAndAdd imageArray:self.imageListView.imageArray];
        CGFloat maxHeight = GetScreenHeight - 64 - GetViewHeight(self.inputTextView);
        
        frame.size.height = MIN(height, maxHeight);
        self.imageListView.frame = frame;
    }
}

- (void)uploadFailed:(NSString *)theFilePath error:(NSError *)error
{
    [LoadingView showProgress:NO inView:self.view];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"上传失败，请选择重传或放弃" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"重传", nil];
    alert.tag = kWriteFeedViewControllerReUploadImageAlertViewTag;
    [alert show];
}

#pragma mark -
#pragma mark - setter and getter -

- (SZTextView *)inputTextView
{
    if (!_inputTextView) {
        _inputTextView = ({
            SZTextView *textView = [[SZTextView alloc] init];
            textView.backgroundColor = [UIColor whiteColor];
            textView.font = [UIFont systemFontOfSize:16];
            textView.placeholder = @"说点什么.....";
            textView.delegate = self;
            textView.textContainerInset = UIEdgeInsetsMake(0, 5, 0, 5);
            textView;
        });
    }
    return _inputTextView;
}

- (MedImageListView *)imageListView
{
    if (!_imageListView) {
        _imageListView = ({
            MedImageListView *imageListView = [[MedImageListView alloc] initWithFrame:CGRectZero];
            imageListView.type = MedImageListViewTypeShowAndAdd;
            __weak __typeof(self) weakSelf = self;
            imageListView.addImageBlock = ^{
                __strong __typeof(self) strongSelf = weakSelf;
                [strongSelf.view endEditing:YES];
                NSDictionary *dict =@{@"name": [[AccountHelper getAccount] userID]};
                [ImagePicker setAllowsEditing:NO];
                [ImagePicker showSheet:dict uvc:strongSelf delegate:strongSelf];
            };
            imageListView;
        });
    }
    return _imageListView;
}

@end
