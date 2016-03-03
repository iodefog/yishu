//
//  MessageController.m
//  medtree
//
//  Created by sam on 8/14/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "MessageController.h"
// View
#import "MessageCell.h"
#import "MessageInputBox.h"
#import "RecorderView.h"
#import "NewPersonDetailController.h"
#import <InfoAlertView.h>
#import "CHPhotoBrowser.h"
// Manager
#import "ServiceManager.h"
// DTO
#import "MessageDTO.h"
#import "UserDTO.h"
#import "CHPhoto.h"
// Util
#import "IMUtil+Public.h"
#import "AccountHelper.h"
#import "ImagePicker.h"
#import "OperationHelper.h"
#import "DateUtil.h"
#import "FileUtil.h"
#import "AudioUtil.h"
#import "UploadHelper.h"
#import "UrlParsingHelper.h"
#import "JSONKit.h"
#import "FontUtil.h"
#import "UIButton+setImageWithURL.h"
#import "RootViewController.h"
#import "NSString+Extension.h"

const NSInteger kResendMessageTag = 10000;

@interface MessageController () <MessageOperationDelegate, ImagePickerDelegate>
{
    UIButton                *rightButton;
    RecorderView            *recorderView;
    CGRect                  keyboardBounds;
    
    NSInteger               uiType;
    
    NSTimeInterval          lastTime;
    NSTimeInterval          lastCellTime;

    NSString                *sessionID;
    
    double                  duration;
    int                     curve;
    
    MessageCell             *lastCell;
    MessageDTO              *resendDTO;
    
    /** 进来时，当前控制器数 */
    NSUInteger              controllerCount;
    /** 消息类型 */
    SessionType             sessionType;
    
    BOOL                    refuseState;
}
@property (nonatomic, strong) UIButton *refuseButton;

@property (nonatomic, strong) UIButton *topTitleButton;

@property (nonatomic, strong) UIView *hintView;

@property (nonatomic, strong) MessageInputBox *inputBox;

@property (nonatomic, strong) NSMutableArray *dataList;
/** 开启发送队列 */
@property (nonatomic, assign) BOOL openQueue;
/** 发送队列 */
@property (nonatomic, strong) NSMutableArray *sendQueue;

@property (nonatomic, strong) AudioUtil *audioUtil;

@property (nonatomic, strong) NSMutableArray *imageList;

@end

@implementation MessageController

#pragma mark - UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    curve = 7;
    duration = 0.25;
    
    [self resize];
    [self setupData];
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setRightOffset:10];
    [self createBackButton];
    [self createRightButton];
    
    [table registerCell:[MessageCell class]];
    table.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    table.enableHeader = YES;
    
    [self.view addSubview:self.inputBox];
    
    recorderView = [[RecorderView alloc] initWithFrame:CGRectZero];
    recorderView.hidden = YES;
    [self.view addSubview:recorderView];
}

- (void)createRightButton
{
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 32, 32);
    rightButton.layer.cornerRadius = 16;
    rightButton.layer.masksToBounds = YES;
    
    [rightButton addTarget:self action:@selector(clickHeader) forControlEvents:UIControlEventTouchUpInside];
    [naviBar setRightButton:rightButton];
}

