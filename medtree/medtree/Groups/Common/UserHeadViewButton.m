//
//  UserHeadView.m
//  medtree
//
//  Created by tangshimi on 9/1/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "UserHeadViewButton.h"
#import "UIImageView+setImageWithURL.h"

@interface UserHeadViewButton ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *levelImageView;

@end

@implementation UserHeadViewButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headImageView];
        [self addSubview:self.levelImageView];
        
        [self.levelImageView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        
        [self.headImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];        
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (CGSize)intrinsicContentSize
{
   return CGSizeMake(40.0, 40.0);
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"img_head.png");
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = self.frame.size.width / 2;
            imageView;
        });
    }
    return _headImageView;
}

- (UIImageView *)levelImageView
{
    if (!_levelImageView) {
        _levelImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
    }
    return _levelImageView;
}

- (void)setHeadImageURL:(NSString *)headImageURL
{
    if (!headImageURL) {
        return;
    }
    
    _headImageURL = [headImageURL copy];
    
    [self.headImageView med_setImageWithUrl:[NSURL URLWithString:_headImageURL]
                           placeholderImage:GetImage(@"img_head.png")];
}

- (void)setLevelType:(NSInteger)levelType
{
    _levelType = levelType;
    
    NSString *levelImage = nil;
    if (_levelType == 1) {
        levelImage = @"image_v4.png";
    } else {
        if (self.certificate_user_type != 0) {
            if (self.certificate_user_type == 1) {
                levelImage = @"image_v4.png";
            } else if (self.certificate_user_type > 1 && self.certificate_user_type < 7) {
                levelImage = @"image_v1.png";
            } else if (self.certificate_user_type == 7) {
                levelImage = @"image_v2.png";
            } else if (self.certificate_user_type == 8) {
                levelImage = @"image_v3.png";
            } else {
                levelImage = @"image_v5.png";
            }
        } else {
            self.levelImageView.image = nil;
        }
    }
    self.levelImageView.image = GetImage(levelImage);
}

@end
