//
//  FindDTO.h
//  medtree
//
//  Created by tangshimi on 7/15/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DTOBase.h"

@interface FindDTO : DTOBase

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *iconImageURL;
@property (copy, nonatomic) NSString *webURL;

@end
