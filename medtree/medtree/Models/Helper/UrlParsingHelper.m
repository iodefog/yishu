//
//  UrlParsingHelper.m
//  medtree
//
//  Created by 陈升军 on 15/9/11.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "UrlParsingHelper.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "UserManager.h"

#import "CommonWebController.h"
#import "MessageController.h"

#import "EventFeedViewController.h"
#import "EventViewController.h"
#import "DeliverResumeRecorderController.h"
#import "NewPersonIdentificationController.h"

#import "HomeJobChannelUnitRelationViewController.h"
#import "HomeJobChannelEnterpriseMapViewController.h"
#import "HomeJobChannelUnitAndEmploymentSearchViewController.h"
#import "HomeChannelDiscussionAndArticleCommentViewController.h"
#import "MyResumeViewController.h"
#import "NewPersonDetailController.h"
#import "HomeChannelArticleDetailViewController.h"
#import "AddDegreeController.h"
#import "FeedbackController.h"
#import "MateFriendsController.h"
#import "EditPersonCardInfoController.h"
#import "HomeJobChannelIntersetViewController.h"

@implementation UrlParsingHelper

#pragma mark -
#pragma mark - 检测url类型

+ (UrlParsingType)getUrlParsingTypeWithUrl:(NSString *)url
{
    UrlParsingType type = UrlParsingTypeNative;
    if ([UrlParsingHelper isHaveNative:url]) {
        type = UrlParsingTypeNative;
    } else if ([UrlParsingHelper isHaveSpecialWeb:url]) {
        type = UrlParsingTypeSpecialWeb;
    } else if ([UrlParsingHelper isCallPhone:url]) {
        type = UrlParsingTypeCallPhone;
    } else {
        type = UrlParsingTypeOtherWeb;
    }
    return type;
}

