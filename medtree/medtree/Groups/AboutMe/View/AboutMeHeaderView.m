//
//  AboutMeHeaderView.m
//  medtree
//
//  Created by tangshimi on 7/29/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "AboutMeHeaderView.h"
#import "UIColor+Colors.h"
#import "UserManager.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "UIButton+setImageWithURL.h"
#import "MedGlobal.h"

@interface AboutMeHeaderView ()

@property (nonatomic, strong) UIButton *headButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *departmentLabel;
@property (nonatomic, strong) UILabel *medtreeNumberLabel;
@property (nonatomic, strong) UIButton *QRCodeButton;

@end

@implementation AboutMeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.headButton];
        [self addSubview:self.nameLabel];
        [self addSubview:self.departmentLabel];
        [self addSubview:self.medtreeNumberLabel];
        [self addSubview:self.QRCodeButton];
        
        self.headButton.frame = CGRectMake(15, 63.5, 65, 65);
        self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headButton.frame) + 15, CGRectGetMinY(self.headButton.frame), 130, 25);
        self.departmentLabel.frame = CGRectMake(CGRectGetMaxX(self.headButton.frame) + 15, CGRectGetMaxY(self.nameLabel.frame), 165, 15);
        self.medtreeNumberLabel.frame = CGRectMake(CGRectGetMaxX(self.headButton.frame) + 15, CGRectGetMaxY(self.departmentLabel.frame), 165, 15);
        self.QRCodeButton.frame = CGRectMake(CGRectGetWidth(frame) - 40, CGRectGetMinY(self.headButton.frame), 25, 25);
        
        UIView *lineView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - 1, CGRectGetWidth(frame), 1)];
            view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
            view;
        });
        [self addSubview:lineView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userInfoChangeAction:)
                                                     name:UserInfoChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark - response event -

- (void)userInfoChangeAction:(NSNotification *)notification
{
    UserDTO *userDTO = [AccountHelper getAccount];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Big], [userDTO photoID]];
    [self.headButton med_setImageWithURL:[NSURL URLWithString:path]
                                forState:UIControlStateNormal
                        placeholderImage:[UIImage imageNamed:@"img_head.png"]];
    self.nameLabel.text = userDTO.name;
    self.departmentLabel.text = userDTO.department_name;
    if (userDTO.userID) {
        self.medtreeNumberLabel.text = [NSString stringWithFormat:@"医树号:%@", userDTO.userID];
    }
}

- (void)headButtonAction:(UIButton *)button
{
    if (!self.clickHeadBlock) {
        return;
    }
    self.clickHeadBlock();
}

- (void)QRCodeButtonAction:(UIButton *)button
{
    if (!self.clickQRCodeBlock) {
        return;
    }
    self.clickQRCodeBlock();
}

#pragma mark -
#pragma mark - helper -

- (UIButton *)identityButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal | UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:@"my_identity.png"] forState:UIControlStateNormal];
    return button;
}

#pragma mark -
#pragma mark - setter/getter -

- (UIButton *)headButton
{
    if (!_headButton) {
        _headButton = ({
            UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
            headButton.layer.cornerRadius = 32.5;
            headButton.layer.masksToBounds = YES;
            headButton.backgroundColor = [UIColor clearColor];
            [headButton addTarget:self action:@selector(headButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            headButton;
        });
    }
    return _headButton;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel = nameLabel;
    }
    return _nameLabel;
}

- (UILabel *)departmentLabel
{
    if (!_departmentLabel) {
        _departmentLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:13];
            label;
        });
    }
    return _departmentLabel;
}

- (UILabel *)medtreeNumberLabel
{
    if (!_medtreeNumberLabel) {
        _medtreeNumberLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:13];
            label;
        });
    }
    return _medtreeNumberLabel;
}

- (UIButton *)QRCodeButton
{
    if (!_QRCodeButton) {
        _QRCodeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"my_QRCode.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(QRCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _QRCodeButton;
}

@end
