//
//  CommentTextView.m
//  medtree
//
//  Created by tangshimi on 7/7/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MedFeedCommentTextView.h"
#import "UIColor+Colors.h"
#import "NSString+Extension.h"

#define URLRegular @"(http|https)://([a-zA-Z]|[0-9])*(\\.([a-zA-Z]|[0-9])*)*(\\/([a-zA-Z]|[0-9])*)*"

@interface MedFeedCommentTextView () <UITextViewDelegate, NSLayoutManagerDelegate>

@end

@implementation MedFeedCommentTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.editable = NO;
        self.selectable = YES;
        self.scrollEnabled = NO;
        self.font = [UIFont systemFontOfSize:14];
        self.dataDetectorTypes = UIDataDetectorTypeLink;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.textContainerInset = UIEdgeInsetsMake(2.5, 0, 0, 0);
        self.layoutManager.delegate = self;
        
        NSDictionary *linkAttributes = @{ NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#256666"] };
        self.linkTextAttributes = linkAttributes;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

#pragma mark -
#pragma mark - NSLayoutManagerDelegate -

//- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager
//           lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex
//           withProposedLineFragmentRect:(CGRect)rect
//{
//    return 2.0;
//}

#pragma mark -
#pragma mark - UITextViewDelegate -

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if (![self.commentTextViewDelegate respondsToSelector:@selector(commentTextView:selectedText:selectedType:)]) {
        return NO;
    }
    
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"reply"]) {
        [self.commentTextViewDelegate commentTextView:self selectedText:URL.absoluteString selectedType:MedFeedCommentTextViewReplyPersonSelectedType];
    } else if ([scheme isEqualToString:@"replyTo"]) {
        [self.commentTextViewDelegate commentTextView:self selectedText:URL.absoluteString selectedType:MedFeedCommentTextViewReplyToPersonSelectedType];
    } else {
        [self.commentTextViewDelegate commentTextView:self selectedText:URL.absoluteString selectedType:MedFeedCommentTextViewOthersSelectedType];
    }
    
    return NO;
}

#pragma mark -
#pragma mark - 

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    if ([self.commentTextViewDelegate respondsToSelector:@selector(commentTextView:selectedText:selectedType:)]) {
        [self.commentTextViewDelegate commentTextView:self selectedText:nil selectedType:MedFeedCommentTextViewOthersSelectedType];
    }
}

#pragma mark - 
#pragma mark - public -

- (void)setupTextView
{
    if ([self isEmptyString:self.replyPersonName] && [self isEmptyString:self.replyToPersonName] && [self isEmptyString:self.commentText] ) {
        return;
    }
    
    self.text = [NSString stringWithFormat:@"%@%@%@%@%@", (![self isEmptyString:self.replyPersonName]) ? self.replyPersonName : @"",
                 (![self isEmptyString:self.replyToPersonName]) ? @"回复" : @"",
                 (![self isEmptyString:self.replyToPersonName]) ? self.replyToPersonName : @"",
                 (![self isEmptyString:self.replyPersonName] || ![self isEmptyString:self.replyToPersonName]) ? @":" : @"",
                 (![self isEmptyString:self.commentText]) ? self.commentText : @""];
    
    NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
    [attributedString removeAttribute:NSLinkAttributeName range:NSMakeRange(0, attributedString.length)];
    
    if (![self isEmptyString:self.replyPersonName]) {
        NSURL *replyPersonNameURL = [NSURL URLWithString:[[NSString stringWithFormat:@"reply://%@", self.replyPersonName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [attributedString addAttribute:NSLinkAttributeName
                                 value:replyPersonNameURL
                                 range:NSMakeRange(0, self.replyPersonName.length)];
    }
        
    if (![self isEmptyString:self.replyToPersonName]) {
        NSURL *replyToPersonNameURL = [NSURL URLWithString:[[NSString stringWithFormat:@"replyTo://%@", self.replyToPersonName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [attributedString addAttribute:NSLinkAttributeName
                                 value:replyToPersonNameURL
                                 range:NSMakeRange(self.replyPersonName.length + 2, self.replyToPersonName.length)];
    }
 
    if ( ![self isEmptyString:self.commentText]) {
        NSRegularExpression *regualrExpression = [NSRegularExpression regularExpressionWithPattern:URLRegular
                                                                                           options:NSRegularExpressionDotMatchesLineSeparators
                                                                                             error:nil];
        NSArray *httpUrlArray = [regualrExpression matchesInString:self.commentText
                                                           options:0
                                                             range:NSMakeRange(0, self.commentText.length)];
        
        NSRange commentRange = [self.text rangeOfString:self.commentText];
        
        for (NSTextCheckingResult *match in httpUrlArray) {
            
            NSRange range = NSMakeRange(commentRange.location + match.range.location, match.range.length);
            
            NSURL *httpURL = [NSURL URLWithString:[self.text substringWithRange:range]];
            [attributedString addAttribute:NSLinkAttributeName
                                     value:httpURL
                                     range:range];
        }
    }
    self.attributedText = [attributedString copy];
}

- (CGFloat)height
{
    if ([self isEmptyString:self.replyPersonName] && [self isEmptyString:self.replyToPersonName] && [self isEmptyString:self.commentText] ) {
        return 0;
    }

    CGRect textFrame = [[self layoutManager] usedRectForTextContainer:[self textContainer]];
    return CGRectGetHeight(textFrame) + 5;
}

#pragma mark -
#pragma mark - helper -

- (BOOL)isEmptyString:(NSString *)string
{
    if (string && ![string isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

@end
