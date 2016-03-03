//
//  NewPersonTagView.m
//  medtree
//
//  Created by 边大朋 on 15-4-4.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewPersonTagView.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "FontUtil.h"
#import "AccountHelper.h"
#import "UserDTO.h"

#define LikeImgW 32

@interface NewPersonTagView ()
{
    UILabel         *tagLab;
    UILabel         *splitLab;
    UILabel         *likeCountLab;
    NSString        *userid;
    NSMutableDictionary *tagInfoDict;
    UIImageView     *likeImgView;
}
@end

@implementation NewPersonTagView

#pragma mark - UI
- (void)createUI
{
    self.backgroundColor = [ColorUtil getColor:@"3F5AB8" alpha:1];
    
    likeImgView = [[UIImageView alloc] init];
    likeImgView.userInteractionEnabled = YES;
    [self addSubview:likeImgView];
    
    tagLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tagLab.backgroundColor = [UIColor clearColor];
    tagLab.textColor = [ColorUtil getColor:@"ffffff" alpha:1];
    tagLab.textAlignment = NSTextAlignmentCenter;
    tagLab.font = [MedGlobal getLittleFont];
    [self addSubview: tagLab];
    
    likeCountLab = [[UILabel alloc] initWithFrame:CGRectZero];
    likeCountLab.textColor = [ColorUtil getColor:@"ffffff" alpha:1];
    likeCountLab.textAlignment = NSTextAlignmentCenter;
    likeCountLab.font = [MedGlobal getLittleFont];
    [self addSubview: likeCountLab];
    
    [self addTap];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    CGFloat tagWidth = [FontUtil getTextWidth:[tagInfoDict objectForKey:@"tag"] font:tagLab.font];
    NSInteger integer = [[tagInfoDict objectForKey:@"count"] integerValue];
    CGFloat likeCountWidth = [FontUtil getTextWidth:[NSString stringWithFormat:@"%ld", (long)integer] font:likeCountLab.font];
    
    likeImgView.frame = CGRectMake(0, (size.height - LikeImgW)/2, LikeImgW, LikeImgW);
    tagLab.frame = CGRectMake(CGRectGetMaxX(likeImgView.frame), 5, tagWidth, 20);
    likeCountLab.frame = CGRectMake(CGRectGetMaxX(tagLab.frame) + 5, 5, likeCountWidth, 20);
}

- (void)addTap
{
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressContent:)];
    [self addGestureRecognizer:press];
}

#pragma mark - touch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.parent likeTag:tagInfoDict];
}

#pragma mark - set data
- (void)setInfo:(NSMutableDictionary *)dict userId:(NSString *)userID
{
    userid = userID;
    tagInfoDict = dict;
    tagLab.text = [dict objectForKey:@"tag"];
    likeCountLab.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"count"]];
    [self layoutSubviews];
}

#pragma mark - 手势
- (void)longPressContent:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ) {
        
        [self becomeFirstResponder];
        
        if ([self becomeFirstResponder]) {
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            UIMenuItem *copyMenuItem = nil;
            if ([[[AccountHelper getAccount] userID] isEqualToString:userid]) {
                copyMenuItem  = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(clickDelete)];
            } else {
                copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(clickReport)];
            }
            
            [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, nil]];
            [menuController setArrowDirection:UIMenuControllerArrowDown];
            [menuController setTargetRect:CGRectMake(self.frame.size.width/2, 10, 0, 0) inView:self];
            [menuController setMenuVisible:YES animated:YES];
        }
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(clickDelete) || action == @selector(clickReport)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark get
- (UIImageView *)getImgView
{
    return likeImgView;
}

- (UILabel *)getLikeCountLab
{
    return likeCountLab;
}

- (UILabel *)getTagLab
{
    return tagLab;
}

#pragma prama mark - action
- (void)clickDelete
{
    [self.parent deleteTag:tagInfoDict];
}

- (void)clickReport
{
    [self.parent reportTag:tagInfoDict];
}

@end
