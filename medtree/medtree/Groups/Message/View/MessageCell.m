//
//  MessageCell.m
//  medtree
//
//  Created by sam on 8/14/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "MessageCell.h"
#import "ImageCenter.h"
#import "DateUtil.h"
#import "MessageDTO.h"
#import "OperationHelper.h"
#import "UserDTO.h"
#import "FileUtil.h"
#import "JSONKit.h"
#import "IMUtil.h"
#import "CoreLabel.h"
#import "UIImageView+setImageWithURL.h"
#import "CoreLabelDelegate.h"
#import "NSString+Extension.h"

#define CHStatusViewWH 20

@interface MessageCell () <CoreLabelDelegate> 
{
    UIImageView         *thumbView;                    // 头像
    UILabel             *contentLabel;                 // 消息内容
    UIView              *bubbleView;
    UIImageView         *bubbleImageView;
    UIImageView         *statusView;
    UIImageView         *headerView;
    UILabel             *timeLabel;
    /** 时间消息 */
    UILabel             *recordLabel;
    UIActivityIndicatorView *indicatorView;
    
    NSString            *accountID;
    CGFloat             timeOffset;
    MessageDTO          *mdto;
    
    BOOL                isLoaded;
    
    NSString            *imagePath;
    NSTimer             *timer;
    int                 timeIndex;
    
    UIView              *returnView;
    /** 消息文本 */
    CoreLabel           *messageLabel;
    UIImageView         *photoView;
    UIImageView         *voiceView;
}

@end

@implementation MessageCell

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor whiteColor];
    
    timeLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview: timeLabel];
    
    recordLabel = [[UILabel alloc] init];
    recordLabel.font = [UIFont systemFontOfSize:11];
    recordLabel.backgroundColor = [UIColor clearColor];
    recordLabel.textColor = [MedGlobal getTitleTextCommonColor];
    [self addSubview:recordLabel];
    
    headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
    headerView.layer.cornerRadius = 20;
    headerView.layer.masksToBounds = YES;
    headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeader)];
    [headerView addGestureRecognizer:singleTap];
    [self addSubview:headerView];
    
    statusView = [[UIImageView alloc] initWithFrame:CGRectZero];
    statusView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *statusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickStatus)];
    [statusView addGestureRecognizer:statusTap];
    [self addSubview:statusView];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:indicatorView];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    returnView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:returnView];
    
    footerLine.hidden = YES;
    
    bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bubbleImageView.userInteractionEnabled = YES;
    messageLabel = [[CoreLabel alloc] initWithFrame:CGRectZero];
    photoView = [[UIImageView alloc] init];
    photoView.contentMode = UIViewContentModeScaleToFill;
    [returnView addSubview:photoView];
    voiceView = [[UIImageView alloc] initWithFrame:CGRectZero];
}

#pragma mark 文本消息
- (UIView *)assembleMessage:(NSString *)message isSelf:(BOOL)isSelf
{
    photoView.hidden = YES;
    messageLabel.parent = self;
    messageLabel.text = message;
    messageLabel.textColor = isSelf ? [UIColor whiteColor] : [MedGlobal getTitleTextCommonColor];
    messageLabel.font = [MedGlobal getMiddleFont];
    messageLabel.backgroundColor = [UIColor clearColor];
    
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 160, MAXFLOAT);
    CGSize labelsize = [CoreLabel boundingRectWithSize:size font:messageLabel.font string:message lineSpace:2].size;
//    CGSize labelsize = [NSString sizeForString:message Size:size Font:messageLabel.font];
    CGRect rect1, rect2;
    rect1 = CGRectMake(0, 7-timeOffset, labelsize.width, labelsize.height);
    rect2 = CGRectMake(0, 7-timeOffset, labelsize.width, labelsize.height);
    messageLabel.frame = rect2;
    returnView.frame = rect1;
    [returnView addSubview:messageLabel];
    return returnView;
}

