//
//  NotifyMessageDTO.m
//  medtree
//
//  Created by 孙晨辉 on 15/9/16.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NotifyMessageDTO.h"
#import "DateUtil.h"

@implementation NotifyMessageDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.fromUserID = [self getStrValue:dict[@"from_user"]];
    self.toUserID = [self getStrValue:dict[@"to_user"]];
    self.content = [self getStrValue:dict[@"message"]];
    self.replyType = (MessageReplyType)[self getIntValue:dict[@"message_type"]];
    self.refID = [self getStrValue:dict[@"ref_id"]];
    self.refType = (PostRefType)[self getIntValue:dict[@"ref_type"]];
    NSTimeInterval create = [self getDoubleValue:dict[@"timestamp"]];
    self.createTime = [DateUtil convertTimeFromNumber:@(create)];
    
    return YES;
}

- (NSString *)refStr
{
    NSString *str = @"";
    switch (self.refType) {
        case PostRefTypeUnknown: {
            str = @"未知";
            break;
        }
        case PostRefTypeDiscuss: {
            str = @"讨论";
            break;
        }
        case PostRefTypeArticle: {
            str = @"文章";
            break;
        }
        case PostRefTypeHomeEvent: {
            str = @"活动";
            break;
        }
        case PostRefTypeFriendFeed: {
            str = @"好友动态";
            break;
        }
        case PostRefTypeEvent: {
            str = @"活动";
            break;
        }
        case PostRefTypePosition: {
            str = @"职位";
            break;
        }
    }
    return str;
}

@end
