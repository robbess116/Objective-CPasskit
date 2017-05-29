//
//  forgotPasswordUIView.h
//  RechargeReward
//
//  Created by RichMan on 10/15/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordUIView : UIView
@property (weak, nonatomic) IBOutlet UIView *emailBackgroundView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *view;

+(id)customView;
@end
