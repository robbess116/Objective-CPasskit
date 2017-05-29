//
//  forgotPasswordUIView.m
//  RechargeReward
//
//  Created by RichMan on 10/15/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import "ForgotPasswordUIView.h"

@implementation ForgotPasswordUIView

+(id)customView{
    ForgotPasswordUIView* customview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                                owner:self
                                                              options:nil] objectAtIndex:0];
    
    [commonUtils setRoundedRectView:customview.view withCornerRadius:customview.view.frame.size.height/20];
    [commonUtils setRoundedRectView:customview.emailBackgroundView withCornerRadius:customview.emailBackgroundView.frame.size.height/2];
    
    [commonUtils setRoundedRectBorderButton:customview.submitButton withBorderWidth:1 withBorderColor:[UIColor clearColor] withBorderRadius:customview.submitButton.frame.size.height/2];
    
    
    return customview;
}

@end
