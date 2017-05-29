//
//  AppController.h
//  WebServiceSample
//
//  Created by RichMan on 10/18/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject

+ (AppController *)sharedInstance;
// Utility Variables
@property (nonatomic, strong) DoAlertView *vAlert;
@property (nonatomic, strong) UIColor *appMainColor;
@property (nonatomic, strong) UIColor *appBackgroundColor;
@property (nonatomic, strong) UIColor *appGradientTopColor, *appGradientBottomColor,*appWaiterBackgroudColor,*refundButtonColor,*appTextColor;

// Phone Contact Array
@property (nonatomic, strong) NSArray *contactArray;
@property (nonatomic, strong) NSMutableDictionary *currentUser, *apnsMessage, *userLoginData, *selectedAccountTransactions;
@property (nonatomic, strong) NSMutableArray* loggedinUserAccounts,*currentUserAccountsDetails, *accountsTransactions, *fundingSourcesDetails;
@property (nonatomic, strong) NSDictionary *loggedinUserData, *loggedinUserDetailsData, *firstAccountDetails, *groupList, *selectedAccountDetails;
@property (nonatomic, strong) NSString *firstOAN, *selectGroupFlag;
@property (nonatomic, assign) NSUInteger oanSelectedCount;
@property (nonatomic, assign) BOOL dataChanged, transactionChanged;




@end
