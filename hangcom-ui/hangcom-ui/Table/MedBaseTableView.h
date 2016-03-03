//
//  MedBaseTableVIew.h
//  hangcom-ui
//
//  Created by tangshimi on 10/20/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MedBaseTableView;

@protocol MedBaseTableViewDelegate <NSObject>

@optional
- (void)clickCell:(id)dto action:(NSNumber *)action;
- (void)clickCell:(id)dto index:(NSIndexPath *)index;
- (void)clickCell:(id)dto index:(NSIndexPath *)index action:(NSNumber *)action;

- (void)loadHeader:(MedBaseTableView *)table;
- (void)loadFooter:(MedBaseTableView *)table;

- (BOOL)isAllowDelete:(NSIndexPath *)indexPath;

- (void)deleteIndex:(NSIndexPath *)indexPath;

- (void)deleteData:(id)data;

@end

@interface MedBaseTableView : UITableView

@property (nonatomic, weak) id<MedBaseTableViewDelegate> parent;
@property (nonatomic, copy) NSArray *data;
@property (nonatomic, copy) NSDictionary *registerCells;
@property (nonatomic, copy) NSArray *sectionTitleArray;
@property (nonatomic, copy) NSArray *sectionTitleHeightArray;
@property (nonatomic, copy) NSString *deleteButtonTitle;

- (NSMutableArray *)getData;

@end
