//
//  MessageInputBox.m
//  medtree
//
//  Created by sam on 8/15/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "MessageInputBox.h"
#import "ImageCenter.h"
#import "MessageDTO.h"
#import "MedGlobal.h"
#import "NavigationBar.h"
#import "FontUtil.h"

@interface MessageInputBox ()
{
    NSInteger       uiType;
    
    UIImageView     *boxGround;
    UIImageView     *faceBackground;
    UITextView      *sendBox;
    UIButton        *speakBtn;
    UILabel         *speakLabel;
    UIButton        *textBtn;
    UIButton        *addBtn;
    
    CGFloat         featureHeight;
    UIView          *featureView;
    UIButton        *albumBtn;
    UIButton        *cameraBtn;
    UIButton        *speakBox;
    
    CGFloat         sendBoxCurrentHeight;
}

@end

@implementation MessageInputBox

- (void)createUI
{
    [super createUI];
    
    //横栏
    UIImage *image = [[ImageCenter getNamedImage:@"chat_box.png"] stretchableImageWithLeftCapWidth:60 topCapHeight:21];
    boxGround = [[UIImageView alloc] initWithFrame:CGRectZero];
    boxGround.image = image;
    boxGround.userInteractionEnabled = YES;
    [self addSubview:boxGround];
    
    // 语音区域
    speakBox = [UIButton buttonWithType: UIButtonTypeCustom];
    [speakBox setBackgroundImage:[[ImageCenter getNamedImage:@"chat_box_speak.png"] stretchableImageWithLeftCapWidth:60 topCapHeight:21] forState:UIControlStateNormal];
    [speakBox setBackgroundImage:[[ImageCenter getNamedImage:@"chat_box_speak_click.png"] stretchableImageWithLeftCapWidth:60 topCapHeight:21] forState:UIControlStateHighlighted];
    [speakBox addTarget:self action: @selector(startRecording) forControlEvents: UIControlEventTouchDown];
    [speakBox addTarget:self action: @selector(stopRecording) forControlEvents: UIControlEventTouchUpInside];
    [speakBox addTarget:self action: @selector(stopRecording2) forControlEvents: UIControlEventTouchUpOutside];
    [speakBox addTarget:self action: @selector(cancelRecording) forControlEvents: UIControlEventTouchDragOutside];
    [speakBox addTarget:self action: @selector(continueRecording) forControlEvents: UIControlEventTouchDragInside];
    speakBox.hidden = YES;
    [boxGround addSubview:speakBox];
    
    speakLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    speakLabel.textAlignment = NSTextAlignmentCenter;
    speakLabel.textColor = [UIColor blackColor];
    speakLabel.backgroundColor = [UIColor clearColor];
    speakLabel.hidden = YES;
    [boxGround addSubview:speakLabel];
    [self setRecordStart:NO];

    // 输入框
    sendBox = [[UITextView alloc] init];
    sendBox.autocapitalizationType = UITextAutocapitalizationTypeNone;
    sendBox.returnKeyType = UIReturnKeySend;
    sendBox.enablesReturnKeyAutomatically = YES;
    sendBox.textAlignment = NSTextAlignmentLeft;
    sendBox.backgroundColor = [UIColor clearColor];
    sendBox.font = [MedGlobal getMiddleFont];
    sendBox.scrollEnabled = NO;
    sendBox.delegate = self;
    sendBox.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [boxGround addSubview: sendBox];

    // 语音按钮
    speakBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [speakBtn setImage:[ImageCenter getBundleImage:@"chat_speak.png"] forState:UIControlStateNormal];
    [speakBtn setImage:[ImageCenter getBundleImage:@"chat_speak_click.png"] forState:UIControlStateHighlighted];
    [speakBtn addTarget: self action: @selector(switchToSpeak) forControlEvents: UIControlEventTouchUpInside];
    [boxGround addSubview: speakBtn];

    // 文字按钮
    textBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [textBtn setImage:[ImageCenter getBundleImage:@"chat_input.png"] forState:UIControlStateNormal];
    [textBtn setImage:[ImageCenter getBundleImage:@"chat_input_click.png"] forState:UIControlStateHighlighted];
    [textBtn addTarget: self action: @selector(switchToInput) forControlEvents: UIControlEventTouchUpInside];
    textBtn.hidden = YES;
    [boxGround addSubview: textBtn];

    // 添加按钮
    addBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [addBtn setImage:[ImageCenter getBundleImage:@"chat_add.png"] forState:UIControlStateNormal];
    [addBtn setImage:[ImageCenter getBundleImage:@"chat_add_click.png"] forState:UIControlStateHighlighted];
    [addBtn addTarget: self action: @selector(switchToFeature) forControlEvents: UIControlEventTouchUpInside];
    [boxGround addSubview: addBtn];

    featureView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:featureView];
    
    // 相册按钮
    albumBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [albumBtn setImage:[ImageCenter getBundleImage:@"btn_add_picture.png"] forState:UIControlStateNormal];
    [albumBtn setImage:[ImageCenter getBundleImage:@"btn_add_picture_click.png"] forState:UIControlStateHighlighted];
    [albumBtn addTarget:self action:@selector(clickAlbum) forControlEvents:UIControlEventTouchUpInside];
    [featureView addSubview: albumBtn];
    
    // 相机按钮
    cameraBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [cameraBtn setImage:[ImageCenter getBundleImage:@"btn_add_camera.png"] forState:UIControlStateNormal];
    [cameraBtn setImage:[ImageCenter getBundleImage:@"btn_add_camera_click.png"] forState:UIControlStateHighlighted];
    [cameraBtn addTarget:self action:@selector(clickCamera) forControlEvents:UIControlEventTouchUpInside];
    [featureView addSubview: cameraBtn];
    
    sendBoxCurrentHeight = 20;
    featureHeight = 100;
    
    //face——background
    faceBackground = [[UIImageView alloc]initWithFrame:CGRectZero];
    faceBackground.image = [ImageCenter getBundleImage:@"chat_background.png"];
    faceBackground.userInteractionEnabled = YES;
    [self addSubview:faceBackground];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    if (uiType == MessageInput_Show_Feature) {
        boxGround.frame = CGRectMake(0, 0, size.width, size.height-featureHeight);
        featureView.frame = CGRectMake(0, size.height-featureHeight, size.width, featureHeight);
    } else {
        boxGround.frame = CGRectMake(0, 0, size.width, size.height);
        featureView.frame = CGRectMake(0, size.height, size.width, featureHeight);
    }
    
    CGSize boxGroundS = boxGround.frame.size;
    CGFloat iconWH = 45;
    sendBox.frame = CGRectMake(iconWH, 15, size.width - iconWH * 2, 60);
    speakBox.frame = CGRectMake(0, 0, size.width, 50);
    speakLabel.frame = CGRectMake(iconWH, 0, size.width - iconWH * 2, 50);
    CGFloat btnY = boxGroundS.height - iconWH;
    speakBtn.frame = CGRectMake(0, btnY, iconWH, iconWH);
    textBtn.frame = CGRectMake(0, btnY, iconWH, iconWH);
    addBtn.frame = CGRectMake(size.width - iconWH, btnY, iconWH, iconWH);
    
    cameraBtn.frame = CGRectMake(40, 0, 60, 100);
    albumBtn.frame = CGRectMake(140, 0, 60, 100);
}

