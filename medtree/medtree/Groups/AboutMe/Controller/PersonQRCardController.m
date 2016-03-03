//
//  PersonQRCardController.m
//  medtree
//
//  Created by 无忧 on 14-11-11.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PersonQRCardController.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "UserDTO.h"
#import "AccountHelper.h"
#import "ZXingObjC.h"
#import <QuartzCore/QuartzCore.h>
#import "FontUtil.h"
#import "WXApi.h"
#import "QRCardController.h"
#import "PersonEditViewController.h"
#import "ServiceManager.h"
#import "InfoAlertView.h"
#import "LoadingView.h"
#import "NewPersonDetailController.h"
#import "UIImageView+setImageWithURL.h"
#import "ScanQRCodeViewController.h"

@interface PersonQRCardController () <WXApiDelegate,ZXingQRCardDelegate>
{
    UIView          *bgView;
    UIImageView     *cardBgView;
    /** 二维码 */
    UIImageView     *cardImage;
    UILabel         *titleLab;
    enum WXScene    _scene;
    UIImageView     *roundImage;
    UIImageView     *vImage2;
    
    UIView          *personView;
    UIImageView     *photoImage;
    UIImageView     *vImage;
    UILabel         *nameLab;
    UILabel         *detailLab;
    UIImageView     *lineImage;
    
    UIView          *footView;
    UILabel         *footLab;
    UIImageView     *footImage;
    UIButton        *footButton;
    
    UIImage         *shareImage;
    
    UIButton        *rightButton;
}
@end

@implementation PersonQRCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (void)clickBack
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)createBackButton
//{
//    UIButton *backButton = [NavigationBar createImageButton:@"btn_back.png" selectedImage:@"btn_back_click.png" target:self action:@selector(clickBack)];
//    [naviBar setLeftButton:backButton];
//}

- (void)createRightButton
{
    rightButton = [NavigationBar createNormalButton:@"扫一扫" target:self action:@selector(clickOver)];
    [naviBar setRightButton:rightButton];
}

- (void)clickOver
{    
    @autoreleasepool {
        QRCardController *card = [[QRCardController alloc] init];
        [self presentViewController:card animated:YES completion:nil];
        card.parent = self;
        [card setIsFromPersonQRCard];
        [card startQRCard];
    }
//    ScanQRCodeViewController *vc =[[ScanQRCodeViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)showInfoAlert:(NSString *)info
{
    [InfoAlertView showInfo:info inView:self.view duration:1];
}

- (void)hiddenZXingQRCard
{

}

- (void)showMyQRCard
{

}

- (void)setQRCode:(NSString *)code
{
    [self checkCardInfo:code];
}

- (void)checkCardInfo:(NSString *)cardInfo
{
    if (cardInfo.length > 0) {
        
    } else {
        return;
    }
    if ([cardInfo rangeOfString:@"https://medtree.cn/release/?package=medtree&uid="].location !=NSNotFound) {
        NSArray *array = [cardInfo componentsSeparatedByString:@"&"];
        NSString *userID = [array objectAtIndex:1];
        userID = [userID stringByReplacingOccurrencesOfString:@"uid=" withString:@""];
        if ([[[AccountHelper getAccount] userID] isEqualToString:userID]) {
            PersonEditViewController *edit = [[PersonEditViewController alloc] init];
            [self.navigationController pushViewController:edit animated:YES];
            [edit setInfo:[AccountHelper getAccount]];
        } else {
            [self searchUserInfo:userID];
        }
    } else {
        [InfoAlertView showInfo:@"不是本系统所用二维码" inView:self.view duration:1];
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cardInfo]];
    }
}

- (void)searchUserInfo:(NSString *)userID
{
    [LoadingView showProgress:YES inView:self.view];
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_Search],@"userInfo":userID} success:^(id JSON) {
        [LoadingView showProgress:NO inView:self.view];
        NSDictionary *dict = [JSON objectForKey:@"result"];
        if (dict == nil) {
            [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:1];
        } else {
            UserDTO *dto = [[UserDTO alloc] init:JSON];
            NewPersonDetailController *detail = [[NewPersonDetailController alloc] init];
            detail.userDTO = dto;
            detail.parent = self;
            [self.navigationController pushViewController:detail animated:YES];
        }
    } failure:^(NSError *error, id JSON) {
        [LoadingView showProgress:NO inView:self.view];
        [InfoAlertView showInfo:@"未找到账号信息" inView:self.view duration:1];
    }];
}

