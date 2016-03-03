//
//  CHPhoto.h
//  medtree
//
//  Created by 孙晨辉 on 15/10/27.
//  Copyright © 2015年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MessageCell;
@interface CHPhoto : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, assign) CGRect orignF;
@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, assign) NSInteger cellIndex;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) CGPoint offSize;

@end
