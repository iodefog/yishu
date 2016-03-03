//
//  PostManager.h
//  medtree
//
//  Created by 孙晨辉 on 15/9/16.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DataManager.h"

@interface PostManager : DataManager

+ (void)inserPosts:(NSArray *)post;

+ (void)getPostByPostID:(NSString *)postID success:(SuccessBlock)success;

@end
