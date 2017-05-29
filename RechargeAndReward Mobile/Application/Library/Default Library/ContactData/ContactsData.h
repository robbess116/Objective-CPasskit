//
//  ContactsData.h
//  PetBook
//
//  Created by Jose on 1/15/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsData : NSObject
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) NSUInteger contactId;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSMutableArray *phoneNumbers;
@property (strong, nonatomic) NSMutableArray *emails;
@property (assign,nonatomic) BOOL selected;
//-(void) setPhoneNumbers:(NSArray*)phoneNumberArray;
//-(void) setEmails:(NSArray*)emailArray;
@end
