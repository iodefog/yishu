//
//  CommonInputBox.h
//  medtree
//
//  Created by 边大朋 on 15-4-9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseView.h"

@protocol CommonInputBoxDelegate <NSObject>

- (void)sendData;

@optional
/** 超过最大长度警告 */
- (void)overMaxLength;
- (void)resize:(CGFloat)offset;
- (void)showHiddenInputList:(BOOL)isShow;

@end

@class TextViewEx;
@interface CommonInputBox : BaseView
{
    TextViewEx      *sendBox;
    UIButton        *sendBtn;
    CGFloat         sendBoxCurrentHeight;
    CGFloat         textViewHeight;
    
    
    CGFloat boxHeight;//输入框高
    
    CGFloat btnWith;//发送按钮宽
    CGFloat btnHeight;//发送按钮高
    
    CGFloat space; //输入框或按钮与边界间隔
    CGFloat midSpace;//控件之间间隔
    CGFloat sendBoxW;
}



@property (nonatomic, assign) id<CommonInputBoxDelegate> parent;

//- (void)sendData;
- (NSString *)getData;
- (void)setData:(NSString *)text;
- (void)becomeResponder;
- (void)resignResponder;
- (CGFloat)getInputHeight;
- (UITextView *)getSendBox;
- (void)clearText;
- (void)setPlaceHolder:(NSString *)text;
- (void)checkHeight;

@property (nonatomic, copy) void (^textBecomeFirstResponder)(void);
@property (nonatomic, copy) void (^overMaxLengthWarming)(void);
@property (nonatomic, copy) void (^voidTextSend)(void);
/** 默认为200 */
@property (nonatomic, assign) NSInteger maxLength;

@end
