//
//  NewCommonPersonCell.h
//  medtree
//  个人主页，工作经历，教育经历共用cell
//  Created by 边大朋 on 15-4-1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseCell.h"

@class OrganizationDTO;

@interface NewCommonPersonCell : BaseCell
{
    UILabel             *keyLab;     //标题
    UILabel             *valueLab;   //标题文字内容
    UILabel             *value2Lab;  //标题文字第二块内容
    UILabel             *timeLab;    //时间
    UIImageView         *nextImg;    //下一页图片
    UISwitch            *setSwitch;  //开关，个人主页和编辑个人经历用到
    NSInteger           touchType;
    OrganizationDTO     *odto;
}

@property (nonatomic, weak) id parent2;

@end
