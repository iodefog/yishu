//
//  HomeJobChannelSearchHistoryTableViewCell.m
//  medtree
//
//  Created by tangshimi on 11/3/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelSearchHistoryTableViewCell.h"
#import "PairDTO.h"

@interface HomeJobChannelSearchHistoryTableViewCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation HomeJobChannelSearchHistoryTableViewCell

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.label];
    [self.label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(0);
        make.right.lessThanOrEqualTo(-15);
    }];
    
    [footerLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.bottom.equalTo(0);
        make.height.equalTo(0.5);
    }];
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    self.label.text = dto.label;
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 50;
}

#pragma mark -
#pragma mark - setter and getter -

- (UILabel *)label
{
    if (!_label) {
        _label = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:15];
            label;
        });
    }
    return _label;
}

@end
