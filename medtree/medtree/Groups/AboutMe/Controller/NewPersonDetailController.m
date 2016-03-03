//
//  NewPersonDetailController.m
//  medtree
//
//  Created by 边大朋 on 15-4-3.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewPersonDetailController.h"
#import "NewPersonEditCell.h"
#import "BlankCell.h"
#import "Pair2DTO.h"
#import "UserDTO.h"
#import "UserTagsDTO.h"
#import "NewPersonTagsCell.h"
#import "OrganizationDTO.h"
#import "NewCommonPersonCell.h"
#import "ServiceManager.h"
#import "AccountHelper.h"
#import "NotificationDTO.h"
#import "DB+NewRelation.h"
#import "UserManager.h"
#import "FormAlert.h"
#import "TextViewEx.h"
#import "UserManager.h"
#import "OperationHelper.h"
#import "NewCommonFriendController.h"
#import "AccountHelper.h"
#import "InfoAlertView.h"
#import "JSONKit.h"
#import "LoadingView.h"
#import "FriendRequestController.h"
#import "MessageController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "LoginGetDataHelper.h"
#import "MyTagController.h"
#import "EmptyDTO.h"
#import "EmptyCell.h"
#import "NearPeopleController.h"
#import "NewPersonEditViewController.h"

#import "PersonCardInfoCell.h"
#import "FooterBar.h"
#import "PersonPushToNextInfoCell.h"
#import "PairDTO.h"

#import "PersonCardInfoAcademicTagCell.h"
#import "AcademicTagsDTO.h"
#import "AcademicTagDTO.h"
#import "FriendFeedViewController.h"

#import "CommonWebController.h"

#import "PersonDetailViewController.h"
#import "HomeArticleAndDiscussionTableViewCell.h"
#import "HomeArticleAndDiscussionDTO.h"
#import "FriendFeedViewController.h"
#import "HomeChannelDiscussionAndArticleCommentViewController.h"
#import "HomeChannelArticleDetailViewController.h"
#import "ClickUtil.h"
#import "ImageCenter.h"
#import "NoDataCell.h"
#import "Pair3DTO.h"

#import "MedShareManager.h"

typedef enum {
    Relation_Type_Friend            = 0,
    Relation_Type_NoFriend          = 1,
    Relation_Type_Shadow            = 2,
    Relation_Type_NoAddFriend       = 3,
    Relation_Type_FriendRequest     = 4,
    Relation_Type_Self              = 5
} Relation_Type_Info;

@interface NewPersonDetailController () <FormAlertDelegate, UIActionSheetDelegate, UIAlertViewDelegate, MFMessageComposeViewControllerDelegate>
{
     NSMutableArray              *userInfoArray;
     BOOL                        isOn;
     BOOL                        isSelf;//是否是自己
     BOOL                        isFriendListChanged;
     BOOL                        isFromSearch;
     BOOL                        isFriendRequest;
     BOOL                        isFriend;
     BOOL                        isReportUser;
     NSArray                     *tagArray;
     FormAlert                   *formAlert;
     NSMutableArray              *reportArray;
     NSMutableDictionary         *tagInfo;
    NSInteger                    tagActionType;
    BOOL                         clearCache;
    NSMutableArray               *tagsCache;
    BOOL                         userFromUserId;
    FooterBar                    *footerBarView;
    NSMutableArray               *userDynamicArray;
    
}
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation NewPersonDetailController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    [self createBackButton];
    table.enableHeader = NO;
    table.enableFooter = NO;
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    [table registerCells:@{@"OrganizationDTO": [NewCommonPersonCell class],@"EmptyDTO":[EmptyCell class],@"Pair2DTO":[BlankCell class],@"UserTagsDTO":[NewPersonTagsCell class],@"UserDTO":[PersonCardInfoCell class],@"PairDTO":[PersonPushToNextInfoCell class],@"AcademicTagsDTO":[PersonCardInfoAcademicTagCell class], @"HomeArticleAndDiscussionDTO" : [HomeArticleAndDiscussionTableViewCell class], @"Pair3DTO":[NoDataCell class]}];
    footerBarView = [[FooterBar alloc] init];
    [self.view addSubview:footerBarView];
    
    formAlert = [[FormAlert alloc] init];
    formAlert.parent = self;
    formAlert.hidden = YES;
    [self.view addSubview:formAlert];
    
    if (self.userDTO) {
        [self setTopTitle];
    }
}

