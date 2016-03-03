//
//  NewPersonEditViewController.m
//  medtree
//
//  Created by 边大朋 on 15-3-30.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewPersonEditViewController.h"
#import "NewPersonEditCell.h"
#import "BlankCell.h"
#import "PairDTO.h"
#import "Pair2DTO.h"
#import "Pair3DTO.h"
#import "UserDTO.h"
#import "AccountHelper.h"
#import "GenderTypes.h"
#import "Request.h"
#import "UserManager.h"
#import "FileUtil.h"
#import "TitleAndDetailView.h"
#import "PersonEditSetViewController.h"
#import "RegisterAddNewController.h"
#import "NewGenderPickerView.h"
#import "ServiceManager.h"
#import "NewDatePickerView.h"
#import "NewTextField.h"
#import "InfoAlertView.h"
#import "ExperienceListController.h"
#import "ExperienceDTO.h"
#import "PersonCardInfoCell.h"
#import "PersonEditCardInfoCell.h"
#import "EditPersonCardInfoController.h"
#import "ExperienceDetailController.h"


@interface NewPersonEditViewController ()<RegisterAddNewControllerDelegate, PersonEditSetViewControllerDelegate, NewGenderPickerViewDelegate, NewDatePickerViewDelegate, ExperienceDetailControllerDelegate>
{
    UserDTO                     *udto;
    NSMutableArray              *certificationArray;
    NSMutableArray              *userInfoArray;
    NewGenderPickerView         *genderPicker;
    NewDatePickerView           *datePicker;
    NewTextField                *textField;
    UILabel                     *valueLabel;
    NSString                    *tmpNameStr;//暂存旧用户名
}
@end

@implementation NewPersonEditViewController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    certificationArray = [[NSMutableArray alloc] init];
    userInfoArray = [[NSMutableArray alloc] init];
    
    [naviBar setTopTitle:@"编辑个人信息"];
    [self createBackButton];
    table.enableHeader = NO;
    table.enableFooter = NO;
    [table setIsNeedFootView:NO];
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    [table registerCells:@{@"PairDTO": [NewPersonEditCell class],@"Pair2DTO":[BlankCell class],@"UserDTO":[PersonCardInfoCell class],@"Pair3DTO":[PersonEditCardInfoCell class]}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize size = self.view.frame.size;
    genderPicker.frame = CGRectMake(0, 0, size.width, size.height);
    datePicker.frame = CGRectMake(0, 0, size.width, size.height);
    [self.view bringSubviewToFront:genderPicker];
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFromNet) name:UserInfoChangeNotification object:nil];
}

- (void)createEditDatePicker
{
    datePicker = [[NewDatePickerView alloc] init];
    datePicker.parent = self;
    [self.view addSubview:datePicker];
}

#pragma  mark NewGenderPickerViewDelegate
- (void)clickSaveGender:(NSInteger)gender
{
    if (gender == 0) {
        gender = 1;
    }
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:[NSNumber numberWithInteger:gender] forKey:@"value"];
    [dataDict setObject:[NSNumber numberWithInteger:gender] forKey:@"detail"];
    [dataDict setObject:@"gender" forKey:@"key"];
    [self saveUserInfo:dataDict indexForLine:3];
}

#pragma  mark NewDatePickerViewDelegate
- (void)clickSaveDate
{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    [dataDict setObject:datePicker.startTime forKey:@"detail"];
    
    [dataDict setObject:[NSString stringWithFormat:@"%@ 00:00:00",[datePicker.startTime stringByReplacingOccurrencesOfString:@"." withString:@"-"]] forKey:@"value"];
    [dataDict setObject:@"birthday" forKey:@"key"];
    [self saveUserInfo:dataDict indexForLine:4];
}

