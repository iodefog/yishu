//
//  ImageTextFieldView.h
//  medtree
//
//  Created by 无忧 on 14-9-12.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseView.h"

@protocol ImageTextFieldViewDelegate <NSObject>

- (void)textFieldOverWithTag:(NSInteger)tag;
- (void)textFieldBecomeFirstResponderWithTag:(NSInteger)tag;

@end

@interface ImageTextFieldView : BaseView <UITextFieldDelegate>
{
    UIImageView     *iconImage;
    UIImageView     *lineImage;
    UIImageView     *bgImage;
    NSInteger       tagNum;
    UIImageView     *headLine;
    UIImageView     *footLine;
    BOOL            isHiddenLine;
}

@property (nonatomic, assign) id<ImageTextFieldViewDelegate> parent;
@property (nonatomic, strong) UITextField     *commonField;

- (void)showBGImage:(BOOL)show;
- (void)setIconImage:(NSString *)imageName placeholder:(NSString *)placeholder;
- (void)setReturnKeyType:(UIReturnKeyType)type;
- (void)setViewTag:(NSInteger)tag;
- (void)setLineHidden;

@end
