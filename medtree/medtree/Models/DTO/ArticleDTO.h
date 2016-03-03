//
//  ArticleDTO.h
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface ArticleDTO : DTOBase

@property (nonatomic, strong) NSString    *author;
@property (nonatomic, strong) NSString    *articleID;
@property (nonatomic, strong) NSString    *source;
@property (nonatomic, assign) NSInteger   read_count;
@property (nonatomic, strong) NSString    *summary;
@property (nonatomic, strong) NSString    *title;
@property (nonatomic, strong) NSString    *url;
@property (nonatomic, strong) NSDate      *create_time;
@property (nonatomic, strong) NSString    *image_id;
@property (nonatomic, strong) NSString    *share_url;
@property (nonatomic, assign) NSInteger   articleType;
@property (nonatomic, assign) NSInteger   comment_count;
@property (nonatomic, assign) BOOL        is_like;
@property (nonatomic, assign) NSInteger   like_count;

@end
