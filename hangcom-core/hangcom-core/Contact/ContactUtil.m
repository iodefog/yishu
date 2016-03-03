//
//  ContactUtil.m
//  aqgj_dial
//
//  Created by Sam on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ContactUtil.h"
#import "ContactInfo.h"
#import "pinyin.h"
#import "DateUtil.h"

@implementation ContactUtil

+ (void)addStr:(NSString **)str value:(CFTypeRef)value
{
    if (value != NULL) {
        *str = [[NSString alloc] initWithString:(NSString *)value];
        if ([*str length] == 0) {
            //NSLog(@"remove addStr");
            [*str release];
            *str = nil;
        } else {
            //NSLog(@"addStr: %@", *str);
        }
        CFRelease(value);
    }
}

+ (NSString *)getFName:(ABRecordRef)rec
{
    NSString *firstname = nil;
    NSString *lastname = nil;
    [ContactUtil addStr:&firstname value:ABRecordCopyValue(rec, kABPersonFirstNameProperty)];
    [ContactUtil addStr:&lastname value:ABRecordCopyValue(rec, kABPersonLastNameProperty)];
    
    ABPersonSortOrdering ordering = ABPersonGetSortOrdering();
    NSString *fname;
    if (ordering == kABPersonSortByLastName) {
        fname = [NSString stringWithFormat:@"%@%@", lastname != nil ? lastname : @"", firstname != nil ? firstname : @""];
    } else {
        fname = [NSString stringWithFormat:@"%@%@", firstname != nil ? firstname : @"", lastname != nil ? lastname : @""];
    }
    [firstname release];
    [lastname release];
    return fname;
}

+ (void)addPhone:(NSString *)phone to:(ABRecordRef)rec
{
    NSMutableArray *phones = [NSMutableArray array];
    ABMultiValueRef values = ABRecordCopyValue(rec, kABPersonPhoneProperty);
    for (int j=0; j<ABMultiValueGetCount(values); j++) {
        NSObject *value = (NSObject *)ABMultiValueCopyValueAtIndex(values, j);
        [phones addObject:value];
        [value release];
    }
    CFRelease(values);
    [phones addObject:[ContactUtil formatPhone:phone]];
    //
    ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    CFErrorRef  err = NULL;
    for (int i=0; i<phones.count; i++) {
        ABMultiValueAddValueAndLabel(multiValue, (CFTypeRef)[phones objectAtIndex:i], kABPersonPhoneMobileLabel, NULL);
    }
    ABRecordSetValue(rec, kABPersonPhoneProperty, multiValue, &err);
    CFRelease(multiValue);
    //
    
    ABAddressBookRef abab = ABAddressBookCreateWithOptions(NULL, &err);
    ABAddressBookAddRecord(abab, rec, &err);
    ABAddressBookSave(abab, &err);
    CFRelease(abab);
}

+ (NSMutableDictionary *)getAllContacts:(BOOL)force process:(TransInfo)process
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
    }
    if (dict.count == 0 || force == YES) {
        //@synchronized (dict) {
            
        [dict removeAllObjects];
        // add code from address book
        CFErrorRef  err = NULL;
        ABAddressBookRef abab = ABAddressBookCreateWithOptions(NULL, &err);
        NSArray *allContact = (NSArray *)ABAddressBookCopyArrayOfAllPeople(abab);
        NSInteger total = allContact.count;
        for (int i=0; i<allContact.count; i++) {
            ABRecordRef rec = [allContact objectAtIndex:i];
            ContactInfo *ci = [[ContactInfo alloc] initWithRecord:rec];
            [dict setObject:ci forKey:[NSNumber numberWithInteger:ci.recordID]];
            //
            if (process) {
                process(ci, i, total);
            }
            //
            [ci release];
        }
        CFRelease(allContact);
        CFRelease(abab);
            
        //}
    }
    return dict;
}

