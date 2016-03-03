//
//  UserHeadView.h
//  medtree
//
//  Created by tangshimi on 9/1/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeadViewButton : UIButton

@property (nonatomic, copy) NSString *headImageURL;
@property (nonatomic, assign) NSInteger certificate_user_type;
@property (nonatomic, assign) NSInteger levelType;

@end