#pragma mark  图片消息
- (UIView *)assembleImageMessage:(MessageDTO *)dto isLocal:(BOOL)isLocal
{
    photoView.hidden = NO;
    if (dto.photoUrl.length > 0) {
        [photoView med_setImageWithUrl:[NSURL URLWithString:dto.photoUrl]
                      placeholderImage:[UIImage imageNamed:@"chat_img_placeholder.png"]];
    } else {
        NSError *error;
        NSData *data = [NSData dataWithContentsOfFile:dto.photoFile options:NSDataReadingMappedAlways error:&error];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            photoView.image = image;
        }
    }
    //
    NSDictionary *dict = [dto.content objectFromJSONString];
    CGFloat height = 80;
    CGFloat width = height;
    if ([dict[@"image"][@"height"] floatValue] > 0) {
        width = height * [dict[@"image"][@"width"] floatValue]  /[dict[@"image"][@"height"] floatValue];
    }
    
    if (width > self.frame.size.width - returnView.frame.origin.x) {
        width = self.frame.size.width - returnView.frame.origin.x - 100;
    } else if (width < 30) {
        width = 30;
    }
    
    photoView.frame = CGRectMake(10, 5-timeOffset, width, height);
    returnView.frame = CGRectMake(0, 7-timeOffset, width, height+20);

    if (isLocal) {
        photoView.frame = CGRectMake(10, 5-timeOffset, width, height);
        returnView.frame = CGRectMake(0, 7-timeOffset, width, height+20);
    } else {
        photoView.frame = CGRectMake(-10, 5-timeOffset, width, height);
        returnView.frame = CGRectMake(-20, 7-timeOffset, width, height+20);
    }
    return returnView;
}

#pragma mark 语音消息
- (UIView *)assembleVoiceMessage:(NSDictionary *)info isLocal:(BOOL)isLocal
{
    photoView.hidden = YES;
    voiceView.tag = 200;
    voiceView.userInteractionEnabled = NO;
    [returnView addSubview:voiceView];
    //
    NSDictionary *voice = [info objectForKey:@"voice"];
    NSInteger duration = [[voice objectForKey:@"duration"] integerValue];
    CGFloat width = duration * 20;
    CGSize size = self.frame.size;
    if (width > size.width/2) {
        width = size.width/2;
    }
    recordLabel.text = [NSString stringWithFormat:@"%@\"", @(duration)];;
    CGFloat height = 20;
    if (isLocal) {
        voiceView.image = [ImageCenter getBundleImage:@"chat_speak_out_3.png"];
        voiceView.frame = CGRectMake((width-16)/2, 5-timeOffset+2, 16, 16);
        returnView.frame = CGRectMake(0, 5-timeOffset, width, height);
    } else {
        voiceView.image = [ImageCenter getBundleImage:@"chat_speak_in_3.png"];
        voiceView.frame = CGRectMake((width-16)/2, 5-timeOffset+2, 16, 16);
        returnView.frame = CGRectMake(0, 5-timeOffset, width, height);
    }
    return returnView;
}

#pragma mark 其他消息
- (UIView *)assembleOtherMessage:(NSString *)message isSelf:(BOOL)isSelf
{
    photoView.hidden = YES;
    messageLabel.parent = self;
    messageLabel.text = @"[当前版本暂不支持]";
    messageLabel.textColor = isSelf ? [UIColor whiteColor] : [MedGlobal getTitleTextCommonColor];
    messageLabel.font = [MedGlobal getMiddleFont];
    messageLabel.backgroundColor = [UIColor clearColor];
    
    CGSize size = CGSizeMake(self.frame.size.width - 160, MAXFLOAT);
    CGSize labelsize = [CoreLabel boundingRectWithSize:size font:messageLabel.font string:messageLabel.text lineSpace:2].size;
    CGRect rect1, rect2;
    if (labelsize.width < 15 || labelsize.height < 15) {
        rect1 = CGRectMake(0, 7-timeOffset, 15, 18);
        rect2 = CGRectMake(0, 7-timeOffset, 15, 18+20);
    } else {
        rect1 = CGRectMake(0, 7-timeOffset, labelsize.width, labelsize.height);
        rect2 = CGRectMake(0, 7-timeOffset, labelsize.width, labelsize.height+20);
    }
    messageLabel.frame = rect2;
    returnView.frame = rect1;
    [returnView addSubview:messageLabel];
    return returnView;
}

