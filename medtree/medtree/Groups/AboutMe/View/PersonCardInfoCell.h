//
//  PersonCardInfoCell.h
//  medtree
//
//  Created by 陈升军 on 15/8/3.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseCell.h"

@class UserDTO;
//@class PersonCardInfoAcademicTagsView;

@interface PersonCardInfoCell : BaseCell
{
    UIView              *footColorView;
    
    UIView              *userView;
    UIImageView         *userPhotoView;
    UIImageView         *vImageView;
    UILabel             *nameLab;
    UILabel             *titleLab;
    UIImageView         *sexImageView;
    UILabel             *relationLab;
    
    UILabel             *userInfoLab;
    UIImageView         *nextView;
   // PersonCardInfoAcademicTagsView     *academicTagsView;
}

@end
