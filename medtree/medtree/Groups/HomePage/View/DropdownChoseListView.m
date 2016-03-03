//
//  DropdownChoseListView.m
//  medtree
//
//  Created by tangshimi on 8/20/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DropdownChoseListView.h"
#import "DropdownChoseListViewTableViewCell.h"

NSString * const kDropdownChoseListViewTableViewCellReuseID = @"DropdownChoseListViewTableViewCell";
CGFloat const kDropdownChoseListViewDragViewHeight = 20.0;

@interface DropdownChoseListView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, weak) UIView *inView;

@end

@implementation DropdownChoseListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.clipsToBounds = YES;
        [self addSubview:self.tableView];
        [self addSubview:self.dragView];

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(panGestureRecognizerAction:)];
        panGesture.delaysTouchesBegan = YES;
        [self.dragView addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideWithAnimated:YES];
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(numberOfItemsForDropdownChoseListView:)]) {
        return [self.delegate numberOfItemsForDropdownChoseListView:self];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(dropdownChoseListView:heightForRowAtIndex:)]) {
        return [self.delegate dropdownChoseListView:self heightForRowAtIndex:indexPath];
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropdownChoseListViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDropdownChoseListViewTableViewCellReuseID];
    
    NSString *title = nil;
    BOOL selected = NO;
    if ([self.delegate respondsToSelector:@selector(dropdownChoseListView:titleForRowAtIndex:)]) {
        title = [self.delegate dropdownChoseListView:self titleForRowAtIndex:indexPath];
    }
    
    if ([indexPath isEqual:self.selectedIndexPath]) {
        selected = YES;
    }
    
    [cell setInfoDic:@{ @"title" : title, @"selected" : @(selected) }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(dropdownChoseListView:didSelectedAtIndex:)]) {
        [self.delegate dropdownChoseListView:self didSelectedAtIndex:indexPath];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideWithAnimated:YES];
    });
}

#pragma mark -
#pragma mark - response event -

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self];
   
    [recognizer setTranslation:CGPointZero inView:self];
    
    CGPoint recognizerViewcenter = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + translation.y);
    
    if (recognizerViewcenter.y > self.tableViewHeight + kDropdownChoseListViewDragViewHeight / 2.0 ||
        recognizerViewcenter.y < kDropdownChoseListViewDragViewHeight / 2.0) {
        return;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        recognizer.view.center = recognizerViewcenter;
        
        CGRect frame = self.tableView.frame;
        frame.size.height = CGRectGetMinY(self.dragView.frame);
        
        self.tableView.frame = frame;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (recognizerViewcenter.y < self.tableViewHeight / 2.0) {
            [self hideWithAnimated:YES];
        } else {
            [UIView animateWithDuration:0.35 animations:^{
                CGRect tablViewFrame = self.tableView.frame;
                tablViewFrame.size.height = self.tableViewHeight;
                self.tableView.frame = tablViewFrame;
                
                CGRect dragViewFrame = self.dragView.frame;
                dragViewFrame.origin.y = CGRectGetMaxY(self.tableView.frame);
                
                self.dragView.frame = dragViewFrame;
            }];
        }
    }
}

#pragma mark -
#pragma mark - show and hide -

- (void)showInView:(UIView *)inView frame:(CGRect)frame animated:(BOOL)animated
{
    if (![self.delegate respondsToSelector:@selector(contentViewSizeOfDropdownChoseListView:)]) {
        return;
    }

    self.inView = inView;
    
    [self.tableView reloadData];
    
    CGSize size = [self.delegate contentViewSizeOfDropdownChoseListView:self];
    self.frame = frame;
    [inView addSubview:self];
    
    if (!animated) {
        self.tableView.frame = CGRectMake(0, 0, size.width, size.height);
        return;
    }
    
    self.tableViewHeight = size.height;
    
    self.tableView.frame = CGRectMake(0, - (size.height + kDropdownChoseListViewDragViewHeight), size.width, size.height);
    self.dragView.frame = CGRectMake(0, - kDropdownChoseListViewDragViewHeight, CGRectGetWidth(self.frame), kDropdownChoseListViewDragViewHeight);
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.9
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.tableView.frame = CGRectMake(0, 0, size.width, size.height);
                         self.dragView.frame = CGRectMake(0,
                                                          CGRectGetMaxY(self.tableView.frame),
                                                          CGRectGetWidth(self.frame),
                                                          kDropdownChoseListViewDragViewHeight);
                   } completion:nil];
}

- (void)hideWithAnimated:(BOOL)animated;
{
    CGRect tableViewFrame = self.tableView.frame;

    if (!animated) {
        tableViewFrame.origin.y = - (self.tableViewHeight + kDropdownChoseListViewDragViewHeight);
        self.tableView.frame = tableViewFrame;
        self.dragView.frame = CGRectMake(0, - kDropdownChoseListViewDragViewHeight, CGRectGetWidth(self.frame), kDropdownChoseListViewDragViewHeight);
        [self removeFromSuperview];

        return;
    }
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(tableViewFrame), 0);
        self.dragView.frame = CGRectMake(0, - kDropdownChoseListViewDragViewHeight, CGRectGetWidth(self.frame), kDropdownChoseListViewDragViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark - setter and getter -

- (UIView *)dragView
{
    if (!_dragView) {
        _dragView =  ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _dragView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            [tableView registerClass:[DropdownChoseListViewTableViewCell class]
              forCellReuseIdentifier:kDropdownChoseListViewTableViewCellReuseID];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView;
        });
    }
    return _tableView;
}

@end