#pragma mark - click
#pragma mark 点击头像
- (void)clickHeader
{
    [self.parent clickCell:mdto.fromUser action:[NSNumber numberWithInteger:ClickAction_MessageContact]];
}

- (void)clickStatus
{
    if (mdto.status == MessageFail || mdto.status == MessageUploadFail) {
        [self.parent clickCell:mdto action:[NSNumber numberWithInteger:ClickAction_MessageStatus]];
    }
}

#pragma mark 查看大图
- (void)clickThumbnail
{
    [self.parent clickCell:mdto action:[NSNumber numberWithInteger:ClickAction_ShowImage]];
}

#pragma mark - 播放声音
- (void)clickVoice
{
    [self.parent clickCell:self action:[NSNumber numberWithInteger:ClickAction_PlayVoice]];
    //
    if ([timer isValid]) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    timeIndex = 0;
    // 声音结束操作
    [[IMUtil sharedInstance] playAudio:mdto success:^(id JSON) {
        NSLog(@"playVoice %@", mdto);
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopVoice];
        });
    } failure:^(NSError *error, id JSON) { // 下载失败
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopVoice];
        });
    }];
}

- (void)stopVoice
{
    [self setPlayTime:2];
    if ([timer isValid]) {
        [timer invalidate];
    }
}

- (void)timerFired:(NSTimer *)timerFired {
    [self setPlayTime:timeIndex];
    timeIndex++;
}

- (void)setPlayTime:(int)idx
{
    if (mdto.isFromSelf) {
        voiceView.image = [ImageCenter getBundleImage:[NSString stringWithFormat:@"chat_speak_out_%d.png", idx%3+1]];
    } else {
        voiceView.image = [ImageCenter getBundleImage:[NSString stringWithFormat:@"chat_speak_in_%d.png", idx%3+1]];
    }
}

#pragma mark - 复制
- (void)clickCopy
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:mdto.content];
    [self.parent clickCell:mdto action:[NSNumber numberWithInteger:ClickAction_MessageLongPress]];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(clickCopy)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan && mdto.type == MessageTypeInstanceText) {
//        [self.parent clickCell:self action:[NSNumber numberWithInteger:ClickAction_ShowMenu]];
        [self.parent clickCell:mdto action:[NSNumber numberWithInteger:ClickAction_MessageLongPress]];
        
        if ([self becomeFirstResponder]) {
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(clickCopy)];
            //
            [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, nil]];
            CGRect rect = bubbleView.frame;
            [menuController setTargetRect:CGRectMake(rect.size.width/2-30, 0, 0, 0) inView:bubbleView];
            [menuController setMenuVisible:YES animated:YES];
        }
    }
}

- (void)clickTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if (mdto.type == MessageTypeInstanceVoice) {
        [self clickVoice];
    } else if (mdto.type == MessageTypeInstanceImage) {
        [self clickThumbnail];
    }
}

