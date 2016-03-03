//
//  MedShareView.h
//  medtree
//
//  Created by tangshimi on 12/18/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MedShareView;

typedef NS_ENUM(NSInteger, MedShareType) {
    MedShareTypeWeChat,
    MedShareTypeWeChatFriendster,
    MedShareTypeQQ,
    MedShareTypeEmail
};

@protocol MedShareViewDelegate <NSObject>

- (void)shareView:(MedShareView *)shareView didSelectedWithType:(MedShareType)shareType;

@end

@interface MedShareView : UIView

@property (nonatomic, weak) id <MedShareViewDelegate> delegate;

+ (MedShareView *)showInView:(UIView *)inView delegate:(id <MedShareViewDelegate>)delegate;

@end


@interface ShareCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSDictionary *infoDic;

@end
