//
//  CommonCell.h
//  medtree
//
//  Created by 孙晨辉 on 15/4/15.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseView.h"


typedef enum {
    CommonCellType_Name             = 1,
    CommonCellType_Organ,
    CommonCellType_Department,
    CommonCellType_Title,
    CommonCellType_Duration,
    CommonCellType_Phone,
    CommonCellType_Captcha,
    CommonCellType_Password,
    CommonCellType_Inviter,

    CommonCellType_Upload           = 20,
    CommonCellType_VerifyCode       = 21,
} CommonCellType;

@class CommonCell;
@protocol CommonCellDelegate <NSObject>

@optional
- (void)returnKeyClicked;

- (void)textFieldBecomeFirstRespond:(CommonCell *)cell;

- (void)clickCell:(CommonCell *)cell;

@end

@interface CommonCell : BaseView

@property (nonatomic, assign) id<CommonCellDelegate> delegate;

@property (nonatomic, copy) void (^returnKeyClicked)(void);

@property (nonatomic, copy) void (^textFieldBecomeFirstRespond)(void);

/** 显示上界线，默认NO */
@property (nonatomic, assign) BOOL showHeadLine;
/** 显示分界线（靠底部），默认YES */
@property (nonatomic, assign) BOOL showMedLine;
/** 显示下界线，默认NO */
@property (nonatomic, assign) BOOL showFootLine;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 文本信息 */
@property (nonatomic, copy) NSString *text;
/** 提示信息 */
@property (nonatomic, copy) NSString *placeHolder;
/** 键盘返回键 */
@property (nonatomic, assign) UIReturnKeyType returnKeyType;
/** 键盘格式 */
@property (nonatomic, assign) UIKeyboardType keyboardType;
/** 数据是否加密 */
@property (nonatomic, assign) BOOL secureTextEntry;
/** 允许交互 */
@property (nonatomic, assign) BOOL textFieldInteractionEnabled;
/** 字数限制， 默认20 */
@property (nonatomic, assign) NSInteger maxLength;
/** 显示箭头 */
@property (nonatomic, assign) BOOL showNextImg;

- (BOOL)isFirstResponder;

- (BOOL)resignFirstResponder;

- (BOOL)becomeFirstResponder;

+ (instancetype)commoncell;

@end
