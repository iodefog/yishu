//
//  EditPersonCardInfoController.m
//  medtree
//
//  Created by 陈升军 on 15/8/5.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "EditPersonCardInfoController.h"
#import "UserDTO.h"
#import "NewPersonEditCell.h"
#import "PairDTO.h"
#import "GenderTypes.h"
#import "ImagePicker.h"
#import "FileUtil.h"
#import "UploadUtil.h"
#import "AccountHelper.h"
#import "UserManager.h"
#import "MedGlobal.h"
#import "AcademicTagController.h"
#import "CardInfoPickerController.h"
#import "CardInfoTextController.h"

@interface EditPersonCardInfoController () <ImagePickerDelegate, UploadDelegate, AcademicTagControllerDelegate>
{
    NSMutableArray          *userInfoArray;
    NSString                *uploadFile;
}
@end

@implementation EditPersonCardInfoController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    [naviBar setTopTitle:@"编辑名片信息"];
    [self createBackButton];
    table.enableHeader = NO;
    table.enableFooter = NO;
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    [table registerCells:@{@"PairDTO": [NewPersonEditCell class]}];
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTable) name:UserInfoChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDTO = [AccountHelper getAccount];
    userInfoArray = [[NSMutableArray alloc] init];
    [self setupData];
    [self setupView];
}

- (void)setupData
{
    [userInfoArray removeAllObjects];
    [self setTable];
}

- (void)setupView
{
    
}

- (void)setTable
{
    [userInfoArray removeAllObjects];
    NSString *commonStr = @"待完善";
    {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = @"头像";
        dto.value = _userDTO.photoID;
        dto.cellType = 0;
        [userInfoArray addObject:dto];
    }
    {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = @"姓名";
        dto.value = _userDTO.name;
        dto.cellType = 1;
        [userInfoArray addObject:dto];
    }
    {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = @"性别";
        dto.value = [GenderTypes getLabel:_userDTO.gender];
        dto.cellType = 1;
        [userInfoArray addObject:dto];
    }
    {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = @"出生日期";
        NSString *birthday = [_userDTO.birthday stringByReplacingOccurrencesOfString:@"." withString:@"-"];
        dto.value = _userDTO.birthday.length > 0 ? birthday : commonStr;
        dto.cellType = 1;
        [userInfoArray addObject:dto];
    }
//    {
//        PairDTO *dto = [[PairDTO alloc] init:@{}];
//        dto.key = @"任(兼)职";
//        dto.value = _userDTO.sideline.length > 0 ? _userDTO.sideline : commonStr;
//        dto.cellType = 2;
//        [userInfoArray addObject:dto];
//    }
    {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = @"个人成就";
        dto.value = _userDTO.achievement.length > 0 ? _userDTO.achievement : commonStr;
        dto.cellType = 2;
        [userInfoArray addObject:dto];
    }
    {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = @"学术标签";
        dto.value = _userDTO.academic_tags.count > 0 ? @"" : commonStr;
        dto.cellType = 1;
        [userInfoArray addObject:dto];
    }
    [table setData:[NSArray arrayWithObjects:userInfoArray, nil]];
}

#pragma mark - cell delegate
- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    switch (index.row) {
        case 0:
            [ImagePicker setAllowsEditing:YES];
            [ImagePicker showSheet:@{@"userid":_userDTO.userID} uvc:self delegate:self];
            break;
        case 1:
        case 4:
        {
            CardInfoTextController *vc = [[CardInfoTextController alloc] init];
            if (index.row == 1) {
                vc.textType = CardInfoTextType_Name;
            } else if (index.row == 4) {
                vc.textType = CardInfoTextType_Achievement;
            }
            vc.parent = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        case 3:
        {
            CardInfoPickerController *vc = [[CardInfoPickerController alloc] init];
            if (index.row == 2) {
                vc.pickerType = PickerType_Gender;
            } else if (index.row == 3) {
                vc.pickerType = PickerType_Birthday;
            }
            vc.parent = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:
        {
            AcademicTagController *vc = [[AcademicTagController alloc] init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UploadDelegate
#pragma mark upload image
- (void)didSavePhoto:(NSDictionary *)userInfo
{
    uploadFile = [userInfo objectForKey:@"file"];
    [self uploadImages];
}

- (void)uploadImages
{
    if (uploadFile != nil) {
        //
        [UploadUtil setHost:[MedGlobal getHost]];
        [UploadUtil setAction:@"file/upload/avatar"];
        [UploadUtil setUploadKey:@"file"];
        [UploadUtil uploadFile:uploadFile header:[Request getHeader] params:nil delegate:self];
    }
}

- (void)uploadSucceeded:(NSString *)filePath ret:(NSDictionary *)ret
{
    NSArray *array = [ret objectForKey:@"result"];
    if (array.count > 0) {
        NSDictionary *dict = [array objectAtIndex:0];
        _userDTO.photoID = [dict objectForKey:@"file_id"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [AccountHelper setAccount:_userDTO];
            [self setUserDTO:_userDTO];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
        });
    }
    [table reloadData];
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
    //
    uploadFile = nil;
}

- (void)uploadFailed:(NSString *)filePath error:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"上传失败，请选择重传或放弃" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"重传", nil];
    alert.tag = 1000;
    [alert show];
}

#pragma mark - AcademicTagControllerDelegate
- (void)updateParentVC:(UserDTO *)dto
{
    _userDTO = dto;
    [self setupData];
}

@end