- (void)setupData
{
    controllerCount = self.navigationController.viewControllers.count;

    if (self.target) {
        sessionID = [MessageTypeProxy getSessionKeyFromUser:self.target];
        if (sessionID.length == 0) {
            [InfoAlertView showInfo:@"您不是他的好友无法聊天" inView:self.view duration:2.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        sessionType = SessionTypeSingle;
        [naviBar setTopTitle:self.target.name];
//        if (self.target.isFriend) {
//            [naviBar setTopTitle:self.target.name];
//        } else {
//            [self.topTitleButton setTitle:self.target.name forState:UIControlStateNormal];
//            CGFloat nameW = [self.target.name getStringWithFont:[UIFont systemFontOfSize:18]];
//            self.topTitleButton.imageEdgeInsets = UIEdgeInsetsMake(0, nameW + 2, 0, 0);
//            self.topTitleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
//            self.topTitleButton.frame = CGRectMake(0, 0, nameW + 15, 44);
//            [naviBar setTopView:self.topTitleButton];
//            [self.view addSubview:self.hintView];
//        }
        
        NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Small], self.target.photoID];
        [rightButton med_setImageWithURL:[NSURL URLWithString:path] forState:UIControlStateNormal];
        
        NSDictionary *param = @{@"method": [NSNumber numberWithInteger:MethodType_MessageList], @"sessionID": sessionID};
        [ServiceManager getData:param success:^(NSArray *JSON) {
            if (JSON.count > 0) {
                self.dataList = [NSMutableArray arrayWithArray:JSON];
                [self checkCellTimes];
                [table setData:@[self.dataList]];
                [self scrollToTableBottom:YES];
            }
        } failure:^(NSError *error, id JSON) {
            
        }];
        
        // 获取屏蔽状态
//        [MessageManager getData:@{@"method":@(MethodType_Refuse_Message), @"remote_id":self.target.userID} success:^(id JSON) {
//            if ([JSON[@"success"] boolValue]) {
//                refuseState = [JSON[@"result"][@"refuse_message"] boolValue];
//                self.refuseButton.selected = refuseState;
//            }
//        } failure:^(NSError *error, id JSON) {
//            
//        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (sessionID.length > 0) {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"max_msg_id": @(-1), @"limit":@6, @"type": @(sessionType)}];
        if (sessionType == SessionTypeGroup) {
            [param setObject:sessionID forKey:@"group_chat_id"];
        } else {
            [param setObject:sessionID forKey:@"remote_chat_id"];
        }
        [param setObject:@(PullOldMsgRequestLatest) forKey:@"request_type"];
        [[IMUtil sharedInstance] pullOldMsg:param];
    } else {
        [InfoAlertView showInfo:@"聊天界面未初始化成功" inView:self.view duration:2.0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopVoice];
    [self.audioUtil stopPlaying];
    NSUInteger count = self.navigationController.viewControllers.count;
    if (controllerCount > count) {
        MessageDTO *last = [[self getValidArray] lastObject];\
        [[IMUtil sharedInstance] readAck:@{@"type":@(sessionType),
                                           @"remote_chat_id":sessionID,
                                           @"msg_id":@(last.remoteID),
                                           @"user_chat_id":[AccountHelper getAccount].chatID}];
        [MessageManager updateSessionUnreadStatus:sessionID];
        if ([self.delegate respondsToSelector:@selector(backFromMessage)]) {
            [self.delegate backFromMessage];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:MessageListChangeNotification object:nil];
        }
    }
}

- (void)resize
{
    CGSize size = self.view.frame.size;
    CGFloat offset = CGRectGetMaxY(naviBar.frame);
    if (!self.target.isFriend) {
//        offset += self.hintView.frame.size.height;
    }
    CGFloat offset2 = [self.inputBox getInputHeight];
    if (uiType == MessageInput_Show_Keyboard) {
        offset2 += keyboardBounds.size.height;
    }
    
    [MessageCell setCellWidth:size.width];
    self.inputBox.frame = CGRectMake(0, size.height - offset2, size.width, [self.inputBox getInputHeight]);
    
    table.frame = CGRectMake(0, offset, size.width, size.height - offset - offset2);
    recorderView.frame = CGRectMake((size.width - 150) / 2, (size.height - 150) / 2, 150, 150);
    
    [self scrollToTableBottom:YES];
}

#pragma mark 通知
- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTableData:) name:MessageStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadHistoryData:) name:MessagePullHistoryMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData:) name:MessagePullNewMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMsgNotification:) name:NewMessageNotification object:nil];
}

#pragma mark - public
- (BOOL)isMatchSession:(NSString *)sid
{
    BOOL isMatch = NO;
    if ([sessionID isEqualToString:sid]) {
        isMatch = YES;
    }
    return isMatch;
}

- (void)setInputMessage:(NSString *)text
{
    [self.inputBox becomeFirstResponder];
    [self.inputBox setInputMessage:text];
}

#pragma mark - 键盘事件
- (void)kbWillShow:(NSNotification*)notification
{
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    //
    [self showKeyboard];
}

- (void)kbWillHide:(NSNotification*)notification
{
    if (uiType == MessageInput_Show_Keyboard) {
        duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
        //
        [self hideKeyboard];
    }
}

- (void)showKeyboard
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    
    CGSize size = self.view.frame.size;
    CGFloat offset = naviBar.frame.origin.y + naviBar.frame.size.height;
    if (!self.target.isFriend) {
//        offset += self.hintView.frame.size.height;
    }
    self.inputBox.frame = CGRectMake(0,
                                size.height-keyboardBounds.size.height-[self.inputBox getInputHeight],
                                size.width,
                                [self.inputBox getInputHeight]);
    
    table.frame = CGRectMake(0, offset, size.width, size.height-offset-[self.inputBox getInputHeight]-keyboardBounds.size.height);
    [UIView commitAnimations];
    [self scrollToTableBottom:YES];
    uiType = MessageInput_Show_Keyboard;
}

