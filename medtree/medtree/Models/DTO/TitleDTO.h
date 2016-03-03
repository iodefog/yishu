//
//  TitleDTO.h
//  medtree
//
//  Created by 孙晨辉 on 15/8/3.
//  Copyright (c) 2015年 sam. All rights reserved.
//
//  职称

#import "DTOBase.h"

typedef enum {
    TitleType_College                           = 1, // 大中专
    TitleType_Undergraduate_Course              = 2, // 本科
    TitleType_Graduate                          = 3, // 硕士研究生
    TitleType_PhD                               = 4, // 博士研究生
    TitleType_College_Other                     = 5, // 其他
    
    TitleType_Education_Other                   = 10, // 其他
    TitleType_Professor                         = 11, // 教授
    TitleType_Associate_Professor               = 12, // 副教授
    TitleType_Lecturer                          = 13, // 讲师
    
    TitleType_Doctor_Other                      = 40, // 其他
    TitleType_Residency                         = 42, // 住院医师
    TitleType_Attending                         = 43, // 主治医师
    TitleType_Deputy_Chief_Physician            = 44, // 副主任医师
    TitleType_Chief_Physician                   = 45, // 主任医师
    TitleType_Intern                            = 46, // 实习医师
    TitleType_Physician_Assistant               = 47, // 助理医师
    TitleType_Nurser                            = 53, // 初级护士
    TitleType_Chief_Nurse                       = 61, // 主任护师
    TitleType_Deputy_Chief_Nurse                = 62, // 副主任护师
    TitleType_Intermediate_Nurse                = 63, // 中级主管护师
    TitleType_Primary_Nurse                     = 64, // 初级护师
    
} Title_Type;

@interface TitleDTO : DTOBase

/** 职位 */
@property (nonatomic, strong) NSString *title;
/** 类型 */
@property (nonatomic, assign) Title_Type titleType;
/** 选中状态 */
@property (nonatomic, assign, getter=isSelected) bool selected;

@end
