//
//  NewPersonIdentificationDetailController.m
//  medtree
//
//  Created by 陈升军 on 15/4/8.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewPersonIdentificationDetailController.h"
#import "CertificationDTO.h"
#import "CertificationStatusType.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "ColorUtil.h"
#import "FontUtil.h"
#import "UserType.h"
#import "ImagePicker.h"
#import "UploadUtil.h"
#import "UploadDelegate.h"
#import "LoadingView.h"
#import "Request.h"
#import "FileUtil.h"
#import "ServiceManager.h"
#import "JSONKit.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "UIImageView+setImageWithURL.h"
#import "ExperienceListController.h"
#import "ExperienceLoactionController.h"
#import "ServiceManager.h"

@interface NewPersonIdentificationDetailController () <ImagePickerDelegate, UploadDelegate, UIAlertViewDelegate>
{
    UILabel                 *titleLab;
    UILabel                 *detailLab;
    
    UIScrollView            *scroll;
    UIImageView             *imageView;
    UILabel                 *addLab;
    UILabel                 *commentLab;
    
    UILabel                 *experienceTitleLab;
    UIButton                *experienceBGButton;
//    UILabel                 *buttonValue;
    UIImageView             *nextImage;
    UIImageView             *lineImage;
    
    NSString                *uploadFile;
    NSString                *imageName;
    
    UIButton                *saveButton;
    
    NSString                *experienceStr;
    UIScrollView            *bgScrollView;
    NSString                *experience_id;
}
@property (nonatomic, strong) UILabel *buttonTitle;

@end

@implementation NewPersonIdentificationDetailController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"上传认证资料"];
    [self createBackButton];
    
    bgScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:bgScrollView];

    [self.view sendSubviewToBack:bgScrollView];
    
    titleLab = [[UILabel alloc] init];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = [MedGlobal getMiddleFont];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [bgScrollView addSubview:titleLab];
    
    detailLab = [[UILabel alloc] init];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.font = [MedGlobal getLittleFont];
    detailLab.numberOfLines = 0;
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.text = @"[医树]是医学专业人员的家园，为尽最大努力\n维护家园的环境，请上传以下证件\n上传资料仅供身份认证，不会泄漏给第三方";
    detailLab.textColor = [UIColor darkGrayColor];
    [bgScrollView addSubview:detailLab];
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scroll.userInteractionEnabled = YES;
    scroll.scrollEnabled = NO;
    [bgScrollView addSubview:scroll];
    
    // 图片
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.userInteractionEnabled = YES;
    imageView.image = [ImageCenter getBundleImage:@"PersonIdentification_image.png"];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [scroll addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [imageView addGestureRecognizer:tap];
    
    addLab = [[UILabel alloc] init];
    addLab.text = @"+";
    addLab.hidden = YES;
    addLab.backgroundColor = [UIColor clearColor];
    addLab.font = [UIFont systemFontOfSize:32];
    addLab.textColor = [UIColor whiteColor];
    addLab.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:addLab];
    
    commentLab = [[UILabel alloc] init];
    commentLab.backgroundColor = [UIColor clearColor];
    commentLab.font = [MedGlobal getLittleFont];
    commentLab.numberOfLines = 0;
    commentLab.hidden = YES;
    commentLab.textAlignment = NSTextAlignmentCenter;
    commentLab.text = @"请点击上传您的有效工作证件的照片\n（如：职业资格证、胸牌、学生证或工作证件）\n照片内需包含姓名、编号、单位信息";
    commentLab.textColor = [UIColor darkGrayColor];
    [imageView addSubview:commentLab];
    
    experienceTitleLab = [[UILabel alloc] init];
    experienceTitleLab.text = @"    所在单位";
    experienceTitleLab.backgroundColor = [ColorUtil getColor:@"E9E9E9" alpha:1];
    experienceTitleLab.font = [MedGlobal getTinyLittleFont];
    [bgScrollView addSubview:experienceTitleLab];
    
    experienceBGButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [experienceBGButton addTarget:self action:@selector(clickSelectExperience) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:experienceBGButton];
    
    [experienceBGButton addSubview:self.buttonTitle];
    /*
    buttonValue = [[UILabel alloc] init];
    buttonValue.text = @"添加工作经历，更加完善您身份";
    buttonValue.textColor = [ColorUtil getColor:@"525251" alpha:1];
    buttonValue.backgroundColor = [UIColor clearColor];
    buttonValue.font = [UIFont systemFontOfSize:13];
    [experienceBGButton addSubview:buttonValue];
     */

    //下一级页面指示图片
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.userInteractionEnabled = YES;
    nextImage.hidden = NO;
    nextImage.image = [ImageCenter getBundleImage:@"img_next.png"];
    [experienceBGButton addSubview:nextImage];
    
    lineImage = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"img_line.png"]];
    lineImage.userInteractionEnabled = YES;
    [bgScrollView addSubview:lineImage];
    
    table.hidden = YES;
    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"确认并上传" forState:UIControlStateNormal];
    [saveButton setBackgroundColor:[ColorUtil getColor:@"365c8a" alpha:1]];
    [saveButton addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:saveButton];
}

