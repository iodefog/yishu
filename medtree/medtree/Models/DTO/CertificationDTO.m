//
//  CertificationDTO.m
//  medtree
//
//  Created by 无忧 on 14-11-8.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "CertificationDTO.h"

@implementation CertificationDTO

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    self.certificationID = [self getStrValue:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"id"] intValue]]];
    self.certificate_type = [self getIntValue:[dict objectForKey:@"certificate_type"]];
    self.reason = [self getStrValue:[dict objectForKey:@"reason"]];
    self.userType = (User_Types)[self getIntValue:[dict objectForKey:@"user_type"]];
    self.status = [self getIntValue:[dict objectForKey:@"status"]];
    self.comment = [self getStrValue:[dict objectForKey:@"comment"]];
    self.certificate_number = [self getStrValue:[dict objectForKey:@"certificate_number"]];
    {
        if (self.images == nil) {
            self.images = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"images"] != [NSNull null] && [dict objectForKey:@"images"] != nil) {
            NSArray *array = [dict objectForKey:@"images"];
            [self.images addObjectsFromArray:array];
        }
    }
    if ([dict objectForKey:@"experience_id"]) {
        self.experience_id = [dict objectForKey:@"experience_id"];
    }
    //
    return tf;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"certificationID:%@, certificate_type:%@, reason:%@, userType:%@, status:%@, comment:%@, certificate_number:%@, images:%@, experience_id:%@", self.certificationID, @(self.certificate_type), self.reason, @(self.userType), @(self.status), self.comment, self.certificate_number, self.images, self.experience_id];
}

@end
