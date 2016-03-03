//
//  DB+Article.h
//  medtree
//
//  Created by 陈升军 on 14/12/30.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DB.h"

@class ArticleDTO;

@interface DB (Article)

- (void)createTable_Article;
- (void)insertArticle:(ArticleDTO *)dto;
- (void)selectArticleDTOResult:(ArrayBlock)result;
- (void)selecArticleWithArticleID:(ArrayBlock)result articleID:(NSString *)articleID;
- (void)updateArticle:(ArticleDTO *)dto;

@end
