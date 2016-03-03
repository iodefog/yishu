//
//  PostDTO.m
//  medtree
//
//  Created by 孙晨辉 on 15/9/16.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "PostDTO.h"
#import "DateUtil.h"

@implementation PostDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.content = [self getStrValue:dict[@"content"]];
    self.userID = [self getStrValue:dict[@"creator"]];
    self.postID = [self getStrValue:dict[@"id"]];
    NSTimeInterval create = [self getDoubleValue:dict[@"created"]];
    self.createTime = [DateUtil convertTimeFromNumber:@(create)];
    NSTimeInterval update = [self getDoubleValue:dict[@"updated"]];
    self.updateTime = [DateUtil convertTimeFromNumber:@(update)];
    self.title = [self getStrValue:dict[@"title"]];
    self.type = (PostRefType)[self getIntValue:dict[@"type"]];
    self.typeName = [self getStrValue:dict[@"type_name"]];
    self.channelName = [self getStrValue:dict[@"channel_name"]];
    self.images = [self getArrayValue:dict[@"images"]];
    
    return YES;
}

@end
