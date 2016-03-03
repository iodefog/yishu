//
//  MedFeedDTO.m
//  medtree
//
//  Created by tangshimi on 9/16/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MedFeedDTO.h"
#import <DateUtil.h>
#import "MedFeedCommentDTO.h"

@implementation MedFeedDTO

- (instancetype)init:(NSDictionary *)dict nameForIDInfo:(NSDictionary *)userInfo
{
    self = [super init];
    if (self) {

        self.feedID = [self getStrValue:dict[@"feed_id"]];
        self.creatorID = [self getStrValue:dict[@"user_id"]];
        self.type = [self getIntValue:dict[@"post_type"]];
        self.content = [self getStrValue:dict[@"content"]];
        self.imageArray = [self getArrayValue:dict[@"images"]];
        NSArray *commentsArray = [self getArrayValue:dict[@"comments"]];
        __block NSMutableArray *feedCommentDTOArray = [NSMutableArray new];
        [commentsArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * stop) {
            MedFeedCommentDTO *dto = [[MedFeedCommentDTO alloc] init:dic];
            dto.creatorName = [userInfo objectForKey: [NSString stringWithFormat:@"%@",dto.creatorID]];
            dto.replyUserName = [userInfo objectForKey: [NSString stringWithFormat:@"%@",dto.replyUserID]];
            [feedCommentDTOArray addObject:dto];
        }];
        
        self.commentArray = [feedCommentDTOArray copy];
        
        self.anonymous = [self getBoolValue:dict[@"is_anonymous"]];
        self.commentNumber = [self getIntValue:dict[@"offical_count"]];
        self.favourNumber = [self getIntValue:dict[@"like_count"]];
        self.favoured = [self getBoolValue:dict[@"is_liked"]];
        self.favourContent = [self getStrValue:dict[@"like_summary"]];
        self.time = [DateUtil getDisplayTime:[self getDateValue:dict[@"create_time"]]];
    }
    return self;
}

@end
