//
//  TQRichTextView.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 2/26/14.
//  Copyright (c) 2014 fuqiang. All rights reserved.
//

#import "TQRichTextView.h"
#import <CoreText/CoreText.h>




@interface TQRichTextView ()

@property (nonatomic,strong) NSMutableArray *runs;
@property (nonatomic,strong) NSMutableDictionary *runRectDictionary;
@property (nonatomic,strong) TQRichTextRun *touchRun;

@end

@implementation TQRichTextView

- (id)init
{
    self = [super init];
    if (self) {
        [self createDefault];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createDefault];
    }
    return self;
}

#pragma mark - CreateDefault

- (void)createDefault
{
    //public
    self.text        = nil;
    self.font        = [UIFont systemFontOfSize:16.0f];
    self.textColor   = [UIColor blackColor];
    self.runTypeList = TQRichTextRunURLType | TQRichTextRunEmojiType;
    self.lineSpace   = 2.0f;
    self.attributedText = nil;
    //private
    self.runs        = [NSMutableArray array];
    self.runRectDictionary = [NSMutableDictionary dictionary];
    self.touchRun = nil;
}

#pragma mark - Draw Rect

- (void)drawRect:(CGRect)rect
{
    if (self.text == nil){
        return;
    }
    
    [self.runs removeAllObjects];
    [self.runRectDictionary removeAllObjects];
    
    CGRect viewRect = self.bounds;
    
    //绘制的文本
    NSMutableAttributedString *attString = nil;
    
    if (self.attributedText == nil)
    {
        attString = [[self class] createAttributedStringWithText:self.text font:self.font lineSpace:self.lineSpace];
    }
    else
    {
        attString = self.attributedText;
    }
    if (self.firstLineSpace > 0)
    {
        attString = [[self class] createAttributedStringWithText:self.text font:self.font lineSpace:self.lineSpace firstLineSpace:self.firstLineSpace];
    }
    {
        [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)self.textColor.CGColor range:NSMakeRange(0, [attString length])];
    }

    NSArray *runs = [[self class] createTextRunsWithAttString:attString runTypeList:self.runTypeList];
    
    [self.runs addObjectsFromArray:runs];
    
    //绘图上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    //修正坐标系
    CGAffineTransform affineTransform = CGAffineTransformIdentity;
    affineTransform = CGAffineTransformMakeTranslation(0.0, viewRect.size.height);
    affineTransform = CGAffineTransformScale(affineTransform, 1.0, -1.0);
    CGContextConcatCTM(contextRef, affineTransform);
    
    //创建一个用来描画文字的路径，其区域为当前视图的bounds  CGPath
    CGMutablePathRef pathRef = CGPathCreateMutable();
    //  坐标点在左下角
    CGPathAddRect(pathRef, NULL, viewRect);
    
    //创建一个framesetter用来管理描画文字的frame  CTFramesetter
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    
    //创建由framesetter管理的frame，是描画文字的一个视图范围  CTFrame
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, NULL);
    
    // 得到frame中的行数组
    CFArrayRef lines = CTFrameGetLines(frameRef);
    
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
    
    for (int i = 0; i < CFArrayGetCount(lines); i++)
    {
        CTLineRef lineRef= CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CGPoint lineOrigin = lineOrigins[i];
//        NSLog(@"self.text ----- %@", self.text);
//        NSLog(@"self.linespace --- %ld", self.lineSpace);
        CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
//        NSLog(@"lineAscent:%f, lineDescent:%f, lineLeading:%f", lineAscent, lineDescent, lineLeading);
        
        // 从一行中得到CTRun数组
        CFArrayRef runs = CTLineGetGlyphRuns(lineRef);
//        NSLog(@"runs.count ----- %ld", CFArrayGetCount(runs));
        for (int j = 0; j < CFArrayGetCount(runs); j++)
        {
            CTRunRef runRef = CFArrayGetValueAtIndex(runs, j);
            CGFloat runAscent;
            CGFloat runDescent;
            CGRect runRect;
            
            runRect.size.width = CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            runRect = CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, NULL),
                                 lineOrigin.y ,
                                 runRect.size.width,
                                 runAscent + runDescent);
            
            NSDictionary * attributes = (__bridge NSDictionary *)CTRunGetAttributes(runRef);
            TQRichTextRun *richTextRun = [attributes objectForKey:kTQRichTextRunSelfAttributedName];
            
            if (richTextRun.drawSelf)
            {
                CGFloat runAscent,runDescent;
                CGFloat runWidth  = CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
                CGFloat runHeight = (lineAscent + lineDescent );
                CGFloat runPointX = runRect.origin.x + lineOrigin.x;
                CGFloat runPointY = lineOrigin.y ;
                
                CGRect runRectDraw = CGRectMake(runPointX, runPointY, runWidth, runHeight);
                
                [richTextRun drawRunWithRect:runRectDraw];
                
                [self.runRectDictionary setObject:richTextRun forKey:[NSValue valueWithCGRect:runRectDraw]];
            }
            else
            {
                if (richTextRun)
                {
                    [self.runRectDictionary setObject:richTextRun forKey:[NSValue valueWithCGRect:runRect]];
                }
            }
        }
    }
    
    //通过context在frame中描画文字内容
    CTFrameDraw(frameRef, contextRef);
    
    CFRelease(pathRef);
    CFRelease(frameRef);
    CFRelease(framesetterRef);
}