#pragma mark - private
- (void)clickSaveName:(NSArray *)array
{
    textField = [array objectAtIndex:0];
    valueLabel = [array objectAtIndex:1];
    valueLabel.text = @"";
    if (textField.text.length == 0) {
        [InfoAlertView showInfo:@"请填写您的姓名" inView:self.view duration:1];
        return;
    }
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:textField.text forKey:@"value"];
    [dataDict setObject:textField.text forKey:@"detail"];
    [dataDict setObject:@"realname" forKey:@"key"];
    [self saveUserInfo:dataDict indexForLine:2];
}

//保存用户信息
- (void)saveUserInfo:(NSMutableDictionary *)dataDict indexForLine:(NSInteger)index
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSArray arrayWithObject:dataDict] forKey:@"data"];
    [dict setObject:[NSNumber numberWithInt:MethodType_UserInfo_Update] forKey:@"method"];
    
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
   
    [ServiceManager setData:dict success:^(id JSON) {
         NSIndexPath *index;
        if ([[dataDict objectForKey:@"key"] isEqualToString:@"gender"]) {
            genderPicker.hidden = YES;
            index = [NSIndexPath indexPathForRow:3 inSection:0];
        } else if ([[dataDict objectForKey:@"key"] isEqualToString:@"birthday"]) {
            datePicker.hidden = YES;
            index =  [NSIndexPath indexPathForRow:4 inSection:0];
        } else if ([[dataDict objectForKey:@"key"] isEqualToString:@"realname"]) {
            textField.hidden = YES;
            valueLabel.hidden = NO;
            index =  [NSIndexPath indexPathForRow:2 inSection:0];
        }
        if (index) {
            [infoDict setObject:index forKey:@"index"];
        }
        [infoDict setObject:[dataDict objectForKey:@"detail"] forKey:@"detail"];
        [self updateUserInfo:infoDict];
       
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)getDataFromNet
{
    [ServiceManager getData:[self getParam_FromNet] success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            udto = (UserDTO *)JSON;
            [self getDataFromLocal];
        });
    } failure:^(NSError *error, id JSON) {

    }];
}

- (NSDictionary *)getParam_FromNet
{
    return @{@"userid": udto.userID,@"method": [NSNumber numberWithInteger:MethodType_UserInfo]};
}

- (void)getDataFromLocal
{
    [userInfoArray removeAllObjects];
    NSString *commonStr = @"待完善";
    {
        Pair3DTO *dto = [[Pair3DTO alloc] init:@{}];
        if (!udto.is_card_complete) {
            dto.key = @"(待完善)";
        }
        [userInfoArray addObject:dto];
    }
    {
        [userInfoArray addObject:udto];
    }

    {
        Pair2DTO *dto2 = [[Pair2DTO alloc] init];
        dto2.title = @"详细信息";
        [userInfoArray addObject:dto2];
    }
    {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = @"工作经历";
        NSInteger experienceCount = udto.experienceArray.count;
        if (experienceCount > 0) {
            NSDictionary *dict =  [udto.experienceArray objectAtIndex:0];
            NSString *organization =[dict objectForKey:@"organization"];
            if (experienceCount == 1) {
                dto.value = organization;
            } else {
                dto.value = [NSString stringWithFormat:@"%@等%ld个工作经历", organization, (long)experienceCount];
            }
            
        } else {
            dto.value = commonStr;
        }
        dto.cellType = 2;
        [userInfoArray addObject:dto];
    }
    {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = @"教育经历";
        NSInteger educationArray = udto.educationArray.count;
        if (educationArray > 0) {
            NSDictionary *dict =  [udto.educationArray objectAtIndex:0];
            NSString *organization =[dict objectForKey:@"organization"];
            
            if (educationArray == 1) {
                dto.value = organization;
            } else {
                dto.value = [NSString stringWithFormat:@"%@等%ld个教育经历", organization, (long)educationArray];
            }

        } else {
            dto.value = commonStr;
        }
        dto.cellType = 2;
        [userInfoArray addObject:dto];
    }
    {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = @"兴趣爱好";
        dto.value = udto.interest.length > 0 ? udto.interest : commonStr;
        dto.cellType = 2;
        [userInfoArray addObject:dto];
    }
    {
        Pair2DTO *dto2 = [[Pair2DTO alloc] init];
        dto2.title = @"其他信息";
        [userInfoArray addObject:dto2];
    }
    {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = @"医树号";
        dto.value = udto.userID;
        dto.cellType = 3;
        [userInfoArray addObject:dto];
    }
    {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = @"注册日期";
        dto.value = udto.regtime;
        dto.cellType = 3;
        [userInfoArray addObject:dto];
    }
    
    [table setData:[NSArray arrayWithObjects:userInfoArray, nil]];
}

