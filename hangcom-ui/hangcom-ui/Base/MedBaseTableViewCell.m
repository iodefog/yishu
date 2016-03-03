//
//  MedBaseTableViewCell.m
//  hangcom-ui
//
//  Created by tangshimi on 10/20/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MedBaseTableViewCell.h"
#import "DTOBase.h"

@interface MedBaseTableViewCell ()

@property (nonatomic, strong) DTOBase *idto;
@property (nonatomic, strong) NSIndexPath *index;

@end

@implementation MedBaseTableViewCell

@synthesize headerLine;
@synthesize footerLine;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0  blue:220 / 255.0  alpha:1];
            view;
        });
        
        [self addSubview:self.headerLine];
        [self addSubview:self.footerLine];
        
        self.headerLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5);
        self.headerLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.footerLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5);
        self.footerLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{
    
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 44;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)headerLine
{
    if (!headerLine) {
        headerLine =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_page_cell_line.png"]];
            imageView;
        });
    }
    return headerLine;
}

- (UIImageView *)footerLine
{
    if (!footerLine) {
        footerLine = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_page_cell_line.png"]];
            imageView;
        });
    }
    return footerLine;
}

@end
