//
//  NewPersonTagView.h
//  medtree
//
//  Created by 边大朋 on 15-4-4.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseView.h"

@protocol NewPersonTagViewDelegate <NSObject>

- (void)likeTag:(NSMutableDictionary *)dict;
- (void)deleteTag:(NSMutableDictionary *)dict;
- (void)reportTag:(NSMutableDictionary *)dict;

@end

@interface NewPersonTagView : BaseView


@property (nonatomic, weak) id parent;
@property (nonatomic, strong) NSString *tagId;
- (void)setInfo:(NSMutableDictionary *)dict userId:(NSString *)userID;
- (UIImageView *)getImgView;
- (UILabel *)getLikeCountLab;
- (UILabel *)getTagLab;
@end
