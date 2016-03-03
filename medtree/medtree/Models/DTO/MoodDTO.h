//
//  MoodDTO.h
//  medtree
//
//  Created by 陈升军 on 14/12/16.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface MoodThemeDTO : DTOBase

@property (nonatomic, strong) NSDate    *mood_time;
@property (nonatomic, strong) NSMutableArray *actions;
@property (nonatomic, assign) NSInteger surgery_count;
@property (nonatomic, assign) NSInteger patient_count;

@end

@interface MoodContentDTO : DTOBase

@property (nonatomic, strong) NSDate    *mood_time;
@property (nonatomic, strong) NSString  *mood_content;
@property (nonatomic, strong) NSMutableArray *images;

@end

@interface MoodImageDTO : DTOBase

@property (nonatomic, strong) NSDate    *mood_time;
@property (nonatomic, strong) NSString  *photoID;

@end

@interface MoodDTO : DTOBase

@property (nonatomic, strong) NSMutableArray *actions;
@property (nonatomic, assign) NSInteger surgery_count;
@property (nonatomic, assign) NSInteger patient_count;
@property (nonatomic, strong) NSString  *mood_content;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSString  *user_name;
@property (nonatomic, strong) NSString  *user_avatar;
@property (nonatomic, strong) NSDate    *mood_time;
@property (nonatomic, strong) NSString  *user_id;
@property (nonatomic, strong) NSString  *mood_id;
@property (nonatomic, assign) NSInteger emotion;
@property (nonatomic, assign) NSInteger weather;
@property (nonatomic, assign) BOOL      isPost;

@end

