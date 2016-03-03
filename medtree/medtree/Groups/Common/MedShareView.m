//
//  MedShareView.m
//  medtree
//
//  Created by tangshimi on 12/18/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MedShareView.h"

static NSString *const reuseID = @"collectionViewCellID";

@interface MedShareView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, copy) NSArray *imageArray;
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MedShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.shareLabel];
        [self.containerView addSubview:self.collectionView];
        
        [self.containerView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(175);
            make.top.equalTo(self.bottom);
        }];
        
        [self.shareLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(15);
            make.left.equalTo(15);
        }];
        
        [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.shareLabel.bottom).offset(25);
            make.right.equalTo(0);
            make.left.equalTo(0);
            make.height.equalTo(80);
        }];
        
        [self.collectionView reloadData];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideWithFinished:nil];
}

#pragma mark -
#pragma mark - UICollectionViewDataSource / UICollectionViewDataSource -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    cell.infoDic = @{ @"image" : self.imageArray[indexPath.row], @"title" : self.titleArray[indexPath.row] };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.delegate respondsToSelector:@selector(shareView:didSelectedWithType:)]) {
        return;
    }
    
    [self hideWithFinished:^{
        switch (indexPath.row) {
            case 0:
                [self.delegate shareView:self didSelectedWithType:MedShareTypeWeChat];
                break;
            case 1:
                [self.delegate shareView:self didSelectedWithType:MedShareTypeWeChatFriendster];
                break;
            case 2:
                [self.delegate shareView:self didSelectedWithType:MedShareTypeQQ];
                break;
            case 3:
                [self.delegate shareView:self didSelectedWithType:MedShareTypeEmail];
                break;
            default:
                break;
        }
    }];
}

#pragma mark -
#pragma mark - helper -

- (void)show
{
    [self.containerView remakeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(0);
        make.height.equalTo(175);
        make.bottom.equalTo(self.bottom);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)hideWithFinished:(dispatch_block_t)finishedBlock
{
    [self.containerView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(175);
        make.top.equalTo(self.bottom);
    }];

    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (finishedBlock) {
            finishedBlock();
        }
    }];
}

#pragma mark -
#pragma mark - public -

+ (MedShareView *)showInView:(UIView *)inView delegate:(id<MedShareViewDelegate>)delegate
{
    MedShareView *shareView = [[MedShareView alloc] init];
    shareView.delegate = delegate;
    [inView addSubview:shareView];
    
    [shareView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [shareView show];
    });
    
    return shareView;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            view.userInteractionEnabled = YES;
            
            view;
        });
    }
    return _containerView;
}

- (UILabel *)shareLabel
{
    if (!_shareLabel) {
        _shareLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor grayColor];
            label.text = @"分享到";
            label;
        });
    }
    return _shareLabel;
}

- (NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = @[ @"wechat.png", @"wechat_friends.png", @"QQ.png", @"email.png" ];
    }
    return _imageArray;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[ @"微信", @"微信朋友圈", @"QQ", @"邮件" ];
    }
    return _titleArray;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = ({
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            
            CGFloat space = (GetScreenWidth - 50 * 4) / 5.0;
            
            flowLayout.itemSize = CGSizeMake(50, 80);
            flowLayout.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
            flowLayout.minimumInteritemSpacing = space;
            flowLayout.minimumLineSpacing = space;
            
            UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            view.backgroundColor = [UIColor whiteColor];
            view.delegate = self;
            view.dataSource = self;
            [view registerClass:[ShareCollectionViewCell class] forCellWithReuseIdentifier:reuseID];
        
            view;
        });
    }
    return _collectionView;
}

@end

// CollectionViewCell

@interface ShareCollectionViewCell ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ShareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.titleLabel];
        
        [self.logoImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 20, 0));
        }];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.logoImageView.bottom).offset(5);
            make.bottom.equalTo(0);
            make.centerX.equalTo(0);
        }];
    }
    return self;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView;
        });
    }
    return _logoImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor blackColor];
            label;
        });
    }
    return _titleLabel;
}

- (void)setInfoDic:(NSDictionary *)infoDic
{
    _infoDic = [infoDic copy];
    
    self.logoImageView.image = GetImage(infoDic[@"image"]);
    self.titleLabel.text = infoDic[@"title"];
}

@end

