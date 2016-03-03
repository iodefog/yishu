//
//  DB.h
//  zhihu
//
//  Created by lyuan on 14-3-5.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBM.h"

typedef void(^ArrayBlock)(NSArray *array);
typedef void(^DictionaryBlock)(NSDictionary *dict);
typedef void (^SuccessBlock)(id JSON);

@interface DB : MDB
{
    NSString    *dbName;
}

/*非初始化调用*/
+ (DB *)shareInstance;

/*加载新DB必须走此处!!!*/
+ (DB *)shareWithName:(NSString *)name;

/*加载默认数据库*/
+ (void)loadDefaultDB;

/*清空表单数据*/
- (void)clearTable:(NSString *)table;

@end
