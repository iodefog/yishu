//
//  DB+Global.h
//  medtree
//
//  Created by tangshimi on 5/19/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DB.h"

@interface DB (Global)

- (void)createGlobalTable;
- (void)cacheWithURL:(NSString *)url data:(id)json;
- (id)readCacheWithURL:(NSString *)url;

@end
