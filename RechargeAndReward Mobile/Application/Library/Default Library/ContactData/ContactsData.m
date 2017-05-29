//
//  ContactsData.m
//  PetBook
//
//  Created by Jose on 1/15/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//


#import "ContactsData.h"


@implementation ContactsData
//- (id)initWithModel:(NSString *)aModel {
//    self = [super init];
//    if (self) {
//        // Any custom setup work goes here
//        _model = [aModel copy];
//        _odometer = 0;
//    }
//    return self;
//}

- (id)init {
    // Forward to the "designated" initialization method
    self = [super init];
    if (self) {
        self.phoneNumbers = [[NSMutableArray alloc] init];
        self.emails = [[NSMutableArray alloc] init];
        self.selected = NO;
    }
    return self;
    
}

//-(void) setPhoneNumbers:(NSArray*)phoneNumbers{
////    [self.phoneNumbers addObjectsFromArray:phoneNumbers];
//    
//}
//-(void) setEmails:(NSArray *)emails{
////    [self.emails addObjectsFromArray:emails];
//}
@end
