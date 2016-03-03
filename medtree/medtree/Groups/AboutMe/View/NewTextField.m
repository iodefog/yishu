//
//  NewTextField.m
//  medtree
//
//  Created by 边大朋 on 15-4-6.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewTextField.h"

@interface NewTextField () <UITextFieldDelegate>
{
    
}

@end

@implementation NewTextField
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.returnKeyType = UIReturnKeyDone;
        self.delegate = self;
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.parent clickSave:textField];
    return YES;
}
@end
