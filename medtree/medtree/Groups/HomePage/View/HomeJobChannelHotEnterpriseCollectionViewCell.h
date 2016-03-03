//
//  HomeJobChannelHotEnterpriseCollectionViewCell.h
//  medtree
//
//  Created by tangshimi on 11/2/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeJobChannelHotEmploymentDetailDTO;

@interface HomeJobChannelHotEnterpriseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) HomeJobChannelHotEmploymentDetailDTO *detailDTO;
@property (nonatomic, assign) BOOL hideReflection;

@end
