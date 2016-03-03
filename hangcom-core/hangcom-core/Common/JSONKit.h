//
//  JSONKit.h
//  hangcom-core
//
//  Created by tangshimi on 6/8/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONKit : NSObject

@end

@interface NSObject (NSObject_JsonWriting)

- (NSString *)JSONString;

@end

@interface NSString (NSString_JsonParsing)

- (id)objectFromJSONString;

@end