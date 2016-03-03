//
//  CognitionPeopleCell.m
//  medtree
//
//  Created by 孙晨辉 on 15/4/30.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "CognitionPeopleCell.h"

@implementation CognitionPeopleCell

- (void)resize:(CGSize)size
{
    [super resize:size];
    inviteButton.frame = CGRectMake(size.width-60, 5, 60, 60);
    
    NSLog(@"header --------------------------- %@", NSStringFromCGRect(headerView.frame));
}

@end