+ (NSMutableDictionary *)getAllContactIDs
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    CFErrorRef  err = NULL;
    ABAddressBookRef abab = ABAddressBookCreateWithOptions(NULL, &err);
    NSArray *allContact = (NSArray *)ABAddressBookCopyArrayOfAllPeople(abab);
    for (int i=0; i<allContact.count; i++) {
        ABRecordRef rec = [allContact objectAtIndex:i];
        //
        ABRecordID rid = ABRecordGetRecordID(rec);
        if (rid != kABRecordInvalidID) {
            NSDate *mdate = (NSDate *)ABRecordCopyValue(rec, kABPersonModificationDateProperty);
            [dict setObject:[DateUtil convertNumberFromTime:mdate] forKey:[NSString stringWithFormat:@"%d", rid]];
//            NSLog(@"%d %@", rid, mdate);
        }
    }
    CFRelease(allContact);
    CFRelease(abab);
    return dict;
}

+ (NSArray *)getContacts:(NSArray *)ids
{
    NSMutableArray *array = [NSMutableArray array];
    CFErrorRef  err = NULL;
    ABAddressBookRef abab = ABAddressBookCreateWithOptions(NULL, &err);
    for (int i=0; i<ids.count; i++) {
        ABRecordRef rec = ABAddressBookGetPersonWithRecordID(abab, (ABRecordID)[[ids objectAtIndex:i] integerValue]);
        if (rec != nil) {
            ContactInfo *ci = [[ContactInfo alloc] initWithRecord:rec];
            [array addObject:ci];
            [ci release];
        }
    }
    CFRelease(abab);
    return array;
}

+ (void)addData:(NSData **)data value:(CFTypeRef)value
{
    if (value != NULL) {
        NSData *d = (NSData *)value;
        *data = [[NSData alloc] initWithData:d];
        CFRelease(value);
    }
}

+ (NSString *)formatPhone:(NSString *)caller
{
    NSMutableString *tCaller = [NSMutableString string];
    [tCaller appendString:caller];
    [tCaller replaceOccurrencesOfString:@"+86" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [tCaller length])];
    [tCaller replaceOccurrencesOfString:@"-" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [tCaller length])];
    [tCaller replaceOccurrencesOfString:@"(" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [tCaller length])];
    [tCaller replaceOccurrencesOfString:@")" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [tCaller length])];
    [tCaller replaceOccurrencesOfString:@" " withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [tCaller length])];
    return tCaller;
}

+ (BOOL)isNeedFormatPhone:(NSString *)caller
{
    BOOL tf = NO;
    NSArray *keys = [NSArray arrayWithObjects:@"+86", @"-", @"(", @")", @" ", nil];
    for (int i=0; i<keys.count; i++) {
        NSRange range = [caller rangeOfString:[keys objectAtIndex:i]];
        if (range.location != NSNotFound && range.length > 0) {
            tf = YES;
            break;
        }
    }
    return tf;
}

+ (NSString *)formatName:(NSString *)name
{
    NSMutableString *tName = [NSMutableString string];
    [tName appendString:name];
    NSArray *array = [NSArray arrayWithObjects:@"𠄎", @"㐊", nil];
    for (int i=0; i<array.count; i++) {
        [tName replaceOccurrencesOfString:[array objectAtIndex:i] withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [tName length])];
    }
    return tName;
}

+ (BOOL)isNeedFormatName:(ContactInfo *)info
{
    BOOL tf = NO;
    if (info.sortOrder == kABPersonSortByLastName && info.fname.length > 0) {
        if (info.lname.length > 0 && [ContactUtil hasChinese:info.fname] == NO) {
            tf = NO;
        } else {
            tf = YES;
        }
    } else if (info.sortOrder == kABPersonSortByFirstName && info.lname.length > 0) {
        if (info.fname.length > 0 && [ContactUtil hasChinese:info.lname] == NO) {
            tf = NO;
        } else {
            tf = YES;
        }
    }
    return tf;
}

