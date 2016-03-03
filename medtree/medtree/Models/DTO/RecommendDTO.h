//
//  RecommendDTO.h
//  medtree
//
//  Created by 陈升军 on 15/1/20.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@class EventDTO;

@interface RecommendDTO : DTOBase

@property (nonatomic, strong) NSString *recommendID;
@property (nonatomic, assign) NSInteger content_type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *image_id;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) EventDTO *eventDTO;

@end
