//
//  ExperienceListTableView.h
//  medtree
//
//  Created by 边大朋 on 15/6/19.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseTableView.h"

@class DTOBase;

@interface DeleteListTableView : BaseTableView

@property (nonatomic, assign) BOOL isCanDel;
@property (nonatomic, strong) DTOBase *edto;
@property (nonatomic, strong) NSString *noticeMsg;
@end
