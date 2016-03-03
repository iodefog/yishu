//
//  MedShareManager.m
//  medtree
//
//  Created by tangshimi on 12/21/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MedShareManager.h"
#import "MedShareView.h"
#import "Diplomat.h"
#import "InfoAlertView.h"
#import "WechatProxy.h"
#import "QQProxy.h"
#import <MessageUI/MessageUI.h>
#import<MessageUI/MFMailComposeViewController.h>
#import "UIView+FindUIViewController.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "MedGlobal.h"

@interface MedShareManager () <MedShareViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *shareURL;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, weak) UIView *inView;
@property (nonatomic, copy) NSString *defaultImage;

@property (nonatomic, copy) NSString *shareText;

@property (nonatomic, strong) UIImage *thumbnailableImage;

/**
 *  是否分享文本
 */
@property (nonatomic, assign) BOOL shareWebpage;

@end

@implementation MedShareManager

+ (MedShareManager *)sharedInstance
{
    static MedShareManager *shareManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[MedShareManager alloc] init];
    });
    
    return shareManager;
}

#pragma mark -
#pragma mark - public -

- (void)showInView:(UIView *)inView
             title:(NSString *)title
           deatail:(NSString *)detail
             image:(NSString *)image
      defaultImage:(NSString *)defaultImage
          shareURL:(NSString *)shareURL
{
    self.shareWebpage = YES;
    
    self.title = title;
    self.detail = detail;
    self.image = image;
    self.shareURL = shareURL;
    self.inView = inView;
    self.defaultImage = defaultImage;
    
    self.thumbnailableImage = nil;
    if (GetImage(image)) {
        self.thumbnailableImage = GetImage(image);
    } else {
        NSString *url = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], image];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url]
                                                        options:SDWebImageRetryFailed
                                                       progress:nil
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!error) {
                self.thumbnailableImage = image;
            }
        }];
    }
    
    [MedShareView showInView:inView delegate:self];
}

- (void)showInView:(UIView *)inView text:(NSString *)text
{
    self.shareWebpage = NO;
    
    self.shareText = text;
}

#pragma mark -
#pragma mark - MedShareViewDelegate -

- (void)shareView:(MedShareView *)shareView didSelectedWithType:(MedShareType)shareType
{
    DTMessage *message;
    
    if (self.shareWebpage) {
        DTPageMessage *shareMessage = [[DTPageMessage alloc] init];
        shareMessage.title = self.title;
        shareMessage.desc = self.detail;
        shareMessage.webPageUrl = self.shareURL;
        shareMessage.thumbnailableImage = self.thumbnailableImage ? : GetImage(self.defaultImage);
        
        message = shareMessage;
    } else {
        DTTextMessage *shareMessage = [[DTTextMessage alloc] init];
        shareMessage.text = self.shareText;
        
        message = shareMessage;
    }
    
    switch (shareType) {
        case MedShareTypeWeChat: {
            if (![[Diplomat sharedInstance] isInstalled:kDiplomatTypeWechat]) {
                [InfoAlertView showInfo:@"未能发现您设备上的微信客户端" inView:self.inView duration:1];
                return;
            }
            message.userInfo = @{ kWechatSceneTypeKey : @(WXSceneSession) };
            
            [[Diplomat sharedInstance] share:message name:kDiplomatTypeWechat completed:^(id  _Nullable result, NSError * _Nullable error) {
                if (!error) {
                    [InfoAlertView showInfo:@"分享成功" inView:self.inView duration:1.0];
                }
            }];
            break;
        }
        case MedShareTypeWeChatFriendster: {
            if (![[Diplomat sharedInstance] isInstalled:kDiplomatTypeWechat]) {
                [InfoAlertView showInfo:@"未能发现您设备上的微信客户端" inView:self.inView duration:1];
                return;
            }
            message.userInfo = @{ kWechatSceneTypeKey : @(WXSceneTimeline) };
            
            [[Diplomat sharedInstance] share:message name:kDiplomatTypeWechat completed:^(id  _Nullable result, NSError * _Nullable error) {
                if (!error) {
                    [InfoAlertView showInfo:@"分享成功" inView:self.inView duration:1.0];
                }
            }];
            break;
        }
        case MedShareTypeQQ: {
//            if (![[Diplomat sharedInstance] isInstalled:kDiplomatTypeQQ]) {
//                [InfoAlertView showInfo:@"未能发现您设备上的QQ客户端" inView:self.inView duration:1];
//                return;
//            }
            message.userInfo = @{ kTencentQQSceneTypeKey : @(TencentSceneQQ) };
            
            [[Diplomat sharedInstance] share:message name:kDiplomatTypeQQ completed:^(id  _Nullable result, NSError * _Nullable error) {
                if (!error) {
                    [InfoAlertView showInfo:@"分享成功" inView:self.inView duration:1.0];
                }
            }];
            break;
        }
        case MedShareTypeEmail: {
            [self showMailPicker];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - MFMailComposeViewControllerDelegate -

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result) {
        caseMFMailComposeResultCancelled:
            NSLog(@"Result: Mail sending canceled");
            break;
        caseMFMailComposeResultSaved:
            NSLog(@"Result: Mail saved");
            break;
        caseMFMailComposeResultSent:
            NSLog(@"Result: Mail sent");
            break;
        caseMFMailComposeResultFailed:
            NSLog(@"Result: Mail sending failed");
            break;
        default:
            NSLog(@"Result: Mail not sent");
            break;
    }
    
    [[self.inView firstAvailableUIViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - helper -

-(void)showMailPicker
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass !=nil) {
        if ([mailClass canSendMail]) {
            [self displayMailComposerSheet];
        }else{
            [self launchMailAppOnDevice];
        }
    } else {
        [self launchMailAppOnDevice];
    }
}

-(void)displayMailComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate =self;
    
    if (self.shareWebpage) {
        [picker setSubject:self.title];
    } else {
        [picker setSubject:@"分享"];
    }
    
    //发送图片附件
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
    //NSData *myData = [NSData dataWithContentsOfFile:path];
    //[picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy.jpg"];
    
    NSString *emailBody = nil;
    if (self.shareWebpage) {
        emailBody =[NSString stringWithFormat:@"%@", self.shareURL] ;
    } else {
        emailBody = self.shareText;
    }
    
    [picker setMessageBody:emailBody isHTML:NO];
    
    [[self.inView firstAvailableUIViewController] presentViewController:picker animated:YES completion:nil];
}

-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

@end
