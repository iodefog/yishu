//
//  CHTextView.h
//  medtree
//
//  Created by 孙晨辉 on 15/11/10.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "BaseView.h"

@interface CHTextView : BaseView

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, strong) NSString *text;

- (void)becomeFirstRespond;

@end
