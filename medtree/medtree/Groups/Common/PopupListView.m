//
//  PopUpListView.m
//  medtree
//
//  Created by tangshimi on 5/12/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "PopupListView.h"
#import "PopupListViewBaseTableViewCell.h"

NSTimeInterval const kPopupListViewAnimationTime = 0.2;
static NSString *const kPopuoLisViewTableViewCellReuseID = @"PopuoLisViewTableViewCellReuseID";

@interface PopupListView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, assign) PopupListViewArrowType type;


@end

@implementation PopupListView

- (instancetype)initWithFrame:(CGRect)frame arrowType:(PopupListViewArrowType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.arrowImageView];
        [self addSubview:self.backImageView];
        [self.backImageView addSubview:self.tableView];
        
    }
    return self;
}

- (instancetype)initWithArrowType:(PopupListViewArrowType)type;
{
    return [self initWithFrame:CGRectZero arrowType:type];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame arrowType:PopupListViewArrowTypeMiddle];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self hide];
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDateSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(numberOfItemsOfPopupListView:)]) {
        return [self.delegate numberOfItemsOfPopupListView:self];
    }
        
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(popupListView:didSelectedAtIndex:)]) {
        [self.delegate popupListView:self didSelectedAtIndex:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self hide];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(popupListView:cellHeightAtIndex:)]) {
        return [self.delegate popupListView:self cellHeightAtIndex:indexPath.row];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PopupListViewBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPopuoLisViewTableViewCellReuseID];
    
    if (!cell) {
        if ([self.delegate respondsToSelector:@selector(cellClassOfPopuoListView:)]) {
            cell = [[[self.delegate cellClassOfPopuoListView:self] alloc] initWithStyle:UITableViewCellStyleDefault
                                                                        reuseIdentifier:kPopuoLisViewTableViewCellReuseID];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(popuplistView:infoDictionaryAtIndex:)]) {
        [cell setInfoDic:[self.delegate popuplistView:self infoDictionaryAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark -
#pragma mark - helper -

- (void)showAtPoint:(CGPoint)point inView:(UIView *)inView;
{
    self.alpha = 0.0;
    self.frame = inView.bounds;
    
    CGSize contentSize;
    
    if ([self.delegate respondsToSelector:@selector(contentSizeOfPopupListView:)]) {
        contentSize = [self.delegate contentSizeOfPopupListView:self];
    }
    
    self.backImageView.frame = CGRectZero;
    self.backImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);

    CGPoint centerPoint = CGPointMake(point.x, point.y + contentSize.height / 2 + 5);
    
    self.backImageView.frame =  CGRectMake(0, 0, contentSize.width, contentSize.height);
    self.backImageView.center = centerPoint;
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.backImageView.frame), CGRectGetHeight(self.backImageView.frame));
    
    CGRect rect = self.backImageView.frame;
    
    switch (self.type) {
        case PopupListViewArrowTypeLeft:
            self.arrowImageView.frame = CGRectMake(CGRectGetMinX(self.backImageView.frame) + 10, CGRectGetMinY(self.backImageView.frame) - 8, 15, 8);
            self.backImageView.layer.anchorPoint = CGPointMake(0.0, 0.0);

            break;
        case PopupListViewArrowTypeMiddle:
            self.arrowImageView.frame = CGRectMake(CGRectGetMidX(self.backImageView.frame) - 7.5, CGRectGetMinY(self.backImageView.frame) - 8, 15, 8);
            self.backImageView.layer.anchorPoint = CGPointMake(0.5, 0.0);

            break;
        case PopupListViewArrowTypeRight:
            self.arrowImageView.frame = CGRectMake(CGRectGetMaxX(self.backImageView.frame) - 25, CGRectGetMinY(self.backImageView.frame) - 8, 15, 8);
            self.backImageView.layer.anchorPoint = CGPointMake(1.0, 0.0);

            break;
    }
    
    self.backImageView.frame = rect;
    self.backImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);

    [inView addSubview:self];
    
    [UIView animateWithDuration:kPopupListViewAnimationTime animations:^{
        self.alpha = 1.0;
        self.backImageView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:kPopupListViewAnimationTime animations:^{
        self.alpha = 0.0;
        self.backImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.backImageView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark -
#pragma mark - setters and getters -

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.bounces = NO;
            tableView;
        });
    }
    
    return _tableView;
}

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = ({
            UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            backImageView.userInteractionEnabled = YES;
            backImageView.image = [[UIImage imageNamed:@"popupview_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)
                                                                                                        resizingMode:UIImageResizingModeStretch];
            backImageView;
        });
    }
    return _backImageView;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"popupview_arrow.png");
            imageView;
        });
    }
    return _arrowImageView;
}

@end