+ (ABRecordRef)createABRecord:(NSString *)caller
{
    ABRecordRef rec = ABPersonCreate();
    ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiValue, (CFTypeRef)caller, kABPersonPhoneMobileLabel, NULL);
    CFErrorRef  err = NULL;
    ABRecordSetValue(rec, kABPersonPhoneProperty, multiValue, &err);
    return rec;
}

+ (NSMutableArray *)getMembers:(NSString *)gName record:(ABRecordRef)group recordIDs:(NSDictionary *)rIDs
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *contacts = (NSArray *)ABGroupCopyArrayOfAllMembers(group);
    for (int i=0; i<contacts.count; i++) {
        ABRecordRef rec = [contacts objectAtIndex:i];
        NSInteger rID = ABRecordGetRecordID(rec);
        if (rID > kABRecordInvalidID) {
            ContactInfo *ci = [rIDs objectForKey:[NSString stringWithFormat:@"%@", @(rID)]];
            if (ci != nil) {
                [ci addGroupInfo:gName];
                [array addObject:ci];
            }
        }
    }
    return array;
}

+ (NSMutableDictionary *)getAllGroup:(BOOL)force
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
    }
    if (dict.count == 0 || force == YES) {
        [dict removeAllObjects];
        // all contact
        NSMutableArray *alls = [NSMutableArray array];
        [dict setObject:alls forKey:KEY_ALL_CONTACT];
        // ungroup
        NSMutableArray *ungroups = [NSMutableArray array];
        [dict setObject:ungroups forKey:KEY_ALL_UNGROUP];

        // get all people
        NSMutableDictionary *rIDs = [NSMutableDictionary dictionary];
        CFErrorRef err = NULL;
        ABAddressBookRef abab = ABAddressBookCreateWithOptions(NULL, &err);
        NSArray *allContact = (NSArray *)ABAddressBookCopyArrayOfAllPeople(abab);
        for (int i=0; i<allContact.count; i++) {
            ABRecordRef rec = [allContact objectAtIndex:i];
            NSInteger rID = ABRecordGetRecordID(rec);
            if (rID > kABRecordInvalidID) {
                ContactInfo *ci = [[ContactInfo alloc] initWithRecord:rec];
                ci.recordID = rID;
                [rIDs setObject:ci forKey:[NSString stringWithFormat:@"%@", @(rID)]];
                //
                [alls addObject:ci];
                [ci release];
            }
        }
        CFRelease(allContact);
        // get all group
        NSArray *allGroup = (NSArray *)ABAddressBookCopyArrayOfAllGroups(abab);
        for (int i=0; i<allGroup.count; i++) {
            ABRecordRef group = [allGroup objectAtIndex:i];
            NSString *gName = ABRecordCopyValue(group, kABGroupNameProperty);
            NSMutableArray *array = [ContactUtil getMembers:gName record:group recordIDs:rIDs];
            [dict setObject:array forKey:gName];
        }
        // get other contact for ungroup
        for (int i=0; i<alls.count; i++) {
            ContactInfo *ci = [alls objectAtIndex:i];
            if (ci.group.count > 0) {
                
            } else {
                [ungroups addObject:ci];
            }
        }
        
        if (allGroup.count != 0) {
            CFRelease(allGroup);
        }
        
        //
        CFRelease(abab);
    }
    return dict;
}