#pragma mark - click
#pragma mark 语音部分
- (void)startRecording
{
    NSLog(@"startRecording");
    [self.parent startRecording];
    [self setRecordStart:YES];
}

- (void)stopRecording2
{
    NSLog(@"cannceled");
    [self.parent cancelRecording];
    [self setRecordStart:NO];
}

- (void)stopRecording
{
    NSLog(@"finished");
    [self.parent stopRecording];
    [self setRecordStart:NO];
}

- (void)cancelRecording
{
    NSLog(@"cancelRecording");
    [self.parent setCancelRecordStatus:YES];
}

- (void)continueRecording
{
    NSLog(@"continueRecording");
    [self.parent setCancelRecordStatus:NO];
}

- (void)setRecordStart:(BOOL)tf
{
    speakLabel.text = tf ? @"松开 结束" : @"按住 说话";
}

#pragma mark 按钮转换键盘界面
/** 弹出键盘 */
- (void)switchToInput
{
    [self checkHeight];
    [self setUiType:MessageInput_Show_Keyboard];
    [sendBox becomeFirstResponder];
}

/** 收回键盘，显示语音按钮 */
- (void)switchToSpeak
{
    sendBoxCurrentHeight = 20;
    if (uiType == MessageInput_Show_Feature) {
        [sendBox resignFirstResponder];
        [self setUiType:MessageInput_Show_Speak];
    } else {
        [sendBox resignFirstResponder];
        [self setUiType:MessageInput_Show_Speak];
    }
}

