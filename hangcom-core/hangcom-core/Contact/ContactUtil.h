//
//  ContactUtil.h
//  aqgj_dial
//
//  Created by Sam on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

#define KEY_ALL_CONTACT @"Key000"
#define KEY_ALL_UNGROUP @"Key001"

typedef void(^TransInfo)(id info, NSInteger idx, NSInteger total);
typedef void(^TransGroup)(id info, NSInteger type);

@class ContactInfo;

@interface ContactUtil : NSObject {
    ABAddressBookRef ababRef;
}

+ (NSString *)getFName:(ABRecordRef)rec;
+ (void)addStr:(NSString **)str value:(CFTypeRef)value;
+ (void)addPhone:(NSString *)phone to:(ABRecordRef)rec;
+ (void)addData:(NSData **)data value:(CFTypeRef)value;
+ (NSString *)formatName:(NSString *)name;
+ (BOOL)isNeedFormatName:(ContactInfo *)info;
+ (NSString *)formatPhone:(NSString *)caller;
+ (BOOL)isNeedFormatPhone:(NSString *)caller;
+ (NSMutableDictionary *)getAllContacts:(BOOL)force process:(TransInfo)process;
+ (ABRecordRef)createABRecord:(NSString *)caller;

+ (NSMutableDictionary *)getAllGroup:(BOOL)force;
+ (NSMutableArray *)getAllMembers:(BOOL)force from:(NSString *)gName;
+ (BOOL)createGroup:(NSString *)gName;
+ (BOOL)deleteGroup:(NSString *)gName;
+ (BOOL)addGroup:(NSString *)gName with:(NSArray *)members;
+ (BOOL)removeGroup:(NSString *)gName with:(NSArray *)members;
+ (void)modifyGroupName:(NSString *)oldName with:(NSString *)newName;
+ (void)deleteContact:(NSInteger)recordID;
+ (BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT;
+ (NSInteger)addContactToArray:(NSMutableArray *)array contact:(id)contact key:(NSString *)key;
+ (NSIndexPath *)addContact:(ContactInfo *)ci sectionArray:(NSMutableArray *)sectionArray;

+ (BOOL)deleteAllContacts:(BOOL)force process:(TransInfo)process;
+ (BOOL)addContacts:(NSArray *)array  process:(TransInfo)process;

+ (ContactInfo *)getContact:(NSInteger)recordID;
+ (BOOL)hasChinese:(NSString *)str;

+ (NSMutableDictionary *)getAllContactIDs;
+ (NSArray *)getContacts:(NSArray *)ids;

@end