- (void)hideKeyboard
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    
    CGSize size = self.view.frame.size;
    CGFloat offset = naviBar.frame.origin.y + naviBar.frame.size.height;
    if (!self.target.isFriend) {
//        offset += self.hintView.frame.size.height;
    }
    self.inputBox.frame = CGRectMake(0,
                                size.height-[self.inputBox getInputHeight],
                                size.width,
                                [self.inputBox getInputHeight]);
    
    table.frame = CGRectMake(0, offset, size.width, size.height-offset-[self.inputBox getInputHeight]);
    [UIView commitAnimations];
    [self scrollToTableBottom:YES];
    uiType = MessageInput_Hide_Keyboard;
}

#pragma mark 键盘状态
- (void)setUiType:(NSInteger)type
{
    uiType = type;
    if (uiType == MessageInput_Show_Keyboard) {
        [self showKeyboard];
    } else {
        [self hideKeyboard];
        uiType = type;
    }
}

- (void)clickTable
{
    if (uiType != MessageInput_Hide_Keyboard) {
        [self hideKeyboard];
        [self.inputBox resignResponder];
    }
}

#pragma mark 检查是否显示时间 & 设置
- (void)checkCellTimes
{
    lastCellTime = 0;
    for (NSUInteger i = 0; i < self.dataList.count; i++) {
        MessageDTO *dto = [self.dataList objectAtIndex:i];
        BOOL isShowTime = [MessageCell isShowTime:dto lastTime:[NSDate dateWithTimeIntervalSince1970:lastCellTime]];
        dto.isShowTime = isShowTime;

        dto.isFromSelf = [dto.fromID isEqualToString:[AccountHelper getAccount].chatID]; // 目前sessionId == ID_ID ， chatID为服务器返回的对UserId封装的消息
        if (dto.isFromSelf) { // 自己
            dto.fromUser = [AccountHelper getAccount];
            dto.toUser = self.target;
        } else { // 他人
            dto.toUser = [AccountHelper getAccount];
            dto.fromUser = self.target;
        }
        if (isShowTime == YES) {
            lastCellTime = dto.updateTime.timeIntervalSince1970;
        }
    }
}

#pragma mark - 文本消息发送
- (void)didSendMessage:(MessageDTO *)dto
{
    NSString *from = [AccountHelper getAccount].chatID;
    NSString *to = (self.target.chatID.length > 0) ? self.target.chatID:sessionID;
    NSDictionary *dict = @{@"content": dto.content,
                           @"from": from, @"to": to,
                           @"session": sessionID,
                           @"touser": self.target.userID,
                           @"fromuser": [[AccountHelper getAccount] userID],
                           @"type":@(MessageTypeInstanceText),
                           @"sessionType":@(sessionType)};
    MessageDTO *message = [[MessageDTO alloc] init:dict];

    message.createTime = [NSDate date];
    message.updateTime = [NSDate date];
    //
    if (self.openQueue) {
        [self.sendQueue addObject:message];
    } else {
        message = [[IMUtil sharedInstance] sendMessage:message];
    }
    //
    message.fromUser = [AccountHelper getAccount];
    message.toUser = self.target;
    //
    [self addMessageDTO:message];
}

#pragma mark 列表添加消息
- (void)addMessageDTO:(MessageDTO *)message
{
    [self.dataList addObject:message];
    //
    [self checkCellTimes];
    
    [table setData:@[self.dataList]];
    //
    [self scrollToTableBottom:YES];
}

#pragma mark 检查消息列表的完整性
- (long)getLatestMsgId
{
    long latestId = 0;
    for (NSInteger i = self.dataList.count - 1; i >= 0; i--) {
        MessageDTO *dto = [self.dataList objectAtIndex:i];
        if (dto.remoteID > 0) {
            latestId = dto.remoteID;
            break;
        }
    }
    return latestId;
}

#pragma mark - 相机
- (void)showCamera
{
    NSString *file = [NSString stringWithFormat:@"%@_%@", sessionID, [DateUtil getFormatTime:[NSDate new] format:@"yyyyMMddHHmmss"]];
    [ImagePicker showCamera:@{@"name": file} uvc:self delegate:self];
}

#pragma mark - 相册
- (void)showAlbum
{
    NSString *file = [NSString stringWithFormat:@"%@_%@", sessionID, [DateUtil getFormatTime:[NSDate new] format:@"yyyyMMddHHmmss"]];
    [ImagePicker showAlbum:@{@"name": file} uvc:self delegate:self];
}

