//
//  PersonEditTitleTableCell.m
//  medtree
//
//  Created by 无忧 on 14-9-17.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PersonEditTitleTableCell.h"
#import "ImageCenter.h"
#import "MedGlobal.h"
#import "DegreeManager.h"

@implementation PersonEditTitleTableCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor clearColor];
    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor darkGrayColor];
//    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [MedGlobal getMiddleFont];
    titleLab.text = @"个人动态";
    [self addSubview: titleLab];
    
    
    userCount = [[UILabel alloc] initWithFrame:CGRectZero];
    userCount.backgroundColor = [UIColor clearColor];
    userCount.textColor = [UIColor darkGrayColor];
    userCount.textAlignment = NSTextAlignmentCenter;
    userCount.font = [MedGlobal getMiddleFont];
    [self addSubview: userCount];
    
    
    selectImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    selectImage.userInteractionEnabled = YES;
    selectImage.image = [ImageCenter getBundleImage:@"img_cell_checked.png"];
    [self addSubview:selectImage];
    
    
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.image = [ImageCenter getBundleImage:@"img_next.png"];
    nextImage.userInteractionEnabled = YES;
    nextImage.hidden = YES;
    [self addSubview:nextImage];

}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    [self checkLine];
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    headerLine.hidden = YES;
    
//    headerLine.frame = CGRectMake(0, 0, size.width, 0.5);
    footerLine.frame = CGRectMake(15, size.height-1, size.width-15*2, 1);
    titleLab.frame = CGRectMake(20, 0, size.width-40, size.height);
    if (true) {
        selectImage.frame = CGRectMake(size.width-30-50, (size.height-16)/2, 16, 16);
        userCount.frame = CGRectMake(size.width-50-15, 0, 50, size.height);
    } else {
        selectImage.frame = CGRectMake(size.width-30, (size.height-16)/2, 16, 16);
    }
//    
//    
//    if ([[typeDict objectForKey:@"method"] intValue] ==  MethodType_DegreeInfo_POrganization) {
//      
//    } else if ([[typeDict objectForKey:@"method"] intValue] ==  MethodType_DegreeInfo_PDepartment) {
//       
//        int level = [[typeDict objectForKey:@"level"] intValue];
//        if (level == 1) {
//            }
//        
//    }
    nextImage.frame = CGRectMake(size.width-15-5, (size.height-10)/2, 5, 10);

    
}

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    NSDictionary *dict = (NSDictionary *)dto;
    titleLab.text = [dict objectForKey:@"title"];
    count = [[dict objectForKey:@"userCount"] integerValue];
    isShowCount = [[dict objectForKey:@"isShowCount"] boolValue];
    if (count > 0 && isShowCount) {
        userCount.text = [NSString stringWithFormat:@"%ld人", (long)count];
    }
    
    selectImage.hidden = ![[dict objectForKey:@"isSelect"] boolValue];
    [self resize:self.frame.size];
    typeDict = [dict objectForKey:@"typeDict"];
    if ([[typeDict objectForKey:@"method"] intValue] ==  MethodType_DegreeInfo_POrganization) {
        
    } else if ([[typeDict objectForKey:@"method"] intValue] ==  MethodType_DegreeInfo_PDepartment) {
        int level = [[typeDict objectForKey:@"level"] intValue];
        if (level == 1) {
            nextImage.hidden = NO;
            selectImage.hidden = YES;
        } else if (level == 2) {
            nextImage.hidden = YES;
            selectImage.hidden = YES;
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self clickHeader];
}

- (void)clickHeader
{
    if (selectImage.hidden) {
        [self.parent clickCell:titleLab.text index:index];
    }
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 60;
}

@end