- (void)registerNotifications
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInfoWithUserId) name:UserInfoChangeNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    clearCache = NO;
    tagsCache = [NSMutableArray array];
    reportArray = [NSMutableArray arrayWithObjects:@"不实身份",@"垃圾营销",@"敏感信息",@"淫秽色情",@"不实信息", nil];
    isSelf = NO;
    isReportUser = NO;
    isFriendRequest = NO;
    isFriend = NO;
    isFromSearch = NO;
    
    self.startIndex = 0;
    self.pageSize = 10;
    userDynamicArray = [[NSMutableArray alloc] init];
    
    [self checkIsSelf];
    
    if (_userDTO) {
        [self loadInfoWithUserDTO];
    } else if (_userId) {
        [self loadInfoWithUserId];
    }
    if (isSelf) {
        [self createRightBtnNai];
        
        [ClickUtil event:@"me_mydata_view" attributes:nil];
    }
    
    if (self.notificationDTO) {
        _userId = self.notificationDTO.target.userID;
        [self loadInfoWithUserId];
    }
    
    [self setupView];
    
//    [self getUserDynamic];
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    CGRect rect = naviBar.frame;
    if (isSelf) {
        table.frame = CGRectMake(0, rect.origin.y+rect.size.height, size.width, size.height-rect.origin.y-rect.size.height);
        footerBarView.frame = CGRectMake(0, size.height, size.width, 44);
    } else {
        table.frame = CGRectMake(0, rect.origin.y+rect.size.height, size.width, size.height-rect.origin.y-rect.size.height-44);
        footerBarView.frame = CGRectMake(0, size.height-44, size.width, 44);
    }
    formAlert.frame = CGRectMake(0, 0, size.width, size.height);
}

- (void)createRightBtnNai
{
    UIButton *backButton = [NavigationBar createImageButton:@"img_checkcheck_card.png" selectedImage:@"img_checkcheck_card.png" target:self action:@selector(clickShareCardInfo)];
    [naviBar setRightOffset:15];
    [naviBar setRightButton:backButton];
}

- (void)setTopTitle
{
    [naviBar setTopTitle:[NSString stringWithFormat:@"%@的主页", self.userDTO.name]];
}

#pragma mark 检测好友请求状态
- (void)tidyRelation
{
    if (_userDTO.friend_requests_not_allowed) {
        [self setRightBarViewInfo:Relation_Type_NoAddFriend];
    } else {
        if (_userDTO.isFriend) {
            [self setRightBarViewInfo:Relation_Type_Friend];
        } else {
            if (_userDTO.user_type == 9) {
                [self setRightBarViewInfo:Relation_Type_Shadow];
            } else {
                if (_userDTO.isFriend == NO) {
                    if (!isSelf) {
                        [self checkFriendRequest];
                    } else {
                        [self setRightBarViewInfo:Relation_Type_Self];
                    }
                }
            }
        }
    }
}

- (void)checkFriendRequest
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_CheckRequest],@"userID":_userId} success:^(id JSON) {
        NSArray *array = [NSArray arrayWithArray:JSON];
        if (array.count > 0) {
            NotificationDTO *dto = [array objectAtIndex:0];
            self.notificationDTO = dto;
            if (dto.processed) {
                isFriendRequest = NO;
                [self setRightBarViewInfo:Relation_Type_NoFriend];
            } else {
                switch (dto.status) {
                    case NewRelationStatus_Friend_Request:
                    {
                        isFriendRequest = YES;
                        [self setRightBarViewInfo:Relation_Type_FriendRequest];
                        break;
                    }
                    case NewRelationStatus_Friend_Request_Deny:
                    case NewRelationStatus_Friend_Request_Sent:
                    case NewRelationStatus_Friend_Request_Inivte:
                    {
                        isFriendRequest = NO;
                        [self setRightBarViewInfo:Relation_Type_NoFriend];
                        break;
                    }
                    case NewRelationStatus_Friend_Request_Accept:
                    {
                        isFriendRequest = YES;
                        [self setRightBarViewInfo:Relation_Type_FriendRequest];
                        break;
                    }
                    default:
                        break;
                }
            }
        } else {
            isFriendRequest = NO;
            [self setRightBarViewInfo:Relation_Type_NoFriend];
        }
    } failure:^(NSError *error, id JSON) {
        isFriendRequest = NO;
        [self setRightBarViewInfo:Relation_Type_NoFriend];
    }];
}