- (void)createUI
{
    [super createUI];
    [self createBackButton];
    [naviBar setTopTitle:@"我的名片"];
    
    bgView = [[UIView alloc] init];
    bgView.layer.shadowColor = [UIColor grayColor].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(1, 0);
    //bgView.layer.shadowOpacity = 0.1;
    bgView.clipsToBounds = NO;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    personView = [[UIView alloc] initWithFrame:CGRectZero];
    personView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:personView];
    
    photoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    photoImage.layer.cornerRadius = 20;
    photoImage.layer.masksToBounds = YES;
    photoImage.userInteractionEnabled = YES;
    [personView addSubview:photoImage];
    
    vImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    vImage.image = [ImageCenter getBundleImage:@"image_v1.png"];
    vImage.userInteractionEnabled = YES;
    [personView addSubview:vImage];
    
    nameLab = [[UILabel alloc] initWithFrame: CGRectZero];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textColor = [UIColor blackColor];
    nameLab.text = @"";
    nameLab.font = [UIFont systemFontOfSize:18];
    [personView addSubview: nameLab];
    
    detailLab = [[UILabel alloc] initWithFrame: CGRectZero];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.textColor = [UIColor lightGrayColor];
    detailLab.text = @"";
    detailLab.font = [UIFont systemFontOfSize:14];
    [personView addSubview: detailLab];
    
    lineImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    lineImage.image = [ImageCenter getBundleImage:@"img_line.png"];
    [personView addSubview:lineImage];
    
    cardImage = [[UIImageView alloc] init];
    [bgView addSubview:cardImage];
    [bgView.layer addSublayer:cardImage.layer];
    
//    roundImage = [[UIImageView alloc] initWithFrame:CGRectZero];
//    roundImage.layer.cornerRadius = 20;
//    roundImage.layer.masksToBounds = YES;
//    roundImage.userInteractionEnabled = YES;
//    [cardImage addSubview:roundImage];
//    [cardImage.layer addSublayer:roundImage.layer];
//    
//    vImage2 = [[UIImageView alloc] initWithFrame:CGRectZero];
//    vImage2.image = [ImageCenter getBundleImage:@"image_v1.png"];
//    vImage2.userInteractionEnabled = YES;
//    [cardImage addSubview:vImage2];
    
    titleLab = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.text = @"扫一扫二维码图案加医树好友";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [MedGlobal getLittleFont];
    [self.view addSubview: titleLab];
    
    footView = [[UIView alloc] initWithFrame:CGRectZero];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    footImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    footImage.image = [ImageCenter getBundleImage:@"weixin_share.png"];
    [footView addSubview:footImage];
    
    footLab = [[UILabel alloc] initWithFrame: CGRectZero];
    footLab.backgroundColor = [UIColor clearColor];
    footLab.textColor = [UIColor lightGrayColor];
    footLab.text = @"分享给微信好友";
    footLab.textAlignment = NSTextAlignmentCenter;
    footLab.font = [MedGlobal getMiddleFont];
    [footView addSubview: footLab];
    
    footButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footButton addTarget:self action:@selector(clickFoot) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:footButton];
    
    footView.hidden = YES;
    [self createRightButton];
    [self getUserInfo];
    [self createCard];
}

- (void)getUserInfo
{
    UserDTO *dto = [AccountHelper getAccount];
    vImage.hidden = YES;
    vImage2.hidden = YES;
    if (dto.user_type == 1) {
        vImage.hidden = NO;
        vImage.image = [ImageCenter getBundleImage:@"image_v4.png"];
    } else {
        if (dto.certificate_user_type == 1) {
            vImage.image = [ImageCenter getBundleImage:@"image_v4.png"];
        } else if (dto.certificate_user_type == 0) {
            vImage.hidden = YES;
        } else {
            if (dto.certificate_user_type == 1) {
                vImage.image = [ImageCenter getBundleImage:@"image_v4.png"];
            } else if (dto.certificate_user_type > 1 && dto.certificate_user_type < 7) {
                vImage.image = [ImageCenter getBundleImage:@"image_v1.png"];
            } else if (dto.certificate_user_type == 7) {
                vImage.image = [ImageCenter getBundleImage:@"image_v2.png"];
            } else if (dto.certificate_user_type == 8) {
                vImage.image = [ImageCenter getBundleImage:@"image_v3.png"];
            } else {
                vImage.image = [ImageCenter getBundleImage:@"image_v5.png"];
            }
            vImage.hidden = NO;
        }
    }
    vImage2.hidden = vImage.hidden;
    vImage2.image = vImage.image;
    //
    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Small], dto.photoID];
    [photoImage med_setImageWithUrl:[NSURL URLWithString:path]];
    [roundImage med_setImageWithUrl:[NSURL URLWithString:path]];
    nameLab.text = dto.name;
    detailLab.text = [NSString stringWithFormat:@"%@ %@",dto.organization_name,dto.department_name];
}