#pragma mark - 设置数据
- (void)setInfo:(MessageDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    BOOL fromSelf = dto.isFromSelf;
    mdto = dto;
    if (mdto.isShowTime == YES) {
        timeOffset = 20;
    } else {
        timeOffset = 0;
    }
    {
        [messageLabel removeFromSuperview];
        [voiceView removeFromSuperview];
    }
    
    if (dto.type == MessageTypeInstanceText) {  // 文本
        UIImage *bubble = [ImageCenter getNamedImage:fromSelf!=YES? @"bubble.png":@"bubbleSelf.png"];
        bubbleImageView.image = [bubble stretchableImageWithLeftCapWidth:42 topCapHeight:19];
        bubbleView = [self assembleMessage:dto.content isSelf:fromSelf];
        recordLabel.hidden = YES;
    } else if (dto.type == MessageTypeInstanceImage) {  // 图片
        bubbleImageView.image = nil;
        bubbleView = [self assembleImageMessage:dto isLocal:fromSelf];
        recordLabel.hidden = YES;
    } else if (dto.type == MessageTypeInstanceVoice) {  // 语音
        UIImage *bubble = [ImageCenter getNamedImage:fromSelf!=YES? @"bubble.png":@"bubbleSelf.png"];
        bubbleImageView.image = [bubble stretchableImageWithLeftCapWidth:42 topCapHeight:19];
        //
        NSDictionary *dict = [dto.content objectFromJSONString];
        bubbleView = [self assembleVoiceMessage:dict isLocal:fromSelf];
        recordLabel.hidden = NO;
    } else {
        UIImage *bubble = [ImageCenter getNamedImage:fromSelf!=YES? @"bubble.png":@"bubbleSelf.png"];
        bubbleImageView.image = [bubble stretchableImageWithLeftCapWidth:42 topCapHeight:19];
        bubbleView = [self assembleOtherMessage:dto.content isSelf:fromSelf];
        recordLabel.hidden = YES;
    }
    
    CGFloat width = cellWidth;
    self.backgroundColor = [UIColor clearColor];
    CGSize size = CGSizeMake(width, 44);
    
    if (timeOffset > 0) {
        timeLabel.hidden = NO;
        timeLabel.frame = CGRectMake(0, 4, size.width, timeOffset);
        timeLabel.text = [DateUtil getFormatTime:dto.updateTime format:@"MM-dd HH:mm"];
    } else {
        timeLabel.hidden = YES;
    }
    if (fromSelf != YES) {
        bubbleView.frame= CGRectMake(28.0f, 2.0f+timeOffset, bubbleView.frame.size.width+50, bubbleView.frame.size.height+2);
        bubbleImageView.frame = CGRectMake(50.0f, 10.0f+timeOffset, bubbleView.frame.size.width+10.0f, bubbleView.frame.size.height+16.0f);
//        statusView.frame = CGRectMake(-30, bubbleImageView.frame.origin.y+9, 27, 27);
//        indicatorView.frame = CGRectMake(-28, bubbleImageView.frame.origin.y+12, 20, 20);
        recordLabel.textAlignment = NSTextAlignmentLeft;
        recordLabel.frame = CGRectMake(CGRectGetMaxX(bubbleImageView.frame) - 20, 10.0f+timeOffset, 100, recordLabel.font.lineHeight);
        headerView.frame = CGRectMake(5, 8+timeOffset, 40, 40);
        statusView.hidden = YES;
    } else { // 我
        bubbleView.frame= CGRectMake(30.0f, 2.0f+timeOffset, bubbleView.frame.size.width+50, bubbleView.frame.size.height+2);
        bubbleImageView.frame = CGRectMake(size.width-bubbleView.frame.size.width-60.0f, 10.0f+timeOffset, bubbleView.frame.size.width+10.0f, bubbleView.frame.size.height+16.0f);
        statusView.frame = CGRectMake(bubbleImageView.frame.origin.x-CHStatusViewWH, bubbleImageView.frame.origin.y+8, CHStatusViewWH, CHStatusViewWH);
        indicatorView.frame = CGRectMake(bubbleImageView.frame.origin.x-20, bubbleImageView.frame.origin.y+8, 20, 20);
        headerView.frame = CGRectMake(size.width-45, 8+timeOffset, 40, 40);
        recordLabel.textAlignment = NSTextAlignmentRight;
        recordLabel.frame = CGRectMake(CGRectGetMinX(bubbleImageView.frame) - 80, 10.0f+timeOffset, 100, recordLabel.font.lineHeight);
        statusView.hidden = NO;
        [self showStatus:dto.status];
    }
    
    if ([imagePath isEqualToString:dto.fromUser.photoID] == NO) {
        headerView.image = [ImageCenter getBundleImage:@"img_head.png"];
        //
        NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Small], dto.fromUser.photoID];
        [headerView med_setImageWithUrl:[NSURL URLWithString:path]];
        imagePath = dto.fromUser.photoID;
    }

    [bubbleImageView addSubview:bubbleView];
    //
    if (mdto.type != MessageTypeInstanceText) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
        [bubbleImageView addGestureRecognizer:tap];
    } else {
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [bubbleImageView addGestureRecognizer:press];
    }
    //
    [self addSubview:bubbleImageView];
}

