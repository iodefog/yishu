//
//  CoreLabel.h
//  hangcom-ui
//
//  Created by sam on 1/15/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "TQRichTextView.h"
#import "CoreLabelDelegate.h"

@interface CoreLabel : TQRichTextView <TQRichTextViewDelegate>

@property (nonatomic, assign) id<CoreLabelDelegate> parent;

@end