#pragma mark 根据好友请求状态设置底部按钮
- (void)setRightBarViewInfo:(NSInteger)type
{
    NSMutableArray *array = [NSMutableArray array];
    if (isSelf) {
//        [array addObject:@{@"imageName":@"footer_bar_edit_icon.png",@"title":@"编辑",@"target":self,@"action":@"clickToPersonEditViewController"}];
        footerBarView.hidden = YES;
        
        return;
        
    } else {
        switch (type) {
            case Relation_Type_Friend:
            {
                [array addObject:@{@"imageName":@"footer_bar_chat_icon.png",@"title":@"聊天",@"target":self,@"action":@"clickMessage"}];
                if (_userDTO.user_type != 1) {
                    [array addObject:@{@"imageName":@"footer_bar_delete_icon.png",@"title":@"删除好友",@"target":self,@"action":@"clickDelete"}];
                }
                break;
            }
            case Relation_Type_NoFriend:
            {
                [array addObject:@{@"imageName":@"footer_bar_add_icon.png",@"title":@"添加好友",@"target":self,@"action":@"clickAdd"}];
                break;
            }
            case Relation_Type_Shadow:
            {
                [array addObject:@{@"imageName":@"footer_bar_invite_icon.png",@"title":@"邀请",@"target":self,@"action":@"clickInvite"}];
                [array addObject:@{@"imageName":@"footer_bar_delete_icon.png",@"title":@"删除关系",@"target":self,@"action":@"clickDelete"}];
                break;
            }
            case Relation_Type_NoAddFriend:
            {
                break;
            }
            case Relation_Type_FriendRequest:
            {
                [array addObject:@{@"imageName":@"footer_bar_agree_icon.png",@"title":@"同意",@"target":self,@"action":@"clickAgree"}];
                break;
            }
            case Relation_Type_Self:
            {
                [array addObject:@{@"imageName":@"footer_bar_edit_icon.png",@"title":@"编辑",@"target":self,@"action":@"clickEditUserInfo"}];
                break;
            }
            default:
                break;
        }
        if (_userDTO.user_type != 1 && _userDTO.user_type != 9 && !isSelf) {
            [array addObject:@{@"imageName":@"footer_bar_report_icon.png",@"title":@"举报",@"target":self,@"action":@"clickReport"}];
        }
    }
    [footerBarView setButtonInfo:array];
}

#pragma mark 跳转到个人信息编辑页
- (void)clickEditUserInfo
{
    NewPersonEditViewController *person = [[NewPersonEditViewController alloc] init];
    [self.navigationController pushViewController:person animated:YES];
    [person setInfo:_userDTO];
}

#pragma mark 发短信
- (void)postInvitewithPhone:(NSString *)phone
{
    [self sendSMS:[NSString stringWithFormat:@"我正在用医树，既可以做职业发展还可以管理自己的人脉，你也试试。注册时请在邀请人处填写我的医树号:%@，我们就能加为好友了。下载地址 https://medtree.cn/release/?package=medtree",[[AccountHelper getAccount] userID]] recipientList:[NSArray arrayWithObjects:phone, nil]];
}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]) {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MessageComposeResultCancelled) {
            [InfoAlertView showInfo:@"短信发送已取消！" inView:self.view duration:1];
        } else if (result == MessageComposeResultSent) {
            [InfoAlertView showInfo:@"短信发送成功！" inView:self.view duration:1];
        } else {
            [InfoAlertView showInfo:@"短信发送失败！" inView:self.view duration:1];
        }
    }];
}

- (void)clickInvite
{
    [self postInvitewithPhone:@""];
}