+ (NSMutableArray *)getAllMembers:(BOOL)force from:(NSString *)gName
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *dict = [ContactUtil getAllGroup:NO];
    if (force == YES) {
        NSMutableDictionary *rIDs = [NSMutableDictionary dictionary];
        NSMutableArray *allContact = [dict objectForKey:KEY_ALL_CONTACT];
        for (int i=0; i<allContact.count; i++) {
            ContactInfo *ci = [allContact objectAtIndex:i];
            [rIDs setObject:ci forKey:[NSString stringWithFormat:@"%@", @(ci.recordID)]];
        }
        CFErrorRef err = NULL;
        ABAddressBookRef abab = ABAddressBookCreateWithOptions(NULL, &err);
        //
        NSArray *allGroup = (NSArray *)ABAddressBookCopyArrayOfAllGroups(abab);
        for (int i=0; i<allGroup.count; i++) {
            ABRecordRef group = [allContact objectAtIndex:i];
            NSString *groupName = ABRecordCopyValue(group, kABGroupNameProperty);
            if ([groupName isEqualToString:gName] == YES) {
                array = [ContactUtil getMembers:gName record:group recordIDs:rIDs];
                break;
            }
        }
        CFRelease(allGroup);
        CFRelease(abab);
    } else {
        array = [dict objectForKey:gName];
    }
    return array;
}

+ (BOOL)createGroup:(NSString *)gName
{
    BOOL tf = YES;
    CFErrorRef err = NULL;
    ABAddressBookRef abab = ABAddressBookCreateWithOptions(NULL, &err);
    CFErrorRef error;
    ABRecordRef group = ABGroupCreate();
    if (group != nil) {
        // create group
        ABRecordSetValue(group, kABGroupNameProperty, gName, &error);
        ABAddressBookAddRecord(abab, group, &error);
        ABAddressBookSave(abab, &error);
        CFRelease(group);
        // add to dict
        NSMutableDictionary *dict = [ContactUtil getAllGroup:NO];
        NSMutableArray *array = [dict objectForKey:gName];
        if (array == nil) {
            [dict setObject:[NSMutableArray array] forKey:gName];
        }
    } else {
        tf = NO;
    }
    return tf;
}

+ (BOOL)deleteGroup:(NSString *)gName
{
    BOOL tf = YES;
    // remove group
    CFErrorRef err = NULL;
    ABAddressBookRef abab = ABAddressBookCreateWithOptions(NULL, &err);
    NSArray *allGroup = (NSArray *)ABAddressBookCopyArrayOfAllGroups(abab);
    for (int i=0; i<allGroup.count; i++) {
        ABRecordRef group = [allGroup objectAtIndex:i];
        NSString *groupName = ABRecordCopyValue(group, kABGroupNameProperty);
        if ([groupName isEqualToString:gName] == YES) {
            tf = ABAddressBookRemoveRecord (abab,group,nil);
            ABAddressBookSave(abab, nil);
            break;
        }
    }
    CFRelease(abab);

    // remove it from dict
    NSMutableDictionary *dict = [ContactUtil getAllGroup:NO];
    NSMutableArray *array = [dict objectForKey:gName];
    if (array != nil) {
        NSMutableArray *ungroup = [dict objectForKey:KEY_ALL_UNGROUP];
        for (int i=0; i<array.count; i++) {
            ContactInfo *ci = [array objectAtIndex:i];
            [ci removeGroupInfo:gName];
            if (ci.group.count == 0) {
                [ungroup addObject:ci];
            }
        }
        [dict removeObjectForKey:gName];
    }
    return tf;
}

+ (ContactInfo *)getContact:(NSInteger)recordID
{
    ContactInfo *contact = nil;
    /*
    NSMutableDictionary *dict = [ContactUtil getAllGroup:NO];
    NSArray *values = [dict objectForKey:KEY_ALL_CONTACT];
    for (int i=0; i<values.count; i++) {
        ContactInfo *ci = [values objectAtIndex:i];
        if (ci.recordID == recordID) {
            contact = ci;
            break;
        }
    }
     */
    if (contact == nil) {
        CFErrorRef err = NULL;
        ABAddressBookRef abab = ABAddressBookCreateWithOptions(NULL, &err);
        ABRecordRef rec = ABAddressBookGetPersonWithRecordID(abab, (ABRecordID)recordID);
        if (rec != nil) {
            contact = [[ContactInfo alloc] initWithRecord:rec];
        }
        CFRelease(abab);
    }
    return contact;
}

