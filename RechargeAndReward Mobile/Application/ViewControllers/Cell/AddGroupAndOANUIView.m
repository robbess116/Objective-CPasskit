//
//  AddGroupAndOANUIView.m
//  RechargeReward
//
//  Created by RichMan on 10/26/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import "AddGroupAndOANUIView.h"

@implementation AddGroupAndOANUIView

+(id)customView{
    AddGroupAndOANUIView * customview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                                      owner:self
                                                              options:nil] objectAtIndex:0];
    [commonUtils setRoundedRectView:customview.contentView withCornerRadius:customview.contentView.frame.size.height / 20];
   
    [commonUtils setRoundedRectView:customview.goupButtonBackgroudView withCornerRadius:customview.goupButtonBackgroudView.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:customview.submitButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:customview.submitButton.frame.size.height / 2];
    
    
    return customview;
}
@end
