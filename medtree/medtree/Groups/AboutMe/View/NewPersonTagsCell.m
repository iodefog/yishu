//
//  NewPersonTagsCell.m
//  medtree
//
//  Created by 边大朋 on 15-4-4.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewPersonTagsCell.h"
#import "UserDTO.h"
#import "ColorUtil.h"
#import "NewPersonTagView.h"
#import "ImageCenter.h"
#import "UserTagsDTO.h"
#import "FormAlert.h"
#import "OperationHelper.h"
#import "MedGlobal.h"
#import "ImageCenter.h"

@interface NewPersonTagsCell () <NewPersonTagViewDelegate>
{
    NSMutableArray          *tagsArray;
    NSMutableArray          *tagViewArray;
    NSInteger               currentIndex;
    
    /**当前行*/
    NSInteger               currentLine;
    
    int                     type;
    UserDTO                 *userDTO;
    NSMutableArray          *moreViewArray;
    
    /**是否有更多按钮*/
    BOOL                    isHaveMore;
    /**是否点击了更多按钮*/
    BOOL                    isClickMoreBtn;
    
    NSIndexSet              *set;
    
    NSInteger               originalCount;
    NSInteger               allCount;
    UserTagsDTO             *utDTO;
    UIView                  *sideView;
    UIImageView             *imgView;
    /**右侧更多箭头背景*/
    UIView                  *morebgView;
    /**个人详情页标签索引*/
    NSInteger               indexI;
    
}
@end

@implementation NewPersonTagsCell

- (void)createUI
{
    self.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
    [self createAddView];
    [self createMoreArrow];
    
    tagViewArray = [NSMutableArray array];
    tagsArray = [NSMutableArray array];
    moreViewArray = [NSMutableArray array];
    type = 0;
    isHaveMore = NO;
    isClickMoreBtn = NO;
    
    originalCount = 0;
    indexI = 0;
}

- (void)layoutSubviews
{
    [self calculateFrame];
}

