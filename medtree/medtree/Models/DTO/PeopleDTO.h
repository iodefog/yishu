//
//  PeopleDTO.h
//  medtree
//
//  Created by 无忧 on 14-9-9.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface PeopleDTO : DTOBase

@property (nonatomic, strong) NSString  *peopleID;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *avatar;
@property (nonatomic, assign) NSInteger degree;
@property (nonatomic, strong) NSArray   *connection;
@property (nonatomic, strong) NSArray   *referrer;
@property (nonatomic, strong) NSString  *title;

@property (nonatomic, strong) NSString  *chatID;
@property (nonatomic, strong) NSString  *age;
@property (nonatomic, strong) NSString  *photoID;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong) NSString  *desc;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger relation;
@property (nonatomic, strong) NSString  *last_active;
@property (nonatomic, strong) NSString  *constellation;
@property (nonatomic, strong) NSString  *distance;
@property (nonatomic, strong) NSString  *regtime;
@property (nonatomic, strong) NSString  *interest;
@property (nonatomic, strong) NSString  *birthday;
@property (nonatomic, assign) double    distance_km;
@property (nonatomic, assign) NSInteger user_type;
@property (nonatomic, assign) NSInteger certificate_user_type;

@property (nonatomic, strong) NSString       *remark;
@property (nonatomic, strong) NSMutableArray *phones;

@property (nonatomic, strong) NSString  *organization_name;
@property (nonatomic, strong) NSString  *department_name;
@property (nonatomic, strong) NSString  *organization_id;
@property (nonatomic, strong) NSString  *department_id;

@property (nonatomic, assign) NSInteger sameNameNum;

@property (nonatomic, strong) id extendData;

@property (nonatomic, assign) BOOL  isFriend;
@property (nonatomic, assign) BOOL  is_certificated;//是否认证
@property (nonatomic, strong) NSString  *certificate_info;//认证理由/信息

@end


@interface ReferrerDTO : DTOBase

@property (nonatomic, strong) NSString  *referrerID;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *avatar;

@end