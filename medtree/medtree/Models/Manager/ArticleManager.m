//
//  ArticleManager.m
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "ArticleManager.h"
#import "IServices+Public.h"
#import "ArticleDTO.h"
#import "DB+Public.h"
#import "ArticleCommentDTO.h"

@implementation ArticleManager

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    //
    switch (method) {
        case MethodType_Article_GetArticle:{
            [IServices getArticle:param success:^(id JSON) {
                NSMutableArray *array = [NSMutableArray array];
                NSMutableArray *result = [JSON objectForKey:@"result"];
                for (int i = 0; i < result.count; i ++) {
                    ArticleDTO *dto = [[ArticleDTO alloc] init:[result objectAtIndex:i]];
                    dto.articleType = i;
                    [[DB shareInstance] selecArticleWithArticleID:^(NSArray *array) {
                        if (array.count == 0) {
                            [[DB shareInstance] insertArticle:dto];
                        } else {
                            [[DB shareInstance] updateArticle:dto];
                        }
                    } articleID:dto.articleID];
                    [array addObject:dto];
                }
                success(array);
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Article_GetArticleRecommend:{
            [IServices getArticleRecommend:param success:^(id JSON) {
                
            } failure:^(NSError *error, id JSON) {
                
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Article_GetArticleDB:{
            [[DB shareInstance] selectArticleDTOResult:^(NSArray *array) {
                success(array);
            }];
            break;
        }
        case MethodType_Article_GetArticleByID:{
            [IServices getArticleByID:param success:^(id JSON) {
                
                NSDictionary *dict = [JSON objectForKey:@"result"];
                ArticleDTO *dto = [[ArticleDTO alloc] init:dict];
                success(dto);
            } failure:^(NSError *error, id JSON) {
                
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Article_GetCommentMore:
        case MethodType_Article_GetComment:{
            [IServices getCommentByID:param success:^(id JSON) {
                
                NSArray *array = [JSON objectForKey:@"result"];
                NSArray *profiles = [[JSON objectForKey:@"meta"] objectForKey:@"profiles"];
                NSMutableArray *comments = [NSMutableArray array];
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *dict = [array objectAtIndex:i];
                    ArticleCommentDTO *dto = [[ArticleCommentDTO alloc] init:dict];
                    [comments addObject:dto];
                    if(profiles.count > 0) {
                        for (int j = 0; j < profiles.count; j++) {
                            if ([[[profiles objectAtIndex:j] objectForKey:@"id"] integerValue] == dto.user_id) {
                                dto.userName = [[profiles objectAtIndex:j] objectForKey:@"nickname"];
                                NSString *avatar = [[profiles objectAtIndex:j] objectForKey:@"avatar"];
                                if (avatar != nil) {
                                    dto.user_avatar = avatar;
                                }
                            }
                        }
                    }
                }
                NSInteger total = [[JSON objectForKey:@"total"] integerValue];
                NSDictionary *data = @{@"data": comments, @"total": [NSNumber numberWithInteger:total],@"method":[NSNumber numberWithInteger:MethodType_Article_GetComment]};
                success(data);
            } failure:^(NSError *error, id JSON) {
                failure(error, JSON);
            }];
            break;
        }
        default:
            break;
    }
}

+ (void)setData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    switch (method) {
        case MethodType_Article_SetComment:{
            [IServices sendComment:param success:^(id JSON) {
                NSLog(@"%@", JSON);
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                failure(error, JSON);
            }];
            
            break;
        };
        case MethodType_Article_DelComment:{
            [IServices deleteComment:param success:^(id JSON) {
                NSLog(@"%@", JSON);
                success(JSON);
            } failure:failure];
            break;
        };
        case MethodType_Article_ReportComment: {
            [IServices report:param success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                failure(error, JSON);
            }];
            break;
        }
        case MethodType_Article_SetLike:{
            [IServices sendLike:param success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                failure(error, JSON);
            }];
            break;
        }
        case MethodType_Article_SetUnLike:{
            [IServices sendUnLike:param success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                failure(error, JSON);
            }];
            break;
            
        }

    }
    
}

+ (BOOL)isHit:(NSInteger)method
{
    if (method > MethodType_Article_Start && method < MethodType_Article_End) {
        return YES;
    } else {
        return NO;
    }
}

@end