/**计算所有标签frame*/
- (void)calculateFrame
{
    
    currentLine = 0;
    CGSize size = self.frame.size;
    CGFloat cellMaxW = size.width - 30;//cell中一排tag的最大宽度
    CGFloat tagH = 32;
    CGFloat tagSpace = 15;
    CGFloat moreSpace = 10;
    CGFloat addTagW = 94;
    CGFloat addTagH = 32;
    
    //详情页一行的标签宽度要小
    if (utDTO.pageType == 1) {
        cellMaxW -= moreSpace;
    }
    
    //当前行tag及间距的和
    CGFloat cellW = 0.0f;
    
    //是否是当前行第一个标签
    BOOL isFirst = YES;
    
    //for begin
    for (NSInteger i = 0; i < tagViewArray.count; i++) {
        
        //个人信息详情页最多3行标签
        if (currentLine == 3 && utDTO.pageType == 1) {
            addView.hidden = YES;
            addView.frame = CGRectZero;
            indexI = i;
            //将其余的标签隐藏掉
            for (NSInteger j = i; j < tagViewArray.count; j++) {
                ((NewPersonTagView *)[tagViewArray objectAtIndex:j]).hidden = YES;
            }
            break;
        }
        
        NewPersonTagView *currTagView = [tagViewArray objectAtIndex:i];
        CGFloat currTagViewX;
        if (isFirst) {
            currTagViewX = 15;
        } else {
            NewPersonTagView *prefTagView = [tagViewArray objectAtIndex:i - 1];
            currTagViewX = tagSpace + CGRectGetMaxX(prefTagView.frame);
        }
        CGFloat currTagViewW = [currTagView getTagLab].frame.size.width + [currTagView getLikeCountLab].frame.size.width + 32 + 10;
        CGFloat currTagViewH = tagH;
        
        CGFloat currTagViewY = currentLine * (tagH + 10) + 10;
        
        currTagView.frame = CGRectMake(currTagViewX, currTagViewY, currTagViewW, currTagViewH);
        
        cellW += (currTagViewW + 15);
        CGFloat nextTagViewW = 0;
        //如果不是最后一个标签则有下一个标签
        if (i < tagViewArray.count - 1) {
            NewPersonTagView *nextTagView = [tagViewArray objectAtIndex:i + 1];
            nextTagViewW = [nextTagView getTagLab].frame.size.width + [nextTagView getLikeCountLab].frame.size.width + 32 + 10;
        }
        cellW += (nextTagViewW + 15);
        if (cellW - 15 >= cellMaxW && i < tagViewArray.count - 1) {
            isFirst = YES;
            currentLine++;
            cellW = 0.0f;
        } else {
            isFirst = NO;
            //最后一个标签不用减
            if (i < tagViewArray.count - 1) {
                cellW -= (nextTagViewW + 15);
            }
        }
    }
    // for end
    
    if (tagViewArray.count == 0) {
        addView.frame = utDTO.pageType == 1 ? CGRectMake(15, (size.height-addTagH)/2, addTagW, addTagH) : CGRectMake(15, 10, addTagW, addTagH);
    } else {
        
        //标签详情页
        if (utDTO.pageType == 0) {
            //添加按钮前边的tagView
            NewPersonTagView *prevTagView = [tagViewArray objectAtIndex:tagViewArray.count-1];
            CGRect frame = prevTagView.frame;
            
            CGFloat addViewY = currentLine * (tagH + 10) + 10;
            //当前行添加按钮前有标签addView宽是94
            if (size.width - CGRectGetMaxX(frame) - 15 >= addTagW + 15) {
                addView.frame = CGRectMake(CGRectGetMaxX(frame) + 15, addViewY, addTagW, addTagH);
            } else {
                addView.frame = CGRectMake(15, addViewY + 30 + 10, addTagW, addTagH);
            }
        } else { //个人详情页
            if (currentLine == 3) {
                addView.hidden = YES;
                addView.frame = CGRectZero;
            } else {
                
                NewPersonTagView *prevTagView = [tagViewArray objectAtIndex:tagViewArray.count - 1];
                CGRect frame = prevTagView.frame;
                
                if (currentLine == 2) {
                    if (size.width - CGRectGetMaxX(frame)-15*2-10+15 < addTagW +15) {
                        addView.hidden = YES;
                        addView.frame = CGRectZero;
                    }
                }
                
                CGFloat addViewY = currentLine * (tagH + 10) + 10;
                
                if (size.width - CGRectGetMaxX(frame) - 15 * 2 - 10 + 15 >= addTagW + 15) {
                    addView.frame = CGRectMake(CGRectGetMaxX(frame) + 15, addViewY, addTagW, addTagH);
                } else {
                    addView.frame = CGRectMake(15, addViewY + 30 + 10, addTagW, addTagH);
                }
            }
        }
    }
    
    //个人详情页更多按钮
    if (utDTO.pageType == 1) {
        if (tagViewArray.count > 0) {
            CGFloat h = 0;
            if (indexI > 0 || currentLine == 3) {//有3行了且不能添加
                h = 3 * 40 - 10;
            } else {
                h =  (currentLine + 1) * 40 - 10;
            }
            morebgView.frame = CGRectMake(size.width - 15 - moreSpace, 10, 15 + moreSpace, h);
            sideView.frame = CGRectMake(0, currentIndex == 0 ? 0 : 5, 0.5, h);
            CGFloat arrowW = 5;
            CGFloat arrowH = 10;
            imgView.frame = CGRectMake(morebgView.frame.size.width / 2 - arrowW / 2, morebgView.frame.size.height / 2 - arrowH / 2, arrowW, arrowH);
        } else {
            CGFloat h = 30;
            morebgView.frame = CGRectMake(size.width - 15 - moreSpace, (size.height-h)/2, 15 + moreSpace, h);
            sideView.frame = CGRectMake(0, 0, 0.5, h);
            CGFloat arrowW = 5;
            CGFloat arrowH = 10;
            imgView.frame = CGRectMake(morebgView.frame.size.width / 2 - arrowW / 2, morebgView.frame.size.height / 2 - arrowH / 2, arrowW, arrowH);
        }
    }
}

