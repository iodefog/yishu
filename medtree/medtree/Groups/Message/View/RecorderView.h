//
//  RecorderView.h
//  medtree
//
//  Created by sam on 12/5/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseView.h"

@interface RecorderView : BaseView {
    UIImageView *bgView;
    UIImageView *timeView;
    UIImageView *cancelView;
    
    NSTimer     *timer;
    NSInteger   timeIndex;
}

- (void)startRecord;
- (void)stopRecord;
- (void)setCancelRecordStatus:(BOOL)tf;
- (void)setShortCancelRecord;

@end
