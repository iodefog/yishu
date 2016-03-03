//
//  CoreLabel.m
//  hangcom-ui
//
//  Created by sam on 1/15/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "CoreLabel.h"

@implementation CoreLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init
{
    self = [super init];
    if (self) {
        self.delegage = self;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegage = self;
    }
    return self;
}

- (void)richTextView:(TQRichTextView *)view touchBeginRun:(TQRichTextRun *)run
{
    
}

- (void)richTextView:(TQRichTextView *)view touchEndRun:(TQRichTextRun *)run
{
    if ([run isKindOfClass:[TQRichTextRunURL class]])
    {
        [self.parent clickURL:run.text];
    } else if (run == nil) {
        [self.parent clickText:nil];
        [self.parent clickTextView:self];
    }
}

- (void)richTextView:(TQRichTextView *)view touchCanceledRun:(TQRichTextRun *)run
{
    
}



@end
