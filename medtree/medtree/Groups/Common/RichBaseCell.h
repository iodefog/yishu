//
//  RichBaseCell.h
//  medtree
//
//  Created by sam on 8/9/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseCell.h"
#import "DTOBase.h"

@interface RichBaseCell : BaseCell {
    UIImageView *headerView;                        // 头像
    UILabel     *nameLabel;                         // 第一行左侧信息
    UILabel     *descLabel;                         // 第一行右侧信息
    UILabel     *contentLabel;                      // 第二行信息
    NSString    *imagePath;
}

- (void)setPhoto:(NSString *)photoID imageView:(UIImageView *)imageView;

@end