#pragma mark 删除关系
- (void)deleteFriendRelation
{
    [self showProgress];
    NSDictionary *param = nil;
    if (_userDTO.user_type != 9) {
        param = @{@"method": [NSNumber numberWithInteger:MethodType_Delete_Friend], @"friend_id":_userDTO.userID};
    } else {
        param = @{@"method":[NSNumber numberWithInt:MethodType_DeleteConnectionPeer],@"user_id":_userDTO.userID} ;
    }
    [ServiceManager setData:param success:^(id JSON) {
        
        [self hideProgress];
        BOOL isSuccess = [[JSON objectForKey:@"success"] boolValue];
        if (isSuccess) {
            if (_userDTO.user_type != 9) {
                isFriendRequest = NO;
                _userDTO.isFriend = NO;
                [_userDTO updateInfo:[NSNumber numberWithBool:_userDTO.isFriend] forKey:@"is_friend"];
                [UserManager checkUser:_userDTO];
                [table reloadData];
                [InfoAlertView showInfo:@"删除成功！" inView:self.view duration:1];
                [self setRightBarViewInfo:Relation_Type_NoFriend];
                isFriendListChanged = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:DeleteFriendNotification object:_userDTO];
            } else {

                /*上一级页面清理该影子用户信息*/
//                if ([self.delegate respondsToSelector:@selector(clearUser:)]) {
//                    [self.delegate performSelector:@selector(clearUser:) withObject:_userDTO];
//                }
                [[NSNotificationCenter defaultCenter] postNotificationName:DeleteFriendNotification object:_userDTO];
                [self clickBack];
            }
        } else {
            [InfoAlertView showInfo:@"删除失败，请重试！" inView:self.view duration:1];
        }
    } failure:^(NSError *error, id JSON) {
        [self hideProgress];
        [InfoAlertView showInfo:@"删除失败，请重试！" inView:self.view duration:1];
    }];
}

- (void)clickDelete
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"删除和TA的关系？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alert.tag = 456;
    [alert show];
}

#pragma mark - 如果是用户自己进入风向名片页
- (void)clickShareCardInfo
{
    [ClickUtil event:@"me_card_share" attributes:nil];
    
    [[MedShareManager sharedInstance] showInView:self.view
                                           title:@"医树名片"
                                         deatail:[NSString stringWithFormat:@"姓名：%@\n医树号：%@",_userDTO.name, _userDTO.userID]
                                           image:nil
                                    defaultImage:nil
                                        shareURL:[NSString stringWithFormat:@"https://m.medtree.cn/daily/personalcard?id=%@",_userDTO.account_id]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (actionSheet.tag == 101) {
        if (buttonIndex < reportArray.count){
            [self reportReson:buttonIndex+1];
        }
    }
}

#pragma mark 聊天
- (void)clickMessage
{
    if (_userDTO.chatID.length > 0) {
        if (self.fromMessageController) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            MessageController *mc = [[MessageController alloc] init];
            mc.target = self.userDTO;
            [self.navigationController pushViewController:mc animated:YES];
        }
    }
}

#pragma mark 进入编辑页
- (void)clickToPersonEditViewController
{
    NewPersonEditViewController *person = [[NewPersonEditViewController alloc] init];
    [self.navigationController pushViewController:person animated:YES];
    person.parent = self;
    if ([AccountHelper getAccount] != nil) {
        [person setInfo:[AccountHelper getAccount]];
    }

}

#pragma mark 添加好友
- (void)clickAdd
{
    FriendRequestController *request = [[FriendRequestController alloc] init];
    request.dataDict = @{@"type":[NSNumber numberWithInt:MethodType_Controller_Add],@"userID":_userDTO.userID};
    [self presentViewController:request animated:YES completion:nil];
}

#pragma mark 同意好友请求
- (void)clickAgree
{
    NSDictionary *param = @{@"method": [NSNumber numberWithInteger:MethodType_Accept_Friend], @"data": self.notificationDTO};
    [ServiceManager setData:param success:^(id JSON) {
        if ([JSON[@"success"] boolValue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.notificationDTO.status = NewRelationStatus_Friend_Request_Accept;
                [UserManager checkNotification:self.notificationDTO];
                [[NSNotificationCenter defaultCenter] postNotificationName:RelationChangeNotification object:self.notificationDTO];
                //
                [InfoAlertView showInfo:@"同意对方好友请求成功！" inView:self.view duration:1];
                isFriendRequest = NO;
                _userDTO.isFriend = YES;
                [_userDTO updateInfo:[NSNumber numberWithBool:_userDTO.isFriend] forKey:@"is_friend"];
                [UserManager checkUser:_userDTO];
                [self requestData];
                [self setRightBarViewInfo:Relation_Type_Friend];
                [self setTable];
                /*刷新页面 添加是否设置隐私好友*/
                [[NSNotificationCenter defaultCenter] postNotificationName:AddFriendNotification object:_userDTO];
            });
        }
    } failure:^(NSError *error, id JSON) {
        [InfoAlertView showInfo:@"同意失败！请重试" inView:self.view duration:1];
    }];
}