+ (BOOL)addGroup:(NSString *)gName with:(NSArray *)members
{
    BOOL tf = YES;
    if (members.count > 0) {
        // add it to dict
        NSMutableDictionary *dict = [ContactUtil getAllGroup:NO];
        if ([gName isEqualToString:KEY_ALL_CONTACT] == YES) {
            NSMutableDictionary *rIDs = [NSMutableDictionary dictionary];
            NSMutableArray *alls = [dict objectForKey:KEY_ALL_CONTACT];
            NSMutableArray *ungroups = [dict objectForKey:KEY_ALL_UNGROUP];
            for (int i=0; i<alls.count; i++) {
                ContactInfo *ci = [alls objectAtIndex:i];
                [rIDs setObject:ci forKey:[NSString stringWithFormat:@"%@", @(ci.recordID)]];
            }
            for (int i=0; i<members.count; i++) {
                ContactInfo *ci = [members objectAtIndex:i];
                ContactInfo *existInfo = [rIDs objectForKey:[NSString stringWithFormat:@"%@", @(ci.recordID)]];
                if (existInfo != nil) {
                    [alls removeObject:existInfo];
                    [ungroups removeObject:existInfo];
                }
                //ci.group = [NSMutableArray array];
                [alls addObject:ci];
                [ungroups addObject:ci];
            }
            return tf;
        }
        NSMutableArray *array = [dict objectForKey:gName];
        if (array == nil) {
            if ([ContactUtil createGroup:gName] == YES) {
                array = [dict objectForKey:gName];
            }
        }
        if (array == nil) {
            tf = NO;
        } else {
            NSMutableDictionary *rIDs = [NSMutableDictionary dictionary];
            for (int i=0; i<array.count; i++) {
                ContactInfo *ci = [array objectAtIndex:i];
                [rIDs setObject:ci forKey:[NSString stringWithFormat:@"%@", @(ci.recordID)]];
            }
            // add to dict
            for (int i=0; i<members.count; i++) {
                ContactInfo *ci = [members objectAtIndex:i];
                ContactInfo *existInfo = [rIDs objectForKey:[NSString stringWithFormat:@"%@", @(ci.recordID)]];
                if (existInfo != nil) {
                    [array removeObject:existInfo];
                }
                [ci addGroupInfo:gName];
                [array addObject:ci];
                [rIDs setObject:ci forKey:[NSString stringWithFormat:@"%@", @(ci.recordID)]];
            }
            // remove it from ungroup
            [ContactUtil removeGroup:KEY_ALL_UNGROUP with:members];
            // add to group
            
            CFErrorRef err = NULL;
            ABAddressBookRef abab = ABAddressBookCreateWithOptions(NULL, &err);
            NSArray *allGroup = (NSArray *)ABAddressBookCopyArrayOfAllGroups(abab);
            for (int i=0; i<allGroup.count; i++) {
                ABRecordRef group = [allGroup objectAtIndex:i];
                NSString *groupName = ABRecordCopyValue(group, kABGroupNameProperty);
                if ([groupName isEqualToString:gName] == YES) {
                    for (int j=0; j<members.count; j++) {
                        ContactInfo *ci = [members objectAtIndex:j];
                        ABRecordRef rec = ABAddressBookGetPersonWithRecordID(abab, (ABRecordID)ci.recordID);
                        if (rec != nil) {
                            tf = ABGroupAddMember(group, rec, nil);
                        }
                    }
                    ABAddressBookSave(abab, nil);
                    break;
                }
            }
            CFRelease(allGroup);
            CFRelease(abab);
        }
    }
    return tf;
}

