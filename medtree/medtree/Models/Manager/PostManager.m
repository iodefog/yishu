//
//  PostManager.m
//  medtree
//
//  Created by 孙晨辉 on 15/9/16.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "PostManager.h"
#import "DB+Post.h"

@implementation PostManager

+ (void)inserPosts:(NSArray *)posts
{
    [[DB shareInstance] insertPosts:posts];
}

+ (void)getPostByPostID:(NSString *)postID success:(SuccessBlock)success
{
    [[DB shareInstance] selectPost:postID success:success];
}

@end