/**创建标签*/
- (void)createOneTagWithDict:(NSMutableDictionary *)dict indexWithTag:(NSInteger)tagIndex
{
    
    NewPersonTagView *tagView = [[NewPersonTagView alloc] initWithFrame:CGRectZero];
    tagView.tag = 1000 + tagIndex;
    tagView.parent = self;
    
    [dict setObject:[NSNumber numberWithInteger:tagIndex] forKey:@"index"];
    
    [tagView setInfo:dict userId:userDTO.userID];
    
    if ([[dict objectForKey:@"is_liked"] boolValue] == YES) {
        [tagView getImgView].image = [ImageCenter getBundleImage:@"academic_tag_like_clicked.png"];
    }
    
    [tagViewArray addObject:tagView];
    [self addSubview:tagView];
    
}

/**创建添加按钮*/
- (void)createAddView
{
    addView = [[UIImageView alloc] initWithFrame:CGRectZero];
    addView.userInteractionEnabled = YES;
    addView.image = [ImageCenter getBundleImageFromName:@"btn_add_tag.png"];
    addView.tag = 101;
    [self addSubview:addView];
}

/**创建更多按钮*/
- (void)createMoreArrow
{
    
    morebgView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:morebgView];
    
    moreBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    sideView = [[UIView alloc] init];
    sideView.backgroundColor = [ColorUtil getColor:@"d6d6d6" alpha:1];
    [morebgView addSubview:sideView];
    imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imgView.userInteractionEnabled = YES;
    imgView.image = [ImageCenter getBundleImage:@"img_next.png"];
    [morebgView addSubview:imgView];
    
}

#pragma mark - click action
- (void)clickMore
{
    isClickMoreBtn = YES;
    [self.parent clickCell:nil action:[NSNumber numberWithInt:100]];
}

- (void)clickAdd
{
    [self.parent clickCell:nil action:[NSNumber numberWithInt:ClickAction_UserTagAdd]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(addView.frame, point)) {
        [self showBgView:NO];
        [self clickAdd];
    } if (CGRectContainsPoint(morebgView.frame, point)) {
        [self clickMore];
    }else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)setInfo:(UserTagsDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    tagsArray = dto.tags;
    userDTO = dto.userDTO;
    utDTO = dto;
    originalCount = tagsArray.count;
    [self initTagView];
    
}

//首次批量添加，只加一次
- (void)initTagView
{
    //初始化
    indexI = 0;
    addView.hidden = NO;
    //清空所有tag，为重新布局做准备
    if (tagViewArray.count > 0) {
        for (UIView *tag in tagViewArray) {
            [tag removeFromSuperview];
        }
        [tagViewArray removeAllObjects];
    }
    
    //创建标签
    if (originalCount > 0) {
        for (NSInteger i = 0; i < originalCount; i++) {
            [self createOneTagWithDict:[tagsArray objectAtIndex:i] indexWithTag:i];
        }
    }
    
    //对标签颜色及赞数进行设置
    for (int i = 0; i < tagViewArray.count; i++) {
        NSMutableDictionary *dict = [tagsArray objectAtIndex:i];
        
        if ([[dict objectForKey:@"is_liked"] boolValue] == YES) {
            [((NewPersonTagView *)[tagViewArray objectAtIndex:i]) getImgView].image = [ImageCenter getBundleImage:@"academic_tag_like_clicked.png"];
        } else {
            [((NewPersonTagView *)[tagViewArray objectAtIndex:i]) getImgView].image = [ImageCenter getBundleImage:@"academic_tag_like.png"];
        }
        [((NewPersonTagView *)[tagViewArray objectAtIndex:i]) getLikeCountLab].text =[NSString stringWithFormat:@"%@", [dict objectForKey:@"count"]];
    }
    
}


