//
//  ArticleManager.h
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface ArticleManager : DataManager

typedef enum {
    MethodType_Article_Start                      = 900,
    MethodType_Article_GetArticle                 = 901,
    MethodType_Article_GetArticleRecommend        = 902,
    MethodType_Article_GetArticleDB               = 903,
    MethodType_Article_GetArticleByID             = 904,
    MethodType_Article_End                        = 999,
    MethodType_Article_GetComment                 = 1000,
    MethodType_Article_GetCommentMore             = 1001,
    MethodType_Article_DelComment                 = 1001,
    MethodType_Article_SetComment                 = 1002,
    MethodType_Article_SetLike                    = 1003,
    MethodType_Article_SetUnLike                  = 1004,
    MethodType_Article_ReportComment              = 1005,
} Method_Article;

@end
