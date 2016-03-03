//
//  NewTextField.h
//  medtree
//
//  Created by 边大朋 on 15-4-6.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewTextFieldDelegate <NSObject>

- (void)clickSave:(UITextField *)textField;
@end
@interface NewTextField : UITextField

@property (nonatomic, weak) id<NewTextFieldDelegate> parent;
@end
