//
//  PersonEditViewController.m
//  medtree
//
//  Created by 无忧 on 14-8-25.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PersonEditViewController.h"
#import "PairCell.h"
#import "UserDTO.h"
#import "ServiceManager+Public.h"
#import "AccountHelper.h"
#import "PersonEditSetViewController.h"
#import "MorePairCell.h"
#import "RelationTypes.h"
#import "PersonEditAddCell.h"
#import "PersonEditPhotoCell.h"
#import "BaseTableViewDelegate.h"
#import "GenderTypes.h"
#import "TitleAndDetailView.h"
#import "ImagePicker.h"
#import "UploadUtil.h"
#import "FileUtil.h"
#import "Request.h"
#import "CommonHelper.h"
#import "FontUtil.h"
#import "PersonExperienceCell.h"
#import "PersonInterestCell.h"
#import "PersonCertificationCell.h"
#import "IdentificationController.h"
#import "UserManager.h"
#import "CertificationDTO.h"
#import "JSONKit.h"
#import "MedGlobal.h"

@interface PersonEditViewController () <UITableViewDataSource, UITableViewDelegate, BaseTableViewDelegate, TitleAndDetailViewDelegate,ImagePickerDelegate, UploadDelegate,PersonEditSetViewControllerDelegate>
{
    NSString                    *uploadFile;
    UserDTO                     *userDTO;
    UITableView                 *table;
    NSMutableArray              *titleArray;
    NSMutableArray              *countArray;
    NSMutableArray              *certificationArray;
}

@end

@implementation PersonEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickBack
{
    [self.parent reloadView];
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)createBackButton
//{
//    UIButton *backButton = [NavigationBar createImageButton:@"btn_back.png" selectedImage:@"btn_back_click.png" target:self action:@selector(clickBack)];
//    [naviBar setLeftButton:backButton];
//}

- (void)createUI
{
    [super createUI];
    certificationArray = [[NSMutableArray alloc] init];
    titleArray = [[NSMutableArray alloc] initWithObjects:[NSNull null],@"",@"",@"",@"",@"", @"",nil];
    countArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:3],[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2], nil];
    
    [naviBar setTopTitle:@"编辑个人信息"];
    [self createBackButton];
    
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCertificatedData:) name:UserInfoChangeCertificatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChanged) name:UserInfoChangeNotification object:nil];
}

- (NSDictionary *)getParam_FromNet
{
    return @{@"userid": userDTO.userID,@"method": [NSNumber numberWithInteger:MethodType_UserInfo]};
}

- (void)userInfoChanged
{
    [ServiceManager getData:[self getParam_FromNet] success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            userDTO = (UserDTO *)JSON;
            [table reloadData];
        });
    } failure:^(NSError *error, id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

- (void)loadCertificatedData:(NSNotification *)notification
{
    CertificationDTO *dto = (CertificationDTO *)notification.object;
    if (certificationArray.count > 0) {
        BOOL isFind = NO;
        for (int i = 0; i < certificationArray.count; i ++) {
            CertificationDTO *cDTO = [certificationArray objectAtIndex:i];
            if (dto.userType == cDTO.userType) {
                [certificationArray replaceObjectAtIndex:i withObject:dto];
                isFind = YES;
                break;
            }
        }
        if (!isFind) {
            [certificationArray addObject:dto];
        }
    } else {
        [certificationArray addObject:dto];
    }
    [self updateCertificationInfo];
    [table reloadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize size = self.view.frame.size;
    table.frame = CGRectMake(0, [self getOffset]+44, size.width, size.height-([self getOffset]+44));
}

- (void)setInfo:(UserDTO *)dto
{
    userDTO = dto;
    [countArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithInteger:userDTO.educationArray.count]];
    [countArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithInteger:userDTO.experienceArray.count]];
    
    [ServiceManager getData:@{@"userid": [[AccountHelper getAccount] userID],@"method": [NSNumber numberWithInteger:MethodType_UserInfo]} success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self hideProgress];
            userDTO = (UserDTO *)JSON;
            [countArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithInteger:userDTO.educationArray.count]];
            [countArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithInteger:userDTO.experienceArray.count]];
            [table reloadData];
        });
    } failure:^(NSError *error, id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];

    {
        [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"certificationInfo"} success:^(id JSON) {
            NSArray *array = [NSArray arrayWithArray:JSON];
            if (array.count > 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:0]];
                [certificationArray removeAllObjects];
                NSArray *array1 = [NSArray arrayWithArray:[dict objectForKey:@"certification"]];
                for (int i = 0; i < [array1 count]; i ++) {
                    NSDictionary *dict = [[array1 objectAtIndex:i] objectFromJSONString];
                    CertificationDTO *dto = [[CertificationDTO alloc] init:dict];
                    [certificationArray addObject:dto];
                }
                [table reloadData];
            }
        } failure:^(NSError *error, id JSON) {
            
        }];
    }
    {
        [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_Certification]} success:^(id JSON) {
            [certificationArray removeAllObjects];
            [certificationArray addObjectsFromArray:JSON];
            [self updateCertificationInfo];
            [table reloadData];
        } failure:^(NSError *error, id JSON) {
            
        }];
    }
    [table reloadData];
}