- (void)switchToFeature
{
    if (uiType == MessageInput_Show_Feature) {
        [sendBox becomeFirstResponder];
        [self setUiType:MessageInput_Show_Keyboard];
    } else {
        [sendBox resignFirstResponder];
        [self setUiType:MessageInput_Show_Feature];
    }
}

- (void)clickAlbum
{
    [self.parent showAlbum];
}

- (void)clickCamera
{
    [self.parent showCamera];
}

#pragma mark - UITextViewDelegate
- (void)sendBoxBecomeFirstResponse
{
    [self checkHeight];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self checkHeight];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    CGFloat caretY = MAX(rect.origin.y - textView.frame.size.height + rect.size.height, 0);
    if (textView.contentOffset.y < caretY && rect.origin.y != INFINITY) {
        textView.contentOffset = CGPointMake(0, caretY);
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self setUiType:MessageInput_Show_Keyboard];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL isEnd = NO;
    if ([text isEqualToString:@"\n"]) {
        isEnd = YES;
        if (textView.text.length > 0) {
            [self sendMessage];
        }
    }
    return !isEnd;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self sendBoxBecomeFirstResponse];
}

#pragma mark - setter
- (void)setUiType:(NSInteger)type
{
    uiType = type;
    if (uiType == MessageInput_Show_Speak) {
        textBtn.hidden = NO;
        speakBtn.hidden = YES;
        speakBox.hidden = NO;
        speakLabel.hidden = NO;
        sendBox.hidden = YES;
    } else {
        textBtn.hidden = YES;
        speakBtn.hidden = NO;
        speakBox.hidden = YES;
        speakLabel.hidden = YES;
        sendBox.hidden = NO;
    }
    [self.parent setUiType:type];
}

#pragma mark - private
- (void)checkHeight
{
    CGFloat height = 0;
    CGRect textBounds = [sendBox.layoutManager usedRectForTextContainer:sendBox.textContainer];
    height = (CGFloat)ceil(textBounds.size.height + sendBox.textContainerInset.top + sendBox.textContainerInset.bottom);
    // 计算高度增益
    CGFloat newHeight = height > (19 * 2 + 20) ? (19 * 2 + 20) : height;
    newHeight = newHeight < 20 ? 20 : newHeight;
    CGFloat heightIncrease = newHeight - sendBoxCurrentHeight;
    if (heightIncrease != 0) {
        sendBoxCurrentHeight = newHeight==0?20:newHeight;
        sendBox.scrollEnabled = YES;
        if ([self.parent respondsToSelector:@selector(resize)]) {
            [self.parent performSelector:@selector(resize) withObject:nil];
        }
    }
}

#pragma mark - public
- (void)setInputMessage:(NSString *)text
{
    sendBox.text = text;
}

- (UITextView *)getTextBox
{
    return sendBox;
}

- (void)switchType:(NSNumber *)type
{
    uiType = [type integerValue];
}

- (CGFloat)getInputHeight
{
    CGFloat height = 30 + sendBoxCurrentHeight;
    if (uiType == MessageInput_Show_Feature) {
        height += featureHeight;
    }
    return height;
}

- (void)sendMessage
{
    sendBox.scrollEnabled = NO;
    MessageDTO *dto = [[MessageDTO  alloc] init];
    dto.content = sendBox.text;
    sendBox.text = @"";
    [self checkHeight];
    [self.parent didSendMessage:dto];
}

- (void)resignResponder
{
    [sendBox resignFirstResponder];
    if (uiType == MessageInput_Show_Keyboard) {
        [self setUiType:MessageInput_Hide_Keyboard];
    } else if (uiType == MessageInput_Show_Feature) {
        [self setUiType:MessageInput_Hide_Keyboard];
    }
}

#pragma mark - over write
- (BOOL)resignFirstResponder
{
    [sendBox resignFirstResponder];
    if (uiType == MessageInput_Show_Keyboard) {
        [self setUiType:MessageInput_Hide_Keyboard];
    } else if (uiType == MessageInput_Show_Feature) {
        [self setUiType:MessageInput_Hide_Keyboard];
    }
    return YES;
}

- (BOOL)becomeFirstResponder
{
    [self setUiType:MessageInput_Show_Keyboard];
    [sendBox becomeFirstResponder];
    return YES;
}

@end