#pragma mark - ImagePickerDelegate
- (void)didSavePhoto:(NSDictionary *)userInfo
{
    NSString *file = [userInfo objectForKey:@"file"];
    UIImage *image = [userInfo objectForKey:@"image"];
    NSString *from = [[AccountHelper getAccount] chatID];
    NSString *to = self.target.chatID;
    
    // 发送图片状态
    NSDictionary *info = @{@"path": file, @"width": [NSNumber numberWithFloat:image.size.width], @"height": [NSNumber numberWithFloat:image.size.height]};
    NSDictionary *content = @{@"image": info};
    MessageDTO *message = [[MessageDTO alloc] init:@{@"content": [content JSONString],
                                                     @"from": from,
                                                     @"to": to,
                                                     @"session": sessionID,
                                                     @"touser": self.target.userID,
                                                     @"fromuser": [[AccountHelper getAccount] userID],
                                                     @"type":@(MessageTypeInstanceImage),
                                                     @"sessionType":@(sessionType)}];
    message.createTime = [NSDate date];
    message.updateTime = [NSDate date];
    message.status = MessageUploading;
    message.fromUser = [AccountHelper getAccount];
    message.toUser = self.target;
    message.messageID = [NSString stringWithFormat:@"%lld", [[MessageBase genRID] longLongValue]];
    //
    [MessageManager addMessage:message success:nil failure:nil];
    
    [self addMessageDTO:message];
    
    // 上传图片更新状态
    [self uploadImageFile:file image:image messageId:message.messageID];
}

#pragma mark - 声音操作
#pragma mark 开始录音录音
- (void)startRecording
{
    recorderView.hidden = NO;
    [recorderView startRecord];
    self.view.userInteractionEnabled = NO;

    [self.audioUtil createRecordName:nil];
    [self.audioUtil startRecording];
}

#pragma mark 取消录音
- (void)cancelRecording
{
    recorderView.hidden = YES;
    [recorderView stopRecord];
    self.view.userInteractionEnabled = YES;
    [self.audioUtil cancelRecording];
}

#pragma mark 结束录音
- (void)stopRecording
{
    [self.audioUtil stopRecordingWithBlock:^(NSTimeInterval currentTime, NSString *filePath) {
        if (currentTime >= 1) {
            // 预发送语音
            NSDictionary *info = @{@"path":filePath, @"duration":@(currentTime)};
            NSDictionary *content = @{@"voice": info};
            NSString *from = [[AccountHelper getAccount] chatID];
            NSString *to = self.target.chatID;
            NSDictionary *dict = @{@"content": [content JSONString],
                                   @"from": from,
                                   @"to": to,
                                   @"session": sessionID,
                                   @"touser": self.target.userID,
                                   @"fromuser": [[AccountHelper getAccount] userID],
                                   @"type":@(MessageTypeInstanceVoice),
                                   @"sessionType":@(sessionType)};
            MessageDTO *message = [[MessageDTO alloc] init:dict];
            message.createTime = [NSDate date];
            message.updateTime = [NSDate date];
            message.status = MessageUploading;
            message.fromUser = [AccountHelper getAccount];
            message.toUser = self.target;
            message.messageID = [NSString stringWithFormat:@"%lld", [[MessageBase genRID] longLongValue]];
            //
            [MessageManager addMessage:message success:nil failure:nil];
            
            [self addMessageDTO:message];
            
            // 声音上传
            [self uploadVoiceFile:filePath duration:currentTime messageId:message.messageID];

            recorderView.hidden = YES;
            [recorderView stopRecord];
        } else {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            [recorderView setShortCancelRecord];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                recorderView.hidden = YES;
            });
        }
    }];
    
    self.view.userInteractionEnabled = YES;
}

#pragma mark YES:设置取消录音 NO:设置继续录音
- (void)setCancelRecordStatus:(BOOL)tf
{
    if ([recorderView isHidden]) {
        recorderView.hidden = NO;
    }
    [recorderView setCancelRecordStatus:tf];
}

#pragma mark - 点击事件
- (void)clickShowButton
{
    [UIView animateWithDuration:0.25 animations:^{
        self.refuseButton.transform = CGAffineTransformMakeTranslation(0, CGRectGetMaxY(naviBar.frame));
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.refuseButton];
    }];
}

- (void)clickChangeRefuseState
{
    if (self.target) {
        [MessageManager setData:@{@"method":@(MethodType_PUT_Refuse_Message), @"remote_id":self.target.userID, @"refuse_message":@(!refuseState)} success:^(id JSON) {
            if (JSON[@"success"]) {
                self.refuseButton.selected = refuseState;
            }
            [UIView animateWithDuration:0.25 animations:^{
                self.refuseButton.transform = CGAffineTransformIdentity;
                [self.view sendSubviewToBack:self.refuseButton];
            }];
        } failure:^(NSError *error, id JSON) {
            [UIView animateWithDuration:0.25 animations:^{
                self.refuseButton.transform = CGAffineTransformIdentity;
                [self.view sendSubviewToBack:self.refuseButton];
            }];
        }];
    }
}

#pragma mark 返回
- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 选择头像
- (void)clickHeader
{
    [self pushToPerson:self.target];
}

