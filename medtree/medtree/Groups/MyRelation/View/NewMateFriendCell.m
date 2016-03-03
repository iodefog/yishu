//
//  NewMateFriendCell.m
//  medtree
//
//  Created by 陈升军 on 15/4/12.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewMateFriendCell.h"
#import "UserDTO.h"
#import "RelationTypes.h"
#import "NavigationBar.h"
#import "DB+Public.h"
#import "OperationHelper.h"
#import "ImageCenter.h"
#import "ColorUtil.h"
#import "MedGlobal.h"

@interface NewMateFriendCell ()<UIGestureRecognizerDelegate>
{
    UIPanGestureRecognizer *pan;
}

@end

@implementation NewMateFriendCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    [super createUI];
    
    inviteButton = [NavigationBar createImageButton:@"btn_friend_invite.png" selectedImage:@"" topTitle:@"" fontSize:14 size:CGSizeMake(48, 32) target:self action:@selector(clickAdd)];
    [self addSubview:inviteButton];
    
    sameNumLab = [[UILabel alloc] initWithFrame:CGRectZero];
    sameNumLab.backgroundColor = [UIColor clearColor];
    sameNumLab.textAlignment = NSTextAlignmentRight;
    sameNumLab.textColor = [ColorUtil getColor:@"767676" alpha:1];
    sameNumLab.font = [MedGlobal getLittleFont];
//    [self addSubview:sameNumLab];
    [self createPan];
}

- (void)createPan
{
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCell)];
     pan.delegate = self;
    [self addGestureRecognizer:pan];
}

- (void)deleteCell
{
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;

}


- (void)setInfo:(UserDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    [super setInfo:dto indexPath:indexPath];
    idto = dto;
    NSLog(@"%@",dto.name);
    if (dto.userID.length > 1) {
        contentLabel.text = dto.organization_name;
        if (dto.user_type != 9) {
            if (dto.isFriend) {
                inviteButton.hidden = NO;
                descLabel.hidden = YES;
                descLabel.text = @"好友";
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_friend_click.png"] forState:UIControlStateHighlighted];
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_friend.png"] forState:UIControlStateNormal];
            } else {
                inviteButton.hidden = NO;
                descLabel.hidden = YES;
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_addition_click.png"] forState:UIControlStateHighlighted];
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_addition.png"] forState:UIControlStateNormal];
            }
        } else {
            descLabel.hidden = YES;
            [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_Invitation_click.png"] forState:UIControlStateHighlighted];
            [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_Invitation.png"] forState:UIControlStateNormal];
        }
    } else {
        if (dto.sameNameNum > 0) {
            descLabel.hidden = YES;
            inviteButton.hidden = NO;
            if (dto.sameStatus == 0) {
                for (int i = 0; i < dto.phones.count; i ++) {
                    if (i == 0) {
                        contentLabel.text = [dto.phones objectAtIndex:i];
                    } else {
                        contentLabel.text = [NSString stringWithFormat:@"%@  %@",contentLabel.text,[dto.phones objectAtIndex:i]];
                    }
                }
                //未标记
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_queren_click.png"] forState:UIControlStateHighlighted];
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_queren.png"] forState:UIControlStateNormal];
            } else if (dto.sameStatus == 1) {
                //已邀请
                contentLabel.text = dto.organization_name;
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_Invitation_click.png"] forState:UIControlStateHighlighted];
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_Invitation.png"] forState:UIControlStateNormal];
            } else if (dto.sameStatus == 2) {
                //已激活
                contentLabel.text = dto.organization_name;
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_addition_click.png"] forState:UIControlStateHighlighted];
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_addition.png"] forState:UIControlStateNormal];
            } else if (dto.sameStatus == 3) {
                //已标记
                contentLabel.text = dto.organization_name;
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_Invitation_click.png"] forState:UIControlStateHighlighted];
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_Invitation.png"] forState:UIControlStateNormal];
            }
        } else {
            descLabel.hidden = YES;
            inviteButton.hidden = NO;
            [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_Invitation_click.png"] forState:UIControlStateHighlighted];
            [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_Invitation.png"] forState:UIControlStateNormal];
            for (int i = 0; i < dto.phones.count; i ++) {
                if (i == 0) {
                    contentLabel.text = [dto.phones objectAtIndex:i];
                } else {
                    contentLabel.text = [NSString stringWithFormat:@"%@  %@",contentLabel.text,[dto.phones objectAtIndex:i]];
                }
            }
        }
    }
    [self layoutSubviews];
}

- (void)clickAdd
{
    if (((UserDTO *)idto).userID.length > 1) {
        if (((UserDTO *)idto).isFriend) {
            
        } else {
            if (((UserDTO *)idto).user_type == 9) {
                [self.parent clickCell:idto action:[NSNumber numberWithInteger:ClickAction_InviteFirend]];
            } else {
                [self.parent clickCell:idto action:[NSNumber numberWithInteger:ClickAction_FirendAdd]];
            }
        }
    } else {
        if (((UserDTO *)idto).sameNameNum > 0) {
            [self.parent clickCell:idto action:[NSNumber numberWithInteger:ClickAction_MateUser]];
        } else {
            [self.parent clickCell:idto action:[NSNumber numberWithInteger:ClickAction_InviteFirend]];
        }
    }
}

- (void)clickHeader
{
    if (((UserDTO *)idto).userID.length > 1) {
        [self.parent clickCell:idto index:index];
    } else {
        if (((UserDTO *)idto).sameNameNum > 0) {
            [self.parent clickCell:idto action:[NSNumber numberWithInteger:ClickAction_MateUser]];
        } else {
            [self.parent clickCell:idto action:[NSNumber numberWithInteger:ClickAction_InviteFirend]];
        }
    }
}

- (void)resize:(CGSize)size
{
    [super resize:size];
    footerLine.frame = CGRectMake(isLastCell ? 0 : 70, size.height - 1, size.width, 1);
    depAndTitleLab.hidden = YES;
    if (((UserDTO *)idto).userID.length == 1 && ((UserDTO *)idto).sameNameNum == 0) {
        headerView.hidden = YES;
    } else {
        headerView.hidden = NO;
    }
    if (contentLabel.text.length > 0) {
        nameLabel.frame = CGRectMake(headerView.hidden == YES?10:70, 15, size.width/2-30, 20);
        contentLabel.frame = CGRectMake(headerView.hidden == YES?10:70, 45, size.width-70-60, 20);
    } else {
        nameLabel.frame = CGRectMake(headerView.hidden == YES?10:70, (size.height-20)/2, size.width/2-30, 20);
    }
    inviteButton.frame = CGRectMake(size.width-80, 5, 60, 60);
    CGFloat offsetx = self.isShowIndexs ? 20 : 0;
    descLabel.frame = CGRectMake(size.width/2+40, (size.height-20)/2, size.width/2-50-offsetx, 20);
}


@end