+ (BOOL)isHaveHttp:(NSString *)url
{
    if ([url rangeOfString:@"http://"].location != NSNotFound || [url rangeOfString:@"https://"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (BOOL)isHaveNative:(NSString *)url
{
    if ([url rangeOfString:@".medtree.cn/native/"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (BOOL)isHaveSpecialWeb:(NSString *)url
{
    if ([url rangeOfString:@"medtree.cn"].location != NSNotFound) {
        if ([url rangeOfString:@"inapp=0"].location == NSNotFound ) {
            return YES;
        } else {
            return NO;
        }
    } else {
        if ([url rangeOfString:@"inapp=1"].location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    }
}

+ (BOOL)isCallPhone:(NSString *)url
{
    if ([url hasPrefix:@"tel://"]) {
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark - 根据url地址、url类型做相应操作
+ (void)operationUrl:(NSString *)url type:(UrlParsingType)type controller:(UIViewController *)controller
{
    switch (type) {
        case UrlParsingTypeNative: {
            [UrlParsingHelper nativePushWithUrl:url controller:controller];
            break;
        }
        case UrlParsingTypeOtherWeb: {
            [UrlParsingHelper openOutWeb:url];
            break;
        }
        case UrlParsingTypeCallPhone: {
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
            [controller.view addSubview:callWebview];
            break;
        }
        default:
            break;
    }
}

+ (void)openOutWeb:(NSString *)url
{
    if ([url rangeOfString:@"http"].location == NSNotFound) {
        url = [NSString stringWithFormat:@"http://%@",url];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",url]]];
        }
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

#pragma mark -
#pragma mark - 根据url地址判断类型后做相应操作
+ (void)operationUrl:(NSString *)url controller:(UIViewController *)controller title:(NSString *)title
{
    UrlParsingType type = [UrlParsingHelper getUrlParsingTypeWithUrl:url];
    if (type != UrlParsingTypeSpecialWeb) {
        [UrlParsingHelper operationUrl:url type:type controller:controller];
    } else {
        [UrlParsingHelper openUrlInCommonWebController:url controller:controller title:title];
    }
}

#pragma mark -
#pragma mark - 跳转至web通用处理类
+ (void)openUrlInCommonWebController:(NSString *)url controller:(UIViewController *)controller title:(NSString *)title
{
    CommonWebController *web = [[CommonWebController alloc] init];
    web.urlPath = [url stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    web.naviTitle = title;
    web.isShowShare = NO;
    web.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:web animated:YES];
}

#pragma mark -
#pragma mark - 追加url信息
+ (void)addUrlInfo:(NSString *)url success:(SuccessBlock)success
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [AccountHelper getUser_Access_token:^(id JSON) {
        if ([url rangeOfString:@"?"].location == NSNotFound) {
            success([NSString stringWithFormat:@"%@?access_token=%@&user_id=%@&client=ios&ver=%@", url, JSON, [[AccountHelper getAccount] userID], version]);
        } else {
            success([NSString stringWithFormat:@"%@&access_token=%@&user_id=%@&client=ios&ver=%@", url, JSON, [[AccountHelper getAccount] userID], version]);
        }
    }];
}

#pragma mark -
#pragma mark - url信息截取
/**根据起点字段fromtext、终点字段toText 对url做信息截取*/
+ (NSString *)getInfoByUrl:(NSString *)url fromText:(NSString *)fromText toText:(NSString *)toText
{
    NSRange range = [url rangeOfString:fromText];
    
    NSRange range2;
    if (toText.length > 0) {
      range2 = [url rangeOfString:toText
                          options:NSLiteralSearch
                            range:NSMakeRange(range.location + range.length, url.length - range.location - range.length)];
    } else {
        return [url substringFromIndex:range.location + range.length];
    }
    
    NSRange substringRange;
    if (range2.location != NSNotFound) {
        substringRange = NSMakeRange(range.location + range.length, range2.location - range.location - range.length);
    } else {
        return [url substringFromIndex:range.location + range.length];
    }
    
    NSString *info = [url substringWithRange:substringRange];
    return info;
}

#pragma mark -
#pragma mark - url native 跳转
+ (void)nativePushWithUrl:(NSString *)url controller:(UIViewController *)controller
{
    if ([UrlParsingHelper isToShare:url]) {
        [UrlParsingHelper controllerInvokeShare:url controller:controller];
    } else if ([UrlParsingHelper isToChat:url]) {
        [UrlParsingHelper pushToChat:url controller:controller];
    } else if ([UrlParsingHelper isToAuths:url]) {
        [UrlParsingHelper pushToOpenAuths:url controller:controller];
    } else if ([UrlParsingHelper isToEventList:url]) {
        [UrlParsingHelper pushToEventList:url controller:controller];
    } else if ([UrlParsingHelper isToEventDetail:url]) {
        [UrlParsingHelper pushToEventDetail:url controller:controller];
//    } else if ([UrlParsingHelper isToArticleDetail:url]) {
//        [UrlParsingHelper pushToArticlDetail:url controller:controller];
//    } else if ([UrlParsingHelper isToArticleList:url]) {
//        [UrlParsingHelper pushToArticleList:url controller:controller];
    } else if ([UrlParsingHelper isToEventInteract:url]) {
        [self pushToEventInteract:url controller:controller];
    } else if ([UrlParsingHelper isToEnterpriseJobList:url]) {
        [self pushToEnterpriseJobList:url controller:controller];
    } else if ([UrlParsingHelper isToEnterpriseRelation:url]) {
        [self pushToEnterpriseRelation:url controller:controller];
    } else if ([UrlParsingHelper isToJobComment:url]) {
        [self pushToJobComment:url controller:controller];
    } else if ([UrlParsingHelper isToJobCreateResume:url]) {
        [self pushToJobCreateResume:url controller:controller];
    } else if ([UrlParsingHelper isToMap:url]) {
        [self pushToEnterpriseMap:url controller:controller];
    } else if ([UrlParsingHelper isToUserInfo:url]) {
        [self pushToUserInfo:url controller:controller];
    } else if ([self isToDiscussion:url]) {
        [self pushToDiscussion:url controller:controller];
    } else if ([self isToArticle:url]) {
        [self pushToArticle:url controller:controller];
    } else if ([self isToEmpolymentDiscussion:url]) {
        [self pushToEmploymentDiscussion:url controller:controller];
    } else if ([self isToUserEditResume:url]) {
        [self pushToUserEditResume:url controller:controller];
    } else if ([self isToUserInfoEdit:url]) {
        [self pushToUserInfoEdit:url controller:controller];
    } else if ([self isToUserJobIntention:url]) {
        [self pushToUserJobIntention:url controller:controller];
    } else if ([self isToMatchContacts:url]) {
        [self pushToMatchContacts:url controller:controller];
    } else if ([self isToInvite:url]) {
        [self pushToInvite:url controller:controller];
    } else if ([self isToFeedback:url]) {
        [self pushToFeedback:url controller:controller];
    } else if ([self isToArticleComment:url]) {
        [self pushToArticleComment:url controller:controller];
    } else {
        [UrlParsingHelper openOutWeb:url];
    }
}

#pragma mark -
#pragma mark - /*是否至个人详情页*/
+ (BOOL)isToUserInfo:(NSString *)url
{
    if ([url rangeOfString:@"/user/profile"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToUserInfo:(NSString *)url controller:(UIViewController *)controller
{
    /*个人ID*/
    NSString *userID = [UrlParsingHelper getInfoByUrl:url fromText:@"?id=" toText:@""];
    
    NewPersonDetailController *vc = [[NewPersonDetailController alloc] init];
    vc.userId = userID;
    [controller.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - /*是否至个人名片信息编辑*/
+ (BOOL)isToUserInfoEdit:(NSString *)url
{
    if ([url rangeOfString:@"/user/editProfile"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToUserInfoEdit:(NSString *)url controller:(UIViewController *)controller
{
    /*个人名片信息编辑*/
    EditPersonCardInfoController *card = [[EditPersonCardInfoController alloc] init];
    card.userDTO = [AccountHelper getAccount];
    [controller.navigationController pushViewController:card animated:YES];
}

#pragma mark -
#pragma mark - /*是否至完善工作意向*/
+ (BOOL)isToUserJobIntention:(NSString *)url
{
    if ([url rangeOfString:@"/user/editJobIntention"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToUserJobIntention:(NSString *)url controller:(UIViewController *)controller
{
    /*完善工作意向*/
    HomeJobChannelIntersetViewController *vc = [[HomeJobChannelIntersetViewController alloc] init];
    vc.type = HomeJobChannelIntersetViewControllerTypeChoseInterest;
    [controller presentViewController:vc animated:YES completion:nil];
}

#pragma mark -
#pragma mark - /*是否至完善简历*/
+ (BOOL)isToUserEditResume:(NSString *)url
{
    if ([url rangeOfString:@"/user/editResume"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToUserEditResume:(NSString *)url controller:(UIViewController *)controller
{
    /*完善简历*/
    MyResumeViewController *vc = [[MyResumeViewController alloc] init];
    vc.comeFrom = MyResumeViewControllerComeFromMe;
    [controller.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - /*是否至匹配通讯录*/
+ (BOOL)isToMatchContacts:(NSString *)url
{
    if ([url rangeOfString:@"/toMatchContacts"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToMatchContacts:(NSString *)url controller:(UIViewController *)controller
{
    /*匹配通讯录*/
    MateFriendsController *phone = [[MateFriendsController alloc] init];
    phone.isDismiss = NO;
    [controller.navigationController pushViewController:phone animated:YES];
}

#pragma mark -
#pragma mark - /*是否至拓展人脉*/
+ (BOOL)isToInvite:(NSString *)url
{
    if ([url rangeOfString:@"/toInvite"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToInvite:(NSString *)url controller:(UIViewController *)controller
{
    /*拓展人脉*/
    AddDegreeController *degree = [[AddDegreeController alloc] init];
    [controller.navigationController pushViewController:degree animated:YES];
}

#pragma mark -
#pragma mark - /*是否至用户反馈*/
+ (BOOL)isToFeedback:(NSString *)url
{
    if ([url rangeOfString:@"/toFeedback"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToFeedback:(NSString *)url controller:(UIViewController *)controller
{
    /*用户反馈*/
    FeedbackController *feedBack = [[FeedbackController alloc] init];
    [controller presentViewController:feedBack animated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark - /*是否跳转简历预览*/
+ (BOOL)isToJobCreateResume:(NSString *)url
{
    if ([url rangeOfString:@"/job/createResume"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToJobCreateResume:(NSString *)url controller:(UIViewController *)controller
{
    /*职位ID*/
    NSString *enterpriseID = [UrlParsingHelper getInfoByUrl:url fromText:@"?id=" toText:@""];
    
    MyResumeViewController *vc = [[MyResumeViewController alloc] init];
    vc.comeFrom = MyResumeViewControllerComeFromPostDetail;
    vc.positionId = enterpriseID;
    [controller.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"%@",enterpriseID);
}

#pragma mark -
#pragma mark - /*是否跳转文章讨论*/
+ (BOOL)isToArticleComment:(NSString *)url
{
    if ([url rangeOfString:@"/comment/article?"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToArticleComment:(NSString *)url controller:(UIViewController *)controller
{
    /*文章ID*/
    NSString *articleID = [UrlParsingHelper getInfoByUrl:url fromText:@"?id=" toText:@""];
    
    HomeChannelDiscussionAndArticleCommentViewController *vc = [[HomeChannelDiscussionAndArticleCommentViewController alloc] init];
    vc.articleAndDiscussionID = articleID;
    [controller.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - /*是否跳转职位讨论*/
+ (BOOL)isToJobComment:(NSString *)url
{
    if ([url rangeOfString:@"/job/comment?"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToJobComment:(NSString *)url controller:(UIViewController *)controller
{
    /*职位ID*/
    NSString *enterpriseID = [UrlParsingHelper getInfoByUrl:url fromText:@"?id=" toText:@""];
    
    HomeChannelDiscussionAndArticleCommentViewController *vc = [[HomeChannelDiscussionAndArticleCommentViewController alloc] init];
    vc.type = HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment;
    vc.employmentID = enterpriseID;
    [controller.navigationController pushViewController:vc animated:YES];

    
    NSLog(@"%@",enterpriseID);
}

#pragma mark -
#pragma mark - /*是否跳转企业人脉*/
+ (BOOL)isToEnterpriseRelation:(NSString *)url
{
    if ([url rangeOfString:@"/job/enterpriseContactsMore?"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToEnterpriseRelation:(NSString *)url controller:(UIViewController *)controller
{
    /*企业ID*/
    NSString *enterpriseID = [UrlParsingHelper getInfoByUrl:url fromText:@"?id=" toText:@""];
    
    HomeJobChannelUnitRelationViewController *vc = [[HomeJobChannelUnitRelationViewController alloc] init];
    vc.enterpriseID = enterpriseID;
    [controller.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - /*查看企业所有招聘职位*/
+ (BOOL)isToEnterpriseJobList:(NSString *)url
{
    if ([url rangeOfString:@"/job/enterpriseJobList?"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToEnterpriseJobList:(NSString *)url controller:(UIViewController *)controller
{
    /*企业ID*/
    NSString *enterpriseID = [UrlParsingHelper getInfoByUrl:url fromText:@"?id=" toText:@""];
    HomeJobChannelUnitAndEmploymentSearchViewController *vc =[[HomeJobChannelUnitAndEmploymentSearchViewController alloc] init];
    vc.type = HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmploymentFromWeb;
    vc.enterpriseID = enterpriseID;
    [controller.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"%@",enterpriseID);
}

#pragma mark -
#pragma mark - /*是否跳转至身份认证*/
+ (BOOL)isToAuths:(NSString *)url
{
    if ([url rangeOfString:@"/openAuths"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

/*跳转至身份认证*/
+ (void)pushToOpenAuths:(NSString *)url controller:(UIViewController *)controller
{
    NewPersonIdentificationController *person = [[NewPersonIdentificationController alloc] init];
    person.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:person animated:YES];
    [person loadData];
}

#pragma mark -
#pragma mark - /*是否调用分享*/
+ (BOOL)isToShare:(NSString *)url
{
    if ([url rangeOfString:@"/shareTo?msg"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

/**父类调用分享功能*/
+ (void)controllerInvokeShare:(NSString *)url controller:(UIViewController *)controller
{
    NSString *path = [UrlParsingHelper getInfoByUrl:url fromText:@"/shareTo?msg=" toText:@""];
    if ([controller respondsToSelector:@selector(clickShareWithInfo:)]) {
        [controller performSelector:@selector(clickShareWithInfo:) withObject:path];
    }
}

#pragma mark -
#pragma mark - /*是否跳转至聊天*/
+ (BOOL)isToChat:(NSString *)url
{
    if ([url rangeOfString:@"/chatTo?"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

/*跳转至聊天*/
+ (void)pushToChat:(NSString *)url controller:(UIViewController *)controller
{
    NSString *userID = [UrlParsingHelper getInfoByUrl:url fromText:@"uid=" toText:@"&msg"];
    
    NSString *msg = @"";
    NSInteger type = 0;
    if ([url rangeOfString:@"&type"].location != NSNotFound) {
        msg = [UrlParsingHelper getInfoByUrl:url fromText:@"&msg=" toText:@"&type"];
        type = [[UrlParsingHelper getInfoByUrl:url fromText:@"&type=" toText:@""] integerValue];
    } else {
        msg = [UrlParsingHelper getInfoByUrl:url fromText:@"&msg=" toText:@""];
    }
    
    NSDictionary *param = @{@"userid": userID};
    [UserManager getUserInfoFull:param success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UserDTO *dto = (UserDTO *)JSON;
            MessageController *mc = [[MessageController alloc] init];
            mc.parent = controller;
            mc.target = dto;
            mc.hidesBottomBarWhenPushed = YES;
            [controller.navigationController pushViewController:mc animated:YES];
            if (msg.length > 0) {
                [mc setInputMessage:msg];
            }
        });
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark -
#pragma mark - /*是否跳转活动列表*/
+ (BOOL)isToEventList:(NSString *)url
{
    if ([url rangeOfString:@"/list/event"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToEventList:(NSString *)url controller:(UIViewController *)controller
{
    EventViewController *event = [[EventViewController alloc] init];
    event.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:event animated:YES];
}

#pragma mark -
#pragma mark - /*是否活动详情*/
+ (BOOL)isToEventDetail:(NSString *)url
{
    if ([url rangeOfString:@"/detail/event"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToEventDetail:(NSString *)url controller:(UIViewController *)controller
{
    NSString *eventID = [UrlParsingHelper getInfoByUrl:url fromText:@"?id=" toText:@""];
    EventFeedViewController *event = [[EventFeedViewController alloc] init];
    event.hidesBottomBarWhenPushed = YES;
    event.eventID = eventID;
    [controller.navigationController pushViewController:event animated:YES];
}

#pragma mark -
#pragma mark - /*是否活动互动*/
+ (BOOL)isToEventInteract:(NSString *)url
{
    if ([url rangeOfString:@"/interact/event"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToEventInteract:(NSString *)url controller:(UIViewController *)controller
{
    NSString *eventID = [UrlParsingHelper getInfoByUrl:url fromText:@"?id=" toText:@""];
    EventFeedViewController *event = [[EventFeedViewController alloc] init];
    event.hidesBottomBarWhenPushed = YES;
    event.eventID = eventID;
    [controller.navigationController pushViewController:event animated:YES];
   // [event loadEventInfoFromWebActivity:eventID];
}

#pragma mark -
#pragma mark - /*是否跳转至热文列表*/
//+ (BOOL)isToArticleList:(NSString *)url
//{
//    if ([url rangeOfString:@"/list/article"].location != NSNotFound) {
//        return YES;
//    }
//    return NO;
//}
//
//+ (void)pushToArticleList:(NSString *)url controller:(UIViewController *)controller
//{
//    
//}
//
///*是否跳转至热文详情*/
//+ (BOOL)isToArticleDetail:(NSString *)url
//{
//    if ([url rangeOfString:@"/detail/article"].location != NSNotFound) {
//        return YES;
//    }
//    return NO;
//}
//
//+ (void)pushToArticlDetail:(NSString *)url controller:(UIViewController *)controller
//{
//    
//}

/*
 跳转地图
 */
+ (BOOL)isToMap:(NSString *)url
{
    if ([url rangeOfString:@"/showMap?"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToEnterpriseMap:(NSString *)url controller:(UIViewController *)controller
{
    double latitude = [[self getInfoByUrl:url fromText:@"latitude=" toText:@"&"] doubleValue];
    double longitude = [[self getInfoByUrl:url fromText:@"longitude=" toText:@"&"] doubleValue];
    NSString *enterpriseName = [self getInfoByUrl:url fromText:@"name=" toText:nil];
    
    HomeJobChannelEnterpriseMapViewController *vc = [[HomeJobChannelEnterpriseMapViewController alloc] init];
    vc.latitude = latitude;
    vc.longitude = longitude;
    vc.enterpriseName = enterpriseName;
    [controller.navigationController pushViewController:vc animated:YES];
}

/*
 打开讨论详情
 */

+ (BOOL)isToDiscussion:(NSString *)url
{
    if ([url rangeOfString:@"/native/detail/discuss?"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToDiscussion:(NSString *)url controller:(UIViewController *)controller
{
    NSString *discussionID = [self getInfoByUrl:url fromText:@"/native/detail/discuss?id=" toText:nil];
    
    HomeChannelDiscussionAndArticleCommentViewController *vc = [[HomeChannelDiscussionAndArticleCommentViewController alloc] init];
    vc.articleAndDiscussionID = discussionID;
    [controller.navigationController pushViewController:vc animated:YES];
}


/*
 职位讨论
 */
+ (BOOL)isToEmpolymentDiscussion:(NSString *)url
{
    if ([url rangeOfString:@"/native/job/comment?"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToEmploymentDiscussion:(NSString *)url controller:(UIViewController *)controller
{
    NSString *discussionID = [self getInfoByUrl:url fromText:@"/native/job/comment?id=" toText:nil];
    
    HomeChannelDiscussionAndArticleCommentViewController *vc = [[HomeChannelDiscussionAndArticleCommentViewController alloc] init];
    vc.employmentID = discussionID;
    [controller.navigationController pushViewController:vc animated:YES];
}

/*
 打开文章
*/

+ (BOOL)isToArticle:(NSString *)url
{
    if([url rangeOfString:@"/native/detail/article?"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)pushToArticle:(NSString *)url controller:(UIViewController *)controller
{
    NSString *articleID = [self getInfoByUrl:url fromText:@"/native/detail/article?id=" toText:nil];
    
    HomeChannelArticleDetailViewController *vc = [[HomeChannelArticleDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.articleID = articleID;
    [controller.navigationController pushViewController:vc animated:YES];
}

@end
