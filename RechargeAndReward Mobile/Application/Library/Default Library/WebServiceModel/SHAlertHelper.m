//
//  SHAlertHelper.m
//  Scan Halal
//
//  Created by Robert Rosiak on 22.05.2013.
//  Copyright (c) 2013 RR Mobile. All rights reserved.
//

#import "SHAlertHelper.h"
#pragma mark Private Classes Definition
@interface __SHAlertDelegate : NSObject<UIAlertViewDelegate>

@property (nonatomic, copy) void (^dismissBlock)(NSInteger buttonIndex);
@end

@interface __SHAlertView : UIAlertView

@property (nonatomic, retain) __SHAlertDelegate *strongDelegate;
@end

#pragma mark Private Classes Implementation
@implementation __SHAlertView

@synthesize strongDelegate = _strongDelegate;
@end

@implementation __SHAlertDelegate

@synthesize dismissBlock = _dismissBlock;

-(void)alertView:(__SHAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (_dismissBlock) {
        _dismissBlock(buttonIndex);
    }
    alertView.strongDelegate = nil;
}
-(void)dealloc
{
    self.dismissBlock = nil;
}
@end

#pragma mark Class Implementation
@implementation SHAlertHelper
#pragma mark Custom alerts
+(UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtons onDismiss:(void(^)(NSInteger buttonIndex)) dismissed
{
    __SHAlertDelegate *delegate = [[__SHAlertDelegate alloc] init];
    delegate.dismissBlock  = dismissed;
    
    __SHAlertView *alert = [[__SHAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    
    for(NSString *buttonTitle in otherButtons) {
        [alert addButtonWithTitle:buttonTitle];
    }
    
    alert.strongDelegate = delegate;
    
    if([NSThread isMainThread])
        [alert show];
    else
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    
    return alert;
}

+(UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle onDismiss:(void(^)(void)) dismissBlock
{
    return [self showAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil onDismiss:^(NSInteger buttonIndex) {
        if (dismissBlock) {
            dismissBlock();
        }
    }];
}

+(UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    return [self showAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil onDismiss:nil];
}

+(UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtons
{
    return [self showAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtons onDismiss:nil];
}

#pragma mark OK alerts

+(UIAlertView* )showOkAlertWithMessage:(NSString *)message
{
    return [self showOkAlertWithTitle:nil message:message];
}

+(UIAlertView*)showOkAlertWithTitle:(NSString *)title message:(NSString *)message
{
    return [self showOkAlertWithTitle:title message:message onDismiss:nil];
}

+(UIAlertView*)showOkAlertWithTitle:(NSString *)title message:(NSString *)message onDismiss:(void(^)(void)) dismissBlock
{
    return [self showAlertWithTitle:title message:message cancelButtonTitle:NSLocalizedString(@"OK",@"OK button caption") onDismiss:dismissBlock];
}

+(UIAlertView*)showOkAlertWithTitle:(NSString *)title andMessage:(NSString *)message andOkBlock:(void(^)(void))okBlock;
{
    __SHAlertDelegate *delegate = [[__SHAlertDelegate alloc] init];
    delegate.dismissBlock  = ^(NSInteger buttonIndex) {
        if (okBlock) {
            okBlock();
        }
    };
    __SHAlertView *alert = [[__SHAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"OK button caption") otherButtonTitles:nil];
    alert.delegate = delegate;
    alert.strongDelegate = delegate;
    if([NSThread isMainThread])
        [alert show];
    else
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    return alert;
}

#pragma mark YES/NO alert

+(UIAlertView *)showYesNoAlertViewWithTitle:(NSString *)title message:(NSString *)message onYes:(void (^)(void))yesBlock onNo:(void (^)(void))noBlock
{
    return [self showAlertWithTitle:title message:message cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:[NSArray arrayWithObject:NSLocalizedString(@"Delete", nil)] onDismiss:^(NSInteger buttonIndex) {
        if (buttonIndex == 0 && noBlock) {
            noBlock();
        } else if (buttonIndex == 1 && yesBlock) {
            yesBlock();
        }
    }];
}

+(UIAlertView *)showOkCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message onOk:(void (^)(void))okBlock onCancel:(void (^)(void))cancelBlock
{
    return [self showAlertWithTitle:title message:message cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:[NSArray arrayWithObject:NSLocalizedString(@"Ok", nil)] onDismiss:^(NSInteger buttonIndex) {
        if (buttonIndex == 0 && cancelBlock) {
            cancelBlock();
        } else if (buttonIndex == 1 && okBlock) {
            okBlock();
        }
    }];
}
@end