+ (BOOL)removeGroup:(NSString *)gName with:(NSArray *)members
{
    BOOL tf = YES;
    if (members.count > 0) {
        NSMutableDictionary *rIDs = [NSMutableDictionary dictionary];
        for (int i=0; i<members.count; i++) {
            ContactInfo *ci = [members objectAtIndex:i];
            [rIDs setObject:ci forKey:[NSString stringWithFormat:@"%@", @(ci.recordID)]];
        }

        NSMutableDictionary *dict = [ContactUtil getAllGroup:NO];
        NSMutableArray *array = [dict objectForKey:gName];
        if ([gName isEqualToString:KEY_ALL_UNGROUP] == YES) {
            if (array != nil) {
                for (NSInteger i = array.count-1; i >= 0; i--) {
                    ContactInfo *ci = [array objectAtIndex:i];
                    if ([rIDs objectForKey:[NSString stringWithFormat:@"%@", @(ci.recordID)]] != nil) {
                        [array removeObjectAtIndex:i];
                    }
                }
            }
        } else if ([gName isEqualToString:KEY_ALL_CONTACT] == YES) {
            if (array != nil) {
                for (NSInteger i = array.count-1; i >= 0; i--) {
                    ContactInfo *ci = [array objectAtIndex:i];
                    if ([rIDs objectForKey:[NSString stringWithFormat:@"%@", @(ci.recordID)]] != nil) {
                        for (int j=0; j<ci.group.count; j++) {
                            NSMutableArray *group = [dict objectForKey:[ci.group objectAtIndex:j]];
                            if (group != nil) {
                                [group removeObject:ci];
                            }
                        }
                        [array removeObjectAtIndex:i];
                    }
                }
                [ContactUtil removeGroup:KEY_ALL_UNGROUP with:members];
            }
        } else {
            // remove it from dict
            if (array != nil) {
                NSMutableArray *ungroup = [dict objectForKey:KEY_ALL_UNGROUP];
                for (NSInteger i = array.count-1; i >= 0; i--) {
                    ContactInfo *ci = [array objectAtIndex:i];
                    if ([rIDs objectForKey:[NSString stringWithFormat:@"%@", @(ci.recordID)]] != nil) {
                        [ci removeGroupInfo:gName];
                        if (ci.group.count == 0) {
                            [ungroup addObject:ci];
                        }
                        [array removeObjectAtIndex:i];
                    }
                }
            }
            // remove it from group
            CFErrorRef err = NULL;
            ABAddressBookRef abab = ABAddressBookCreateWithOptions(NULL, &err);
            NSArray *allGroup = (NSArray *)ABAddressBookCopyArrayOfAllGroups(abab);
            for (int i=0; i<allGroup.count; i++) {
                ABRecordRef group = [allGroup objectAtIndex:i];
                NSString *groupName = ABRecordCopyValue(group, kABGroupNameProperty);
                if ([groupName isEqualToString:gName] == YES) {
                    //
                    NSArray *contacts = (NSArray *)ABGroupCopyArrayOfAllMembers(group);
                    for (NSInteger j = contacts.count-1; j >= 0; j--) {
                        ABRecordRef rec = [contacts objectAtIndex:j];
                        NSInteger rID = ABRecordGetRecordID(rec);
                        if (rID > kABRecordInvalidID) {
                            ContactInfo *ci = [rIDs objectForKey:[NSString stringWithFormat:@"%@", @(rID)]];
                            if (ci != nil) {
                                tf = ABGroupRemoveMember(group, rec,nil);
                            }
                        }
                    }
                    ABAddressBookSave(abab, nil);
                    break;
                }
            }
            CFRelease(abab);
        }
    }
    return tf;
}

+ (void)modifyGroupName:(NSString *)oldName with:(NSString *)newName
{
    NSMutableDictionary *dict = [ContactUtil getAllGroup:NO];
    NSMutableArray *array = [dict objectForKey:oldName];
    if (array != nil && [newName isEqualToString:oldName] == NO) {
        [dict setObject:array forKey:newName];
        [dict removeObjectForKey:oldName];
        //
        NSMutableArray *alls = [dict objectForKey:KEY_ALL_CONTACT];
        for (int i=0; i<alls.count; i++) {
            ContactInfo *ci = [alls objectAtIndex:i];
            if ([ci isBelongToGroup:oldName] == YES) {
                [ci removeGroupInfo:oldName];
                [ci addGroupInfo:newName];
            }
        }
    }
}

