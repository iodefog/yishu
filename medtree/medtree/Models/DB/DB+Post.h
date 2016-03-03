//
//  DB+Post.h
//  medtree
//
//  Created by 孙晨辉 on 15/9/16.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DB.h"

@interface DB (Post)

- (void)createTable_Post;
- (void)insertPosts:(NSArray *)posts;
- (void)selectPost:(NSString *)postID success:(SuccessBlock)success;

@end
