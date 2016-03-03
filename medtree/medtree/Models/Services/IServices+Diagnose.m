//
//  IServices+Diagnose.m
//  medtree
//
//  Created by 无忧 on 14-9-14.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices+Diagnose.h"

@implementation IServices (Diagnose)

+ (void)sendDiagnose:(NSDictionary *)param
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"diagnose/exception" method:@"POST" params:param success:^(id JSON) {
        
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}

@end
