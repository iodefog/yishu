//
//  TitleType.m
//  medtree
//
//  Created by 无忧 on 14-9-20.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "TitleType.h"

@implementation TitleType

+ (NSString *)getLabel:(NSInteger)type
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        //
        [dict setObject:@"未设置" forKey:[NSNumber numberWithInteger:Title_Types_Unknow]];
        
        [dict setObject:@"大专" forKey:[NSNumber numberWithInteger:Title_Types_Education_dazhuang]];
        [dict setObject:@"本科" forKey:[NSNumber numberWithInteger:Title_Types_Education_benke]];
        [dict setObject:@"硕士" forKey:[NSNumber numberWithInteger:Title_Types_Education_suoshi]];
        [dict setObject:@"博士" forKey:[NSNumber numberWithInteger:Title_Types_Education_boshi]];
        [dict setObject:@"其他" forKey:[NSNumber numberWithInteger:Title_Types_Education_qita]];
        
        [dict setObject:@"其他" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_qita]];
        [dict setObject:@"主任医师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_zhurenyishi]];
        [dict setObject:@"副主任医师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_fuzhurenyishi]];
        [dict setObject:@"主治医师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_zhuzhiyishi]];
        [dict setObject:@"住院医师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_zhuyuanyishi]];
        [dict setObject:@"实习医师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_shixiyishi]];
        [dict setObject:@"助理医师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_zhuliyishi]]
        ;
        [dict setObject:@"主任护师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_zhuren_hushi]];
        [dict setObject:@"副主任护师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_fuzhuren_hushi]];
        [dict setObject:@"中级主管护师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_zhongji_zhuguanhushi]];
        [dict setObject:@"初级护师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_hushi]];
        [dict setObject:@"初级护士" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_chuji_hushi]];
        
        [dict setObject:@"教授" forKey:[NSNumber numberWithInteger:Title_Types_School_professor]];
        [dict setObject:@"副教授" forKey:[NSNumber numberWithInteger:Title_Types_School_associate_professor]];
        [dict setObject:@"讲师" forKey:[NSNumber numberWithInteger:Title_Types_School_lecturer]];
        [dict setObject:@"其他" forKey:[NSNumber numberWithInteger:Title_Types_School_other]];
        
        
    }
    NSString *label = [dict objectForKey:[NSNumber numberWithInteger:type]];
    return label ? label : @"";
}


+ (NSInteger)getInteger:(NSString *)title
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        //
        [dict setObject:@"未设置" forKey:[NSNumber numberWithInteger:Title_Types_Unknow]];
        
        [dict setObject:@"大专" forKey:[NSNumber numberWithInteger:Title_Types_Education_dazhuang]];
        [dict setObject:@"本科" forKey:[NSNumber numberWithInteger:Title_Types_Education_benke]];
        [dict setObject:@"硕士" forKey:[NSNumber numberWithInteger:Title_Types_Education_suoshi]];
        [dict setObject:@"博士" forKey:[NSNumber numberWithInteger:Title_Types_Education_boshi]];
        [dict setObject:@"其他" forKey:[NSNumber numberWithInteger:Title_Types_Education_qita]];
        
        [dict setObject:@"其他" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_qita]];
        [dict setObject:@"主任医师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_zhurenyishi]];
        [dict setObject:@"副主任医师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_fuzhurenyishi]];
        [dict setObject:@"主治医师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_zhuzhiyishi]];
        [dict setObject:@"住院医师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_zhuyuanyishi]];
        [dict setObject:@"实习医师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_shixiyishi]];
        [dict setObject:@"助理医师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_zhuliyishi]];
        [dict setObject:@"主任护师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_zhuren_hushi]];
        [dict setObject:@"副主任护师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_fuzhuren_hushi]];
        [dict setObject:@"中级主管护师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_zhongji_zhuguanhushi]];
        [dict setObject:@"初级护师" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_hushi]];
        [dict setObject:@"初级护士" forKey:[NSNumber numberWithInteger:Title_Types_Hospital_chuji_hushi]];
        
        [dict setObject:@"教授" forKey:[NSNumber numberWithInteger:Title_Types_School_professor]];
        [dict setObject:@"副教授" forKey:[NSNumber numberWithInteger:Title_Types_School_associate_professor]];
        [dict setObject:@"讲师" forKey:[NSNumber numberWithInteger:Title_Types_School_lecturer]];
        [dict setObject:@"其他" forKey:[NSNumber numberWithInteger:Title_Types_School_other]];
    }
    
    NSArray *array = [dict allKeys];
    NSInteger keyNum = 0;
    for (NSString *key in array)
    {
        if (  [title isEqualToString:[dict objectForKey:key] ] )
        {
            keyNum = [key integerValue];
            break;
        }
    }
    return keyNum;
}

@end
