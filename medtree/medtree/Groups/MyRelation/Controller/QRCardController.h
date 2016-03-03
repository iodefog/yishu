//
//  QRCardController.h
//  medtree
//
//  Created by 无忧 on 14-12-3.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"

@protocol ZXingQRCardDelegate <NSObject>

- (void)setQRCode:(NSString *)code;
- (void)hiddenZXingQRCard;
- (void)showMyQRCard;
- (void)showInfoAlert:(NSString *)info;

@end

@interface QRCardController : MedTreeBaseController

@property (nonatomic, assign) id<ZXingQRCardDelegate> parent;

- (void)startQRCard;
- (void)setIsFromPersonQRCard;

@end
