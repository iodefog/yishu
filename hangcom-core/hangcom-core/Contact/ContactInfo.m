//
//  ContactInfo.m
//  aqgj_dial
//
//  Created by Sam on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ContactInfo.h"
#import "ContactUtil.h"

@implementation ContactInfo

@synthesize key;
@synthesize name;
@synthesize displayName;
@synthesize phones;
@synthesize email;
@synthesize recordID;
@synthesize rowid;
@synthesize group;
@synthesize imagePath;
@synthesize imageData;
@synthesize selected;
@synthesize reverse1;
@synthesize reverse2;
@synthesize contactSize;

@synthesize fname;
@synthesize lname;
@synthesize sortOrder;
@synthesize trimOper;

- (id)init
{
    self = [super init];
    if (self) {
        phones = [[NSMutableArray alloc] init];
        email = [[NSMutableArray alloc] init];
        group = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithRecord:(ABRecordRef)rec
{
    self = [super init];
    if ([self parseRec:rec] == NO) {
        self = nil;
    } else {
        [self getContactSize];
    }
    return self;
}

- (BOOL)parseRec:(ABRecordRef)rec
{
    BOOL tf = YES;
    ABRecordID rid = ABRecordGetRecordID(rec);
    if (rid != kABRecordInvalidID) {
        recordID = rid;
        name = [[ContactUtil getFName:rec] copy];
        
        [ContactUtil addStr:&fname value:ABRecordCopyValue(rec, kABPersonFirstNameProperty)];
        [ContactUtil addStr:&lname value:ABRecordCopyValue(rec, kABPersonLastNameProperty)];

        ABPersonSortOrdering ordering = ABPersonGetSortOrdering();
        if (ordering == kABPersonSortByLastName) {
            name = [[NSString alloc] initWithFormat:@"%@%@", lname != nil ? lname : @"", fname != nil ? fname : @""];
            displayName = [[NSString alloc] initWithFormat:@"%@ %@", lname != nil ? lname : @"", fname != nil ? fname : @""];
        } else {
            name = [[NSString alloc] initWithFormat:@"%@%@", fname != nil ? fname : @"", lname != nil ? lname : @""];
            displayName = [[NSString alloc] initWithFormat:@"%@ %@", lname != nil ? lname : @"", fname != nil ? fname : @""];
        }
        sortOrder = ordering;

        //
        if (phones == nil) {
            phones = [[NSMutableArray alloc] init];
        }
        ABMultiValueRef values = ABRecordCopyValue(rec, kABPersonPhoneProperty);
        for (int j=0; j<ABMultiValueGetCount(values); j++) {
            NSString *value = (NSString *)ABMultiValueCopyValueAtIndex(values, j);
            //[phones addObject:[ContactUtil formatPhone:value]];
            [phones addObject:value];
            [value release];
        }
        CFRelease(values);
        //
        if (ABPersonHasImageData(rec) == true) {
            if (&ABPersonCopyImageDataWithFormat != NULL) {
                [ContactUtil addData:&imageData value:ABPersonCopyImageDataWithFormat(rec, kABPersonImageFormatThumbnail)];
            } else {
                [ContactUtil addData:&imageData value:ABPersonCopyImageData(rec)];
            }
        }
        if (email == nil) {
            email = [[NSMutableArray alloc] init];
        }
        //获取email多值
        ABMultiValueRef mail = ABRecordCopyValue(rec, kABPersonEmailProperty);
        NSInteger emailcount = ABMultiValueGetCount(mail);
        for (int x = 0; x < emailcount; x++)
        {
            //获取email值
            [email addObject:(NSString*)ABMultiValueCopyValueAtIndex(mail, x)];
        }
        //
        if (group == nil) {
            group = [[NSMutableArray alloc] init];
        }
        reverse1 = nil;
        reverse2 = nil;
    }
    return tf;
}

- (BOOL)parseToRec:(ABRecordRef)rec
{
    BOOL tf = YES;
    CFErrorRef  err = NULL;
    {
        ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for (int i=0; i<phones.count; i++) {
            ABMultiValueAddValueAndLabel(multiValue, (CFTypeRef)[phones objectAtIndex:i], kABPersonPhoneMobileLabel, NULL);
        }
        ABRecordSetValue(rec, kABPersonPhoneProperty, multiValue, &err);
        CFRelease(multiValue);
    }
    {
        ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for (int i=0; i<email.count; i++) {
            ABMultiValueAddValueAndLabel(multiValue, (CFTypeRef)[email objectAtIndex:i], kABWorkLabel, NULL);
        }
        ABRecordSetValue(rec, kABPersonEmailProperty, multiValue, &err);
        CFRelease(multiValue);
    }
    if (imageData != nil) {
        ABPersonSetImageData(rec, (CFDataRef)imageData, &err);
    }
    ABRecordSetValue(rec, kABPersonFirstNameProperty, fname, &err);
    ABRecordSetValue(rec, kABPersonLastNameProperty, lname, &err);
    return tf;
}

- (UIImage *)getImage
{
    if (imageData != nil) {
        return [UIImage imageWithData:imageData];
    } else {
        return nil;
    }
}

- (void)setReverse2:(NSString *)str
{
    reverse2 = str;
}

- (void)addGroupInfo:(NSString *)gName
{
    if ([group containsObject:gName] == NO) {
        [group addObject:gName];
    }
}

- (void)removeGroupInfo:(NSString *)gName
{
    if ([group containsObject:gName] == YES) {
        [group removeObject:gName];
    }
}

- (BOOL)isBelongToGroup:(NSString *)gName
{
    BOOL tf = [group containsObject:gName];
    return tf;
}

- (void)getContactSize
{
    contactSize += name.length;
    contactSize += imageData.length;
    for(int i=0; i<phones.count; i++) {
        contactSize += [[phones objectAtIndex:i] length];
    }
    for(int i=0; i<email.count; i++) {
        contactSize += [[email objectAtIndex:i] length];
    }
}

- (void)dealloc
{
    [key release];
    [name release];
    [phones release];
    [imageData release];
    [email release];
    [group release];
    [reverse1 release];
    [reverse2 release];
    //
    [fname release];
    [lname release];
    [displayName release];
    [super dealloc];
}

-(id)copyWithZone:(NSZone *)zone
{
    ContactInfo *ci = [[ContactInfo alloc] init];
    //
    ci.key = key;
    ci.name = name;
    //
    [ci.phones addObjectsFromArray:phones];
    [ci.email addObjectsFromArray:email];
    [ci.group addObjectsFromArray:group];
    ci.imageData = imageData;
    ci.reverse1 = reverse1;
    ci.reverse2 = reverse2;
    //
    ci.fname = fname;
    ci.lname = lname;
    ci.displayName = displayName;
    //
    ci.recordID = recordID;
    ci.sortOrder = sortOrder;
    ci.selected = selected;
    ci.contactSize = contactSize;
    //
    return ci;
}

@end