+ (BOOL)isShowTime:(MessageDTO *)dto lastTime:(NSDate *)lastTime
{
    BOOL tf = NO;
    NSTimeInterval ti = dto.updateTime.timeIntervalSince1970 - lastTime.timeIntervalSince1970;
    if (ti > 60*5 || ti < 0-60*5) {
        tf = YES;
    }
    return tf;
}

- (void)showStatus:(NSInteger)step
{
    if (step <= MessageHide || step >= MessageRead) {
        if ([self.subviews containsObject:statusView] == YES) {
            [statusView removeFromSuperview];
        }
        [indicatorView stopAnimating];
    } else {
        if ([self.subviews containsObject:statusView] == NO) {
            [self addSubview:statusView];
        }
        if (step == MessagePending || step == MessageUploading) {
            [indicatorView startAnimating];
            statusView.image = nil;
        } else {
            [indicatorView stopAnimating];
            
            if (step == MessageFail || step == MessageUploadFail) {
                statusView.hidden = NO;
                statusView.image = [ImageCenter getNamedImage:@"img_message_fail.png"];
                statusView.userInteractionEnabled = YES;
            } else {
                statusView.hidden = YES;
                statusView.userInteractionEnabled = NO;
            }
        }
    }
}

+ (CGFloat)getCellHeight:(MessageDTO *)dto width:(CGFloat)width
{
    CGFloat height = 60;
    if (dto != nil) {
        CGFloat textHeight = 0;
        if (dto.type == MessageTypeInstanceText) {
            CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 160, MAXFLOAT);
            CGSize labelsize = [CoreLabel boundingRectWithSize:size font:[MedGlobal getMiddleFont] string:dto.content lineSpace:2].size;
            if (labelsize.width < 15 || labelsize.height < 20) {
                textHeight = 18;
            } else {
                textHeight = labelsize.height+10;
            }
        } else if (dto.type == MessageTypeInstanceImage) {
            textHeight = 70;
        } else if (dto.type == MessageTypeInstanceVoice) {
            textHeight = 20;
        } else if (dto.type == 0) {
            CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 160, MAXFLOAT);
            CGSize labelsize = [CoreLabel boundingRectWithSize:size font:[MedGlobal getMiddleFont] string:@"[当前版本暂不支持]" lineSpace:2].size;
            if (labelsize.width < 15 || labelsize.height < 20) {
                textHeight = 18;
            } else {
                textHeight = labelsize.height+10;
            }
        }
        height = textHeight + 40;
        if (dto.isShowTime == YES) {
            height += 20;
        }
    }
    return height;
}

static CGFloat cellWidth;

+ (void)setCellWidth:(CGFloat)width
{
    cellWidth = width;
}

- (void)clickURL:(NSString *)url
{
    [self.parent clickCell:url action:[NSNumber numberWithInteger:ClickAction_OpenURL]];
}

- (void)clickText:(NSString *)text
{
    [self.parent clickCell:text action:[NSNumber numberWithInteger:ClickAction_MessageContent]];
}

- (void)clickTextView:(id)view
{
    
}

@end
