//
//  RelationTypes.h
//  mcare-model
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumBase.h"

@interface RelationTypes : EnumBase

typedef enum {
    RelationTypes_None          = 0,
    RelationTypes_Friend        = 1,
    RelationTypes_Classmate     = 10,
    RelationTypes_Alumni        = 12,
    RelationTypes_Tutor         = 13,
    RelationTypes_Colleague     = 20,
    RelationTypes_Peer          = 22,
    RelationTypes_Membership    = 30,
    RelationTypes_otherFriend   = 90,
    RelationTypes_Stranger      = 100
} Relation_Types;

+ (NSString *)getLabel:(NSInteger)type;

@end
