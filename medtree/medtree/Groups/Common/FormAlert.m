//
//  FormAlert.m
//  medtree
//
//  Created by 边大朋 on 15-4-5.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "FormAlert.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "FontUtil.h"
#import "TextViewEx.h"
#import "MedGlobal.h"

@interface FormAlert () <UITextViewDelegate>
{
    UILabel             *titleLab;
    UILabel             *topSegmentLab;
    UILabel             *bottomSegmentLab;
    UILabel             *midSegmentLab;
    UIButton            *calcelBtn;
    UIButton            *saveBtn;
    UIView              *formView;
    CGFloat             keyBoardHeight;
    
    NSString            *tagStr;
    
}
@end

@implementation FormAlert

- (void)createUI
{
    self.backgroundColor = [ColorUtil getColor:@"000000" alpha:0.4];
    [self createFormView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
    [self addGestureRecognizer:tap];
}

- (void)createFormView
{
    formView = [[UIView alloc] init];
    formView.backgroundColor = [UIColor whiteColor];
    formView.layer.cornerRadius = 10;
    formView.layer.masksToBounds = YES;
    [self addSubview:formView];
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.text = @"贴个标签";
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [ColorUtil getColor:@"1C1C1C" alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [MedGlobal getLargeFont];
    [formView addSubview: titleLab];
    
    _textView = [[TextViewEx alloc] initWithFrame:CGRectZero];
    _textView.placeholder = @"标签内容";
    _textView.backgroundColor = [ColorUtil getColor:@"EDEDED" alpha:1];
    _textView.delegate = self;
    _textView.font = [MedGlobal getLittleFont];
    [formView addSubview:_textView];
    
    topSegmentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    topSegmentLab.backgroundColor = [ColorUtil getColor:@"CBCBCB" alpha:1];
    topSegmentLab.textAlignment = NSTextAlignmentCenter;
    [formView addSubview: topSegmentLab];
    
    bottomSegmentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    bottomSegmentLab.backgroundColor = [ColorUtil getColor:@"CBCBCB" alpha:1];
    bottomSegmentLab.textAlignment = NSTextAlignmentCenter;
    [formView addSubview: bottomSegmentLab];
    
    midSegmentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    midSegmentLab.backgroundColor = [ColorUtil getColor:@"CBCBCB" alpha:1];
    midSegmentLab.textAlignment = NSTextAlignmentCenter;
    [formView addSubview: midSegmentLab];
    
    calcelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    calcelBtn.backgroundColor = [UIColor clearColor];
    [calcelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [calcelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [calcelBtn setTitleColor:[ColorUtil getColor:@"595959" alpha:1] forState:UIControlStateNormal];
    [formView addSubview:calcelBtn];
    
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitleColor:[ColorUtil getColor:@"00B4AF" alpha:1] forState:UIControlStateNormal];
    [formView addSubview:saveBtn];
    
    [self registerForKeyboardNotifications];
    
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self layoutSubviews];
}

//- (void)textViewDidChange:(UITextView *)textView
//{
//    NSString *text = _textView.text;
//    if ([self charNumber:text] > 20) {
//        _textView.text = tagStr;
//    } else {
//        tagStr = _textView.text;
//    }
//}

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

- (void)keyboardWillShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardHeight = [value CGRectValue].size.height;
//    [self layoutSubviews];
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        CGSize size = self.frame.size;
        formView.frame = CGRectMake(20, size.height-keyBoardHeight-165, size.width-40, 165);
    }];
}

- (void)cancelClick
{
    _textView.text = @"";
    tagStr = @"";
    self.hidden = YES;
    [_textView resignFirstResponder];
}

- (void)saveClick
{
    [self.parent clickSave];
}

- (void)setEnableSaveBtn
{
    saveBtn.enabled = YES;
}

- (void)setNotEnableSaveBtn
{
    saveBtn.enabled = NO;
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
//    if (keyBoardHeight > 0) {
//        formView.frame = CGRectMake(20 , size.height-260-165, size.width - 40, 165);
//    } else {
//        formView.frame = CGRectMake(20 , size.height-keyBoardHeight-165-40, size.width - 40, 165);
//    }
    formView.frame = CGRectMake(20 , size.height-keyBoardHeight-165, size.width - 40, 165);
    titleLab.frame = CGRectMake(0, 0, formView.frame.size.width, 40);
    topSegmentLab.frame = CGRectMake(0, CGRectGetMaxY(titleLab.frame)+1, formView.frame.size.width, 0.5);
    _textView.frame = CGRectMake(10, CGRectGetMaxY(topSegmentLab.frame) + 10, formView.frame.size.width - 20, 60);
    bottomSegmentLab.frame = CGRectMake(0, CGRectGetMaxY(_textView.frame)+10, formView.frame.size.width, 0.5);
    calcelBtn.frame = CGRectMake(0, CGRectGetMaxY(bottomSegmentLab.frame)+1, formView.frame.size.width/2-1, 40);
    midSegmentLab.frame = CGRectMake(formView.frame.size.width/2, CGRectGetMaxY(bottomSegmentLab.frame), 0.5, 42);
    saveBtn.frame = CGRectMake(formView.frame.size.width/2, CGRectGetMaxY(bottomSegmentLab.frame)+1, formView.frame.size.width/2, 40);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

