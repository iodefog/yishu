//
//  MessageCell.h
//  medtree
//
//  Created by sam on 8/14/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseCell.h"

@class MessageDTO;

@interface MessageCell : BaseCell

+ (BOOL)isShowTime:(MessageDTO *)dto lastTime:(NSDate *)lastTime;
- (void)stopVoice;

@end
