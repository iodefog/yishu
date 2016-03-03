//
//  SectionSpaceTableViewCell.m
//  medtree
//
//  Created by tangshimi on 8/17/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "SectionSpaceTableViewCell.h"
#import "UIColor+Colors.h"

@implementation SectionSpaceTableViewCell

- (void)createUI
{
    self.backgroundColor =  [UIColor colorFromHexString:@"#F4F4F7"];
   // self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 10;
}

@end
