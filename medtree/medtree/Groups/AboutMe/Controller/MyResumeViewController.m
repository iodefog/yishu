//
//  MyResumeViewController.m
//  medtree
//
//  Created by 边大朋 on 15/10/20.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "MyResumeViewController.h"
#import "MyResumeCell.h"
#import "ResumeDTO.h"
#import "Pair2DTO.h"
#import "BlankCell.h"
#import "UserDTO.h"
#import "GenderTypes.h"
#import "ExperienceDTO.h"
#import "ImagePicker.h"
#import "UploadUtil.h"
#import "FileUtil.h"
#import "Request.h"
#import "AccountHelper.h"
#import "UserManager.h"
#import "ResumeEditViewController.h"
#import <InfoAlertView.h>
#import <DateUtil.h>
#import "ExperienceListController.h"
#import "ProgressHUD.h"

@interface MyResumeViewController () <ImagePickerDelegate, UploadDelegate, ResumeEditViewControllerDelegate>
{
    NSMutableArray      *dataArray;
    NSString            *uploadFile;
    ResumeDTO           *resumeDto;
    NSIndexPath         *currentIndex;
}

@end

@implementation MyResumeViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    
    if (self.comeFrom == MyResumeViewControllerComeFromRegister) {
        [naviBar setTopTitle:@"完善简历"];
        [self createSaveButton];
        [self createLeftButton];
    } else {
        [naviBar setTopTitle:@"我的简历"];
        if (self.comeFrom == MyResumeViewControllerComeFromPostDetail) {
            [self createFootButton];
            [self setupView];
        }
        [self createBackButton];
    }
    [self setupData];
}

#pragma mark - UI
- (void)createUI
{
    [super createUI];

    table.enableHeader = NO;
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    [table registerCells:@{@"ResumeDTO":[MyResumeCell class],@"Pair2DTO":[BlankCell class]}];
}

- (void)createSaveButton
{
    UIButton *button = [NavigationBar createNormalButton:@"保存" target:self action:@selector(clickSave)];
    [naviBar setRightButton:button];
}

- (void)createLeftButton
{
    UIButton *button = [NavigationBar createNormalButton:@"以后再说" target:self action:@selector(clickLeft)];
    [naviBar setLeftButton:button];
}

- (void)createFootButton
{
//    UIButton *rightButton = [NavigationBar createNormalButton:@"投递" target:self action:@selector(clickDelivery)];
    UIButton *footButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footButton addTarget:self action:@selector(clickDelivery) forControlEvents:UIControlEventTouchUpInside];
    [footButton setTitle:@"投递" forState:UIControlStateNormal];
    [footButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    footButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    footButton.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - 44, CGRectGetWidth([UIScreen mainScreen].bounds), 44);
    [self.view addSubview:footButton];
//    [naviBar setRightButton:rightButton];
}