#pragma mark - Set
- (void)setText:(NSString *)text
{
    [self setNeedsDisplay];
    _text = text;
}

- (void)setFont:(UIFont *)font
{
    [self setNeedsDisplay];
    _font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    [self setNeedsDisplay];
    _textColor = textColor;
}

- (void)setLineSpace:(CGFloat)lineSpace
{
    _lineSpace = lineSpace;
    [self setNeedsDisplay];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
    
//    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2f];
    
    if (self.delegage && [self.delegage respondsToSelector:@selector(richTextView: touchBeginRun:)])
    {
        __weak TQRichTextView *weakSelf = self;
        
        [self.runRectDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            
             CGRect rect = [((NSValue *)key) CGRectValue];
             if(CGRectContainsPoint(rect, runLocation))
             {
                 self.touchRun = obj;
                 [weakSelf.delegage richTextView:weakSelf touchBeginRun:obj];
             }
         }];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
    
    if (self.delegage && [self.delegage respondsToSelector:@selector(richTextView: touchBeginRun:)])
    {
        __weak TQRichTextView *weakSelf = self;
        
        /*
        [self.runRectDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            
            CGRect rect = [((NSValue *)key) CGRectValue];
            if(CGRectContainsPoint(rect, runLocation))
            {
                self.touchRun = obj;
                [weakSelf.delegage richTextView:weakSelf touchEndRun:obj];
            }
        }];
         */
        BOOL isFind = NO;
        for (int i=0; i<self.runRectDictionary.allKeys.count; i++) {
            id key = [self.runRectDictionary.allKeys objectAtIndex:i];
            id obj = [self.runRectDictionary objectForKey:key];

            CGRect rect = [((NSValue *)key) CGRectValue];
            if(CGRectContainsPoint(rect, runLocation))
            {
                self.touchRun = obj;
                [weakSelf.delegage richTextView:weakSelf touchEndRun:obj];
                isFind = YES;
                break;
            }
        }
        if (!isFind) {
            [weakSelf.delegage richTextView:weakSelf touchEndRun:nil];
        }
    }
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
    
    if (self.delegage && [self.delegage respondsToSelector:@selector(richTextView: touchBeginRun:)])
    {
        __weak TQRichTextView *weakSelf = self;
        
        [self.runRectDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            
            CGRect rect = [((NSValue *)key) CGRectValue];
            if(CGRectContainsPoint(rect, runLocation))
            {
                self.touchRun = obj;
                [weakSelf.delegage richTextView:weakSelf touchCanceledRun:obj];
            }
        }];
    }
    
    self.backgroundColor = [UIColor clearColor];
}

- (UIResponder*)nextResponder
{
    [super nextResponder];
    self.backgroundColor = [UIColor clearColor];
    return self.touchRun;
}

#pragma mark -
/**
 *  设置富文本属性
 *
 *  @param text      文本信息
 *  @param font      字体
 *  @param lineSpace 行间距
 *
 *  @return 富文本属性
 */
+ (NSMutableAttributedString *)createAttributedStringWithText:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)lineSpace
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:(text?text:@"")];
    
    //设置字体
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,attString.length)];
    CFRelease(fontRef);
    
    //添加换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec        = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value       = &lineBreak;
    lineBreakMode.valueSize   = sizeof(lineBreak);
    
    //行距
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value =&lineSpace;
    
    CTParagraphStyleSetting settings[] = {lineSpaceStyle,lineBreakMode};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(settings[0]));
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    CFRelease(style);
    
    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
    
    return attString;
}

/**
 *  设置富文本属性,包含首行缩进
 *
 *  @param text      文本信息
 *  @param font      字体
 *  @param lineSpace 行间距
 *  @param firstLineSpace 首行缩进
 *
 *  @return 富文本属性
 */
+ (NSMutableAttributedString *)createAttributedStringWithText:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)lineSpace firstLineSpace:(CGFloat)firstLineSpace
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:(text?text:@"")];
    
    //设置字体
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,attString.length)];
    CFRelease(fontRef);
    
    //添加换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec        = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value       = &lineBreak;
    lineBreakMode.valueSize   = sizeof(lineBreak);
    
    //行距
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value = &lineSpace;
    
    // 首行缩进
    CTParagraphStyleSetting firstSpace;
    firstSpace.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    firstSpace.valueSize = sizeof(firstLineSpace);
    firstSpace.value = &firstLineSpace;
    
    CTParagraphStyleSetting settings[] = {lineSpaceStyle,lineBreakMode,firstSpace};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(settings[0]));
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    CFRelease(style);
    
    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
    
    return attString;
}

