//
//  CHTitleView.h
//
//  Created by 孙晨辉 on 15/3/6.
//

#import <UIKit/UIKit.h>

@interface CHTitleView : UIView

/** 正在加载 */
@property (nonatomic, assign, getter=isLoading) BOOL loading;
/** 设置标题 */
@property (nonatomic, strong) NSString *title;

/** 初始化 */
+ (instancetype)titleView;

@end
