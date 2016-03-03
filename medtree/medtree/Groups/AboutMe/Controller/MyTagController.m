//
//  MyTagController.m
//  medtree
//
//  Created by 边大朋 on 15-4-13.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MyTagController.h"
#import "NewPersonTagsCell.h"
#import "FormAlert.h"
#import "InfoAlertView.h"
#import "TextViewEx.h"
#import "ServiceManager.h"
#import "OperationHelper.h"
#import "UserDTO.h"
#import "AccountHelper.h"
#import "UserManager.H"
#import "UserTagsDTO.h"
#import "LoadingView.h"
#import "JSONKit.h"
#import "NewPersonDetailController.h"

@interface MyTagController ()<FormAlertDelegate, UIActionSheetDelegate>
{
    FormAlert                   *formAlert;
    NSMutableArray              *userInfoArray;
    UserDTO                     *udto;
    NSMutableDictionary         *tagInfo;
    NSMutableArray              *reportArray;
    BOOL                        isReportUser;
}
@end

@implementation MyTagController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    [self createBackButton];
    [naviBar setTopTitle:@"个人标签"];
    table.enableHeader = NO;
    table.enableFooter = NO;
    [table setIsNeedFootView:NO];
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    [table registerCells:@{@"UserTagsDTO":[NewPersonTagsCell class]}];
    
    formAlert = [[FormAlert alloc] init];
    formAlert.parent = self;
    formAlert.hidden = YES;
    [self.view addSubview:formAlert];
    table.enableHeader = YES;
}

- (void)showActionSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"举报" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"不实身份",@"垃圾营销",@"敏感信息",@"淫秽色情",@"不实信息", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    sheet.tag = 101;
    [sheet showInView:self.view];
}

- (void)delNotice
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认删除该标签？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1000;
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    reportArray = [NSMutableArray arrayWithObjects:@"不实身份",@"垃圾营销",@"敏感信息",@"淫秽色情",@"不实信息", nil];
    [self setupData];
    [self setupView];
}

- (void)setupData
{
    [self loadData];
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    formAlert.frame = CGRectMake(0, 0, size.width, size.height);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.parent isKindOfClass:[NewPersonDetailController class]]) {
        [(NewPersonDetailController *)self.parent setTable];
    }
}

#pragma mark - data
- (NSDictionary *)getParam_FromNet
{
    return @{@"userid": udto.userID,@"method": [NSNumber numberWithInteger:MethodType_UserInfo]};
}

- (void)parseData:(id)JSON
{
    udto = (UserDTO *)[JSON objectForKey:@"data"];
    UserTagsDTO *utdto = [userInfoArray objectAtIndex:0];
    
    [udto updateInfo:utdto.tags forKey:@"user_tags"];
    [UserManager checkUser:udto];
    [self setTable];
}

- (void)loadData
{
    if (!udto) {
        udto =  [AccountHelper getAccount];
        [self loadUserInfoFromDB:[udto userID]];
    }
    [self setTable];
}

- (void)setUserInfo:(UserDTO *)dto
{
    udto = dto;
    [self loadUserInfoFromDB:[udto userID]];
}

- (void)loadUserInfoFromDB:(NSString *)userID
{
    NSDictionary *param = @{@"userid":userID};
    [UserManager getUserInfoFromLocal:param success:^(id JSON) {
        udto = JSON;
    } failure:^(NSError *error, id JSON) {
    }];
}

- (void)setTable
{
    userInfoArray = [NSMutableArray array];
    //标签
    {
        UserTagsDTO *utdto = [[UserTagsDTO alloc] init];
        utdto.pageType = 0;
        if (udto.user_tags.count > 0) {
            utdto.tags = [NSMutableArray array];
            for (int i = 0; i < udto.user_tags.count; i++) {
                NSDictionary *dict = [udto.user_tags objectAtIndex:i];
                NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [mdict setObject:@1 forKey:@"type"];
                [utdto.tags addObject:mdict];
            }
        }
        
        utdto.maxWidth = [[UIScreen mainScreen] bounds].size.width - 40;
        utdto.userDTO = udto;
        [userInfoArray addObject:utdto];
        [table setData:[NSArray arrayWithObjects:userInfoArray, nil]];
    }
}

#pragma mark - private
- (int)charNumber:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

#pragma mark - click
- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    
}