#pragma mark 点击cell后续事件
- (void)clickCell:(id)dto action:(NSNumber *)action
{
    if ([action integerValue] == ClickAction_MessageContact) {
        [self pushToPerson:dto];
    } else if ([action integerValue] == ClickAction_ShowImage) {
        [self.inputBox resignResponder];
        [self showImage:dto];
    } else if ([action integerValue] == ClickAction_PlayVoice) {
        [self stopVoice];
        lastCell = dto;
    } else if ([action integerValue] == ClickAction_MessageStatus) {
        resendDTO = dto;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"发送消息失败，请选择重传或取消" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重发", nil];
        alert.tag = kResendMessageTag;
        [alert show];
    } else if ([action integerValue] == ClickAction_OpenURL) {
        if (dto != nil) {
            [UrlParsingHelper operationUrl:dto controller:self title:@"详情"];
        }
    } else if ([action integerValue] == ClickAction_MessageContent) {
        [self clickTable];
    } else if ([action integerValue] == ClickAction_MessageLongPress) {
        [self.inputBox resignResponder];
    }
}

#pragma mark 进入个人详情
- (void)pushToPerson:(UserDTO *)dto
{
    NewPersonDetailController *pc = [[NewPersonDetailController alloc] init];
    pc.userDTO = dto;
    pc.fromMessageController = YES;
    [self.navigationController pushViewController:pc animated:YES];
}

#pragma mark 显示图片
- (void)showImage:(MessageDTO *)dto
{
    [self findAllImage];
    if (self.imageList.count > 0) {
        NSInteger index = [self.dataList indexOfObject:dto];
        __block NSInteger currentIndex = 0;
        [self.imageList enumerateObjectsUsingBlock:^(CHPhoto *dto, NSUInteger idx, BOOL * _Nonnull stop) {
            if (dto.cellIndex == index) {
                currentIndex = idx;
            }
        }];
        
        CHPhotoBrowser *browser = [[CHPhotoBrowser alloc] init];
        browser.currentPhotoIndex = currentIndex;
        browser.photos = self.imageList;
        [browser show];
    }
}

#pragma mark - 播放声音
- (void)stopVoice
{
    [lastCell stopVoice];
}

#pragma mark - Message Come In Notification
#pragma mark Change Send Message Status
- (void)loadTableData:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (notification != nil && notification.object != nil) {
            if ([notification.object isKindOfClass:[MessageDTO class]]) {
                MessageDTO *dto = notification.object;
                if (dto.status == MessagePending) {
                    return;
                } else { // 发送的消息状态更新
                    // 更换状态
                    if (dto.errorCode == ERROR_NOT_FRIENDS) {
                        [InfoAlertView showInfo:@"他已经不是您的好友" inView:self.view duration:2.0];
                    }
                    NSLog(@"============一条信息状态改变开始================ %@", dto.messageID);
                    for (MessageDTO *msg in self.dataList) {
                        if (msg.remoteID == 0) {
                            if ([msg.messageID isEqualToString:dto.messageID]) {
                                msg.status = dto.status;
                                msg.remoteID = dto.remoteID;
                                NSLog(@"============状态改变成功=========");
                            }
                        }
                    }
                    NSLog(@"============一条信息状态改变结束================");
                    [table setData:@[self.dataList]];
                }
            }
        }
    });
}

#pragma mark Old Message
- (void)loadHistoryData:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (notification.object) {
            MessageDTO *dto = [[self getValidArray] firstObject];
            NSLog(@"load old - %@", @(dto.remoteID));
            NSDictionary *param = @{@"method": [NSNumber numberWithInteger:MethodType_MessageList_Pull_HistoryMessage], @"sessionID": sessionID, @"createTime": dto.createTime?dto.createTime:@0};
            [ServiceManager getData:param success:^(NSArray *array) {
                if (array.count > 0) {
                    NSLog(@"\n\n\n\n\n\n\n\n\n  pull old \n %@ \n %@ \n\n\n\n\n\n", self.dataList, array);
                    [self.dataList insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                    [self checkCellTimes];
                    [table setData:@[self.dataList]];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataList indexOfObject:dto] inSection:0];
                    [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    
                    MessageDTO *lastDto = [[self getValidArray] lastObject];
                    if (self.dataList.count >= lastDto.remoteID) {
                        table.enableHeader = NO;
                    }
                }
            } failure:^(NSError *error, id JSON) {
                
            }];
        }
    });
}