- (UILabel *)buttonTitle
{
    if (!_buttonTitle) {
        _buttonTitle = [[UILabel alloc] init];
        _buttonTitle.text = @"选择认证资料相关单位";
        _buttonTitle.backgroundColor = [UIColor clearColor];
        _buttonTitle.font = [MedGlobal getLargeFont];
        _buttonTitle.textColor = [ColorUtil getColor:@"19233b" alpha:1.0];
    }
    return _buttonTitle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    [self setupData];
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    bgScrollView.frame = CGRectMake(0, 0, size.width, size.height);
    bgScrollView.contentSize= CGSizeMake(size.width, size.height + 100);
    titleLab.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame) + 10, size.width, 30);
    detailLab.frame = CGRectMake(0, titleLab.frame.origin.y + 30, size.width, 60);
    scroll.frame = CGRectMake(15, detailLab.frame.origin.y + 60 + 10, size.width - 30, (size.width - 30) * 2 / 3);
    imageView.frame = CGRectMake(0, 0, scroll.frame.size.width, scroll.frame.size.height);
    addLab.frame = CGRectMake(0, imageView.frame.size.height / 2 - 30, imageView.frame.size.width, 30);
    commentLab.frame = CGRectMake(0, imageView.frame.size.height/2, imageView.frame.size.width, 80);
    experienceTitleLab.frame = CGRectMake(0, scroll.frame.origin.y + scroll.frame.size.height + 20, size.width, 30);
    experienceBGButton.frame = CGRectMake(0, experienceTitleLab.frame.origin.y + experienceTitleLab.frame.size.height, size.width, 60);
    
    _buttonTitle.frame = CGRectMake(15, 0, size.width - 30, 65);
//    buttonValue.frame = CGRectMake(15, CGRectGetMaxY(buttonTitle.frame), size.width - 30, 15);
    
    nextImage.frame = CGRectMake(size.width - 30, (experienceBGButton.frame.size.height - 10) / 2, 5, 10);
    lineImage.frame = CGRectMake(15, experienceBGButton.frame.size.height + experienceBGButton.frame.origin.y + 1, size.width - 30, 1);
    saveButton.frame = CGRectMake(20, experienceBGButton.frame.size.height + experienceBGButton.frame.origin.y + 20, size.width - 40, 50);
}

- (void)createTable {}

- (void)setupData
{
    if (self.experienceDto) {
        self.buttonTitle.text = self.experienceDto.org;
        experience_id = self.experienceDto.experienceId;
        self.certifDto.reason = self.experienceDto.org;
    }
}

#pragma mark - private
// 上传信息
- (void)postData
{
    [LoadingView showProgress:YES inView:self.view];
    NSDictionary *dict = @{@"method":[NSNumber numberWithInt:MethodType_UserInfo_CertificationApply],
                           @"user_type":[NSNumber numberWithInteger:self.certifDto.userType],
                           @"reason":self.certifDto.reason,
                           @"images":[NSArray arrayWithObjects:imageName,nil],
                           @"experience_id":experience_id};
    [ServiceManager setData:dict success:^(id JSON) {
        self.view.userInteractionEnabled = YES;
        [LoadingView showProgress:NO inView:self.view];
        if ([[JSON objectForKey:@"success"] boolValue]) {
            if (self.fromRegister) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ImproveThePersonalInformationSuccessNotification object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                CertificationDTO *dto = [[CertificationDTO alloc] init:[JSON objectForKey:@"result"]];
                if (dto.status == CertificationStatusType_No) {
                    dto.status = CertificationStatusType_Wait;
                }
                [self.delegate updateCertificationArray:dto];
                [self.navigationController popToViewController:self.fromVC animated:YES];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[JSON objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alert show];
        }
    } failure:^(NSError *error, id JSON) {
        self.view.userInteractionEnabled = YES;
        [LoadingView showProgress:NO inView:self.view];
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if (result[@"message"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:result[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                [alert show];
            }
        }
    }];
}

/*清空提交完毕的缓存文件*/
- (void)cleanImages
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *files = [fm subpathsAtPath:[FileUtil getPicPath]];
    
    for (NSInteger i = 0; i < files.count; i++) {
        NSString *filePath = [[FileUtil getPicPath] stringByAppendingPathComponent:[files objectAtIndex:i]];
        [fm removeItemAtPath:filePath error:nil];
    }
    uploadFile = nil;
}

