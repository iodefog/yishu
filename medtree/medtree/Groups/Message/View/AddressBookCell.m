//
//  AddressBookCell.m
//  medtree
//
//  Created by sam on 10/7/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "AddressBookCell.h"
#import "NavigationBar.h"
#import "OperationHelper.h"
#import "UserDTO.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "ImageCenter.h"

@implementation AddressBookCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)clickInvite
{
    if (((UserDTO *)idto).isFriend) {
        [self.parent clickCell:idto index:index];
    } else {
        if (((UserDTO *)idto).userID.length > 1 && ((UserDTO *)idto).user_type != 9) {
            [self.parent clickCell:idto action:[NSNumber numberWithInteger:ClickAction_FirendAdd]];
        } else {
            if (((UserDTO *)idto).sameNameNum > 0) {
                [self.parent clickCell:idto index:index];
            } else {
                [self.parent clickCell:idto action:[NSNumber numberWithInteger:ClickAction_InviteFirend]];
            }
        }
    }
}

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor whiteColor];
    
    lineLab = [[UILabel alloc] init];
    lineLab.hidden = YES;
    lineLab.backgroundColor = [ColorUtil getColor:@"d5d5d5" alpha:1];
    [self addSubview:lineLab];
    
    inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_Invitation_click.png"] forState:UIControlStateHighlighted];
    [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_Invitation.png"] forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(clickInvite) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:inviteButton];
    
    sameNumLab = [[UILabel alloc] initWithFrame:CGRectZero];
    sameNumLab.backgroundColor = [UIColor clearColor];
    sameNumLab.textAlignment = NSTextAlignmentRight;
    sameNumLab.textColor = [ColorUtil getColor:@"767676" alpha:1];
    sameNumLab.font = [MedGlobal getLittleFont];
    [self addSubview:sameNumLab];
    
//    descLabel.hidden = YES;
}

- (void)setInfo:(UserDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    [super setInfo:dto indexPath:indexPath];
    inviteButton.userInteractionEnabled = YES;
    sameNumLab.hidden = YES;
    descLabel.hidden = YES;
    contentLabel.text = @"";
    NSLog(@"%@",dto.name);
    if (dto.userID.length > 1) {
        if (dto.isFriend) {
//            inviteButton.userInteractionEnabled = NO;
            [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_ic_tree.png"] forState:UIControlStateNormal];
            [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_ic_tree_click.png"] forState:UIControlStateHighlighted];
            inviteButton.hidden = NO;
            descLabel.hidden = YES;
        } else {
            if (dto.user_type == 9) {
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_Invitation_click.png"] forState:UIControlStateHighlighted];
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_Invitation.png"] forState:UIControlStateNormal];
            } else {
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_addition_click.png"] forState:UIControlStateHighlighted];
                [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_addition.png"] forState:UIControlStateNormal];
            }
            inviteButton.hidden = NO;
        }
        
        if (dto.organization_name.length > 0) {
            contentLabel.text = dto.organization_name;
        } else {
            for (int i = 0; i < dto.phones.count; i ++) {
                if (i == 0) {
                    contentLabel.text = [dto.phones objectAtIndex:i];
                } else {
                    contentLabel.text = [NSString stringWithFormat:@"%@  %@",contentLabel.text,[dto.phones objectAtIndex:i]];
                }
            }
        }
    } else {
        inviteButton.hidden = NO;
        
        if (dto.sameNameNum > 0) {
            [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_queren_click.png"] forState:UIControlStateHighlighted];
            [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_queren.png"] forState:UIControlStateNormal];
            sameNumLab.hidden = YES;
            sameNumLab.text = @"TA是医学好友？";
//            sameNumLab.text = [NSString stringWithFormat:@"%d个同名医学专业人士",dto.sameNameNum];
        } else {
            [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_Invitation_click.png"] forState:UIControlStateHighlighted];
            [inviteButton setBackgroundImage:[ImageCenter getBundleImage:@"tree_btn_Invitation.png"] forState:UIControlStateNormal];
            sameNumLab.hidden = YES;
            sameNumLab.text = @"";
        }
        
        for (int i = 0; i < dto.phones.count; i ++) {
            if (i == 0) {
                contentLabel.text = [dto.phones objectAtIndex:i];
            } else {
                contentLabel.text = [NSString stringWithFormat:@"%@  %@",contentLabel.text,[dto.phones objectAtIndex:i]];
            }
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    bgView.frame = CGRectMake(0, 0, size.width-80, size.height);
    sameNumLab.frame = CGRectMake(size.width-20-100-80, 10, 120, 20);
    lineLab.frame = CGRectMake(size.width-80, 10, 1, size.height-20);
    inviteButton.frame = CGRectMake(size.width-80, 5, 60, 60);
    contentLabel.frame = CGRectMake(70, 40, size.width-70-80, 20);
}

@end
