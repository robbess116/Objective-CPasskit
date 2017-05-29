//
//  Config.h
//  Recharge Reward
//
//  Created by RichMan on 9/28/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//


#ifndef Config_h
#define Config_h

#define APP_NAME @"RechargeReward"
#define SERVER_URL @"https://rechargeandreward-cert.bytevampire.com"
//#define SERVER_URL @"http://"
#define API_KEY @"669c567f1878009a05312cb2059b461d"

// Messages

#define MSG_SIGN_IN_FAILED @"There isn't matcted user email"
#define MSG_FILL_FORM_CORRECTLY @"Fill the form correctly."
#define MSG_CHECK_INTERNET_CONNECTION @"Connection Error!\nPlease check your internet connection status."
#define MSG_CONFIRM_SURE @"Are you sure?"

#define MSG_PENDING_EVENT_REQUIRES_PAYMENT @"You have a pending payment for an event that has ended. Please make payment first before sending your next offer."
#define MSG_EVENT_ENDED @"Event has ended successfully."
#define MSG_VERIFY_PAYMENT @"Verify your payment method first."
#define MSG_CANNOT_OFFER_ANOTHER_PENDING @"You cannot make an offer at this time,\nsince you have another\npending offer/event."
#define MSG_VERIFIED_BANK_ACCOUNT @"You have verified your bank account successfully."



// Utility Values
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]
#define M_PI        3.14159265358979323846264338327950288
#define EMAIL_VERIFY_CODE_MAX_LENGTH 4

#define FONT_GOTHAM_NORMAL(s) [UIFont fontWithName:@"GothamRounded-Book" size:s]
#define FONT_GOTHAM_BOLD(s) [UIFont fontWithName:@"GothamRounded-Bold" size:s]

#define FONT_HELVETICA15 [UIFont fontWithName:@"Helvetica" size:15]
#define FONT_HELVETICA10 [UIFont fontWithName:@"Helvetica" size:10]


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6_OR_ABOVE (IS_IPHONE && SCREEN_MAX_LENGTH >= 667.0)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#endif /* Config_h */