#pragma mark 展示个人信息
- (void)setTopNavTitle
{
//    if (isSelf) {
//        [naviBar setTopTitle:@"个人信息"];
//    } else {
//        [naviBar setTopTitle:_userDTO.name];
//    }
    [self setTopTitle];
}

- (void)loadUserInfoFromDB
{
    NSDictionary *param = @{@"userid":_userId};
    [UserManager getUserInfoFromLocal:param success:^(id JSON) {
        if (JSON) {
            _userDTO = JSON;
            tagsCache = _userDTO.user_tags;
        }
    } failure:^(NSError *error, id JSON) {
    }];
}

- (void)loadInfoWithUserDTO
{
    userFromUserId = NO;
    [self checkIsSelf];
    _userId = _userDTO.userID;
    [self loadUserInfoFromDB];
    
    [self setTopNavTitle];
    [self setTable];
    [self tidyRelation];
    
    if (_userId != nil) {
        [self checkIsSelf];
        [self requestData];
    }
}

- (void)setIsFromSearch
{
    isFromSearch = YES;
}

- (NSDictionary *)getParam_FromNet
{
    return @{@"userid": _userId,@"method": [NSNumber numberWithInteger:MethodType_UserInfo]};
}

- (void)parseData:(id)JSON
{
    [self hideProgress];
    _userDTO = (UserDTO *)[JSON objectForKey:@"data"];
    clearCache = YES;
    [self setTopNavTitle];
    [self setTable];
    [self tidyRelation];
    [self getUserDynamic];

}

- (void)loadInfoWithUserId
{
    [self setTopNavTitle];
    if (_userId != nil) {
        [self checkIsSelf];
        userFromUserId = YES;
        [self loadUserInfoFromDB];
        [self requestData];
    }
}

- (void)showProgress
{
    [LoadingView showProgress:YES inView:self.view];
}

- (void)hideProgress
{
    [LoadingView showProgress:NO inView:self.view];
}

- (void)setTable
{
    userInfoArray = [NSMutableArray array];
    
    [userInfoArray addObject:_userDTO];
    //学术标签
    if (_userDTO.academic_tags.count > 0) {
        AcademicTagsDTO *atsDTO = [[AcademicTagsDTO alloc] init];
        atsDTO.dataArray = [[NSMutableArray alloc] init];
        [_userDTO.academic_tags enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            AcademicTagDTO *dto = [[AcademicTagDTO alloc] init:obj];
            dto.showType = AcademicTagShowType_Show;
            [atsDTO.dataArray addObject:dto];
        }];
        [userInfoArray addObject:atsDTO];
    }
    {
        Pair2DTO *dto2 = [[Pair2DTO alloc] init];
        dto2.title = @"我的标签";
        [userInfoArray addObject:dto2];
    }
    //标签
    {
        UserTagsDTO *utdto = [[UserTagsDTO alloc] init:@{}];
        utdto.clearCache = clearCache;
        utdto.pageType = 1;
        if (_userDTO) {
            [self loadUserInfoFromDB];
        }
        if (tagsCache.count > 0) {
            utdto.tags = [NSMutableArray array];
            for (int i = 0; i < tagsCache.count; i++) {
                NSDictionary *dict = [tagsCache objectAtIndex:i];
                NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [mdict setObject:@1 forKey:@"type"];
                [utdto.tags addObject:mdict];
            }
        }
        
        utdto.maxWidth = [[UIScreen mainScreen] bounds].size.width - 40;
        utdto.userDTO = _userDTO;
        [userInfoArray addObject:utdto];
        
//        {
//            Pair2DTO *dto2 = [[Pair2DTO alloc] init];
//            dto2.title = @"";
//            [userInfoArray addObject:dto2];
//        }
    }
    
    //影子用户
    if (_userDTO.user_type == 9) {
        Pair2DTO *dto2 = [[Pair2DTO alloc] init];
        dto2.title = @"当前用户尚未使用医树客户端\n请邀请TA登陆医树客户端";
        dto2.label = @"shadow";
        [userInfoArray addObject:dto2];
    } else {
        {
            Pair2DTO *dto2 = [[Pair2DTO alloc] init];
            dto2.title = isSelf ? @"我的动态" : @"Ta的动态";
            [userInfoArray addObject:dto2];
        }
    }
