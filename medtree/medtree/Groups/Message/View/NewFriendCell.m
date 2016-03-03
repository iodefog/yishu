//
//  NewFriendCell.m
//  medtree
//
//  Created by sam on 9/26/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "NewFriendCell.h"
#import "NotificationDTO.h"
#import "UserDTO.h"
#import "ImageCenter.h"
#import "UserManager.h"
#import "ImageButton.h"
#import "NavigationBar.h"
#import "DB+Public.h"
#import "OperationHelper.h"
#import "FontUtil.h"

@implementation NewFriendCell

- (void)createUI
{
    [super createUI];
    self.isShowIndexs = NO;
    
    self.backgroundColor = [UIColor whiteColor];
    
    acceptButton = [NavigationBar createImageButton:@"new_btn_Accept.png" selectedImage:@"new_btn_Accept_click.png" topTitle:@"" fontSize:14 size:CGSizeMake(60, 60) target:self action:@selector(clickAccept)];
    [self.contentView addSubview:acceptButton];
    
    inviteButton = [NavigationBar createImageButton:@"tree_btn_addition.png" selectedImage:@"tree_btn_addition_click.png" topTitle:@"" fontSize:14 size:CGSizeMake(60, 60) target:self action:@selector(clickInvite)];
    [self.contentView addSubview:inviteButton];
}

- (void)resize:(CGSize)size
{
    [super resize:size];
    acceptButton.frame = CGRectMake(size.width-60, (size.height-60)/2, 60, 60);
    inviteButton.frame = CGRectMake(size.width-60, (size.height-60)/2, 60, 60);
    CGFloat name = [FontUtil getTextWidth:nameLabel.text font:nameLabel.font];
    depAndTitleLab.frame = CGRectMake(70+name+10, 10, size.width-(70+name+10)-80-10, 20);
//    descLabel.frame = CGRectMake(size.width/2+70, (size.height-20)/2, size.width/2-80, 20);
    contentLabel.frame = CGRectMake(70, 40, size.width-80-80, 20);
}

- (void)setInfo:(NotificationDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    idto = dto;
    //
    
    if (dto.target != nil) {
        [self loadUserInfo];
    } else {
        NSDictionary *param = @{@"userid": dto.userID};
        [UserManager getUserInfoFull:param success:^(id JSON) {
            [self loadUserDTO:JSON];
        } failure:^(NSError *error, id JSON) {
            
        }];
    }
    contentLabel.text = dto.message;
    if (dto.status == NewRelationStatus_Friend_Request) {
        descLabel.hidden = YES;
        acceptButton.hidden = dto.processed;
        inviteButton.hidden = YES;
    } else if (dto.status == NewRelationStatus_Friend_Request_Inivte) {
        descLabel.hidden = YES;
        acceptButton.hidden = YES;
        inviteButton.hidden = dto.processed;
    } else {
        acceptButton.hidden = YES;
        inviteButton.hidden = YES;
        descLabel.hidden = NO;
        if (dto.status == NewRelationStatus_Friend_Request_Accept) {
            descLabel.text = @"已添加";
        } else if (dto.status == NewRelationStatus_Friend_Request_Deny) {
            descLabel.text = @"已拒绝";
        } else if (dto.status == NewRelationStatus_Friend_Request_Sent) {
            descLabel.text = @"待验证";
        }
    }
}

- (void)loadUserDTO:(id)JSON
{
    UserDTO *udto = (UserDTO *)JSON;
    ((NotificationDTO *)idto).target = udto;
    [self loadUserInfo];
}

- (void)loadUserInfo
{
    UserDTO *udto = ((NotificationDTO *)idto).target;
    vImage.hidden = YES;
    if (udto.user_type == 1) {
        vImage.hidden = NO;
        vImage.image = [ImageCenter getBundleImage:@"image_v4.png"];
    } else {
        if (udto.certificate_user_type == 0) {
            vImage.hidden = YES;
        } else {
            if (udto.certificate_user_type == 1) {
                vImage.image = [ImageCenter getBundleImage:@"image_v4.png"];
            } else if (udto.certificate_user_type > 1 && udto.certificate_user_type < 7) {
                vImage.image = [ImageCenter getBundleImage:@"image_v1.png"];
            } else if (udto.certificate_user_type == 7) {
                vImage.image = [ImageCenter getBundleImage:@"image_v2.png"];
            } else if (udto.certificate_user_type == 8) {
                vImage.image = [ImageCenter getBundleImage:@"image_v3.png"];
            } else {
                vImage.image = [ImageCenter getBundleImage:@"image_v5.png"];
            }
            vImage.hidden = NO;
        }
    }
    nameLabel.text = udto.name;
    depAndTitleLab.text = udto.organization_name;
    depAndTitleLab.hidden = NO;
    
    if (contentLabel.text.length == 0) {
        contentLabel.text = [NSString stringWithFormat:@"我是%@",udto.name];
    }
    if (((NotificationDTO *)idto).status == NewRelationStatus_Friend_Request_Inivte) {
        if (((NotificationDTO *)idto).message.length == 0) {
            contentLabel.text = [NSString stringWithFormat:@"%@ %@",udto.department_name.length>0?udto.department_name:@"",udto.title.length>0?udto.title:@""];
        }
    } else {
        if (((NotificationDTO *)idto).status == NewRelationStatus_Friend_Request_Sent) {
            if (((NotificationDTO *)idto).message.length == 0) {
                contentLabel.text = [NSString stringWithFormat:@"%@ %@",udto.department_name.length>0?udto.department_name:@"",udto.title.length>0?udto.title:@""];
            }
        }
    }
    
//    depAndTitleLab.text = [NSString stringWithFormat:@"%@ %@",udto.department_name.length>0?udto.department_name:@"",udto.title.length>0?udto.title:@""];
//    headerView.image = [ImageCenter getBundleImage:@"img_head.png"];
    [self setPhoto:((NotificationDTO *)idto).target.photoID imageView:headerView];
    [self layoutSubviews];
}

- (void)clickAccept
{
    [self.parent clickCell:idto action:[NSNumber numberWithInteger:ClickAction_FriendRequestAccept]];
}

- (void)clickInvite
{
    [self.parent clickCell:idto action:[NSNumber numberWithInteger:ClickAction_FriendRequestInvite]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    UIView *touched = [self hitTest:point withEvent:event];
    if (![touched isEqual:headerView]) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (isMove == YES) {
        [self showBgView:NO];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isMove == YES) {
        
    } else {
        [self.parent clickCell:idto index:index];
    }
    isMove = NO;
    [self showBgView:NO];
}

@end
