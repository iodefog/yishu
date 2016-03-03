//
//  MyRelationHeaderView.m
//  medtree
//
//  Created by tangshimi on 6/12/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MyRelationHeaderView.h"
#import "UIColor+Colors.h"
#import "MedGlobal.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "UserManager.h"
#import "UIButton+setImageWithURL.h"
#import "ImageCenter.h"

#define kMyRelationHeaderViewButtonBaseTag 1000

NSString * const kColleagueType  = @"20";
NSString * const kFriendType = @"1";
NSString * const kSchoolmateType = @"12";
NSString * const kPeerType = @"22";
NSString * const kFriendOfFriend = @"90";

NSInteger const kMaxNumber = 10000;

@interface MyRelationHeaderView ()

@property (nonatomic, strong)UIButton *headButton;
@property (nonatomic, strong)UIImageView *vImageView;
@property (nonatomic, strong)MyRelationHeaderViewButton *colleagueButton;
@property (nonatomic, strong)MyRelationHeaderViewButton *friendOfFriendButton;
@property (nonatomic, strong)MyRelationHeaderViewButton *friendButton;
@property (nonatomic, strong)MyRelationHeaderViewButton *schoolmateButton;
@property (nonatomic, strong)MyRelationHeaderViewButton *peerButton;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation MyRelationHeaderView

- (void)createUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    
    [self addSubview:self.colleagueButton];
    [self addSubview:self.friendOfFriendButton];
    [self addSubview:self.friendButton];
    [self addSubview:self.schoolmateButton];
    [self addSubview:self.peerButton];
    [self addSubview:self.headButton];
    [self addSubview:self.vImageView];
    [self addSubview:self.bottomLineView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImage:) name:UserInfoChangeNotification object:nil];
    
    [self loadHeadImage];
    
    self.headButton.frame = CGRectMake(0, 0, 112, 112);
    self.headButton.center = self.center;
    self.vImageView.frame = CGRectMake(CGRectGetMaxX(self.headButton.frame) - 22, CGRectGetMaxY(self.headButton.frame) - 22, 12, 12);
    
    self.colleagueButton.frame = CGRectMake(0, 0, 70, 70);
    self.colleagueButton.center = self.center;
    
    self.friendOfFriendButton.frame = CGRectMake(0, 0, 60, 60);
    self.friendOfFriendButton.center = self.center;
    
    self.friendButton.frame = CGRectMake(0, 0, 84, 84);
    self.friendButton.center = self.center;
    
    self.schoolmateButton.frame = CGRectMake(0, 0, 54, 54);
    self.schoolmateButton.center = self.center;
    
    self.peerButton.frame = CGRectMake(0, 0, 65, 65);
    self.peerButton.center = self.center;
    
    self.bottomLineView.frame = CGRectMake(0, GetViewHeight(self) - 0.5, GetViewWidth(self), 0.5);
    self.bottomLineView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark - event response -

- (void)buttonAction:(UIButton *)button
{
    MyRelationHeaderViewSelectedType type = (MyRelationHeaderViewSelectedType) (button.tag - kMyRelationHeaderViewButtonBaseTag);
    MyRelationHeaderViewButton *relationButton = nil;
    if (type != MyRelationHeaderViewHeadSelectedType) {
        relationButton = (MyRelationHeaderViewButton *)button;
    }
    
    if ([self.delegate respondsToSelector:@selector(myRelationHeaderViewSelectedType:isCertificated:)]) {
        [self.delegate myRelationHeaderViewSelectedType:type isCertificated:![relationButton.numberLabel.text isEqualToString:@"?"]];
    }
}

- (void)updateHeadImage:(NSNotification *)noti
{
    [self loadHeadImage];
}

#pragma mark -
#pragma mark -helper -

