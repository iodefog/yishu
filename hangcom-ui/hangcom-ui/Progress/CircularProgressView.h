//
//  CircularProgressView.h
//  CircularProgressView
//
//  Created by lyuan on 13-7-11.
//  Copyright (c) 2013年 lyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LoadType_NetWork                     =   0,
    LoadType_DB                          =   1
} LoadType;

@interface CircularProgressView : UIView

@property (nonatomic, strong) UIColor *trackTintColor;
@property (nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, assign) BOOL    isShowLabel;
@property (nonatomic, assign) CGFloat fontFloat;

@end
