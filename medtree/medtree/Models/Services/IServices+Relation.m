//
//  IServices+Relation.m
//  medtree
//
//  Created by tangshimi on 6/13/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "IServices+Relation.h"

@implementation IServices (Relation)

+ (void)getRealtionStatusSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"relation/stats" method:@"GET" params:nil success:success failure:failure];
}

+ (void)getRealtionResultParams:(NSDictionary *)dict  Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    NSMutableString *action = [NSMutableString stringWithFormat:@"relation/%zi/_search",[[dict objectForKey:@"relation_type"] integerValue]];

    NSInteger from = [[dict objectForKey:@"from"] integerValue];
    NSInteger size = [[dict objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%zi&size=%zi", from, size];
    }
    
    if ([dict objectForKey:@"keyword"]) {
        [action appendFormat:@"&keyword=%@", [[dict objectForKey:@"keyword"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }

    if ([dict objectForKey:@"org_name"]) {
        [action appendFormat:@"&org_name=%@", [[dict objectForKey:@"org_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([dict objectForKey:@"province"]) {
        [action appendFormat:@"&province=%@", [[dict objectForKey:@"province"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([dict objectForKey:@"city"]) {
        [action appendFormat:@"&city=%@", [[dict objectForKey:@"city"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([dict objectForKey:@"first_dept_name"]) {
        [action appendFormat:@"&first_dept_name=%@", [[dict objectForKey:@"first_dept_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }

    if ([dict objectForKey:@"second_dept_name"]) {
        [action appendFormat:@"&second_dept_name=%@", [[dict objectForKey:@"second_dept_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }

    if ([dict objectForKey:@"exp_start_year"]) {
        [action appendFormat:@"&exp_start_year=%@", [dict objectForKey:@"exp_start_year"]];
    }
 
    if ([dict objectForKey:@"title"]) {
        [action appendFormat:@"&title=%@", [[dict objectForKey:@"title"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }

    if ([dict objectForKey:@"facet"]) {
        [action appendFormat:@"&facet=%@", [dict objectForKey:@"facet"]];
    }
    
    if ([dict objectForKey:@"fetch_org_details"]) {
        [action appendFormat:@"&fetch_org_details=%@", [dict objectForKey:@"fetch_org_details"]];
    }
    
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

@end