#pragma mark Load New Remote Message
- (void)loadNewData:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (notification.object) {
            if (self.dataList.count == 0) {
                [MessageManager getMessageList:@{@"sessionID":sessionID} success:^(NSArray *JSON) {
                    self.dataList = [NSMutableArray arrayWithArray:JSON];
                    [self checkCellTimes];
                    [table setData:@[self.dataList]];
                    [self scrollToTableBottom:YES];
                } failure:^(NSError *error, id JSON) {
                    
                }];
            } else {
                NSArray *array = notification.object;
                MessageDTO *lastDto = [[MessageDTO alloc] init:[array lastObject]];
                MessageDTO *dto = [self getValidArray].lastObject;
                
                if (dto.remoteID < lastDto.remoteID) {
                    [MessageManager getMessageList:@{@"sessionID":sessionID} success:^(NSArray *JSON) {
                        [self.dataList removeAllObjects];
                        self.dataList = [NSMutableArray arrayWithArray:JSON];
                        [self checkCellTimes];
                        [table setData:@[self.dataList]];
                        [self scrollToTableBottom:YES];
                    } failure:^(NSError *error, id JSON) {
                        
                    }];
                } else {
                    MessageDTO *remoteDto = [self getLastRemoteMessage];
                    NSDictionary *param = @{@"method":[NSNumber numberWithInteger:MethodType_MessageList_Pull_NewMessage], @"sessionID": sessionID, @"createTime":remoteDto.createTime?remoteDto.createTime:@0};
                    [ServiceManager getData:param success:^(NSArray *array) {
                        if (array.count > 0) {
                            [self.dataList addObjectsFromArray:array];
                            [self checkCellTimes];
                            [table setData:@[self.dataList]];
                            [self scrollToTableBottom:YES];
                        }
                    } failure:^(NSError *error, id JSON) {
                        
                    }];
                }
            }
            
            if (self.sendQueue.count > 0) {
                for (MessageDTO *msg in self.sendQueue) {
                    [[IMUtil sharedInstance] sendMessage:msg];
                }
            }
        }
    });
}

#pragma mark - New Message Come In
- (void)newMsgNotification:(NSNotification *)notification
{
    if (notification.object) {
        MessageDTO *dto = notification.object;
        if ([dto.sessionID isEqualToString:sessionID]) {
            self.openQueue = YES;
        }
    }
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kResendMessageTag) {
        if (buttonIndex == 1) {
            [self resendMessage];
        }
    }
}

#pragma mark - table delegate
- (void)loadHeader:(BaseTableView *)tableT
{
    if (self.dataList.count > 0) {
        MessageDTO *firstDto = [[self getValidArray] firstObject];
        MessageDTO *lastDto = [[self getValidArray] lastObject];
        if (lastDto.remoteID <= self.dataList.count) {
            tableT.enableHeader = NO;
        } else {
            NSDictionary *param = @{@"method": [NSNumber numberWithInteger:MethodType_MessageList_HistoryMessage],
                                    @"sessionID": sessionID,
                                    @"createTime": firstDto.createTime,
                                    @"remoteID":@(lastDto.remoteID)};
            [ServiceManager getData:param success:^(NSArray *array) {
                if (array.count == 0) { //向服务器拉历史消息
                    NSString *toID = sessionID;
                    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"max_msg_id": @(firstDto.remoteID - 1), @"limit":@6, @"type": @(sessionType)}];
                    if (sessionType == SessionTypeGroup) {
                        [param setObject:toID forKey:@"group_chat_id"];
                    } else {
                        [param setObject:toID forKey:@"remote_chat_id"];
                    }
                    [param setObject:@(PullOldMsgRequestOld) forKey:@"request_type"];
                    [[IMUtil sharedInstance] pullOldMsg:param];
                } else { // 直接显示在界面上
                    [self.dataList insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                    [self checkCellTimes];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [table setData:@[self.dataList]];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataList indexOfObject:firstDto] inSection:0];
                        [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    });
                    
                    if (self.dataList.count >= lastDto.remoteID) {
                        tableT.enableHeader = NO;
                    }
                }
            } failure:^(NSError *error, id JSON) {
                
            }];
        }
    }
}

#pragma mark - /////////////////////////////////////////
#pragma mark - private
- (void)resendMessage
{
    if (resendDTO.status == MessageUploadFail) {
        resendDTO.status = MessagePending;
        if (resendDTO.type == MessageTypeInstanceImage) { // 图片
            NSDictionary *dict = [resendDTO.content objectFromJSONString];
            NSString *filePath = dict[@"image"][@"path"];
            NSError *error;
            NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedAlways error:&error];
            UIImage *image = [UIImage imageWithData:data];
            [self uploadImageFile:filePath image:image messageId:resendDTO.messageID];
        } else if (resendDTO.type == MessageTypeInstanceVoice) {
            NSDictionary *dict = [resendDTO.content objectFromJSONString];
            NSString *filePath = dict[@"voice"][@"path"];
            double length = [dict[@"voice"][@"duration"] doubleValue];
            [self uploadVoiceFile:filePath duration:length messageId:resendDTO.messageID];
        }
    } else {
        resendDTO = [[IMUtil sharedInstance] resendMessage:resendDTO];
        for (MessageDTO *msg in self.dataList) {
            if (msg.remoteID == resendDTO.remoteID) {
                if ([msg.messageID isEqualToString:resendDTO.messageID]) {
                    msg.status = MessagePending;
                }
            }
        }
    }
    
    [table setData:@[self.dataList]];
}