- (void)uploadImages
{
    if (uploadFile != nil) {
        [LoadingView showProgress:YES inView:self.view];
        [UploadUtil setHost:[MedGlobal getHost]];
        [UploadUtil setAction:@"file/upload"];
        [UploadUtil uploadFile:uploadFile header:[Request getHeader] params:nil delegate:self];
    }
}

#pragma mark - click
- (void)clickImage
{
    [ImagePicker setAllowsEditing:YES];
    [ImagePicker showSheet:nil uvc:self delegate:self];
}

- (void)clickSave
{
    NSString *msg = @"";
    if (self.certifDto.reason.length == 0) {
        msg = @"请选择所在单位";
    } else if (imageName.length == 0) {
        msg = @"请添加资料照片";
    }
    if (msg.length == 0) {
        [self postData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }
}

- (void)clickSelectExperience
{
    if (_fromRegister) {
        return;
    }
    experienceBGButton.backgroundColor = [UIColor lightGrayColor];
    [UIView animateWithDuration:0.5 animations:^{
        experienceBGButton.backgroundColor = [UIColor clearColor];
    }];
    
    ExperienceListController *vc = [[ExperienceListController alloc] init];
    vc.experienceType = (self.certifDto.userType == 8) ? ExperienceType_Edu : ExperienceType_Work;
    vc.parent = self;
    vc.fromVerify = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - public
- (void)updateInfo:(NSDictionary *)dict
{
    self.certifDto.reason = [dict objectForKey:@"organization_name"];
    experience_id = [dict objectForKey:@"experience_id"];
    
    self.buttonTitle.text = [dict objectForKey:@"organization_name"];
    /*
    if ([dict objectForKey:@"dep"]) {
        buttonValue.text = [NSString stringWithFormat:@"%@   %@", [dict objectForKey:@"dep"], [dict objectForKey:@"title"]];
    }
     */
}

- (void)loadDataInfo:(CertificationDTO *)dto
{
    self.certifDto = dto;
    titleLab.text = [NSString stringWithFormat:@"身份：%@",[UserType getShortLabel:dto.userType]];
  
    if (self.certifDto.userType == 8) {
        imageView.image = [ImageCenter getBundleImage:@"PersonIdentification_image.png"];
        experienceTitleLab.text = @"    教育经历";
        _buttonTitle.text = @"添加教育经历，更加完善您身份";
    }
}

#pragma mark - ImagePickerDelegate
- (void)didSavePhoto:(NSDictionary *)userInfo
{
    uploadFile = [userInfo objectForKey:@"file"];
    [self uploadImages];
}

#pragma mark - UploadDelegate
- (void)uploadProgressUpdated:(NSString *)filePath percent:(float)percent
{
    
}

- (void)uploadSucceeded:(NSString *)filePath ret:(NSDictionary *)ret
{
    [LoadingView showProgress:NO inView:self.view];
    NSArray *array = [ret objectForKey:@"result"];
    if (array.count > 0) {
        NSDictionary *dict = [array objectAtIndex:0];
        imageName = [dict objectForKey:@"file_id"];
        addLab.hidden = YES;
        commentLab.hidden = YES;
        NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], imageName];
        [imageView med_setImageWithUrl:[NSURL URLWithString:path]];
    }
    [self cleanImages];
}

#pragma mark - UploadDelegate
- (void)uploadFailed:(NSString *)filePath error:(NSError *)error
{
    [LoadingView showProgress:NO inView:self.view];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"上传失败，请选择重传或放弃" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"重传", nil];
    alert.tag = 1000;
    [alert show];
}

- (void)unreachableHost:(NSString *)theFilePath error:(NSError *)error
{
    [LoadingView showProgress:NO inView:self.view];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络连接失败，请选择重传或放弃" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"重传", nil];
    alert.tag = 1000;
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self uploadImages];
        } else if (buttonIndex == 0) {
            [self cleanImages];
        }
    }
}

@end
