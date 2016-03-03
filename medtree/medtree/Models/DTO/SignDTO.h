//
//  SignDTO.h
//  medtree
//
//  Created by 陈升军 on 15/2/12.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface SignDTO : DTOBase

@property (nonatomic, strong) NSDate    *todayTime;
@property (nonatomic, assign) BOOL      today_check;
@property (nonatomic, assign) NSInteger total_amount;
@property (nonatomic, assign) NSInteger point;
@property (nonatomic, assign) NSInteger check_count;
@property (nonatomic, assign) NSInteger balance;
@property (nonatomic, copy) NSString  *content;
@property (nonatomic, assign) BOOL      exchangeable;
@property (nonatomic, assign) BOOL      locked;


@end