#pragma mark NewPersonTagViewDelegate
- (void)likeTag:(NSMutableDictionary *)dict
{
    [self.parent clickCell:dict index:index action:@4];
}

#pragma mark NewPersonTagViewDelegate
- (void)deleteTag:(NSMutableDictionary *)dict
{
    [self.parent clickCell:dict index:index action:@1];
}

#pragma mark NewPersonTagViewDelegate
- (void)reportTag:(NSMutableDictionary *)dict
{
    [self.parent clickCell:dict index:index action:@2];
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    CGFloat addTagW = 94;
    UserTagsDTO *utdto = ((UserTagsDTO *)dto);
    if (utdto.tags.count == 0) {
        return 40;
    }
    
    NSMutableArray *tagViewArray = [NSMutableArray array];
    for (NSInteger i = 0; i < utdto.tags.count; i++) {
        NSMutableDictionary *tagDict = [utdto.tags objectAtIndex:i];
        NewPersonTagView *tagView = [[NewPersonTagView alloc] initWithFrame:CGRectZero];
        [tagView setInfo:tagDict userId:utdto.userDTO.userID];
        [tagViewArray addObject:tagView];
    }
    
    CGFloat currentLine = 0;
    CGFloat cellMaxW = [[UIScreen mainScreen] bounds].size.width - 30;//cell中一排tag的最大宽度
    if (utdto.pageType == 1) {
        cellMaxW -= 10;
    }
    CGFloat cellW = 0.0f; //当前一排中总的tag及间距的和
    BOOL isFirst = YES;
    for (NSInteger i = 0; i < utdto.tags.count; i++) {
        if (currentLine == 3 && utdto.pageType == 1) {
            break;
        }
        
        NewPersonTagView *currTagView = [tagViewArray objectAtIndex:i];
        CGFloat currTagViewW = [currTagView getTagLab].frame.size.width + [currTagView getLikeCountLab].frame.size.width + 32 + 10;
        cellW += currTagViewW + 15;
        CGFloat nextTagViewW = 0;
        if (i < tagViewArray.count - 1) {
            NewPersonTagView *nextTagView = [tagViewArray objectAtIndex:i + 1];
            nextTagViewW = [nextTagView getTagLab].frame.size.width + [nextTagView getLikeCountLab].frame.size.width + 32 + 10;
            
        }
        cellW += (nextTagViewW + 15);
        if (cellW - 15 >= cellMaxW && i < tagViewArray.count - 1) {
            currentLine++;
            cellW = 0.0f;
        } else {
            isFirst = NO;
            
            //最后标签不用减
            if (i < tagViewArray.count - 1) {
                cellW -= (nextTagViewW + 15);
            }
            
            if (i == utdto.tags.count - 1) {
                //添加按钮如果放到下一行第一个则高度要加上添加按钮高度
                if(utdto.pageType == 1) {
                    if (width - cellW - 10 < addTagW + 15) {
                        currentLine++;
                    }
                } else {
                    if (width - cellW < addTagW + 15) {
                        currentLine++;
                    }
                    
                }
            }
        }
    }
    
    currentLine = utdto.pageType == 1 ? (currentLine == 3 ? currentLine : currentLine + 1) : (currentLine + 1);
    CGFloat height = utdto.pageType == 1 ? 40 * currentLine : 40 * currentLine + 10;
    
    for (int i = 0; i < tagViewArray.count; i++) {
        UIView *view = [tagViewArray objectAtIndex:i];
        view = nil;
    }
    [tagViewArray removeAllObjects];
    
    return height + 15;
    
}

#pragma mark rewrite system method 禁用cell选中
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}


@end
