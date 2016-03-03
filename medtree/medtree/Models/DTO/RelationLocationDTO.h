//
//  RelationLocationDTO.h
//  medtree
//
//  Created by tangshimi on 6/16/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DTOBase.h"

@interface RelationLocationDTO : DTOBase

@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *alias;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *created;
@property (nonatomic, copy)NSString *creater;
@property (nonatomic, copy)NSString *id;
@property (nonatomic, assign)double latitude;
@property (nonatomic, assign)double longitude;
@property (nonatomic, assign)NSInteger medical_institution;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)NSInteger org_grade;
@property (nonatomic, copy)NSString *pinyin;
@property (nonatomic, copy)NSString *province;
@property (nonatomic, copy)NSString *region;
@property (nonatomic, assign)NSInteger source;
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, copy)NSString *updated;
@property (nonatomic, assign)NSInteger visible;

@end
