//
//  UserDTO.h
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOBase.h"
#import "UserType.h"

@interface UserDTO : DTOBase

/**名片信息是否完整*/
@property (nonatomic, assign) BOOL  is_card_complete;
/**名片、名家专栏时使用**/
@property (nonatomic, strong) NSString *account_id;
/**兼职**/
@property (nonatomic, strong) NSString *sideline;
/**成就**/
@property (nonatomic, strong) NSString *achievement;
/**是否拥有名家专栏**/
@property (nonatomic, assign) BOOL  isMaster;

@property (nonatomic, copy) NSString  *userID;
@property (nonatomic, strong) NSString  *anonymous_id;
@property (nonatomic, strong) NSString  *anonymous_name;
@property (nonatomic, strong) NSString  *chatID;
@property (nonatomic, strong) NSString  *age;
@property (nonatomic, strong) NSString  *photoID;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong) NSString  *desc;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger common_friends_count;
@property (nonatomic, strong) NSString  *common_friends_summary;
@property (nonatomic, assign) NSInteger relation;
@property (nonatomic, strong) NSString  *last_active;
@property (nonatomic, strong) NSString  *constellation;
@property (nonatomic, strong) NSString  *distance;
@property (nonatomic, strong) NSString  *regtime;
@property (nonatomic, strong) NSString  *interest;
@property (nonatomic, strong) NSString  *birthday;
/** 出生年，用于经历判断 */
@property (nonatomic, assign) NSInteger birthYear;
@property (nonatomic, assign) double    distance_km;
@property (nonatomic, assign) User_Types user_type;
/** 用户信息完善状态 0:未完善 1:已完善 */
@property (nonatomic, assign) NSInteger user_status;
@property (nonatomic, assign) NSInteger certificate_user_type;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSMutableArray *certificationArray;
/** 教育经历 */
@property (nonatomic, strong) NSMutableArray *educationArray;
/** 工作经历 */
@property (nonatomic, strong) NSMutableArray *experienceArray;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *network;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) NSMutableArray *preferences;
@property (nonatomic, strong) NSString       *remark;
@property (nonatomic, strong) NSMutableArray *phones;

@property (nonatomic, strong) NSString  *organization_name;
@property (nonatomic, strong) NSString  *department_name;
@property (nonatomic, strong) NSString  *organization_id;
@property (nonatomic, strong) NSString  *department_id;

@property (nonatomic, assign) NSInteger sameNameNum;
@property (nonatomic, assign) NSInteger sameStatus;
@property (nonatomic, assign) NSInteger match_type;
@property (nonatomic, strong) NSString  *mateID;
@property (nonatomic, strong) NSString  *relation_summary;

@property (nonatomic, strong) id extendData;

@property (nonatomic, assign) BOOL  isVerify;
@property (nonatomic, assign) BOOL  isFriend;
@property (nonatomic, assign) BOOL  is_certificated;//是否认证
@property (nonatomic, strong) NSString  *certificate_info;//认证理由/信息

@property (nonatomic, assign) BOOL  isEncrypted;
@property (nonatomic, assign) BOOL  isSelect;
/*普通标签*/
@property (nonatomic, strong) NSMutableArray  *user_tags;
/*学术标签*/
@property (nonatomic, strong) NSMutableArray  *academic_tags;

@property (nonatomic, assign) NSInteger distributePoint;

@property (nonatomic, assign) BOOL  friend_requests_not_allowed;

@property (nonatomic, assign, getter=isAnonymous, readonly) BOOL anonymous;

//v4.1 add
@property (nonatomic, strong) NSString *phone; //联系方式
@property (nonatomic, strong) NSString *selfIntroduction; //自我介绍
@property (nonatomic, strong) NSString *honour; //荣誉
@property (nonatomic, strong) NSString *birthplace; //出生地
@property (nonatomic, strong) NSString *residential; //居住地
@property (nonatomic, strong) NSString *workExperience; //工作经验
@property (nonatomic, assign) NSInteger resumeCount;

/**
 *  查看职位企业次数为5时，提示 完善简历
 */
@property (nonatomic, assign) NSInteger lookEmploymentAndEnterpriseCount;

@end