+ (void)deleteContact:(NSInteger)recordID
{
    NSMutableDictionary *dict = [ContactUtil getAllGroup:NO];
    NSMutableArray *alls = [dict objectForKey:KEY_ALL_CONTACT];
    for (int i=0; i<alls.count; i++) {
        ContactInfo *ci = [alls objectAtIndex:i];
        if (ci.recordID == recordID) {
            NSMutableArray *group = ci.group;
            for (int j=0; j<group.count; j++) {
                NSString *gName = [group objectAtIndex:j];
                NSMutableArray *array = [dict objectForKey:gName];
                [array removeObject:ci];
            }
            [alls removeObject:ci];
            break;
        }
    }
}

+ (BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT {
	NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
											   range:NSMakeRange(0, searchT.length)];
	if (result == NSOrderedSame)
		return YES;
	else
		return NO;
}

+ (NSInteger)addContactToArray:(NSMutableArray *)array contact:(id)contact key:(NSString *)key
{
    NSInteger insert = 0;
    for (; insert<array.count; insert++) {
        id obj = [array objectAtIndex:insert];
        NSString *name = [obj name];
        NSComparisonResult result = [key compare:name options:NSCaseInsensitiveSearch
                                             range:NSMakeRange(0, name.length)];
        //NSLog(@"%d %@ %@", result, name, key);
        if (result < NSOrderedSame) {
            break;
        }
    }
    if (insert >= array.count) {
        [array addObject:contact];
    } else {
        [array insertObject:contact atIndex:insert];
    }
    return insert;
}

+ (NSIndexPath *)addContact:(ContactInfo *)ci sectionArray:(NSMutableArray *)sectionArray
{
    NSIndexPath *indexPath = nil;
    NSString *string = ci.name;
    NSString *sectionName = nil;
    
    if ([ContactUtil searchResult:string searchText:@"曾"])
        sectionName = @"Z";
    else if ([ContactUtil searchResult:string searchText:@"解"])
        sectionName = @"X";
    else if ([ContactUtil searchResult:string searchText:@"仇"])
        sectionName = @"Q";
    else if ([ContactUtil searchResult:string searchText:@"朴"])
        sectionName = @"P";
    else if ([ContactUtil searchResult:string searchText:@"查"])
        sectionName = @"Z";
    else if ([ContactUtil searchResult:string searchText:@"能"])
        sectionName = @"N";
    else if ([ContactUtil searchResult:string searchText:@"乐"])
        sectionName = @"Y";
    else if ([ContactUtil searchResult:string searchText:@"单"])
        sectionName = @"S";
    else {
        if (string.length > 0) {
            char c = pinyinFirstLetter([string characterAtIndex:0]);
            if (c >= 'a' && c<='z') {
                sectionName = [[NSString stringWithFormat:@"%c", c] uppercaseString];
            } else {
                c = [string characterAtIndex:0];
                if ((c >= 'A' && c<='Z') || (c >= 'a' && c<='z')) {
                    sectionName = [[NSString stringWithFormat:@"%c", c] uppercaseString];
                } else {
                    sectionName = @"#";
                }
            }
        } else {
            sectionName = @"#";
        }
    }
    
    //NSLog(@"idx %d match %@ -> %@ %@", i+1, string, sectionName, [ci.phones objectAtIndex:0]);
    if (string.length > 0) {
        NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
        if (firstLetter != NSNotFound) {
            NSInteger row = [ContactUtil addContactToArray:[sectionArray objectAtIndex:firstLetter] contact:ci key:ci.name];
            indexPath = [NSIndexPath indexPathForRow:row inSection:firstLetter];
        }
    } else {
        NSUInteger firstLetter = 26;
        [[sectionArray objectAtIndex:firstLetter] addObject:ci];
        indexPath = [NSIndexPath indexPathForRow:[[sectionArray objectAtIndex:firstLetter] count]-1 inSection:firstLetter];
    }
    return indexPath;
}

