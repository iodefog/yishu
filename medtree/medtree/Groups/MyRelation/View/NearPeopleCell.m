//
//  NearPeopleCell.m
//  medtree
//
//  Created by 无忧 on 14-11-13.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "NearPeopleCell.h"
#import "UserDTO.h"

@implementation NearPeopleCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code n   
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    depAndTitleLab.hidden = YES;
    contentLabel.frame = CGRectMake(70, 40, size.width/2+40-70, 20);
}

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{
    [super setInfo:dto indexPath:indexPath];
    double distance_km = ((UserDTO *)dto).distance_km;
    NSString *distance = @"";
    if (distance_km > 1) {
        distance = @"1公里以外";
    } else if (distance_km < 1 && distance_km > 0.5) {
        distance = @"1000米以内";
    } else if (distance_km < 0.5 && distance_km > 0.1) {
        distance = @"500米以内";
    } else {
        distance = @"100米以内";
    }
    descLabel.text = [NSString stringWithFormat:@"%@",distance];
}

@end
