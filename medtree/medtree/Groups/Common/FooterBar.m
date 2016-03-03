//
//  PersonDetailControllerFoot.m
//  medtree
//
//  Created by 无忧 on 14-9-2.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "FooterBar.h"
#import "ImageCenter.h"
#import "ColorUtil.h"
#import "MedGlobal.h"
#import "FontUtil.h"

@implementation FooterBar

- (void)createUI
{
    bgImage = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@".png"]];
    bgImage.userInteractionEnabled = YES;
    bgImage.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgImage];
    
    buttonArray = [[NSMutableArray alloc] init];
    lineArray = [[NSMutableArray alloc] init];
    
    headerLine = [[UILabel alloc] init];
    headerLine.backgroundColor = [ColorUtil getColor:@"D6D6D6" alpha:1];
    [self addSubview:headerLine];
    
    footerLine = [[UILabel alloc] init];
    footerLine.backgroundColor = [ColorUtil getColor:@"D6D6D6" alpha:1];
    [self addSubview:footerLine];
}

- (void)setBackgroundImage:(NSString *)imageName
{
    bgImage.image = [ImageCenter getNamedImage:imageName];
}

- (void)setButtonInfo:(NSArray *)array
{
    /**清除残留视图**/
    if (buttonArray.count > 0) {
        for (int i = 0; i < buttonArray.count; i ++) {
            NSDictionary *dict = [buttonArray objectAtIndex:i];
            
            UIImageView *imageView = dict[@"image"];
            [imageView removeFromSuperview];
            
            UILabel *titleLab = dict[@"label"];
            [titleLab removeFromSuperview];
            
            UIButton *btn = dict[@"button"];
            [btn removeFromSuperview];
            
            UIView *btnView = dict[@"view"];
            [btnView removeFromSuperview];
        }
        [buttonArray removeAllObjects];
    }
    
    if (lineArray.count > 0) {
        for (UILabel *label in lineArray) {
            [label removeFromSuperview];
        }
        [lineArray removeAllObjects];
    }
    
    /**创建视图**/
    for (NSInteger i = 0; i < array.count; i++) {
        
        NSDictionary *dict = (NSDictionary *)[array objectAtIndex:i];
        
        UIView *btnBGView = [[UIView alloc] init];
        btnBGView.backgroundColor = [UIColor clearColor];
        [self addSubview:btnBGView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[ImageCenter getNamedImage:dict[@"imageName"]]];
        imageView.userInteractionEnabled = YES;
        [btnBGView addSubview:imageView];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = dict[@"title"];
        titleLab.textColor = [ColorUtil getColor:@"505050" alpha:1];
        titleLab.font = [MedGlobal getLittleFont];
        titleLab.backgroundColor = [UIColor clearColor];
        [btnBGView addSubview:titleLab];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        
        if ([dict objectForKey:@"btnTag"]) {
            NSInteger btnTag = [[dict objectForKey:@"btnTag"] intValue];
            btn.tag = 100 + btnTag;
        }
        id target = [dict objectForKey:@"target"];
        SEL action = NSSelectorFromString([dict objectForKey:@"action"]);
        [btn setBackgroundImage:[ImageCenter getNamedImage:@"footer_bar_btn_select.png"] forState:UIControlStateHighlighted];
        //        NSLog(@"btn ------------ dict ------------ %@", dict);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [btnBGView addSubview:btn];
        
        
        [buttonArray addObject:@{@"view":btnBGView, @"button":btn, @"image":imageView, @"label":titleLab}];
    }
    
    if (buttonArray.count > 1) {
        for (int i = 0; i < buttonArray.count-1; i ++) {
            UILabel *lineLab = [[UILabel alloc] init];
            lineLab.backgroundColor = [ColorUtil getColor:@"D6D6D6" alpha:1];
            [self addSubview:lineLab];
            [lineArray addObject:lineLab];
        }
    }
    
    [self layoutSubviews];
}

- (void)changeButtonImage:(NSString *)imageName index:(NSInteger)index
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[buttonArray objectAtIndex:index]];//[[NSMutableDictionary alloc] initWithDictionary:[buttonArray objectAtIndex:index]];
    UIImageView *imageView = dict[@"image"];
    imageView.image = [ImageCenter getNamedImage:imageName];
    [buttonArray replaceObjectAtIndex:index withObject:dict];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    
    bgImage.frame = CGRectMake(0, 0, size.width, size.height);
    headerLine.frame = CGRectMake(0, 0, size.width, 0.5);
    footerLine.frame = CGRectMake(0, size.height-0.5, size.width, 0.5);
    
    CGFloat btnWidth = size.width/buttonArray.count;
    
    for (NSInteger i = 0; i < buttonArray.count; i++) {
        NSDictionary *dict = [buttonArray objectAtIndex:i];
        
        UIView *btnBGView = dict[@"view"];
        btnBGView.frame = CGRectMake(i*btnWidth, 0.5, btnWidth, size.height-1);
        
        UIButton *btn = dict[@"button"];
        btn.frame = CGRectMake(0, 0, btnWidth, size.height);
        
        UILabel *titleLab = dict[@"label"];
        CGFloat width = [FontUtil getTextWidth:titleLab.text font:titleLab.font];
        UIImageView *imageView = dict[@"image"];
        imageView.frame =  CGRectMake((btnWidth-44-width)/2, (size.height-44)/2, 44, 44);
        titleLab.frame = CGRectMake(imageView.frame.origin.x+imageView.frame.size.height, 0, width, size.height);
    }
    
    for (int i = 0; i < lineArray.count; i ++) {
        UILabel *lineLab = [lineArray objectAtIndex:i];
        lineLab.frame = CGRectMake((i+1)*btnWidth, (size.height-30)/2, 0.5, 30);
    }
}

@end
