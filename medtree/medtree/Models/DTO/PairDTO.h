//
//  PairDTO.h
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOBase.h"

@interface PairDTO : DTOBase

@property (nonatomic, strong) NSDate    *date;
@property (nonatomic, strong) NSString  *label;
@property (nonatomic, strong) NSString  *key;
@property (nonatomic, strong) NSString  *value;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger cellType;
@property (nonatomic, assign) NSInteger accessType;
@property (nonatomic, assign) BOOL      isShowHeaderLine;
@property (nonatomic, assign) BOOL      isShowFootLine;
@property (nonatomic, assign) BOOL      isShowRoundView;
@property (nonatomic, strong) NSString  *imageName;
@property (nonatomic, strong) NSString  *badge;
@property (nonatomic, strong) NSMutableArray *resourceArray;
@property (nonatomic, strong) NSMutableDictionary *resourceDict;
@property (nonatomic, strong) NSMutableArray *selectResourceArray;
@property (nonatomic, assign) BOOL      isLastCell;
@property (nonatomic, assign) BOOL      isOn;
@property (nonatomic, assign) BOOL      isSelect;
@property (nonatomic, assign) BOOL      isHideFootLine;

@end


@interface SectionDTO : DTOBase

@property (nonatomic, strong) NSString          *name;
@property (nonatomic, strong) NSMutableArray    *items;

@end