- (void)updateCertificationInfo
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < certificationArray.count; i ++) {
        CertificationDTO *dto = [certificationArray objectAtIndex:i];
        [array addObject:[[dto JSON] JSONString]];
    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    DTOBase *dto = [[DTOBase alloc] init:@{@"certification":array}];
        [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"certificationInfo",@"info":dto} success:^(id JSON) {
        } failure:^(NSError *error, id JSON) {
            
        }];
//    });
}

#pragma mark -
#pragma mark table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return countArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = 1;
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"Cell0";
        PersonEditPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[PersonEditPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.parent = self;
        [cell setInfo:userDTO indexPath:indexPath];
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"Cell1";
        MorePairCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MorePairCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.parent = self;
        cell.parent2 = self;
        [cell setInfo:[NSArray arrayWithObjects:@{@"title":@"姓名",@"detail":userDTO.name},@{@"title":@"性别",@"detail":[GenderTypes getLabel:userDTO.gender]},@{@"title":@"出生日期",@"detail":userDTO.birthday}, nil] indexPath:indexPath];
        [cell allShowNext:YES];
        return cell;
    } else if (indexPath.section == 3 || indexPath.section == 4) {
        static NSString *CellIdentifier = @"Cell2";
        PersonExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[PersonExperienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.parent = self;
        cell.parent2 = self;
        if (indexPath.section == 4) {
            [cell setInfo:@{@"array":userDTO.educationArray.count>0?userDTO.educationArray:[NSNull null],@"title":@"教育经历",@"add":@"增加教育经历",@"isAdd":[NSNumber numberWithBool:YES],@"type":[NSNumber numberWithInt:0]} indexPath:indexPath];
        } else if (indexPath.section == 3) {
            [cell setInfo:@{@"array":userDTO.experienceArray.count>0?userDTO.experienceArray:[NSNull null],@"title":@"工作经历",@"add":@"增加工作经历",@"isAdd":[NSNumber numberWithBool:YES],@"type":[NSNumber numberWithInt:0]} indexPath:indexPath];
        }
        return cell;
    } else if (indexPath.section == 5) {
        static NSString *CellIdentifier = @"Cell4";
        PersonInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[PersonInterestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        [cell showNext];
        cell.parent = self;
        if (userDTO.interest.length > 0) {
            [cell setInfo:@{@"interest":userDTO.interest} indexPath:indexPath];
        } else {
            [cell setInfo:@{@"interest":@"未填写"} indexPath:indexPath];
        }
        return cell;
    } else if (indexPath.section == 2) {
        static NSString *CellIdentifier = @"Cell2";
        PersonExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[PersonExperienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.parent = self;
        cell.parent2 = self;
        [cell setInfo:@{@"array":certificationArray.count>0?certificationArray:[NSNull null],@"title":@"认证信息",@"add":@"增加认证信息",@"isAdd":certificationArray.count>6?[NSNumber numberWithBool:NO]:[NSNumber numberWithBool:YES],@"type":[NSNumber numberWithInt:1]} indexPath:indexPath];
        return cell;
    } else {
        static NSString *CellIdentifier = @"Cell111";
        MorePairCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MorePairCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        [cell setInfo:[NSArray arrayWithObjects:@{@"title":@"医树号",@"detail":userDTO.userID},@{@"title":@"注册时间",@"detail":userDTO.regtime}, nil] indexPath:indexPath];
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == table)
    {
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 20;
    if ((NSObject *)[titleArray objectAtIndex:section] == [NSNull null]) {
        height = 0;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 30)];
    header.text = [titleArray objectAtIndex:section];
    header.font = [UIFont systemFontOfSize:12];
    header.textColor = [UIColor darkGrayColor];
    header.backgroundColor = [UIColor clearColor];
    [view addSubview:header];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (userDTO == nil) {
        return 0;
    }
    if (indexPath.section == 0) {
        return 44;
    } else if (indexPath.section == 1) {
        return 46*3;
    } else if (indexPath.section == 4) {
        if (indexPath.row < userDTO.educationArray.count) {
            return [PersonExperienceCell getCellHeight:@{@"array":userDTO.educationArray.count>0?userDTO.educationArray:[NSNull null],@"title":@"教育经历",@"add":@"增加教育经历",@"isAdd":[NSNumber numberWithBool:YES],@"type":[NSNumber numberWithInt:0]} width:self.view.frame.size.width-80];
        } else {
            return 46;
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row < userDTO.experienceArray.count) {
            return [PersonExperienceCell getCellHeight:@{@"array":userDTO.experienceArray.count>0?userDTO.experienceArray:[NSNull null],@"title":@"工作经历",@"add":@"增加工作经历",@"isAdd":[NSNumber numberWithBool:YES],@"type":[NSNumber numberWithInt:0]} width:self.view.frame.size.width-80];
        } else {
            return 46;
        }
    } else if (indexPath.section == 5) {
        return [PersonInterestCell getCellHeight:userDTO.interest.length>0?@{@"interest":userDTO.interest}:@{@"interest":@"未填写"} width:self.view.frame.size.width];
    } else if (indexPath.section == 2)  {
        return [PersonExperienceCell getCellHeight:@{@"array":certificationArray.count>0?certificationArray:[NSNull null],@"title":@"认证信息",@"add":@"增加认证信息",@"isAdd":certificationArray.count>7?[NSNumber numberWithBool:NO]:[NSNumber numberWithBool:YES],@"type":[NSNumber numberWithInt:1]} width:self.view.frame.size.width-80];
    } else {
        return 46*2;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark Edit Other Info

- (void)updateInfo:(NSDictionary *)dict
{
    userDTO.interest = [dict objectForKey:@"detail"];
    [table reloadData];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if (index.section == 0 && index.row == 0) {
        [ImagePicker setAllowsEditing:YES];
        [ImagePicker showSheet:@{@"userid":userDTO.userID} uvc:self delegate:self];
    } else if (index.section == 5) {
        /*
        RegisterAddNewController *add = [[RegisterAddNewController alloc] init];
        [self.navigationController pushViewController:add animated:YES];
        add.parent = self;
        [add setInterestInfo:userDTO.interest];
         */
    }
}

- (void)clickiViewIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag
{
    NSLog(@"indexPath%@  %@",indexPath, @(tag));
    if (indexPath.section == 1) {
        PersonEditSetViewController *set = [[PersonEditSetViewController alloc] init];
        [self.navigationController pushViewController:set animated:YES];
        set.parent = self;
        if (tag == 0) {
            [set setNaviTitle:@"姓名"];
            [set setUserInfo:@{@"index":indexPath,@"detail":userDTO.name,@"tag":[NSNumber numberWithInteger:tag]}];
        } else if (tag == 1) {
            [set setNaviTitle:@"性别"];
            [set setUserInfo:@{@"index":indexPath,@"detail":[GenderTypes getLabel:userDTO.gender],@"tag":[NSNumber numberWithInteger:tag]}];
        } else {
            [set setNaviTitle:@"生日"];
            [set setUserInfo:@{@"index":indexPath,@"detail":userDTO.birthday,@"tag":[NSNumber numberWithInteger:tag]}];
        }
    } else if (indexPath.section == 3 || indexPath.section == 4) {
        NSMutableDictionary *organizationDict = [NSMutableDictionary dictionary];
        [organizationDict setObject:indexPath forKey:@"index"];
        [organizationDict setObject:[NSNumber numberWithInteger:tag] forKey:@"tag"];
        
        /*
        PersonEditOrganizationController *organization = [[PersonEditOrganizationController alloc] init];
        [self.navigationController pushViewController:organization animated:YES];
        organization.parent = self;
        organization.parent2 = self;
        if (indexPath.section == 4) {
            if (tag < userDTO.educationArray.count) {
                NSDictionary *dict = [userDTO.educationArray objectAtIndex:tag];
                if ((NSObject *)[dict objectForKey:@"organization"] == [NSNull null]) {
                    [organization setNaviTitle:@"教育经历"];
                } else {
                    [organization setNaviTitle:[dict objectForKey:@"organization"]];
                }
                [organizationDict setObject:dict forKey:@"dict"];
                [organizationDict setObject:[NSNumber numberWithBool:NO] forKey:@"isAdd"];
            } else {
                [organization setNaviTitle:@"添加教育经历"];
                [organizationDict setObject:[NSNumber numberWithBool:YES] forKey:@"isAdd"];
            }
        } else if (indexPath.section == 3) {
            if (tag < userDTO.experienceArray.count) {
                NSDictionary *dict = [userDTO.experienceArray objectAtIndex:tag];
                if ((NSObject *)[dict objectForKey:@"organization"] == [NSNull null]) {
                    [organization setNaviTitle:@"工作经历"];
                } else {
                    [organization setNaviTitle:[dict objectForKey:@"organization"]];
                }
                [organizationDict setObject:dict forKey:@"dict"];
                [organizationDict setObject:[NSNumber numberWithBool:NO] forKey:@"isAdd"];
            } else {
                [organization setNaviTitle:@"添加工作经历"];
                [organizationDict setObject:[NSNumber numberWithBool:YES] forKey:@"isAdd"];
            }
        }
        [organization setInfo:organizationDict];
         */
    } else if (indexPath.section == 2) {
        if (tag < certificationArray.count) {
            /*
            PersonCertificationController *view = [[PersonCertificationController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
            [view setCertificationDTOInfo:[certificationArray objectAtIndex:tag]];
             */
        } else {
            IdentificationController *view = [[IdentificationController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
            [view setisPerson:YES];
            [view setDataInfo:certificationArray];
        }
    }
}

#pragma mark -
#pragma mark upload image
- (void)didSavePhoto:(NSDictionary *)userInfo
{
    uploadFile = [userInfo objectForKey:@"file"];
    [self uploadImages];
}

/*清空提交完毕的混存文件*/
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

- (void)uploadProgressUpdated:(NSString *)filePath percent:(float)percent
{
    
}

- (void)uploadSucceeded:(NSString *)filePath ret:(NSDictionary *)ret
{
    NSArray *array = [ret objectForKey:@"result"];
    if (array.count > 0) {
        NSDictionary *dict = [array objectAtIndex:0];
        userDTO.photoID = [dict objectForKey:@"file_id"];
        [UserManager checkUser:userDTO];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
    }
//    userDTO.photoID = [[ret objectForKey:@"result"] objectForKey:@"file_id"];
    [table reloadData];
    [self cleanImages];
    
}

- (void)uploadFailed:(NSString *)filePath error:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"上传失败，请选择重传或放弃" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"重传", nil];
    alert.tag = 1000;
    [alert show];
}

- (void)unreachableHost:(NSString *)theFilePath error:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络连接失败，请选择重传或放弃" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"重传", nil];
    alert.tag = 1000;
    [alert show];
}

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

#pragma mark -
#pragma mark change user info
- (void)updateUserInfo:(NSDictionary *)dict
{
    NSIndexPath *index = [dict objectForKey:@"index"];
    NSInteger tag = [[dict objectForKey:@"tag"] integerValue];
    if (index.section == 5) {
        userDTO.interest = [dict objectForKey:@"detail"];
    } else if (index.section == 1 ) {
        if (tag == 0) {
            userDTO.name = [dict objectForKey:@"detail"];
        } else if (tag == 1) {
            userDTO.gender = [[dict objectForKey:@"detail"] integerValue];
        } else {
            userDTO.birthday = [dict objectForKey:@"detail"];
        }
    } else if (index.section == 4) {
        if (tag < userDTO.educationArray.count) {
            [userDTO.educationArray replaceObjectAtIndex:tag withObject:[dict objectForKey:@"dict"]];
        } else {
            [userDTO.educationArray addObject:[dict objectForKey:@"dict"]];
        }
        [userDTO updateInfo:userDTO.educationArray forKey:@"educationArray"];
    } else if (index.section == 3) {
        if (tag < userDTO.experienceArray.count) {
            [userDTO.experienceArray replaceObjectAtIndex:tag withObject:[dict objectForKey:@"dict"]];
        } else {
            [userDTO.experienceArray addObject:[dict objectForKey:@"dict"]];
        }
        [userDTO updateInfo:userDTO.experienceArray forKey:@"experienceArray"];
    }
    [UserManager checkUser:userDTO];
    [self.parent reloadView];
    
    [table reloadData];
}

- (void)deleteUserExperience:(NSDictionary *)dict
{
    NSIndexPath *idx = [dict objectForKey:@"index"];
    if (idx.section == 4) {
        for (int i = 0; i < userDTO.educationArray.count; i ++) {
            NSDictionary *udict = [userDTO.educationArray objectAtIndex:i];
            if ([[udict objectForKey:@"organization_id"] isEqualToString:[[dict objectForKey:@"dict"] objectForKey:@"organization_id"]]) {
                [userDTO.educationArray removeObjectAtIndex:i];
                [userDTO updateInfo:userDTO.educationArray forKey:@"educationArray"];
                break;
            }
        }
    } else {
        for (int i = 0; i < userDTO.experienceArray.count; i ++) {
            NSDictionary *udict = [userDTO.experienceArray objectAtIndex:i];
            if ([[udict objectForKey:@"organization_id"] isEqualToString:[[dict objectForKey:@"dict"] objectForKey:@"organization_id"]]) {
                [userDTO.experienceArray removeObjectAtIndex:i];
                [userDTO updateInfo:userDTO.experienceArray forKey:@"experienceArray"];
                break;
            }
        }
    }
    [UserManager checkUser:userDTO];
    [self.parent reloadView];
    [table reloadData];
}

@end
