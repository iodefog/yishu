//
//  MessageInputBox.h
//  medtree
//
//  Created by sam on 8/15/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

enum {
    MessageInput_Show_Keyboard,
    MessageInput_Show_Feature,
    MessageInput_Show_Speak,
    MessageInput_Hide_Keyboard,
} MessageInput_Type;

@class MessageDTO;

@protocol MessageOperationDelegate <NSObject>

- (void)didSendMessage:(MessageDTO *)dto;
- (void)showCamera;
- (void)showAlbum;
- (void)setUiType:(NSInteger)type;

- (void)resize;
- (void)startRecording;
- (void)cancelRecording;
- (void)stopRecording;
- (void)setCancelRecordStatus:(BOOL)tf;

@end

@interface MessageInputBox : BaseView <UITextViewDelegate>

@property (nonatomic, assign) id parent;

- (void)setInputMessage:(NSString *)text;
- (UITextView *)getTextBox;
- (void)switchType:(NSNumber *)type;
- (void)resignResponder;
- (CGFloat)getInputHeight;
- (void)sendMessage;

@end