//    [table setData:[NSArray arrayWithObjects:userInfoArray, nil]];
}

- (NSString *)checkIsNull:(id)sender
{
    if ((NSObject *)sender == [NSNull null]) {
        return @"未填写";
    } else {
        return sender;
    }
}

//处理添加事件
- (void)clickCell:(id)dto action:(NSNumber *)action
{
    if (ClickAction_UserTagAdd == [action integerValue]) {        
        formAlert.hidden = NO;
        [formAlert.textView becomeFirstResponder];
    } else if (100 == [action integerValue]) {//加载更多
        MyTagController *tag = [[MyTagController alloc] init];
        tag.parent = self;
        [tag setUserInfo:_userDTO];
        [self.navigationController pushViewController:tag animated:YES];
    } else if (action.integerValue == 200) {
        if (userInfoArray.count >= 2 && [userInfoArray[1] isKindOfClass:[AcademicTagsDTO class]]) {
            [userInfoArray replaceObjectAtIndex:1 withObject:dto];
            [table setData:@[ userInfoArray ]];
        }
    } else if ([action integerValue] == HomeArticleAndDiscussionTableViewCellActionTypeHeadImage) {
        NewPersonDetailController *vc = [[NewPersonDetailController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userDTO = ((HomeArticleAndDiscussionDTO *)dto).userDTO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    NSLog(@"%d",[action intValue]);
    isOn = [action boolValue];
}

//处理标签事件
- (void)clickCell:(id)object index:(NSIndexPath *)index action:(NSNumber *)action
{
    NSLog(@"%ld", (long)index.row);
    tagInfo = object;
    tagActionType = [action integerValue];
    //添加标签
    if ([action integerValue] == 0) {
        [self addLikeTag:object];
        return;
    } else if ([action integerValue] == 1) { //删除
        [self delNotice];
        return;
    } else if ([action integerValue] == 2) { //举报
        isReportUser = NO;
        [self showActionSheet];
        return;
    } else if ([action integerValue] == 4) { //对标签点赞
        [self likeTag:object];
        return;
    } else if ([action integerValue] == 5) { //对学术标签点赞
        [self likeAcademicTag:object];
        return;
    }
}

- (void)likeAcademicTag:(NSString *)tag
{
    NSDictionary *param = @{@"to_user":_userDTO.userID,@"tag":tag};
    [UserManager likeAcademicTag:param success:^(id JSON) {
        if ([JSON[@"success"] boolValue]) {
            NSDictionary *result = JSON[@"result"];
            __block AcademicTagsDTO *dto;
            [userInfoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[AcademicTagsDTO class]]) {
                    dto = obj;
                }
            }];
            NSMutableArray *acArray = dto.dataArray;
            [acArray enumerateObjectsUsingBlock:^(AcademicTagDTO *obj, NSUInteger idx, BOOL *stop) {
                if ([obj.tagName isEqualToString:tag]) {
                    obj.tagCount = [result[@"count"] stringValue];
                    obj.isLike = [result[@"is_liked"] boolValue];
                    *stop = YES;
                }
            }];
            [table reloadData];
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if (index.row == 0) {
        PersonDetailViewController *vc = [[PersonDetailViewController alloc] init];
        vc.udto = self.userDTO;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        //去共同好友列表页面
        if ([dto isKindOfClass:[PairDTO class]]) {
            if (((PairDTO *)dto).cellType == 10) {
                [self pushToCommeontFriendPage];
            } else if (((PairDTO *)dto).cellType == 11) {
                //名家专栏
                //            NSString *urlPath = [NSString stringWithFormat:@"https://m.medtree.cn/inner/auth/daily/master?id=%@",_userDTO.account_id];
            } else if (((PairDTO *)dto).cellType == 12) {
                FriendFeedViewController *vc = [[FriendFeedViewController alloc] init];
                vc.feedType = FriendFeedViewControllerDataType_Person;
                vc.userDTO = _userDTO;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else if (((HomeArticleAndDiscussionDTO *)dto).type == HomeArticleAndDiscussionTypeDiscussion) {
            HomeChannelDiscussionAndArticleCommentViewController *vc = [[HomeChannelDiscussionAndArticleCommentViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.articleAndDiscussionDTO = dto;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (((HomeArticleAndDiscussionDTO *)dto).type == HomeArticleAndDiscussionTypeArticle || ((HomeArticleAndDiscussionDTO *)dto).type == HomeArticleAndDiscussionTypeEvent) {
            HomeChannelArticleDetailViewController *vc = [[HomeChannelArticleDetailViewController alloc] init];
            vc.articleDTO = dto;
            [ClickUtil event:@"homepage_recommend_articlanddiscuss" attributes:@{@"article_id":((HomeArticleAndDiscussionDTO *)dto).id, @"title":((HomeArticleAndDiscussionDTO *)dto).title}];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)delNotice
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认删除该标签？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1000;
    [alert show];
}

- (void)pushToCommeontFriendPage
{
    NewCommonFriendController *ncf = [[NewCommonFriendController alloc] init];
    [self.navigationController pushViewController:ncf animated:YES];
    [ncf loadInfo:_userId];
}

- (void)reportLikeTag:(NSMutableDictionary *)oldDict
{
    NSDictionary *param = @{@"to_user":_userId,@"tag":[oldDict objectForKey:@"tag"]};
    
    [UserManager reportUserTag:param success:^(id JSON) {
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self deleteLikeTag];
        }
    } else if (alertView.tag == 456) {
        if (buttonIndex == 1) {
            [self deleteFriendRelation];
        }
    }
}

#pragma mark 举报人或标签
- (void)clickReport
{
    isReportUser = YES;
    [self showActionSheet];
}

- (void)showActionSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"举报" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"不实身份",@"垃圾营销",@"敏感信息",@"淫秽色情",@"不实信息", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    sheet.tag = 101;
    [sheet showInView:self.view];
}

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
    [dict setObject:_userId forKey:@"userID"];
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

#pragma mark 删除自己的标签
- (void)deleteLikeTag
{
    if ([[[AccountHelper getAccount] userID] isEqualToString:_userId]) {
        
        NSString *tag =[tagInfo objectForKey:@"tag"];
        NSDictionary *param = @{@"to_user":_userId,@"tag":tag};
        [LoadingView showProgress:YES inView:self.view];
        [UserManager delUserTag:param success:^(id JSON) {
            [LoadingView showProgress:NO inView:self.view];
            NSInteger index = [[tagInfo objectForKey:@"index"] integerValue];
            
            [_userDTO.user_tags removeObjectAtIndex:index];
            __block UserTagsDTO *utdto;
            [userInfoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[UserTagsDTO class]]) {
                    utdto = obj;
                }
            }];
            [utdto.tags removeObjectAtIndex:index];
            [_userDTO updateInfo:_userDTO.user_tags forKey:@"user_tags"];
            [UserManager checkUser:_userDTO];
            
            [table reloadData];
        } failure:^(NSError *error, id JSON) {
            [LoadingView showProgress:NO inView:self.view];
        }];
    }
}

#pragma mark 对标签点赞
- (void)addLikeTag:(NSMutableDictionary *)oldDict
{
    NSDictionary *param = @{@"method":[NSNumber numberWithInt:MethodType_UserInfo_AddTag],@"to_user":_userId,@"tag":[oldDict objectForKey:@"tag"]};
    [UserManager addUserTag:param success:^(id JSON) {
        NSDictionary *dict = [JSON objectForKey:@"result"];
        
        [oldDict setValue:[dict objectForKey:@"count"] forKey:@"count"];
        
        //对标签点赞后，换标签背景色
        if (tagActionType == 3) {
            
        }
        [UserManager checkUser:_userDTO];
        [table reloadData];
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)likeTag:(NSMutableDictionary *)dict
{
    NSDictionary *param = @{@"method":[NSNumber numberWithInt:MethodType_UserInfo_AddTag],@"to_user":_userId,@"tag":[dict objectForKey:@"tag"]};
    [UserManager addUserTag:param success:^(id JSON) {
        
        NSDictionary *dict = [JSON objectForKey:@"result"];
        __block UserTagsDTO *utdto;
        [userInfoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UserTagsDTO class]]) {
                utdto = obj;
            }
        }];
        for (int i = 0; i < utdto.tags.count; i++) {
            if ([[[utdto.tags objectAtIndex:i] objectForKey:@"tag"] isEqualToString:[dict objectForKey:@"tag"]]) {
                [[utdto.tags objectAtIndex:i] setObject:[dict objectForKey:@"is_liked"] forKey:@"is_liked"];
                [[utdto.tags objectAtIndex:i] setObject:[dict objectForKey:@"count"] forKey:@"count"];
            }
        }
        [_userDTO updateInfo:utdto.tags forKey:@"user_tags"];
        [UserManager checkUser:_userDTO];
        [table setData:[NSArray arrayWithObjects:userInfoArray, nil]];
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)longPressTag
{
    
}

- (void)clickSave
{
    if (formAlert.textView.text.length == 0 || [formAlert.textView.text isEqualToString:@"标签内容"]) {
        return;
    }
    if (formAlert.textView.text.length > 10) {
        [InfoAlertView showInfo:@"标签内容长度最多10个汉字" inView:self.view duration:1];
        return;
    }
    __block UserTagsDTO *utdto;
    [userInfoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UserTagsDTO class]]) {
            utdto = obj;
        }
    }];
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
    
    NSDictionary *param = @{@"method":[NSNumber numberWithInt:MethodType_UserInfo_AddTag],@"to_user":_userId,@"tag":formAlert.textView.text};
    [formAlert setNotEnableSaveBtn];
    [UserManager addUserTag:param success:^(id JSON) {
        NSDictionary *dict = [JSON objectForKey:@"result"];
        __block UserTagsDTO *utdto;
        [userInfoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UserTagsDTO class]]) {
                utdto = obj;
            }
        }];
        NSString *count =  [NSString stringWithFormat:@"%@", [dict objectForKey:@"count"]];
        NSDictionary *dict2 = @{@"tag":[dict objectForKey:@"tag"],@"count":count,@"type":@1,@"is_liked":[dict objectForKey:@"is_liked"]};
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionaryWithDictionary:dict2];
        
        [utdto.tags addObject:dict3];
        
        [_userDTO.user_tags addObject:dict3];
        [_userDTO updateInfo:utdto.tags forKey:@"user_tags"];
        [UserManager checkUser:_userDTO];
        
        [table setData:[NSArray arrayWithObjects:userInfoArray, nil]];
        
        [formAlert.textView resignFirstResponder];
        formAlert.hidden = YES;
        formAlert.textView.text = @"";
        [formAlert setEnableSaveBtn];
    } failure:^(NSError *error, id JSON) {
        
    }];

}