#pragma mark Scroll Table To Bottom
- (void)scrollToTableBottom:(BOOL)animated
{
    if (self.dataList.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataList.count - 1) inSection:0];
        [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark Get A Valid Message Array, Not Exit Sending Or Send Failure Message
- (NSArray *)getValidArray
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (MessageDTO *dto in self.dataList) {
        if (dto.remoteID != 0) {
            [arrayM addObject:dto];
        }
    }
    return arrayM;
}

#pragma mark Get The Lastest Remote Message
- (MessageDTO *)getLastRemoteMessage
{
    __block MessageDTO *dto = [[MessageDTO alloc] init];
    if (self.dataList.count > 0) {
        [self.dataList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(MessageDTO *message, NSUInteger idx, BOOL *stop) {
            if (!message.isFromSelf) {
                dto = message;
                *stop = YES;
            }
        }];
    }
    return dto;
}

#pragma mark Upload Image, Send Message While Image Is Uploaded
- (void)uploadImageFile:(NSString *)filePath image:(UIImage *)image messageId:(NSString *)messageId
{
    UploadHelper *helper = [[UploadHelper alloc] init];
    [helper uploadImageFile:filePath image:image params:nil success:^(NSString *path, NSDictionary *ret, UIImage *image) {
        NSString *from = [[AccountHelper getAccount] chatID];
        NSString *to = (self.target.chatID.length > 0) ? self.target.chatID:sessionID;
        NSString *fileId = @"";
        NSArray *array = ret[@"result"];
        if (array.count > 0) {
            fileId = [array firstObject][@"file_id"];
        }
        
        // 封装消息
        NSDictionary *info = @{@"path": fileId, @"width": [NSNumber numberWithFloat:image.size.width], @"height": [NSNumber numberWithFloat:image.size.height]};
        NSDictionary *content = @{@"image": info};
        NSDictionary *dict = @{@"content": [content JSONString],
                               @"from": from,
                               @"to": to,
                               @"session": sessionID,
                               @"touser": self.target.userID,
                               @"fromuser": [[AccountHelper getAccount] userID],
                               @"type":@(MessageTypeInstanceImage),
                               @"sessionType":@(sessionType)};
        MessageDTO *messageDTO = [[MessageDTO alloc] init:dict];
        messageDTO.updateTime = [NSDate date];
        messageDTO.status = MessagePending;
        messageDTO.messageID = messageId;
        if (self.openQueue) {
            [self.sendQueue addObject:messageDTO];
        } else {
            messageDTO = [[IMUtil sharedInstance] sendMessage:messageDTO];
        }
        
        for (MessageDTO *msg in self.dataList) {
            if (msg.remoteID == 0) {
                if ([msg.messageID isEqualToString:messageDTO.messageID]) {
                    msg.content = messageDTO.content;
                    msg.status = MessagePending;
                }
            }
        }
        [table reloadData];
        [FileUtil removeFile:filePath];
    } failure:^(NSError *error) {
        for (MessageDTO *msg in self.dataList) {
            if (msg.remoteID == 0) {
                if ([msg.messageID isEqualToString:messageId]) {
                    msg.status = MessageUploadFail;
                    [MessageManager updateMessageUploadFailure:msg success:nil failure:nil];
                }
            }
        }
        [table setData:@[self.dataList]];
    }];
}

