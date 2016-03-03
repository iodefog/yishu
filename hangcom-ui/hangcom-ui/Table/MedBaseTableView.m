//
//  MedBaseTableVIew.m
//  hangcom-ui
//
//  Created by tangshimi on 10/20/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MedBaseTableView.h"
#import "DTOBase.h"
#import "BaseCell.h"

@interface MedBaseTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *heights;

@end

@implementation MedBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
        self.delegate = self;
        self.dataSource = self;        
    }
    return self;
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSAssert([self.dataArray[section] isKindOfClass:[NSArray class]], @"self.data[section] must is array");
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTOBase *dto = self.dataArray[indexPath.section][indexPath.row];
    
    if (dto.cellHeight != 0) {
        return dto.cellHeight;
    } else {
        Class cellClass = self.registerCells[NSStringFromClass([dto class])];
        CGFloat height = ceilf([cellClass getCellHeight:dto width:self.frame.size.width]);
        dto.cellHeight = height;
        return height;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTOBase *DTO = self.dataArray[indexPath.section][indexPath.row];

    NSString *cellIdentifier = NSStringFromClass(self.registerCells[NSStringFromClass([DTO class])]);
    
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert([cell isKindOfClass:[BaseCell class]], @"cell must inherit from BaseCell");

    DTOBase *DTO = self.dataArray[indexPath.section][indexPath.row];
    
    BaseCell *baseCell = (BaseCell *)cell;
    
    baseCell.parent = self.parent;
    [baseCell setInfo:DTO indexPath:indexPath];
    baseCell.firstCell = indexPath.row == 0 ? : NO;
    baseCell.lastCell  = indexPath.row == [self.dataArray[indexPath.section] count] - 1 ? : NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.parent respondsToSelector:@selector(clickCell:index:)]) {
        [self.parent clickCell:self.dataArray[indexPath.section][indexPath.row]
                         index:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section < self.sectionTitleArray.count) {
        title = self.sectionTitleArray[section];
    }
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    if (section < self.sectionTitleHeightArray.count) {
        height = [self.sectionTitleHeightArray[section] floatValue];
    }
    return height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.parent) {
        if ([self.parent respondsToSelector:@selector(isAllowDelete:)]) {
            return [self.parent isAllowDelete:indexPath];
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.deleteButtonTitle ? : @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.parent respondsToSelector:@selector(deleteIndex:)]) {
            [self.parent deleteIndex:indexPath];
        } else if ([self.parent respondsToSelector:@selector(deleteData:)]) {
            [self.parent deleteData:self.dataArray[indexPath.section][indexPath.row]];
        }
        
        if (self.dataArray.count > indexPath.section) {
            NSMutableArray *array =  [self.dataArray[indexPath.section] mutableCopy];
            [array removeObjectAtIndex:indexPath.row];
            
            if (array.count > 0) {
                self.dataArray[indexPath.section] = array;
            } else {
                [self.dataArray removeObjectAtIndex:indexPath.section];
            }
        }
        
        if (self.dataArray.count > 0) {
            [tableView beginUpdates];

            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            [tableView endUpdates];
        } else {
            [self reloadData];
        }
    }
}

- (NSMutableArray *)getData;
{
    return self.dataArray;
}

#pragma mark -
#pragma mark - setter and getter -

- (void)setData:(NSArray *)data
{
    _data = [data copy];
    
    [self.dataArray removeAllObjects];
    [self.heights removeAllObjects];
    [self.dataArray addObjectsFromArray:_data];
    
//    __unsafe_unretained typeof(self) weakSelf = self;
//    [self.dataArray enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger section, BOOL * _Nonnull stop) {
//        __block NSMutableArray *arrayM = [[NSMutableArray alloc] initWithCapacity:array.count];
//        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger row, BOOL * _Nonnull stop) {
//            DTOBase *dto = self.dataArray[section][row];
//            Class cellClass = self.registerCells[NSStringFromClass([dto class])];
//            CGFloat height = ceilf([cellClass getCellHeight:dto width:self.frame.size.width]);
//            [arrayM addObject:@(height)];
//        }];
//        [weakSelf.heights addObject:arrayM];
//    }];
    
    [self reloadData];
}

- (void)setRegisterCells:(NSDictionary *)registerCells
{
    _registerCells = [registerCells copy];
    
    for (Class cellClass in registerCells.allValues) {
       // NSAssert([cellClass isSubclassOfClass:[cl]], @"");
        
        [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
    }
}

- (NSMutableArray *)heights
{
    if (!_heights) {
        _heights = [NSMutableArray new];
    }
    return _heights;
}

@end
