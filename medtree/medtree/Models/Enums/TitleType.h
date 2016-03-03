//
//  TitleType.h
//  medtree
//
//  Created by 无忧 on 14-9-20.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "EnumBase.h"

@interface TitleType : EnumBase


typedef enum {
    Title_Types_Unknow = 0,                             //未设置
    
    
    
    Title_Types_Education_dazhuang = 1,                 //大中专
    Title_Types_Education_benke = 2,                    //本科
    Title_Types_Education_suoshi = 3,                   //硕士研究生
    Title_Types_Education_boshi = 4,                    //博士研究生
    Title_Types_Education_qita = 5,                     //其它
    
    
    Title_Types_School_other = 10,                      //其他
    Title_Types_School_professor  = 11,                 //教授
    Title_Types_School_associate_professor  = 12,       //副教授
    Title_Types_School_lecturer  = 13,                  //讲师
    
    
    Title_Types_Hospital_qita  = 40,                    //其它
    Title_Types_Hospital_zhurenyishi  = 45,             //主任医师
    Title_Types_Hospital_fuzhurenyishi  = 44,           //副主任医师
    Title_Types_Hospital_zhuzhiyishi  = 43,             //主治医师
    Title_Types_Hospital_zhuyuanyishi  = 42,            //住院医师
    Title_Types_Hospital_shixiyishi  = 46,              //实习医师
    Title_Types_Hospital_zhuliyishi  = 47,              //助理医师
    Title_Types_Hospital_zhuren_hushi  = 61,            //主任护师
    Title_Types_Hospital_fuzhuren_hushi  = 62,          //副主任护师
    Title_Types_Hospital_zhongji_zhuguanhushi  = 63,    //中级主管护师
    Title_Types_Hospital_hushi  = 64,                   //初级护师
    Title_Types_Hospital_chuji_hushi  = 53,             //初级护士
    
    
    
} Title_Types;


+ (NSString *)getLabel:(NSInteger)type;
+ (NSInteger)getInteger:(NSString *)title;

@end