+ (NSArray *)createTextRunsWithAttString:(NSMutableAttributedString *)attString runTypeList:(TQRichTextRunTypeList)typeList
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (typeList != TQRichTextRunNoneType)
    {
        if ((typeList & TQRichTextRunURLType) == TQRichTextRunURLType)
        {
            [array addObjectsFromArray:[TQRichTextRunURL runsForAttributedString:attString]];
        }
        
        if ((typeList & TQRichTextRunEmojiType) == TQRichTextRunEmojiType)
        {
            [array addObjectsFromArray:[TQRichTextRunEmoji runsForAttributedString:attString]];
        }
    }
    
    return  array;
}

/** 计算文本frame */
+ (CGRect)boundingRectWithSize:(CGSize)size font:(UIFont *)font AttString:(NSMutableAttributedString *)attString
{
    [[self class] createTextRunsWithAttString:attString runTypeList:TQRichTextRunURLType | TQRichTextRunEmojiType ];
    
    NSDictionary *dic = [attString attributesAtIndex:0 effectiveRange:nil];
    CTParagraphStyleRef paragraphStyle = (__bridge CTParagraphStyleRef)[dic objectForKey:(id)kCTParagraphStyleAttributeName];
    CGFloat linespace = 0;
    CGFloat firstSpace = 0;
    
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineSpacing, sizeof(linespace), &linespace);
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(firstSpace), &firstSpace);

    CGFloat height = 0;
    CGFloat width = 0;
    CFIndex lineIndex = 0;
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, size.width, size.height));
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, nil);
    CFArrayRef lines = CTFrameGetLines(frameRef);
    
    lineIndex = CFArrayGetCount(lines);

    if (lineIndex > 1) {
        for (int i = 0; i < lineIndex ; i++) {
            CTLineRef lineRef= CFArrayGetValueAtIndex(lines, i);
            CGFloat lineAscent;
            CGFloat lineDescent;
            CGFloat lineLeading;
            CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
//            NSLog(@"lineAscent - %f, lineDescent - %f, lineLeading - %f", lineAscent, lineDescent, lineLeading);
            if (i == lineIndex - 1) {
                height += (lineAscent + lineDescent + lineLeading);
            } else {
                height += (lineAscent + lineDescent + linespace + lineLeading);
            }
        }
        
        width = size.width;
    } else {
        for (int i = 0; i <lineIndex ; i++) {
            CTLineRef lineRef= CFArrayGetValueAtIndex(lines, i);
            CGRect rect = CTLineGetBoundsWithOptions(lineRef,kCTLineBoundsExcludeTypographicShifts);
            width = rect.size.width;
            
            CGFloat lineAscent;
            CGFloat lineDescent;
            CGFloat lineLeading;
            CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
            
            height += (lineAscent + lineDescent + linespace + lineLeading);
        }
        
        height = height;
    }
    
    CFRelease(pathRef);
    CFRelease(frameRef);
    CFRelease(framesetterRef);

    CGRect rect = CGRectMake(0, 0, width, height);
    
    return rect;
}

+ (CGRect)boundingRectWithSize:(CGSize)size font:(UIFont *)font string:(NSString *)string lineSpace:(CGFloat )lineSpace
{
    NSMutableAttributedString *attributedString = [[self class] createAttributedStringWithText:string font:font lineSpace:lineSpace];
    CGRect rect = CGRectZero;
    if (attributedString.length > 0) {
        rect = [self boundingRectWithSize:size font:font AttString:attributedString];
    }
    return rect;
}

+ (CGRect)boundingRectWithSize:(CGSize)size font:(UIFont *)font string:(NSString *)string lineSpace:(CGFloat )lineSpace firstLineSpace:(CGFloat)firstLineSpace
{
    NSMutableAttributedString *attributedString = [[self class] createAttributedStringWithText:string font:font lineSpace:lineSpace firstLineSpace:firstLineSpace];
    CGRect rect = CGRectZero;
    if (attributedString.length > 0) {
        rect = [self boundingRectWithSize:size font:font AttString:attributedString];
    }
//    NSLog(@"text:%@", string);
//    NSLog(@"rect:%@", NSStringFromCGRect(rect));
    return rect;
}

+ (BOOL)hasEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
//    NSLog(@"string ----------------- %@", string);
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
         if (0x2702 <= hs && hs <= 0x27b0) {
             returnValue = YES;
         }
//         if (0x24c2 <= hs && hs <= 0x27b0) {
//             returnValue = YES;
//         }
     }];
    return returnValue;
}

@end