- (MyRelationHeaderViewButton *)circleButton:(UIColor *)backgroundColor
{
    MyRelationHeaderViewButton *button = [[MyRelationHeaderViewButton alloc] initWithFrame:CGRectZero];
    [button setBackgroundColor:backgroundColor];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)showHeaderButtonWithAnimated:(BOOL)animated;
{
    if (!animated) {
        self.friendButton.center = [self centerWithMyRelationHeaderViewSelectedType:MyRelationHeaderViewFriendSelectedType];
        self.friendOfFriendButton.center = [self centerWithMyRelationHeaderViewSelectedType:MyRelationHeaderViewFriendOfFriendSelectedType];
        self.colleagueButton.center = [self centerWithMyRelationHeaderViewSelectedType:MyRelationHeaderViewColleagueSelectedType];
        self.schoolmateButton.center = [self centerWithMyRelationHeaderViewSelectedType:MyRelationHeaderViewSchoolmateSelectedType];
        self.peerButton.center = [self centerWithMyRelationHeaderViewSelectedType:MyRelationHeaderViewPeerSelectedType];
    } else {
        [UIView animateKeyframesWithDuration:1.0 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations:^{
                self.friendButton.center = [self centerWithMyRelationHeaderViewSelectedType:MyRelationHeaderViewFriendSelectedType];
                self.friendOfFriendButton.center = [self centerWithMyRelationHeaderViewSelectedType:MyRelationHeaderViewFriendOfFriendSelectedType];
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:1 / 3.0 animations:^{
                self.colleagueButton.center = [self centerWithMyRelationHeaderViewSelectedType:MyRelationHeaderViewColleagueSelectedType];
                self.schoolmateButton.center = [self centerWithMyRelationHeaderViewSelectedType:MyRelationHeaderViewSchoolmateSelectedType];
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.7 / 3.0 animations:^{
                self.peerButton.center = [self centerWithMyRelationHeaderViewSelectedType:MyRelationHeaderViewPeerSelectedType];
            }];
            
        } completion:nil];
    }
}

- (CGPoint)centerWithMyRelationHeaderViewSelectedType:(MyRelationHeaderViewSelectedType)type
{
    CGFloat offset = 0;
    if ([MedGlobal isPhone6Plus]) {
        offset = 20;
    }
    
    CGPoint point;
    CGPoint headButtonCenter = self.headButton.center;
    switch (type) {
        case MyRelationHeaderViewColleagueSelectedType:
            point = CGPointMake(headButtonCenter.x - 100 - offset, headButtonCenter.y - 65 - offset);
            break;
        case MyRelationHeaderViewFriendSelectedType:
            point = CGPointMake(headButtonCenter.x - 100 - offset, headButtonCenter.y + 50 + offset);
            break;
        case MyRelationHeaderViewSchoolmateSelectedType:
            point = CGPointMake(headButtonCenter.x + 70 + offset, headButtonCenter.y + 80 + offset);
            break;
        case MyRelationHeaderViewPeerSelectedType:
            point = CGPointMake(headButtonCenter.x + 110 + offset, headButtonCenter.y);
            break;
        case MyRelationHeaderViewFriendOfFriendSelectedType:
            point = CGPointMake(headButtonCenter.x + 60 + offset, headButtonCenter.y - 75 - offset);
        default:
            break;
    }
    
    return point;
}

- (void)loadHeadImage
{
    UserDTO *dto = [AccountHelper getAccount];
    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Big], [dto photoID]];
    [self.headButton med_setImageWithURL:[NSURL URLWithString:path]
                                forState:UIControlStateNormal
                        placeholderImage:[UIImage imageNamed:@"img_head.png"]];
    
    self.vImageView.hidden = YES;
    if (dto.user_type == 1) {
        self.vImageView.hidden = NO;
        self.vImageView.image = [ImageCenter getBundleImage:@"image_v4.png"];
    } else {
        if (dto.certificate_user_type == 0) {
            self.vImageView.hidden = YES;
        } else {
            if (dto.certificate_user_type == 1) {
                self.vImageView.image = [ImageCenter getBundleImage:@"image_v4.png"];
            } else if (dto.certificate_user_type > 1 && dto.certificate_user_type < 7) {
                self.vImageView.image = [ImageCenter getBundleImage:@"image_v1.png"];
            } else if (dto.certificate_user_type == 7) {
                self.vImageView.image = [ImageCenter getBundleImage:@"image_v2.png"];
            } else if (dto.certificate_user_type == 8) {
                self.vImageView.image = [ImageCenter getBundleImage:@"image_v3.png"];
            } else {
                self.vImageView.image = [ImageCenter getBundleImage:@"image_v5.png"];
            }
            self.vImageView.hidden = NO;
        }
    }
}

