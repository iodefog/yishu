//
//  ContactInfo.h
//  aqgj_dial
//
//  Created by Sam on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface ContactInfo : NSObject <NSCopying> {
    NSString            *key;
    NSString            *name;
    NSString            *displayName;
    NSMutableArray      *email;
    NSInteger           recordID;
    NSString            *rowid;
    NSMutableArray      *group;
    NSMutableArray      *phones;
    NSData              *imageData;
    NSString            *imagePath;
    BOOL                selected;
    NSString            *reverse1;
    NSString            *reverse2;
    NSInteger           contactSize;
    
    NSString            *fname;
    NSString            *lname;
    NSInteger           sortOrder;
    NSInteger           trimOper;
}

- (id)initWithRecord:(ABRecordRef)rec;
- (BOOL)parseRec:(ABRecordRef)rec;
- (BOOL)parseToRec:(ABRecordRef)rec;
- (UIImage *)getImage;
- (void)setReverse2:(NSString *)str;

- (void)addGroupInfo:(NSString *)gName;
- (void)removeGroupInfo:(NSString *)gName;
- (BOOL)isBelongToGroup:(NSString *)gName;
- (void)getContactSize;

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSMutableArray *email;
@property (nonatomic, copy) NSMutableArray *phones;
@property (nonatomic, assign) NSInteger recordID;
@property (nonatomic, copy) NSString *rowid;
@property (nonatomic, copy) NSMutableArray *group;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSData *imageData;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *reverse1;
@property (nonatomic, copy) NSString *reverse2;
@property (nonatomic, assign) NSInteger contactSize;

@property (nonatomic, copy) NSString *fname;
@property (nonatomic, copy) NSString *lname;
@property (nonatomic, assign) NSInteger sortOrder;
@property (nonatomic, assign) NSInteger trimOper;

@end
