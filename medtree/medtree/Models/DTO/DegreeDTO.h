//
//  DegreeDTO.h
//  medtree
//
//  Created by 无忧 on 14-9-5.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface DegreeDTO : DTOBase

@property (nonatomic, assign) NSInteger first_degree_total_count;//一度总数
@property (nonatomic, assign) NSInteger first_degree_Friend_count;//一度朋友总数
@property (nonatomic, assign) NSInteger first_degree_Classmate_count;//一度同学总数
@property (nonatomic, assign) NSInteger first_degree_Colleague_count;//一度同事总数
@property (nonatomic, assign) NSInteger first_degree_Peer_count;//一度同行总数

@property (nonatomic, assign) NSInteger second_degree_total_count;//二度好友总数
@property (nonatomic, assign) NSInteger second_degree_Friend_count;//一度朋友总数
@property (nonatomic, assign) NSInteger second_degree_Classmate_count;//一度同学总数
@property (nonatomic, assign) NSInteger second_degree_Colleague_count;//一度同事总数

@end
