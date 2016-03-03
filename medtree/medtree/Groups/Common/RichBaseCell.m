//
//  RichBaseCell.m
//  medtree
//
//  Created by sam on 8/9/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "RichBaseCell.h"
#import "DateUtil.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "ColorUtil.h"
#import "UIImageView+setImageWithURL.h"

@implementation RichBaseCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)createUI
{
    [super createUI];
    
    // 头像
    headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
    headerView.layer.cornerRadius = 25;
    headerView.layer.masksToBounds = YES;
    headerView.userInteractionEnabled = YES;
    [self addSubview:headerView];
    
    // 昵称
    nameLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [MedGlobal getMiddleFont];
    [self addSubview: nameLabel];
    
    // 时间
    descLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.textColor = [ColorUtil getColor:@"767676" alpha:1];
    descLabel.font = [MedGlobal getTinyLittleFont];
    descLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview: descLabel];
    
    // 消息内容
    contentLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textColor = [ColorUtil getColor:@"767676" alpha:1];
    contentLabel.font = [MedGlobal getLittleFont];
    [self addSubview: contentLabel];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    [self resize:size];
}

- (void)resize:(CGSize)size
{
    [super resize:size];
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    headerView.frame = CGRectMake(10, 10, 50, 50);
    nameLabel.frame = CGRectMake(70, 10, size.width/2-30, 20);
    descLabel.frame = CGRectMake(size.width/2+40, 10, size.width/2-50, 20);
    contentLabel.frame = CGRectMake(70, 40, size.width-80, 20);
}

- (void)setPhoto:(NSString *)photoID imageView:(UIImageView *)imageView
{
    if (photoID.length > 0) {
        NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Small], photoID];
        [imageView med_setImageWithUrl:[NSURL URLWithString:path]];
        imagePath = path;
    } else if (imagePath.length == 0 || photoID.length == 0) {
        headerView.image = [ImageCenter getBundleImage:@"img_head.png"];
    }
}

- (void)setInfo:(DTOBase *)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    idto = dto;
    //
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 70;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
//    [self clickHeader];
}

- (void)clickHeader
{

}

@end
