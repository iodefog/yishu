//
//  ArticleCommentDTO.h
//  medtree
//
//  Created by 边大朋 on 15-4-14.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface ArticleCommentDTO : DTOBase

@property (nonatomic, assign) NSInteger cellType;
@property (nonatomic, strong) NSString  *comment_id;
@property (nonatomic, strong) NSDate    *comment_time;
@property (nonatomic, strong) NSString  *comment_content;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, strong) NSString  *reply_to_article_id;
@property (nonatomic, strong) NSString  *reply_to_feed_id;
@property (nonatomic, assign) NSInteger reply_to_user_id;
@property (nonatomic, strong) NSString  *user_avatar;
@property (nonatomic, strong) NSString  *userName;

@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger likeCount;
@end
