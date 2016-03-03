//
//  HomePosterView.h
//  medtree
//
//  Created by tangshimi on 8/31/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomePosterClickBlock)(NSString *, NSString *);

@interface HomePosterView : UIView

@property (nonatomic, copy) NSArray *posterArray;
@property (nonatomic, copy) HomePosterClickBlock clickBlock;
@property (nonatomic, copy) dispatch_block_t closeBlock;

@end


@interface HomePosterViewCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imageULR;

@end