// 设置隐私处理
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (isSelf) {
        return;
    }
    //隐私时 在此处进行数据上传
    NSMutableArray *array = [NSMutableArray arrayWithArray:[_userDTO preferences]];
    BOOL isPrivacy = NO;
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *uDict = [array objectAtIndex:i];
        if ([[uDict objectForKey:@"key"] isEqualToString:@"hide_friend"]) {
            isPrivacy = [[uDict objectForKey:@"value"] boolValue];
            break;
        }
    }
    if (isOn != isPrivacy) {
        [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_FriendsPrivacy],@"key":isOn?@"_hide":@"_show",@"user":_userDTO,@"friends_id":_userDTO.userID} success:^(id JSON) {
            
        } failure:^(NSError *error, id JSON) {
            
        }];
    }
}

- (void)checkIsSelf
{
    NSString *userID = _userId ? _userId : _userDTO.userID;
    isSelf = [[AccountHelper getAccount].userID isEqualToString:userID];
}

#pragma mark - load footer
- (void)loadFooter:(BaseTableView *)table
{
    [self getUserDynamic];
}

#pragma mark - 获取某人动态
- (void)getUserDynamic
{
    NSDictionary *param = @{@"method" : @(MethodType_FeedList_Person), @"userId" : _userDTO.userID, @"from" : @(self.startIndex), @"size" : @(self.pageSize)};
    [ServiceManager getData:param success:^(id JSON) {
        NSLog(@"--%@", JSON);
        userDynamicArray = JSON;
        self.startIndex += [userDynamicArray count];
        table.enableFooter = [userDynamicArray count] == self.pageSize;
        
        if ([userDynamicArray count] > 0) {
            [userInfoArray addObjectsFromArray:userDynamicArray];
        } else {
            Pair3DTO *dto = [[Pair3DTO alloc] init];
            [userInfoArray addObject:dto];
        }
        [table setData:[NSArray arrayWithObjects:userInfoArray, nil]];
    } failure:^(NSError *error, id JSON) {

    }];
}

@end
