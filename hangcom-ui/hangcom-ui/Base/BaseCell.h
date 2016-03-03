//
//  BaseCell.h
//  zhihu
//
//  Created by sam on 7/30/14.
//  Copyright (c) 2014 lyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewDelegate.h"

@class DTOBase;

@interface BaseCell : UITableViewCell {
    UIImageView *bgView;
    //
    UIImageView *headerLine;
    UIImageView *footerLine;
    BOOL        isFirstCell;
    BOOL        isLastCell;
    BOOL        isEndCell;
    //
    BOOL        isDisable;
    BOOL        isMove;
    NSIndexPath *index;
    DTOBase     *idto;
}

@property (nonatomic, weak) id<BaseTableViewDelegate> parent;
@property (nonatomic, assign) BOOL firstCell;
@property (nonatomic, assign) BOOL lastCell;

- (void)createUI;
- (void)resize:(CGSize)size;
- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath;
+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width;
+ (void)setCellWidth:(CGFloat)width;
- (void)showBgView:(BOOL)tf;
- (void)checkLine;

@end
