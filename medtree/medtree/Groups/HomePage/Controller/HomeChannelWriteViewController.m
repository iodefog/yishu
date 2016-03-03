//
//  HomeChannelWriteViewController.m
//  medtree
//
//  Created by tangshimi on 8/21/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeChannelWriteViewController.h"
#import "SZTextView.h"
#import "MedImageListView.h"
#import <FontUtil.h>
#import <ColorUtil.h>
#import "SZTextView.h"
#import <InfoAlertView.h>
#import "ImagePicker.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "UploadUtil.h"
#import "MedGlobal.h"
#import "Request.h"
#import "LoadingView.h"
#import "ServiceManager.h"
#import "UIColor+Colors.h"
#import "ChannelManager.h"
#import "HomeRecommendChannelDetailDTO.h"
#import "HomeChannelMyInterestViewController.h"
#import "HomeArticleAndDiscussionDTO.h"
#import <JSONKit.h>
#import "NewPersonIdentificationController.h"
#import <MBProgressHUD.h>

static NSInteger const kGiveUpFeedAlertViewTag = 1000;
static NSInteger const kReUploadImageAlertViewTag = 1001;
static NSInteger const kAboutAnoymityAlertViewTag = 1002;
static NSInteger const kAbandonAlertViewTag = 1003;

@interface HomeChannelWriteViewController () <UITextViewDelegate, UIAlertViewDelegate, ImagePickerDelegate, UploadDelegate>

@property (nonatomic, strong) UIView *inputHelpView;
@property (nonatomic, strong) SZTextView *inputTextView;
@property (nonatomic, strong) MedImageListView *imageListView;
@property (nonatomic, copy) NSString *imageFile;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UIButton *anonymityButton;
@property (nonatomic, copy) NSArray *publisTagsArray;

@end

@implementation HomeChannelWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputTextView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), GetViewWidth(self.view), 100);
    
    CGFloat height = [MedImageListView heightWithWidth:GetScreenWidth type:MedImageListViewTypeShowAndAdd imageArray:nil] ;
    self.imageListView.frame = CGRectMake(0, CGRectGetMaxY(self.inputTextView.frame)+5, GetViewWidth(self.view), height);
    
    self.toolView.frame = CGRectMake(0, GetScreenHeight - 45, GetScreenWidth, 45);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createUI
{
    [super createUI];
    
    if (self.type == HomeChannelWriteViewControllerTypePublish ||
        self.type == HomeChannelWriteViewControllerTypeEmploymentComment) {
        [naviBar setTopTitle:@"发讨论"];
    } else if (self.type == HomeChannelWriteViewControllerTypeComment ||
               self.type == HomeChannelWriteViewControllerTypeEmploymentComment) {
        [naviBar setTopTitle:@"发言"];
    }
    
    [naviBar setLeftButton:[NavigationBar createNormalButton:@"取消" target:self action:@selector(cancleButtonAction:)]];
    [naviBar setRightButton:[NavigationBar createNormalButton:@"发布" target:self action:@selector(publishButtonAction:)]];
    
    [self.view addSubview:self.inputTextView];
    [self.view addSubview:self.imageListView];
    
    [self.view addSubview:self.toolView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.toolView.frame = CGRectMake(0, GetScreenHeight - 45, GetScreenWidth, 45);
    }];
}

#pragma mark -
#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case kGiveUpFeedAlertViewTag: {
            if (buttonIndex == 1) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
        case kReUploadImageAlertViewTag: {
            if (buttonIndex == 1) {
                [self uploadImage];
            } else if (buttonIndex == 0) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
        case kAboutAnoymityAlertViewTag: {
            if (buttonIndex == 1) {
                NewPersonIdentificationController *identification = [[NewPersonIdentificationController alloc] init];
                [self.navigationController pushViewController:identification animated:YES];
                [identification loadData];
            }
            
            break;
        }
        case kAbandonAlertViewTag: {
            if (buttonIndex == 1) {
                [self dismissViewControllerAnimated:YES completion:nil];
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"网络连接失败，请选择重传或放弃"
                                                   delegate:self
                                          cancelButtonTitle:@"放弃"
                                          otherButtonTitles:@"重传", nil];
    alert.tag = kGiveUpFeedAlertViewTag;
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
        CGFloat maxHeight = GetScreenHeight - 64 - GetViewHeight(self.inputTextView) - GetViewHeight(self.toolView);
        
        frame.size.height = MIN(height, maxHeight);
        self.imageListView.frame = frame;
    }
}

- (void)uploadFailed:(NSString *)theFilePath error:(NSError *)error
{
    [LoadingView showProgress:NO inView:self.view];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"上传失败，请选择重传或放弃" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"重传", nil];
    alert.tag = kGiveUpFeedAlertViewTag;
    [alert show];
}

