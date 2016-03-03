//
//  NewFeedCommentCell.m
//  medtree
//
//  Created by 边大朋 on 15-4-7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewFeedCommentCell.h"
#import "MedGlobal.h"
#import "MedFeedCommentDTO.h"
#import "ImageCenter.h"
#import "UserManager.h"
#import "UserDTO.h"
#import "FontUtil.h"
#import "AccountHelper.h"
#import "OperationHelper.h"
#import "NSString+CH.h"
#import "MedFeedCommentTextView.h"
#import "UIColor+Colors.h"

#define CHLineSpace 2

@interface NewFeedCommentCell () <MedFeedCommentTextViewDelegate>
{
 
}

@property (strong, nonatomic) MedFeedCommentTextView *commentTextView;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation NewFeedCommentCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor whiteColor];
    footerLine.hidden = YES;
    
    [self.contentView addSubview:self.commentTextView];
    [self.contentView addSubview:self.arrowImageView];
    
    [self.commentTextView makeConstraints:^(MASConstraintMaker *make) {
    }];
    
    [self.arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@75);
        make.size.equalTo(CGSizeMake(10, 5));
    }];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(longPressAction:)];
    [self.commentTextView addGestureRecognizer:press];
}

- (void)setInfo:(MedFeedCommentDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    idto = dto;
    
    self.commentTextView.replyPersonName = dto.creatorName;
    self.commentTextView.replyToPersonName = dto.replyUserName;
    self.commentTextView.commentText = dto.content;
    [self.commentTextView setupTextView];
    
    if (dto.showSharpCorner) {
        self.arrowImageView.hidden = NO;
        
        [self.commentTextView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.arrowImageView.bottom).offset(-0.5);
            make.left.equalTo(@65);
            make.right.equalTo(@-15);
            make.bottom.equalTo(@0);
        }];
    } else {
        self.arrowImageView.hidden = YES;
        
        [self.commentTextView remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 65, -0.5, 15));
        }];
    }
}

+ (CGFloat)getCellHeight:(MedFeedCommentDTO *)dto width:(CGFloat)width
{
    CGFloat space = (dto.showSharpCorner ? 5 : 0);
    
    MedFeedCommentTextView *textView = [[MedFeedCommentTextView alloc] initWithFrame:CGRectMake(0, 0, GetScreenWidth - 80, MAXFLOAT)];
    
    textView.replyPersonName = dto.creatorName;
    textView.replyToPersonName = dto.replyUserName;
    textView.commentText = dto.content;

    [textView setupTextView];
    
    return [textView height] + space;
}

#pragma mark -
#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([self.parent respondsToSelector:@selector(clickCell:index:action:)]) {
            [self.parent clickCell:idto index:index action:@(FeedCommentCellActionTypeDelete)];
        }
    }
}
#pragma mark -
#pragma mark - CommentTextViewDelegate -

- (void)commentTextView:(MedFeedCommentTextView *)textView selectedText:(NSString *)selectedText selectedType:(MedFeedCommentTextViewSelectedType)type
{
    switch (type) {
        case MedFeedCommentTextViewReplyPersonSelectedType:
            [self.parent clickCell:idto index:index action:@(FeedCommentCellActionTypeReply)];
            break;
        case MedFeedCommentTextViewReplyToPersonSelectedType: {
            [self.parent clickCell:idto index:index action:@(FeedCommentCellActionTypeReplyTo)];
            break;
        }
        case MedFeedCommentTextViewURLSelectedType:
            [self.parent clickCell:selectedText action:@(ClickAction_OpenURL)];
            break;
        case MedFeedCommentTextViewOthersSelectedType:
            [self.parent clickCell:idto index:index action:@(FeedCommentCellActionTypeTap)];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - response event -

- (void)longPressAction:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        
        if ([self becomeFirstResponder]) {
            UIMenuController *menuController = [UIMenuController sharedMenuController];
           
            UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(clickCopy)];
            UIMenuItem *copyMenuItem1 = nil;
            
            if ([[[AccountHelper getAccount] userID] isEqualToString: [NSString stringWithFormat:@"%@", ((MedFeedCommentDTO *)idto).creatorID]]) {
                copyMenuItem1 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(clickDelete)];
            } else {
                copyMenuItem1 = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(clickReport)];
            }
            
            [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, copyMenuItem1,nil]];

            [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, copyMenuItem1,nil]];
            [menuController setArrowDirection:UIMenuControllerArrowDown];
            [menuController setTargetRect:CGRectMake(CGRectGetWidth(self.commentTextView.frame) / 2.0, 0, 0, 0)
                                   inView:self.commentTextView];
            [menuController setMenuVisible:YES animated:YES];
        }
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(clickCopy) ||
        action == @selector(clickDelete) ||
        action == @selector(clickReport)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)clickCopy
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:((MedFeedCommentDTO *)idto).content];
}

- (void)clickReport
{
    if ([self.parent respondsToSelector:@selector(clickCell:index:action:)]) {
        [self.parent clickCell:idto index:index action:@(FeedCommentCellActionTypeReport)];
    }
}

- (void)clickDelete
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"是否确认删除"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认", nil];
    [alert show];    
}

#pragma mark -
#pragma mark - setter and getter -

- (MedFeedCommentTextView *)commentTextView
{
    if (!_commentTextView) {
        MedFeedCommentTextView *textView = [[MedFeedCommentTextView alloc] initWithFrame:CGRectZero];
        textView.backgroundColor = [UIColor colorFromHexString:@"#E4E4E8"];
        textView.commentTextViewDelegate = self;
        _commentTextView = textView;
    }
    return _commentTextView;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"feed_img_guide.png");
            imageView;
        });
    }
    return _arrowImageView;
}

@end