- (NSInteger)peopleNumberWithMyRelationHeaderViewSelectedType:(MyRelationHeaderViewSelectedType)type
{
    NSInteger number = 0;
    switch (type) {
        case MyRelationHeaderViewColleagueSelectedType:
            number = [self.colleagueButton.numberLabel.text integerValue];
            break;
        case MyRelationHeaderViewFriendSelectedType:
            number = [self.friendButton.numberLabel.text integerValue];
            break;
        case MyRelationHeaderViewSchoolmateSelectedType:
            number = [self.schoolmateButton.numberLabel.text integerValue];
            break;
        case MyRelationHeaderViewPeerSelectedType:
            number = [self.peerButton.numberLabel.text integerValue];
            break;
        case MyRelationHeaderViewFriendOfFriendSelectedType:
            number = [self.friendOfFriendButton.numberLabel.text integerValue];
            break;
        default:
            break;
    }
    return number;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIButton *)headButton
{
    if (!_headButton) {
        UIButton *headButton = [[UIButton alloc] init];
        [headButton setImage:[UIImage imageNamed:@"img_head.png"] forState:UIControlStateNormal];
        headButton.layer.cornerRadius = 56.0;
        headButton.layer.masksToBounds = YES;
        headButton.tag = kMyRelationHeaderViewButtonBaseTag + MyRelationHeaderViewHeadSelectedType;
        [headButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _headButton = headButton;
    }
    return _headButton;
}

- (UIImageView *)vImageView
{
    if (!_vImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.hidden = YES;
        _vImageView = imageView;
    }
    return _vImageView;
}

- (MyRelationHeaderViewButton *)colleagueButton
{
    if (!_colleagueButton) {
        _colleagueButton = [self circleButton:[UIColor colorFromHexString:@"#48ae75"]];
        _colleagueButton.tag = MyRelationHeaderViewColleagueSelectedType + kMyRelationHeaderViewButtonBaseTag;
        _colleagueButton.numberLabel.text = @"?";
        _colleagueButton.nameLabel.text = @"同事";
    }
    return _colleagueButton;
}

- (MyRelationHeaderViewButton *)friendOfFriendButton
{
    if (!_friendOfFriendButton) {
        _friendOfFriendButton = [self circleButton:[UIColor colorFromHexString:@"#c99954"]];
        _friendOfFriendButton.tag = MyRelationHeaderViewFriendOfFriendSelectedType + kMyRelationHeaderViewButtonBaseTag;
        _friendOfFriendButton.numberLabel.text = @"?";
        _friendOfFriendButton.nameLabel.text = @"好友的好友";
    }
    return _friendOfFriendButton;
}

- (MyRelationHeaderViewButton *)friendButton
{
    if (!_friendButton) {
        _friendButton = [self circleButton:[UIColor colorFromHexString:@"#795e9a"]];
        _friendButton.tag = MyRelationHeaderViewFriendSelectedType + kMyRelationHeaderViewButtonBaseTag;
        _friendButton.numberLabel.text = @"?";
        _friendButton.nameLabel.text = @"好友";
    }
    return _friendButton;
}

- (MyRelationHeaderViewButton *)peerButton
{
    if (!_peerButton) {
        _peerButton = [self circleButton:[UIColor colorFromHexString:@"#2fbcd0"]];
        _peerButton.tag = MyRelationHeaderViewPeerSelectedType + kMyRelationHeaderViewButtonBaseTag;
        _peerButton.numberLabel.text = @"?";
        _peerButton.nameLabel.text = @"同行";
    }
    return _peerButton;
}

- (MyRelationHeaderViewButton *)schoolmateButton
{
    if (!_schoolmateButton) {
        _schoolmateButton = [self circleButton:[UIColor colorFromHexString:@"#4082d7"]];
        _schoolmateButton.tag = MyRelationHeaderViewSchoolmateSelectedType + kMyRelationHeaderViewButtonBaseTag;
        _schoolmateButton.numberLabel.text = @"?";
        _schoolmateButton.nameLabel.text = @"校友";
    }
    return _schoolmateButton;
}

- (void)setRelationStatusDic:(NSDictionary *)relationStatusDic
{
    _relationStatusDic = nil;
    _relationStatusDic = relationStatusDic;
 
    NSInteger colleagueNum = [[relationStatusDic objectForKey:kColleagueType] integerValue];
    NSInteger friendNum =  [[relationStatusDic objectForKey:kFriendType] integerValue];
    NSInteger schoolmateNum = [[relationStatusDic objectForKey:kSchoolmateType] integerValue];
    NSInteger peerNum = [[relationStatusDic objectForKey:kPeerType] integerValue];
    NSInteger friendOfFriendNum = [[relationStatusDic objectForKey:kFriendOfFriend] integerValue];
    
    if ( colleagueNum > -1) {
        self.colleagueButton.numberLabel.text = [NSString stringWithFormat:@"%@%@", @(colleagueNum < kMaxNumber ? colleagueNum : kMaxNumber), colleagueNum < kMaxNumber ? @"" : @"+"];
        _workExperienceCertificated = YES;
    } else {
        self.colleagueButton.numberLabel.text = @"?";
        _workExperienceCertificated = NO;
    }
    
    if (friendNum > -1) {
        self.friendButton.numberLabel.text = [NSString stringWithFormat:@"%@%@", @(friendNum < kMaxNumber ? friendNum : kMaxNumber), friendNum < kMaxNumber ? @"" : @"+"];
    } else {
        self.friendButton.numberLabel.text = @"?";
    }
    
    if (schoolmateNum > -1) {
        self.schoolmateButton.numberLabel.text = [NSString stringWithFormat:@"%@%@", @(schoolmateNum < kMaxNumber ? schoolmateNum : kMaxNumber), schoolmateNum < kMaxNumber ? @"" : @"+" ];
    } else {
        self.schoolmateButton.numberLabel.text = @"?";
    }
    
    if (peerNum > -1) {
        self.peerButton.numberLabel.text = [NSString stringWithFormat:@"%@%@", @(peerNum < kMaxNumber ? peerNum : kMaxNumber), peerNum < kMaxNumber ? @"" : @"+"];
    } else {
        self.peerButton.numberLabel.text = @"?";
    }
    
    if (friendOfFriendNum > -1) {
        self.friendOfFriendButton.numberLabel.text = [NSString stringWithFormat:@"%@%@",  @(friendOfFriendNum < kMaxNumber ? friendOfFriendNum : kMaxNumber), friendOfFriendNum < kMaxNumber ? @"" : @"+"];
    } else {
        self.friendOfFriendButton.numberLabel.text = @"?";
    }
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView =  ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
            view;
        });
    }
    return _bottomLineView;
}

- (NSArray *)buttonArray
{
    return @[ self.colleagueButton, self.friendButton, self.schoolmateButton, self.peerButton, self.friendOfFriendButton ];
}

@end


@interface MyRelationHeaderViewButton ()

@end

@implementation MyRelationHeaderViewButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.numberLabel];
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2.0;
    self.layer.masksToBounds = YES;

    self.numberLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 30);
    self.numberLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0 - 5);
    self.nameLabel.frame = CGRectMake(0, CGRectGetMaxY(self.numberLabel.frame) - 5, CGRectGetWidth(self.frame), 20);
}

#pragma mark
#pragma mark - setter and getter -

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:21];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        _numberLabel = label;
    }
    return _numberLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        _nameLabel = label;
    }
    return _nameLabel;
}

@end