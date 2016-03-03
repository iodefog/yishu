//
//  AddressBookController.h
//  medtree
//
//  Created by sam on 9/25/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "TableController.h"
#import "pinyin.h"

@class BaseTableView;
@class UserDTO;
@class ContactInfo;

@interface AddressBookController : TableController {
    NSMutableArray  *sectionArray;
    NSInteger       contactCount;
    NSMutableArray  *phonesArray;
}

- (void)getContactInfo;
- (void)putToTable;
- (BaseTableView *)getTable;

- (NSArray *)createSectionHeaders:(NSArray *)array;
- (NSArray *)createSectionHeights:(NSArray *)array;

- (UserDTO *)convertUser:(ContactInfo *)ci;

@end
