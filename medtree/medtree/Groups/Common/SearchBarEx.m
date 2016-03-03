//
//  SearchBarEx.m
//  medtree
//
//  Created by 无忧 on 14-9-23.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "SearchBarEx.h"
#import "ImageCenter.h"
#import "ColorUtil.h"
#import "MedGlobal.h"

@implementation SearchBarEx

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
//
    imageView = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@".png"]];
    imageView.backgroundColor = [UIColor clearColor];//[ColorUtil getColor:@"f9fcfc" alpha:1];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.font = [MedGlobal getLittleFont];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:cancelButton];
    
    searchView = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 400, 44)];
    searchView.autocorrectionType        = UITextAutocorrectionTypeNo;
    searchView.placeholder               = @"请输入你所要搜索的信息";
//    searchView.backgroundImage = [ImageCenter getBundleImage:@"naviBar_background.png"];
    searchView.autocapitalizationType    = UITextAutocapitalizationTypeNone;
    searchView.delegate                  = self;
    searchView.backgroundColor           = [UIColor clearColor];//[ColorUtil getColor:@"049597" alpha:1];
    searchView.alpha                     = 1;
    searchView.userInteractionEnabled    = YES;
    searchView.autoresizesSubviews       = NO;
    searchView.showsCancelButton         = NO;
    [self addSubview:searchView];
    
    for (UIView *view in searchView.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    isCanAdd = NO;
    isAdd = NO;
//    [NavigationBar createImageButton:@"btn_add_contact.png" selectedImage:@"" target:self action:@selector(clickAdd)]
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    
    imageView.frame = CGRectMake(size.width-44, 0, 44, size.height);
    cancelButton.frame = CGRectMake(0, 0, 44, 44);
    searchView.frame = CGRectMake(0, 0, size.width-44, size.height);
}

- (void)setIsAdd
{
    isAdd = YES;
    isCanAdd = YES;
    cancelButton.userInteractionEnabled = NO;
    [cancelButton setTitle:@"" forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[ImageCenter getBundleImage:@".png"] forState:UIControlStateHighlighted];
    [cancelButton setBackgroundImage:[ImageCenter getBundleImage:@".png"] forState:UIControlStateNormal];
}

- (void)setButtonTitleBlackColor
{
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)setSearchPlaceholder:(NSString *)text
{
    searchView.placeholder = text;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (isCanAdd) {
        isAdd = NO;
        cancelButton.userInteractionEnabled = YES;
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[ImageCenter getBundleImage:@""] forState:UIControlStateHighlighted];
        [cancelButton setBackgroundImage:[ImageCenter getBundleImage:@""] forState:UIControlStateNormal];
    }
    [self.parent searchBecomeFirstResponder];
    return YES;
}

- (void)clickCancel
{
    if (isAdd) {
        [self.parent searchViewClickAdd];
    } else {
        if (isCanAdd) {
            isAdd = YES;
            cancelButton.userInteractionEnabled = NO;
            [cancelButton setTitle:@"" forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:[ImageCenter getBundleImage:@".png"] forState:UIControlStateHighlighted];
            [cancelButton setBackgroundImage:[ImageCenter getBundleImage:@".png"] forState:UIControlStateNormal];
        }
        searchView.text = @"";
        [searchView resignFirstResponder];
        [self.parent searchBarCancelButtonClicked];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarCancelButtonClicked");
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClicked");
    [self.parent searchBarSearchButtonClicked:searchView.text];
    [searchView resignFirstResponder];
}

- (void)searchViewResignFirstResponder
{
    if (isCanAdd) {
        isAdd = YES;
        cancelButton.userInteractionEnabled = NO;
        [cancelButton setTitle:@"" forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[ImageCenter getBundleImage:@".png"] forState:UIControlStateHighlighted];
        [cancelButton setBackgroundImage:[ImageCenter getBundleImage:@".png"] forState:UIControlStateNormal];
    }
    searchView.text = @"";
    [searchView resignFirstResponder];
}

- (void)searchViewBecomeFirstResponder
{
    
    [searchView becomeFirstResponder];
}

@end
