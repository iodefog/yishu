//
//  CHPhotoBrowser.h
//  medtree
//
//  Created by 孙晨辉 on 15/10/30.
//  Copyright © 2015年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHPhotoBrowserDelegate;
@interface CHPhotoBrowser : UIViewController <UIScrollViewDelegate>

@property (nonatomic, assign) id<CHPhotoBrowserDelegate> delegate;

@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, assign) NSUInteger currentPhotoIndex;

- (void)show;

@end

@protocol CHPhotoBrowserDelegate <NSObject>

@optional
- (void)photoBroser:(CHPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;

@end