//
//  TextFieldCell.h
//  medtree
//
//  Created by 陈升军 on 14/12/30.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseCell.h"

@interface TextFieldCell : BaseCell<UITextFieldDelegate>
{
    UILabel         *titleLab;
    UITextField     *textField;
    NSString        *text;
    UIView          *textBGView;
}

@end