+ (CFStringRef)convertContactTypeToPropertyLabel:(NSString*)label
{
	CFStringRef type;
	
	if ([label isKindOfClass:[NSNull class]] || ![label isKindOfClass:[NSString class]]){
		type = NULL; // no label
	} else {
        NSArray *array = [NSArray arrayWithObjects:(NSString *)kABWorkLabel, (NSString *)kABHomeLabel, (NSString *)kABOtherLabel, (NSString *)kABPersonPhoneMobileLabel, (NSString *)kABPersonPhonePagerLabel, (NSString *)kABPersonInstantMessageServiceAIM, (NSString *)kABPersonInstantMessageServiceICQ, (NSString *)kABPersonInstantMessageServiceMSN, (NSString *)kABPersonInstantMessageServiceYahoo, (NSString *)kABPersonHomePageLabel, nil];
        BOOL isFind = NO;
        for (int i=0; i<array.count; i++) {
            NSString *localLabel = (NSString *)ABAddressBookCopyLocalizedLabel((CFStringRef)[array objectAtIndex:i]);
            if ([label rangeOfString:localLabel].location != NSNotFound) {
                type = (CFStringRef)[array objectAtIndex:i];
                isFind = YES;
                break;
            }
        }
        if (isFind == NO) {
            type = kABOtherLabel;
        }
    }
	return type;
}

+ (BOOL)hasChinese:(NSString *)str
{
    BOOL tf = NO;
    for (int i=0; i<str.length; i++) {
        NSString *sub = [str substringWithRange:NSMakeRange(i, 1)];
        const char *cString = [sub UTF8String];
        if (strlen(cString) == 3) {
            tf = YES;
            break;
        }
    }
    return tf;
}

- (id)init
{
    self = [super init];
    if (self) {
        CFErrorRef  err = NULL;
        ababRef = ABAddressBookCreateWithOptions(NULL, &err);
    }
    return self;
}

- (void)dealloc
{
    CFRelease(ababRef);
    [super dealloc];
}

+ (BOOL)deleteAllContacts:(BOOL)force process:(TransInfo)process
{
    BOOL tf = YES;
    CFErrorRef err = NULL;
    ABAddressBookRef abab = ABAddressBookCreateWithOptions(NULL, &err);
    NSArray *allContact = (NSArray *)ABAddressBookCopyArrayOfAllPeople(abab);
    //
    NSInteger total = allContact.count;
    for (int i=0; i<total; i++) {
        ABRecordRef rec = [allContact objectAtIndex:i];
        tf = ABAddressBookRemoveRecord(abab, rec, nil);
        if (process) {
            process(nil, i, total);
        }
    }
    ABAddressBookSave(abab, nil);
    //
    CFRelease(allContact);
    CFRelease(abab);
    return tf;
}

+ (BOOL)addContacts:(NSArray *)array process:(TransInfo)process
{
    BOOL tf = YES;
    CFErrorRef error;
    CFErrorRef err = NULL;
    ABAddressBookRef abab = ABAddressBookCreateWithOptions(NULL, &err);
    //
    NSInteger total = array.count;
    for (int i=0; i<total; i++) {
        ABRecordRef rec = ABPersonCreate();
        if (rec != nil) {
            ContactInfo *ci = [array objectAtIndex:i];
            if ([ci parseToRec:rec] == YES) {
                ABAddressBookAddRecord(abab, rec, &error);
            }
            CFRelease(rec);
            if (process) {
                process(ci, i, total);
            }
        }
    }
    NSLog(@"ABAddressBookSave start");
    ABAddressBookSave(abab, nil);
    //
    CFRelease(abab);
    NSLog(@"ABAddressBookSave end");
    return tf;
}

@end
