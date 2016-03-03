//
//  MedBaseTableViewCell.h
//  hangcom-ui
//
//  Created by tangshimi on 10/20/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedBaseTableVIew.h"

@interface MedBaseTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MedBaseTableViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *headerLine;
@property (nonatomic, strong) UIImageView *footerLine;

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width;

@end