- (void)getUserInfo
{
    udto = [AccountHelper getAccount];
    [self getDataFromLocal];
}

- (void)setInfo:(UserDTO *)dto
{
    [self getUserInfo];
    [self getDataFromNet];
}

#pragma mark - cell delegate
- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    NSInteger cellLine = index.row;
    switch (cellLine) {
        case 0:
        {
            EditPersonCardInfoController *card = [[EditPersonCardInfoController alloc] init];
          //  card.userDTO = udto;
            [self.navigationController pushViewController:card animated:YES];
            break;
        }
        case 3: //工作经历
        case 4: //教育经历
        {
            ExperienceListController *organizationList = [[ExperienceListController alloc] init];
            organizationList.parent = self;
            organizationList.experienceType = (cellLine == 3) ? ExperienceType_Work: ExperienceType_Edu;
            [self.navigationController pushViewController:organizationList animated:YES];
        }
            break;
        case 5: { // 兴趣爱好
            RegisterAddNewController *add = [[RegisterAddNewController alloc] init];
            add.parent = self;
            add.content = udto.interest;
            add.infoType = EditUserInfoType_Interest;
            [self.navigationController pushViewController:add animated:YES];
            break;
        }
    }
}

#pragma mark -
#pragma mark Edit Other Info

- (void)updateInfo:(NSDictionary *)dict
{
    udto.interest = [dict objectForKey:@"detail"];
    
    NSMutableDictionary *interestDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSIndexPath *index = [NSIndexPath indexPathForRow:8 inSection:0];
    [interestDict setValue:index forKey:@"index"];
    [self updateUserInfo:interestDict];
}

#pragma mark -
#pragma mark change user info
- (void)updateUserInfo:(NSDictionary *)dict
{
    NSIndexPath *index = [dict objectForKey:@"index"];
    NSInteger cellLine = index.row;
    NSInteger tag = [[dict objectForKey:@"tag"] integerValue];
    
    PairDTO *dto = [userInfoArray objectAtIndex:cellLine];
    
    if (cellLine == 5) {
        udto.interest = [dict objectForKey:@"detail"];
        dto.value = udto.interest;
    } if (cellLine == 4) {
        if (0 < udto.educationArray.count) {
            [udto.educationArray replaceObjectAtIndex:tag withObject:[dict objectForKey:@"dict"]];
        } else {
            [udto.educationArray addObject:[dict objectForKey:@"dict"]];
        }
        [udto updateInfo:udto.educationArray forKey:@"educationArray"];
    } else if (cellLine == 3) {
        if (0 < udto.experienceArray.count) {
            [udto.experienceArray replaceObjectAtIndex:tag withObject:[dict objectForKey:@"dict"]];
        } else {
            [udto.experienceArray addObject:[dict objectForKey:@"dict"]];
        }
        [udto updateInfo:udto.experienceArray forKey:@"experienceArray"];
    }
    [UserManager checkUser:udto];
    [AccountHelper setAccount:udto];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
    });
    [userInfoArray replaceObjectAtIndex:cellLine withObject:dto];
    [table setData:[NSArray arrayWithObjects:userInfoArray, nil]];
}

#pragma mark - ExperienceDetailControllerDelegate
- (void)reloadParent:(UserDTO *)dto
{
    [self setInfo:dto];
}

@end
