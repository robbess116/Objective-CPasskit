//
//  AppController.m
//  WebServiceSample
//
//  Created by RichMan on 10/18/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import "AppController.h"


static AppController *_appController;

@implementation AppController

+ (AppController *)sharedInstance {
    static dispatch_once_t predicate;
    if (_appController == nil) {
        dispatch_once(&predicate, ^{
            _appController = [[AppController alloc] init];
        });
    }
    return _appController;
}

- (id)init {
    self = [super init];
    if (self) {
        
        // Utility Data
        _appMainColor = RGBA(254, 242, 91, 1.0f);
     
        _contactArray = [[NSArray alloc] init];
        
        _vAlert = [[DoAlertView alloc] init];
        _vAlert.nAnimationType = 2;  // there are 5 type of animation
        _vAlert.dRound = 7.0;
        _vAlert.bDestructive = NO;  // for destructive mode
        
        _appBackgroundColor = RGBA(69, 85, 96, 1.0f);
        _appWaiterBackgroudColor = RGBA(255, 255 ,255,0.1f);
        _refundButtonColor = RGBA(199, 204, 207, 1.0f);
        _appTextColor = RGBA(125, 136, 144, 1.0f);
        
        _dataChanged = YES;
        _transactionChanged = NO;
//        _currentUser = nil;
//        _loggedinUserAccounts = nil;
//        _currentUserAccountsDetails = nil;
//        _accountsTransactions = nil;
//        _fundingSourcesDetails = nil;
//        _loggedinUserData =nil;
//        _loggedinUserDetailsData =nil;
//        _firstAccountDetails = nil;
//        _groupList = nil;
        _firstOAN = @"virtual card";

        
    
    }
    return self;
}

@end