- (void)setupData
{
    [dataArray removeAllObjects];
    [ServiceManager getData:@{@"method":@(MethodType_Resume_Get)} success:^(NSDictionary *dict) {
        if ([dict[@"success"] boolValue]) {
            ResumeDTO *resume = [[ResumeDTO alloc] init:[dict[@"result"] firstObject]];
            [self bindData:resume];
            [AccountHelper getAccount].resumeCount = [dict[@"result"] count];
        } else {
            if (dict[@"message"]) {
                [InfoAlertView showInfo:dict[@"message"] inView:self.view duration:1.0];
            }
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)setupView
{
    table.frame = CGRectMake(0, CGRectGetMinY(table.frame), CGRectGetWidth(table.frame), CGRectGetHeight(table.frame) - 44);
}

#pragma mark - private
- (void)bindData:(ResumeDTO *)resume
{
    resumeDto = resume;
    NSString *commonStr = @"待完善";
    {
        Pair2DTO *dto = [[Pair2DTO alloc] init];
        dto.title = @"基本信息";
        [dataArray addObject:dto];
    }
    {
        ResumeDTO *dto = [[ResumeDTO alloc] init:@{}];
        dto.key = @"照片";
        dto.value = resume.avater;
        dto.resumeRowType = ResumeRowTypePic;
        dto.isShowFootLine = YES;
        [dataArray addObject:dto];
    }
    {
        ResumeDTO *dto = [[ResumeDTO alloc] init:@{}];
        dto.key = @"真实姓名";
        dto.value = resume.name;
        dto.resumeRowType = ResumeRowTypeName;
        dto.isShowFootLine = YES;
        [dataArray addObject:dto];
    }
    {
        ResumeDTO *dto = [[ResumeDTO alloc] init:@{}];
        dto.key = @"性别";
        dto.value = [GenderTypes getLabel:resume.gender];
        dto.gender = resume.gender;
        dto.resumeRowType = ResumeRowTypeGender;
        dto.isShowFootLine = YES;
        [dataArray addObject:dto];
    }
    {
        ResumeDTO *dto = [[ResumeDTO alloc] init:@{}];
        dto.key = @"出生地";
        dto.value = resume.birthProvince;
        dto.resumeRowType = ResumeRowTypeBirthplace;
        dto.isShowFootLine = YES;
        [dataArray addObject:dto];
    }
    {
        ResumeDTO *dto = [[ResumeDTO alloc] init:@{}];
        dto.key = @"出生日期";
        dto.value = resume.birthday ? [DateUtil getFormatTime:resume.birthday format:@"yyyy-MM-dd"] :  commonStr;
        dto.birthday = resume.birthday;
        dto.resumeRowType = ResumeRowTypeBirthday;
        dto.isShowFootLine = YES;
        [dataArray addObject:dto];
    }
    {
        ResumeDTO *dto = [[ResumeDTO alloc] init:@{}];
        dto.key = @"联系电话";
        dto.value = resume.mobile.length > 0 ? resume.mobile : commonStr;
        dto.resumeRowType = ResumeRowTypePhone;
        dto.isShowFootLine = YES;
        [dataArray addObject:dto];
    }
    {
        ResumeDTO *dto = [[ResumeDTO alloc] init:@{}];
        dto.key = @"现居住地";
        dto.value = resume.liveProvince.length > 0 ? resume.liveProvince : commonStr;
        dto.resumeRowType = ResumeRowTypeResidential;
        dto.isShowFootLine = YES;
        [dataArray addObject:dto];
    }
    {
        ResumeDTO *dto = [[ResumeDTO alloc] init:@{}];
        dto.key = @"工作经验";
        dto.value = resume.workExperienceStr;
        dto.workExperience = resume.workExperience;
        dto.resumeRowType = ResumeRowTypeWorkExperience;
        dto.isShowFootLine = NO;
        [dataArray addObject:dto];
    }
    {
        Pair2DTO *dto = [[Pair2DTO alloc] init];
        dto.title = @"简历推荐单位时，允许看到照片、姓名、电话";
        [dataArray addObject:dto];
    }
    {
        ResumeDTO *dto = [[ResumeDTO alloc] init:@{}];
        dto.key = @"隐私";
        dto.isOn = resume.privacy;
        dto.resumeRowType = ResumeRowTypePrivacy;
        dto.isShowFootLine = YES;
        [dataArray addObject:dto];
    }
    {
        Pair2DTO *dto = [[Pair2DTO alloc] init:@{}];
        dto.title = @"教育经历";
        [dataArray addObject:dto];
    }
    {
        ResumeDTO *dto = [[ResumeDTO alloc] init:@{}];
        NSInteger educationArray = resume.eduList.count;
        if (educationArray > 0) {
            NSDictionary *dict =  [resume.eduList objectAtIndex:0];
            NSString *organization =[dict objectForKey:@"organization"];
            if (educationArray == 1) {
                dto.key = organization;
            } else {
                dto.key = [NSString stringWithFormat:@"%@等%ld个教育经历", organization, (long)educationArray];
            }
        } else {
            dto.key = commonStr;
        }
        dto.resumeRowType = ResumeRowTypeExperienceEdu;
        dto.isShowFootLine = YES;
        [dataArray addObject:dto];
    }
    {
        Pair2DTO *dto = [[Pair2DTO alloc] init:@{}];
        dto.title = @"工作经历";
        [dataArray addObject:dto];
    }
    {
        ResumeDTO *dto = [[ResumeDTO alloc] init:@{}];
        NSInteger experienceCount = resume.workList.count;
        if (experienceCount > 0) {
            NSDictionary *dict =  [resume.workList objectAtIndex:0];
            NSString *organization =[dict objectForKey:@"organization"];
            if (experienceCount == 1) {
                dto.key = organization;
            } else {
                dto.key = [NSString stringWithFormat:@"%@等%ld个工作经历", organization, (long)experienceCount];
            }
        } else {
            dto.key = commonStr;
        }
        dto.resumeRowType = ResumeRowTypeExperienceWork;
        [dataArray addObject:dto];
    }
    {
        Pair2DTO *dto = [[Pair2DTO alloc] init];
        dto.title = @"兴趣爱好";
        [dataArray addObject:dto];
    }
    {
        ResumeDTO *dto = [[ResumeDTO alloc] init:@{}];
        dto.value = resume.hobby.length > 0 ? resume.hobby : commonStr;
        dto.resumeRowType = ResumeRowTypeInterest;
        dto.isShowFootLine = NO;
        [dataArray addObject:dto];
    }
    {
        Pair2DTO *dto = [[Pair2DTO alloc] init];
        dto.title = @"自我介绍";
        [dataArray addObject:dto];
    }
    {
        ResumeDTO *dto = [[ResumeDTO alloc] init:@{}];
        dto.value = resume.introduction.length > 0 ? resume.introduction : commonStr;
        dto.resumeRowType = ResumeRowTypeSelfIntroduction;
        dto.isShowFootLine = NO;
        [dataArray addObject:dto];
    }
    {
        Pair2DTO *dto = [[Pair2DTO alloc] init];
        dto.title = @"所获荣誉";
        [dataArray addObject:dto];
    }
    {
        ResumeDTO *dto = [[ResumeDTO alloc] init:@{}];
        dto.value = resume.honor.length > 0 ? resume.honor : commonStr;
        dto.resumeRowType = ResumeRowTypeHonour;
        dto.isShowFootLine = NO;
        [dataArray addObject:dto];
    }
    [table setData:[NSArray arrayWithObjects:dataArray, nil]];
}

#pragma mark - BaseTableViewDelegate
- (void)clickCell:(ResumeDTO *)dto index:(NSIndexPath *)index
{
    ResumeEditViewController *vc = [[ResumeEditViewController alloc] init];
    vc.editType = dto.resumeRowType;
    vc.naviTitle = dto.key;
    vc.delegate = self;
    vc.resumeId = resumeDto.resumeId;
    vc.index = index;
    vc.netRequest = (self.comeFrom == MyResumeViewControllerComeFromRegister) ? NO : YES;
    switch (dto.resumeRowType) {
        case ResumeRowTypePic: {
            currentIndex = index;
            [ImagePicker setAllowsEditing:YES];
            [ImagePicker showSheet:@{@"userid":resumeDto.userId} uvc:self delegate:self];
            return;
        }
        case ResumeRowTypeName: {
            vc.value = resumeDto.name;
            break;
        }
        case ResumeRowTypeGender: {
            vc.genderType = resumeDto.gender;
            break;
        }
        case ResumeRowTypeBirthplace: {
            vc.value = resumeDto.birthProvince;
            break;
        }
        case ResumeRowTypeBirthday: {
            vc.birthday = resumeDto.birthday;
            break;
        }
        case ResumeRowTypePhone: {
            vc.value = resumeDto.mobile;
            break;
        }
        case ResumeRowTypeExperienceEdu: {
            currentIndex = index;
            ExperienceListController *evc = [[ExperienceListController alloc] init];
            evc.experienceType = ExperienceType_Edu;
            evc.fromResume = YES;
            evc.parent = self;
            [self.navigationController pushViewController:evc animated:YES];
            return;
        }
        case ResumeRowTypeExperienceWork: {
            currentIndex = index;
            ExperienceListController *evc = [[ExperienceListController alloc] init];
            evc.experienceType = ExperienceType_Work;
            evc.fromResume = YES;
            evc.parent = self;
            [self.navigationController pushViewController:evc animated:YES];
            return;
        }
        case ResumeRowTypeInterest: {
            vc.naviTitle = @"兴趣爱好";
            vc.value = resumeDto.hobby;
            break;
        }
        case ResumeRowTypeSelfIntroduction: {
            vc.naviTitle = @"自我介绍";
            vc.value = resumeDto.introduction;
            break;
        }
        case ResumeRowTypeHonour: {
            vc.naviTitle = @"所获荣誉";
            vc.value = resumeDto.honor;
            break;
        }
        case ResumeRowTypeResidential: {
            vc.value = resumeDto.liveProvince;
            break;
        }
        case ResumeRowTypeWorkExperience: {
            vc.workType = resumeDto.workExperience;
            break;
        }
        default: {
            return;
            break;
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickCell:(id)on action:(NSNumber *)action
{
    if (action.integerValue == 1000) {
        BOOL needNet = (self.comeFrom == MyResumeViewControllerComeFromRegister) ? NO : YES;
        resumeDto.privacy = [(NSNumber *)on boolValue];
        if (needNet) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:@(MethodType_Resume_Put) forKey:@"method"];
            [param setObject:resumeDto.resumeId forKey:@"resumeId"];
            [param setObject:@(resumeDto.privacy) forKey:@"privacy"];
            [UserManager setData:param success:^(id JSON) {
               
            } failure:^(NSError *error, id JSON) {
                
            }];
        }
    }
}

#pragma mark - ResumeEditViewControllerDelegate
- (void)updateType:(ResumeRowType)type key:(NSUInteger)key index:(NSIndexPath *)index
{
    ResumeDTO *dto = dataArray[index.row];
    switch (type) {
        case ResumeRowTypeGender: {
            resumeDto.gender = (Gender_Types)key;
            dto.value = [GenderTypes getLabel:(Gender_Types)key];
            dto.gender = (Gender_Types)key;
            break;
        }
        case ResumeRowTypeWorkExperience: {
            resumeDto.workExperience = (WorkExperienceType)key;
            dto.value = resumeDto.workExperienceStr;
            dto.workExperience = (WorkExperienceType)key;
            break;
        }
        default: {
            break;
        }
    }
    [table reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateType:(ResumeRowType)type value:(NSString *)value index:(NSIndexPath *)index
{
    ResumeDTO *dto = dataArray[index.row];
    switch (type) {
        case ResumeRowTypeName: {
            resumeDto.name = value;
            dto.value = value;
            break;
        }
        case ResumeRowTypeBirthplace: {
            resumeDto.birthProvince = value;
            dto.value = value;
            break;
        }
        case ResumeRowTypeBirthday: {
            resumeDto.birthday = [DateUtil convertTime:value formate:@"yyyy-MM-dd"];
            dto.value = value;
            break;
        }
        case ResumeRowTypePhone: {
            resumeDto.mobile = value;
            dto.value = value;
            break;
        }
        case ResumeRowTypeInterest: {
            resumeDto.hobby = value;
            dto.value = value;
            break;
        }
        case ResumeRowTypeSelfIntroduction: {
            resumeDto.introduction = value;
            dto.value = value;
            break;
        }
        case ResumeRowTypeHonour: {
            resumeDto.honor = value;
            dto.value = value;
            break;
        }
        case ResumeRowTypeResidential: {
            resumeDto.liveProvince = value;
            dto.value = value;
            break;
        }
        default: {
            break;
        }
    }
    [table reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UploadDelegate
#pragma mark upload image
- (void)didSavePhoto:(NSDictionary *)userInfo
{
    uploadFile = [userInfo objectForKey:@"file"];
    if (uploadFile != nil) {
        [UploadUtil setHost:[MedGlobal getHost]];
        [UploadUtil setAction:@"file/upload"];
        [UploadUtil setUploadKey:@"file"];
        [UploadUtil uploadFile:uploadFile header:[Request getHeader] params:nil delegate:self];
    }
}

- (void)uploadSucceeded:(NSString *)filePath ret:(NSDictionary *)ret
{
    NSArray *array = [ret objectForKey:@"result"];
    if (array.count > 0) {
        NSDictionary *dict = [array firstObject];
        resumeDto.avater = [dict objectForKey:@"file_id"];
        
        BOOL needNet = (self.comeFrom == MyResumeViewControllerComeFromRegister) ? NO : YES;
        if (needNet) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:@(MethodType_Resume_Put) forKey:@"method"];
            [param setObject:resumeDto.resumeId forKey:@"resumeId"];
            [param setObject:resumeDto.avater forKey:@"photo"];
            [UserManager setData:param success:^(id JSON) {
                ResumeDTO *dto = dataArray[currentIndex.row];
                dto.value = resumeDto.avater;
                [table reloadRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationNone];
            } failure:^(NSError *error, id JSON) {
                
            }];
        } else {
            ResumeDTO *dto = dataArray[currentIndex.row];
            dto.value = resumeDto.avater;
            [table reloadRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    [self cleanImages];
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

- (void)uploadFailed:(NSString *)filePath error:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"上传失败，请选择重传或放弃" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"重传", nil];
    alert.tag = 1000;
    [alert show];
}

#pragma mark - click
- (void)clickLeft
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ImproveThePersonalInformationSuccessNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSave
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(MethodType_Resume_Put) forKey:@"method"];
    [param setObject:resumeDto.resumeId forKey:@"resumeId"];
    if (resumeDto.name.length > 0) {
        [param setObject:resumeDto.name forKey:@"real_name"];
    }
    if (resumeDto.gender > 0) {
        [param setObject:@(resumeDto.gender) forKey:@"gender"];
    }
    if (resumeDto.avater > 0) {
        [param setObject:resumeDto.avater forKey:@"photo"];
    }
    if (resumeDto.birthday > 0) {
        [param setObject:[DateUtil getFormatTime:resumeDto.birthday format:@"yyyy-HH-dd HH:mm:ss"] forKey:@"birthday"];
    }
    if (resumeDto.mobile.length > 0) {
        [param setObject:resumeDto.mobile forKey:@"mobile"];
    }
    if (resumeDto.birthProvince.length > 0) {
        [param setObject:resumeDto.birthProvince forKey:@"birth_province"];
    }
    if (resumeDto.liveProvince.length > 0) {
        [param setObject:resumeDto.liveProvince forKey:@"live_province"];
    }
    if (resumeDto.introduction.length > 0) {
        [param setObject:resumeDto.introduction forKey:@"self_introduction"];
    }
    if (resumeDto.honor.length > 0) {
        [param setObject:resumeDto.honor forKey:@"honor"];
    }
    if (resumeDto.workExperience > 0) {
        [param setObject:@(resumeDto.workExperience) forKey:@"work_experience"];
    }
    [param setObject:@(resumeDto.privacy) forKey:@"privacy"];
    [[ProgressHUD instance] showProgressHD:YES inView:self.view info:@"保存中..."];
    [UserManager setData:param success:^(id JSON) {
        [[ProgressHUD instance] showProgressHD:NO inView:self.view info:@"保存成功"];
        NSLog(@"json - %@", JSON);
        if ([JSON[@"success"] boolValue]) {
            if (self.comeFrom == MyResumeViewControllerComeFromRegister) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ImproveThePersonalInformationSuccessNotification object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            if (JSON[@"message"]) {
                [InfoAlertView showInfo:JSON[@"message"] inView:self.view duration:1.5];
            }
        }
    } failure:^(NSError *error, id JSON) {
        [[ProgressHUD instance] showProgressHD:NO inView:self.view info:@"保存失败"];
    }];
}

- (void)clickDelivery
{
    if (self.comeFrom == MyResumeViewControllerComeFromPostDetail) {
        NSString *msg = nil;
        if (resumeDto.avater.length == 0) {
            msg = @"您还没有上传照片";
        }
        if (resumeDto.name.length == 0) {
            msg = @"您还没有填写填写姓名";
        }
        if (resumeDto.gender == 0) {
            msg = @"您还没有填写选择性别";
        }
        if (resumeDto.birthProvince.length == 0) {
            msg = @"您还没有填写出生地";
        }
        if (resumeDto.workExperience < WorkExperienceTypeOverOne) {
            msg = @"您还没有填写工作经验";
        }
        if (resumeDto.liveProvince.length == 0) {
            msg = @"您还没有填写现居住地";
        }
        if (resumeDto.mobile.length == 0) {
            msg = @"您还没有填写联系电话";
        }
        if (resumeDto.eduList.count == 0) {
            msg = @"您还没有填写教育经历";
        }
        if (resumeDto.introduction.length == 0) {
            msg = @"您还没有填写自我介绍";
        }
        if (self.positionId.length == 0) {
            msg = @"未获取正确的职位信息";
        }
        if (msg.length > 0) {
            [InfoAlertView showInfo:msg inView:self.view duration:1];
            return;
        }
        [[ProgressHUD instance] showProgressHD:YES inView:self.view info:@"投递中..."];
        NSDictionary *param = @{
                                @"method":@(MethodType_Resume_Post),
                                @"position_id":self.positionId
                                };
        [ServiceManager setData:param success:^(id JSON) {
            [[ProgressHUD instance] showProgressHD:NO inView:self.view info:@"投递中"];
            if ([JSON[@"success"] boolValue]) {
                [InfoAlertView showInfo:@"投递成功" inView:self.view duration:1.5];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [InfoAlertView showInfo:JSON[@"message"] duration:1.5];
            }
        } failure:^(NSError *error, id JSON) {
            [[ProgressHUD instance] showProgressHD:NO inView:self.view info:@"投递中"];
        }];
    }
}

- (void)updateInfo:(NSDictionary *)info
{
    PairDTO *dto = dataArray[currentIndex.row];
    NSInteger type = [info[@"experience"] integerValue];
    if (type == 1) { //edu
        resumeDto.eduList = [AccountHelper getAccount].educationArray;
        NSInteger educationArray = resumeDto.eduList.count;
        if (educationArray > 0) {
            NSDictionary *dict =  [resumeDto.eduList objectAtIndex:0];
            NSString *organization =[dict objectForKey:@"organization"];
            if (educationArray == 1) {
                dto.key = organization;
            } else {
                dto.key = [NSString stringWithFormat:@"%@等%ld个教育经历", organization, (long)educationArray];
            }
        } else {
            dto.key = @"待完善";
        }
    } else { // work
        resumeDto.workList = [AccountHelper getAccount].experienceArray;
        NSInteger experienceCount = resumeDto.workList.count;
        if (experienceCount > 0) {
            NSDictionary *dict =  [resumeDto.workList objectAtIndex:0];
            NSString *organization =[dict objectForKey:@"organization"];
            if (experienceCount == 1) {
                dto.key = organization;
            } else {
                dto.key = [NSString stringWithFormat:@"%@等%ld个工作经历", organization, (long)experienceCount];
            }
        } else {
            dto.key = @"待完善";
        }
    }
    [table reloadRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationNone];
}

@end