#pragma mark -
#pragma mark - uploadImage -

- (void)uploadImage
{
    [UploadUtil setHost:[MedGlobal getHost]];
    [UploadUtil setAction:@"file/upload"];
    [UploadUtil uploadFile:self.imageFile header:[Request getHeader] params:nil delegate:self];
    
    [LoadingView setOffset:self.inputTextView.frame.origin.y + 50];
    [LoadingView showProgress:YES inView:self.view];
}

#pragma mark -
#pragma mark - response event -

- (void)anonymityButtonAction:(UIButton *)button
{
    if (![AccountHelper getAccount].is_certificated) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"只有认证用户才可以匿名哦~"
                                                           delegate:self
                                                  cancelButtonTitle:@"以后再说"
                                                  otherButtonTitles:@"立即认证", nil];
        alertView.tag = kAboutAnoymityAlertViewTag;
        [alertView show];
        
        return;
    }
    
    button.selected = !button.selected;
}

- (void)cancleButtonAction:(UIButton *)button
{
    [self.view endEditing:YES];
    if (self.inputTextView.text.length <= 0 || [self.imageListView imageArray].count <= 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"放弃此次编辑？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alertView.tag = kAbandonAlertViewTag;
        [alertView show];
    }
}

- (void)publishButtonAction:(UIButton *)button
{    
    if (self.inputTextView.text.length == 0 || [self.inputTextView.text isEqualToString:@""]) {
        [InfoAlertView showInfo:@"请输入内容！" inView:self.view duration:1];
        return;
    }
    
    if (self.inputTextView.text.length > 2000) {
        NSString *str = [NSString stringWithFormat:@"文字字数过多，请在2000字以内(当前字数:%@)", @(self.inputTextView.text.length)];
        [InfoAlertView showInfo:str inView:self.view duration:2.0];
        return;
    }
    
    button.userInteractionEnabled = NO;
    if (self.type == HomeChannelWriteViewControllerTypePublish) {
        if (self.channelDetailDTO.channelHaveTags) {
            HomeChannelMyInterestViewController *vc = [[HomeChannelMyInterestViewController alloc] init];
            vc.type = HomeChannelMyInterestViewControllerTypePublishDiscussionChoseInterest;
            vc.channelDatailDTO = self.channelDetailDTO;
            vc.choseInterstBlock = ^(NSArray *tagsArray) {
                self.publisTagsArray = [tagsArray copy];
                [self publishDisussionRequest];
            };
            [self presentViewController:vc animated:YES completion:nil];
            
            return;
        }
        [self publishDisussionRequest];
    } else if (self.type == HomeChannelWriteViewControllerTypeComment) {
        [self commentArticleAndDiscussionRequest];
    } else if (self.type == HomeChannelWriteViewControllerTypeEmploymentComment) {
        [self commentEmploymentRequest];
    }
}

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    NSDictionary *infoDic = [notification userInfo];
    CGFloat height = [infoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat animationTime = [infoDic[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationTime animations:^{
        self.toolView.frame = CGRectMake(0, GetScreenHeight - height - 45, GetScreenWidth, 45);
    }];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    NSDictionary *infoDic = [notification userInfo];
    CGFloat animationTime = [infoDic[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationTime animations:^{
        self.toolView.frame = CGRectMake(0, GetScreenHeight - 45, GetScreenWidth, 45);
    }];
}

#pragma mark -
#pragma mark - network -

- (void)publishDisussionRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSDictionary *params = nil;
    
    if (self.channelDetailDTO.channelHaveTags) {
        params = @{ @"method" : @(MethodTypeChannelPublishDiscussion),
                    @"channel_id" : self.channelDetailDTO.channelID,
                    @"content" : self.inputTextView.text,
                    @"is_anonymous" : @(self.anonymityButton.selected),
                    @"tags" : self.publisTagsArray,
                    @"images" : self.imageListView.imageArray == nil ? [NSArray array] : self.imageListView.imageArray};
    } else {
        params = @{ @"method" : @(MethodTypeChannelPublishDiscussion),
                    @"channel_id" : self.channelDetailDTO.channelID,
                    @"content" : self.inputTextView.text,
                    @"is_anonymous" : @(self.anonymityButton.selected),
                    @"images" : self.imageListView.imageArray == nil ? [NSArray array] : self.imageListView.imageArray};
    }

    [ChannelManager getChannelParam:params success:^(id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dic = JSON;
        if ([dic[@"success"] boolValue]) {
        
            [InfoAlertView showInfo:@"发布成功！" inView:self.view duration:1];
            if (self.updateBlock) {
                self.updateBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            UIButton *sendBtn = [naviBar rightButton];
            sendBtn.userInteractionEnabled = YES;

            [InfoAlertView showInfo:dic[@"message"] inView:self.view duration:1];
        }
    } failure:^(NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        UIButton *sendBtn = [naviBar rightButton];
        sendBtn.userInteractionEnabled = YES;
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

- (void)commentArticleAndDiscussionRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableArray *images = [self.imageListView.imageArray mutableCopy];
    
    NSDictionary *params = nil;
    if (images.count > 0) {
        params = @{ @"method" : @(MethodTypeChannelDetailComment),
                    @"content" : self.inputTextView.text,
                    @"post_id" : self.articleAndDiscussionDTO.id,
                    @"is_anonymous" : @(self.anonymityButton.selected),
                    @"post_type" : @(self.articleAndDiscussionDTO.type),
                    @"images" : images };
    } else {
        params = @{ @"method" : @(MethodTypeChannelDetailComment),
                    @"content" : self.inputTextView.text,
                    @"post_id" : self.articleAndDiscussionDTO.id,
                    @"is_anonymous" : @(self.anonymityButton.selected),
                    @"post_type" : @(self.articleAndDiscussionDTO.type) };
    }
    [ChannelManager getChannelParam:params success:^(id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([[JSON objectForKey:@"success"] boolValue]) {
            
            [InfoAlertView showInfo:@"发布成功！" inView:self.view duration:1];
            
            if (self.updateBlock) {
                self.updateBlock();
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            UIButton *sendBtn = [naviBar rightButton];
            sendBtn.userInteractionEnabled = YES;

            [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:1];
        }
    } failure:^(NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        UIButton *sendBtn = [naviBar rightButton];
        sendBtn.userInteractionEnabled = YES;
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

- (void)commentEmploymentRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableArray *images = [self.imageListView.imageArray mutableCopy];
    
    NSDictionary *params = nil;

    if (images.count > 0) {
        params = @{ @"method" : @(MethodTypeJobChannelEmploymentPublishFeed),
                    @"content" : self.inputTextView.text,
                    @"job_id" : self.employmentID,
                    @"is_anonymous" : @(self.anonymityButton.selected),
                    @"images" : images };
    } else {
        params = @{ @"method" : @(MethodTypeJobChannelEmploymentPublishFeed),
                    @"content" : self.inputTextView.text,
                    @"job_id" : self.employmentID,
                    @"is_anonymous" : @(self.anonymityButton.selected)};
    }
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([[JSON objectForKey:@"success"] boolValue]) {
            
            [InfoAlertView showInfo:@"发布成功！" inView:self.view duration:1];
            
            if (self.updateBlock) {
                self.updateBlock();
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            UIButton *sendBtn = [naviBar rightButton];
            sendBtn.userInteractionEnabled = YES;
            
            [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:1];
        }
    } failure:^(NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        UIButton *sendBtn = [naviBar rightButton];
        sendBtn.userInteractionEnabled = YES;
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

#pragma mark -
#pragma mark - setter and getter -

- (UIView *)toolView
{
    if (!_toolView) {
        _toolView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GetScreenWidth, 45)];
            view.backgroundColor = [UIColor colorFromHexString:@"#f7f7f7"];
            view.userInteractionEnabled = YES;
            
            [view addSubview:({
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GetScreenWidth, 0.5)];
                view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
                view;
            })];
            
            self.anonymityButton = ({
                UIButton *anonymityButton = [UIButton buttonWithType:UIButtonTypeCustom];
                anonymityButton.frame = CGRectMake(0, 10, 80, 25);
                [anonymityButton setTitle:@"  匿名" forState:UIControlStateNormal];
                [anonymityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                anonymityButton.titleLabel.font = [UIFont systemFontOfSize:15];
                [anonymityButton setImage:GetImage(@"hidden_icon_select_image.png")
                                 forState:UIControlStateNormal];
                [anonymityButton setImage:GetImage(@"hidden_icon_select_image_click.png")
                                 forState:UIControlStateNormal | UIControlStateSelected];
                [anonymityButton addTarget:self
                                    action:@selector(anonymityButtonAction:)
                          forControlEvents:UIControlEventTouchUpInside];
                anonymityButton;
            });
            
            [view addSubview:self.anonymityButton];
            
            view;
        });
    }
    return _toolView;
}

- (SZTextView *)inputTextView
{
    if (!_inputTextView) {
        _inputTextView = ({
            SZTextView *textView = [[SZTextView alloc] init];
            textView.backgroundColor = [UIColor whiteColor];
            textView.font = [UIFont systemFontOfSize:15];
            if (self.type == HomeChannelWriteViewControllerTypePublish) {
                textView.placeholder = self.channelDetailDTO.publishFeedPlaceHolderText;
            } else {
                textView.placeholder = @"来发个言吧！";
            }
            
            textView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);
            textView.delegate = self;
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