- (void)clickSave
{
    if (formAlert.textView.text.length == 0 || [formAlert.textView.text isEqualToString:@"标签内容"]) {
        return;
    }
    if ([self charNumber:formAlert.textView.text] > 20) {
        [InfoAlertView showInfo:@"标签内容长度最多10个汉字" inView:self.view duration:1];
        return;
    }
    
    UserTagsDTO *utdto = [userInfoArray objectAtIndex:0];
    if (utdto.tags.count > 0) {
        for (NSInteger i = 0; i < utdto.tags.count; i++) {
            NSString *tagStr = [[utdto.tags objectAtIndex:i] objectForKey:@"tag"];
            NSString *inputStr = [formAlert.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([inputStr isEqualToString:tagStr]) {
                [InfoAlertView showInfo:@"请不要重复添加" inView:self.view duration:1];
                return;
            }
        }
    }
    
    [LoadingView showProgress:YES inView:self.view];
    [formAlert setNotEnableSaveBtn];
    NSDictionary *param = @{@"method":[NSNumber numberWithInt:MethodType_UserInfo_AddTag],@"to_user":udto.userID,@"tag":formAlert.textView.text};
        [UserManager addUserTag:param success:^(id JSON) {
            [LoadingView showProgress:NO inView:self.view];
            NSDictionary *dict = [JSON objectForKey:@"result"];
            UserTagsDTO *utdto = [userInfoArray objectAtIndex:0];
            NSString *count =  [NSString stringWithFormat:@"%@", [dict objectForKey:@"count"]];
            NSDictionary *dict2 = @{@"tag":[dict objectForKey:@"tag"],@"count":count,@"type":@1,@"is_liked":[dict objectForKey:@"is_liked"]};
            NSMutableDictionary *dict3 = [NSMutableDictionary dictionaryWithDictionary:dict2];
            
            [utdto.tags addObject:dict3];
            NSLog(@"dict3 ----- %@", utdto.tags);
            
            [udto.user_tags addObject:dict3];

            [udto updateInfo:utdto.tags forKey:@"user_tags"];
            [UserManager checkUser:udto];
            [table setData:[NSArray arrayWithObjects:userInfoArray, nil]];
            
            [formAlert.textView resignFirstResponder];
            formAlert.hidden = YES;
            formAlert.textView.text = @"";
            [formAlert setEnableSaveBtn];
        } failure:^(NSError *error, id JSON) {
            
        }];
}

- (void)clickCell:(id)dto action:(NSNumber *)action
{
    if (ClickAction_UserTagAdd == [action integerValue]) {
        formAlert.hidden = NO;
        [formAlert.textView becomeFirstResponder];
    } else if ([action integerValue] == 2) {
       //
    }
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index action:(NSNumber *)action
{
    tagInfo = dto;
    if ([action integerValue] == 1) {//删除标签
        [self delNotice];
    } else if ([action integerValue] == 4) { //对标签点赞
        [self likeTag:tagInfo];
    } else if ([action integerValue] == 2) { //举报
        isReportUser = NO;
        [self showActionSheet];
    }
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 101) {
        if (buttonIndex < reportArray.count) {
            [self reportReson:buttonIndex+1];
        }
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self deleteLikeTag];
        }
    }
}

#pragma mark - send data
/**
 *  举报标签
 */
- (void)reportReson:(NSInteger)reson
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (isReportUser) {
        [dict setObject:[NSNumber numberWithInt:1000] forKey:@"report_type"];
    } else {
        [dict setObject:[NSNumber numberWithInt:1001] forKey:@"report_type"];
        [dict setObject:[tagInfo objectForKey:@"tag"] forKey:@"item_id"];
    }
    [dict setObject:[NSNumber numberWithInteger:reson] forKey:@"reason"];
    [dict setObject:udto.userID forKey:@"userID"];
    [dict setObject:[NSNumber numberWithInt:MethodType_Feed_Report] forKey:@"method"];
    [UserManager reportUserTag:dict success:^(id JSON) {
        [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:1];
    } failure:^(NSError *error, id JSON) {
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

//对标签点赞
- (void)likeTag:(NSMutableDictionary *)dict
{
    NSDictionary *param = @{@"method":[NSNumber numberWithInt:MethodType_UserInfo_AddTag],@"to_user":udto.userID,@"tag":[dict objectForKey:@"tag"]};
    [UserManager addUserTag:param success:^(id JSON) {
        NSDictionary *dict = [JSON objectForKey:@"result"];
        
        UserTagsDTO *utdto = [userInfoArray objectAtIndex:0];
        for (NSInteger i = 0; i < utdto.tags.count; i++) {
            if ([[[utdto.tags objectAtIndex:i] objectForKey:@"tag"] isEqualToString:[dict objectForKey:@"tag"]]) {
                [[utdto.tags objectAtIndex:i] setObject:[dict objectForKey:@"is_liked"] forKey:@"is_liked"];
                [[utdto.tags objectAtIndex:i] setObject:[dict objectForKey:@"count"] forKey:@"count"];
                
                NSMutableDictionary *dictCache = [NSMutableDictionary dictionaryWithDictionary:[udto.user_tags objectAtIndex:i]];
                [dictCache setObject:[dict objectForKey:@"count"] forKey:@"count"];
                [dictCache setObject:[dict objectForKey:@"is_liked"] forKey:@"is_liked"];
                [udto.user_tags replaceObjectAtIndex:i withObject:dictCache];
            }
        }
        [udto updateInfo:udto.user_tags forKey:@"user_tags"];
        [UserManager checkUser:udto];
        [table setData:[NSArray arrayWithObjects:userInfoArray, nil]];
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)deleteLikeTag
{
    NSString *tag =[tagInfo objectForKey:@"tag"];
    NSDictionary *param = @{@"to_user":[[AccountHelper getAccount] userID],@"tag":tag};
    [LoadingView showProgress:YES inView:self.view];
    
    [UserManager delUserTag:param success:^(id JSON) {
        
        [LoadingView showProgress:NO inView:self.view];
        
        //对应的索引
        NSInteger index = [[tagInfo objectForKey:@"index"] integerValue];
        NSLog(@"---------delete tag index--------- %ld", (long)index);
        //更新缓存
        [udto.user_tags removeObjectAtIndex:index];
        [udto updateInfo:udto.user_tags forKey:@"user_tags"];
        [UserManager checkUser:udto];
        
        UserTagsDTO *utdto = [userInfoArray objectAtIndex:0];
        [utdto.tags removeObjectAtIndex:index];

        [table reloadData];
    } failure:^(NSError *error, id JSON) {
        [LoadingView showProgress:NO inView:self.view];
        NSLog(@"%@--%@", error, JSON);

    }];
}

@end
