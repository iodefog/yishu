//
//  HomeJobChannelHotEmploymentDetailDTO.h
//  medtree
//
//  Created by tangshimi on 11/2/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "DTOBase.h"

@interface HomeJobChannelHotEmploymentDetailDTO : DTOBase

@property (nonatomic, copy) NSString *enterpriseID;
@property (nonatomic, copy) NSString *enterpriseImage;
@property (nonatomic, copy) NSString *enterpriseName;
@property (nonatomic, copy) NSString *detailDescription;
@property (nonatomic, copy) NSString *enterpriseURL;
@property (nonatomic, copy) NSString *enterprisePlace;
@property (nonatomic, copy) NSString *enterpriseNature;
@property (nonatomic, copy) NSString *enterpriseSize;
@property (nonatomic, assign) NSInteger enterpriseEmploymentCount;
@property (nonatomic, assign) BOOL isFromWeb;
@property (nonatomic, copy) NSString *shareInfo;

@end