- (void)createCard
{
    NSError* error = nil;
    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
    
    ZXBitMatrix* result = [writer encode:[NSString stringWithFormat:@"https://medtree.cn/release/?package=medtree&uid=%@&action=scan",[[AccountHelper getAccount] userID]]
                                  format:kBarcodeFormatQRCode width:250 height:250 hints:nil error:&error];
    if (result) {
        UIImage  *image =   [UIImage imageWithCGImage:[[ZXImage imageWithMatrix:result] cgimage]];//二维码原图
        cardImage.image = image;
    }
}

//将UIView转成UIImage
-(UIImage *)getImageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.bounds.size);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize size = self.view.frame.size;
    //bgView.frame = CGRectMake((size.width-270)/2, [self getOffset]+44+(size.height-[self getOffset]-44-270-60-40-30)/2, 270, 270+60);
    bgView.frame = CGRectMake(0, [self getOffset]+44+0, size.width, 270+100);
    personView.frame = CGRectMake(0, 0, bgView.frame.size.width, 60);
    photoImage.frame = CGRectMake(10, 10, 40, 40);
    vImage.frame = CGRectMake(photoImage.frame.origin.x+30, photoImage.frame.origin.y+photoImage.frame.size.height-12, 12, 12);
    nameLab.frame = CGRectMake(60, 10, bgView.frame.size.width-60, 25);
    detailLab.frame = CGRectMake(60, 35, bgView.frame.size.width-60, 20);
    lineImage.frame = CGRectMake(0, personView.frame.size.height-1, personView.frame.size.width, 1);
    
    cardImage.frame = CGRectMake((bgView.frame.size.width-250)/2, 60+10, 250, 250);
//    roundImage.frame = CGRectMake((cardImage.frame.size.width-40)/2, (cardImage.frame.size.height-40)/2, 40, 40);
//    vImage2.frame = CGRectMake(roundImage.frame.origin.x+30, roundImage.frame.origin.y+roundImage.frame.size.height-12, 12, 12);
    
    titleLab.frame = CGRectMake(0, bgView.frame.origin.y+270+40+5, size.width, 20);
    footView.frame = CGRectMake(0, size.height-40, size.width, 40);
    CGFloat width = [FontUtil getLabelWidth:footLab labelFont:[[MedGlobal getMiddleFont] pointSize]];
    footLab.frame = CGRectMake((size.width-width)/2, 10, width, 20);
    footImage.frame = CGRectMake((size.width-width)/2-30, 5, 30, 30);
    footButton.frame = CGRectMake(0, 0, size.width, 40);
}

#define BUFFER_SIZE 1024 * 100
- (void)clickFoot
{
    if (shareImage == nil) {
        shareImage = [self getImageFromView:bgView];
    }
    
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = @"医树网";
//    message.description = [NSString stringWithFormat:@"知道医树App吗？想知道医学专业人员都在聊些什么吗？赶紧一起来抱团吧。注册时请在邀请人那里填写我的医树号：%@，我们就能加为好友了。点下面链接立即下载App https://medtree.cn/release/?package=medtree",[[AccountHelper getAccount] userID]] ;
//    [message setThumbImage:shareImage];
//    
//    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl = @"https://medtree.cn/release/?package=medtree";
//    
//    message.mediaObject = ext;
//    
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = _scene;
//    
//    [WXApi sendReq:req];
    
//    WXMediaMessage *message = [WXMediaMessage message];
////    message.title = @"App消息";
//    message.description = [NSString stringWithFormat:@"知道医树App吗？想知道医学专业人员都在聊些什么吗？赶紧一起来抱团吧。注册时请在邀请人那里填写我的医树号：%@，我们就能加为好友了。点下面链接立即下载App https://medtree.cn/release/?package=medtree",[[AccountHelper getAccount] userID]] ;
//    [message setThumbImage:shareImage];
//    
//    WXAppExtendObject *ext = [WXAppExtendObject object];
//    ext.extInfo = @"<xml>extend info</xml>";
//    ext.url = @"https://medtree.cn/release/?package=medtree";
//    
//    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
//    memset(pBuffer, 0, BUFFER_SIZE);
//    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
//    free(pBuffer);
//    
//    ext.fileData = data;
//    
//    message.mediaObject = ext;
//    
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = _scene;
//    
//    [WXApi sendReq:req];
    
    
    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = @"App消息";
//    message.description = [NSString stringWithFormat:@"知道医树App吗？想知道医学专业人员都在聊些什么吗？赶紧一起来抱团吧。注册时请在邀请人那里填写我的医树号：%@，我们就能加为好友了。点下面链接立即下载App https://medtree.cn/release/?package=medtree",[[AccountHelper getAccount] userID]] ;
    [message setThumbImage:shareImage];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(shareImage);
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    
    [WXApi sendReq:req];
    
    message = nil;
    req = nil;
}

@end
