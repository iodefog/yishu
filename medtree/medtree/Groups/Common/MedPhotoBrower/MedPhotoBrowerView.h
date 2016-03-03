//
//  TSMPhotoBrowerView.h
//  TSMPhotoBrowerView
//
//  Created by tangshimi on 10/3/15.
//  Copyright © 2015 tangshimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedPhotoBrowerView : UIViewController

/**
 *  大图URL
 */
@property (nonatomic, copy) NSArray *imageURLArray;

/**
 *  小图URL
 */
@property (nonatomic, copy) NSArray *originalImageURLArray;

/**
 *  小图相对于MedPhotoBrowerView的frame, frame以NSValue方式
 */
@property (nonatomic, copy) NSArray<NSValue *> *imageFrameArray;
@property (nonatomic, assign) NSInteger currentIndex;

- (void)show;

@end
