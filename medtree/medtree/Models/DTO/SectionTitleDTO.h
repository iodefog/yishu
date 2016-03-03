//
//  SectionTitleDTO.h
//  medtree
//
//  Created by tangshimi on 8/17/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DTOBase.h"

@interface SectionTitleDTO : DTOBase

@property (nonatomic, strong) UIColor *verticalViewColor;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL showMoreButton;
@property (nonatomic, copy) NSString *moreButtonTitle;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) BOOL hideFooterLine;

@end
