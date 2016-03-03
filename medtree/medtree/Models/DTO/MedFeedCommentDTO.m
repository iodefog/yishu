//
//  MedFeedCommentDTO.m
//  medtree
//
//  Created by tangshimi on 9/16/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MedFeedCommentDTO.h"
#import "UserManager.h"
#import "UserDTO.h"

@implementation MedFeedCommentDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.commentID = [self getStrValue:dict[@"comment_id"]];
    self.creatorID = [self getStrValue:dict[@"user_id"]];
    
    NSDictionary *param = @{ @"userid" : self.creatorID };
    [UserManager getUserInfoFull:param success:^(UserDTO *userDto) {
        self.creatorDTO = userDto;
    } failure:nil];
    
    self.replyFeedID = [self getStrValue:dict[@"reply_to_feed_id"]];
    self.replyUserID = [self getStrValue:dict[@"reply_to_user_id"]];
    
    if (self.replyUserID.length > 0) {
        NSDictionary *replayToParam = @{ @"userid" : self.replyUserID };
        [UserManager getUserInfoFull:replayToParam success:^(UserDTO *userDto) {
            self.replyUserDTO = userDto;
        } failure:nil];
    }
    
    self.content = [self getStrValue:dict[@"content"]];
    self.anonymous = [self getBoolValue:dict[@"is_anonymous"]];
    self.time = [self getDateValue:dict[@"create_time"]];

    return YES;
}

@end
