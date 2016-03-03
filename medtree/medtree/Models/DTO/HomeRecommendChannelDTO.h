//
//  HomeRecommandChannelDTO.h
//  medtree
//
//  Created by tangshimi on 9/10/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DTOBase.h"

@interface HomeRecommendChannelDTO : DTOBase

@property (nonatomic, copy) NSArray *channelArray;
@property (nonatomic, assign) BOOL moreChannel;

@end
