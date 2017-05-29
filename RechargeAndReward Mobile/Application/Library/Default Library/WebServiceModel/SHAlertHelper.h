//
//  SHAlertHelper.h
//  Scan Halal
//
//  Created by Robert Rosiak on 22.05.2013.
//  Copyright (c) 2013 RR Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SHAlertHelper : NSObject

/**
 Shows alert with given message
 */
+(UIAlertView*)showOkAlertWithMessage:(NSString*) message;

/**
 Shows alert with given title and message
 */
+(UIAlertView*)showOkAlertWithTitle:(NSString *)title message:(NSString *)message;

/**
 Shows alert with given title, message and OK button
 Provide a dismiss block to handle the user's answer
 */
+(UIAlertView*)showOkAlertWithTitle:(NSString *)title andMessage:(NSString *)message andOkBlock:(void(^)(void))okBlock;

/**
 Shows alert with given title, message and button title
 */
+(UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

/**
 Shows alert with given title, message and buttons
 Provide a dismiss block to handle the user's answer
 */
+(UIAlertView*) showAlertWithTitle:(NSString*) title
                           message:(NSString*) message
                 cancelButtonTitle:(NSString*) cancelButtonTitle
                 otherButtonTitles:(NSArray*) otherButtons
                         onDismiss:(void(^)(NSInteger buttonIndex)) dismissed;

/**
 Shows Yes/No alert with given title, message
 Provide YES and NO blocks to handle the user's answer
 */
+(UIAlertView*) showYesNoAlertViewWithTitle:(NSString*) title
                                    message:(NSString*) message
                                      onYes:(void(^)(void)) yesBlock
                                       onNo:(void(^)(void)) noBlock;

+(UIAlertView *)showOkCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message onOk:(void (^)(void))okBlock onCancel:(void (^)(void))cancelBlock;

@end