#pragma mark Upload Audio, Send Message While Audio Is Uploaded
- (void)uploadVoiceFile:(NSString *)filePath duration:(NSTimeInterval)length messageId:(NSString *)messageId
{
    UploadHelper *helper = [[UploadHelper alloc] init];
    [helper uploadVoiceFile:filePath duration:length params:nil success:^(NSString *path, NSDictionary *ret, NSTimeInterval audioLength) {
        NSString *fileId = @"";
        NSArray *array = ret[@"result"];
        if (array.count > 0) {
            fileId = [array firstObject][@"file_id"];
        }
        NSString *from = [[AccountHelper getAccount] chatID];
        NSString *to = (self.target.chatID.length > 0) ? self.target.chatID:sessionID;
        NSDictionary *info = @{@"path":fileId, @"duration":@(audioLength)};
        NSDictionary *content = @{@"voice": info};
        NSDictionary *dict = @{@"content": [content JSONString],
                               @"from": from,
                               @"to": to,
                               @"session": sessionID,
                               @"touser": self.target.userID,
                               @"fromuser": [[AccountHelper getAccount] userID],
                               @"type":@(MessageTypeInstanceVoice),
                               @"sessionType":@(sessionType)};
        MessageDTO *messageDTO = [[MessageDTO alloc] init:dict];
        messageDTO.updateTime = [NSDate date];
        messageDTO.status = MessagePending;
        messageDTO.messageID = messageId;
        if (self.openQueue) {
            [self.sendQueue addObject:messageDTO];
        } else {
            messageDTO = [[IMUtil sharedInstance] sendMessage:messageDTO];
        }
        for (MessageDTO *msg in self.dataList) {
            if (msg.remoteID == 0) {
                if ([msg.messageID isEqualToString:messageId]) {
                    msg.content = messageDTO.content;
                    msg.status = MessagePending;
                }
            }
        }
        [table reloadData];
    } failure:^(NSError *error) {
        for (MessageDTO *msg in self.dataList) {
            if (msg.remoteID == 0) {
                if ([msg.messageID isEqualToString:messageId]) {
                    msg.status = MessageUploadFail;
                    [MessageManager updateMessageUploadFailure:msg success:nil failure:nil];
                }
            }
        }
        [table setData:@[self.dataList]];
    }];
}

#pragma mark - ------------------------
- (void)findAllImage
{
    [self.imageList removeAllObjects];
    __block NSInteger index = 0;
    [self.dataList enumerateObjectsUsingBlock:^(MessageDTO *dto, NSUInteger idx, BOOL * _Nonnull stop) {
        if (dto.type == MessageTypeInstanceImage) {
            CHPhoto *photo = [[CHPhoto alloc] init];
            photo.cellIndex = idx;
            photo.index = index++;
            if (dto.photoFile.length > 0) {
                photo.filePath = dto.photoFile;
            } else {
                photo.url = dto.photoUrl;
            }
            
            [self.imageList addObject:photo];
        }
    }];
    
    NSLog(@"imageList --- %@", self.imageList);
}

#pragma mark - getter & setter
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (AudioUtil *)audioUtil
{
    if (!_audioUtil) {
        _audioUtil = [AudioUtil shareAudioUtil];
    }
    return _audioUtil;
}

- (NSMutableArray *)sendQueue
{
    if (!_sendQueue) {
        _sendQueue = [[NSMutableArray alloc] init];
    }
    return _sendQueue;
}

- (MessageInputBox *)inputBox
{
    if (!_inputBox) {
        _inputBox = [[MessageInputBox alloc] init];
        _inputBox.parent = self;
    }
    return _inputBox;
}

- (NSMutableArray *)imageList
{
    if (!_imageList) {
        _imageList = [[NSMutableArray alloc] init];
    }
    return _imageList;
}

- (UIButton *)topTitleButton
{
    if (!_topTitleButton) {
        _topTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topTitleButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_topTitleButton addTarget:self action:@selector(clickShowButton) forControlEvents:UIControlEventTouchUpInside];
        [_topTitleButton setImage:[UIImage imageNamed:@"btn_triangle.png"] forState:UIControlStateNormal];
    }
    return _topTitleButton;
}

- (UIView *)hintView
{
    if (!_hintView) {
        _hintView = [[UIView alloc] init];
        _hintView.backgroundColor = [UIColor whiteColor];
        
        UILabel *hintLabel = [[UILabel alloc] init];
        hintLabel.textColor = [ColorUtil getColor:@"737373" alpha:1.0];
        hintLabel.font = [UIFont systemFontOfSize:12];
        hintLabel.numberOfLines = 0;
        hintLabel.text = @"温馨提示：非好友关系的对话属于临时对话，点击上方对方名字可以屏蔽Ta的消息";
        [_hintView addSubview:hintLabel];
        CGFloat height = [hintLabel.text sizefitLabelInSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, MAXFLOAT) Font:hintLabel.font].height;
        hintLabel.frame = CGRectMake(15, 6, [UIScreen mainScreen].bounds.size.width - 30, height);
        _hintView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, height + 12);
    }
    return _hintView;
}

- (UIButton *)refuseButton
{
    if (!_refuseButton) {
        _refuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _refuseButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _refuseButton.backgroundColor = [UIColor whiteColor];
        [_refuseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view insertSubview:_refuseButton atIndex:1];
        _refuseButton.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 40);
        [_refuseButton addTarget:self action:@selector(clickChangeRefuseState) forControlEvents:UIControlEventTouchUpInside];
        [self.refuseButton setTitle:@"开启Ta的消息" forState:UIControlStateSelected|UIControlStateHighlighted];
        [self.refuseButton setTitle:@"开启Ta的消息" forState:UIControlStateSelected];
        [self.refuseButton setTitle:@"屏蔽Ta的消息" forState:UIControlStateNormal];
    }
    return _refuseButton;
}

@end
