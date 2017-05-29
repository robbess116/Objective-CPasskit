//
//  ChangePassView.m
//  Recharge Reward
//
//  Created by RichMan on 10/11/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import "ChangePassView.h"

@implementation ChangePassView
+(id)customView{
    ChangePassView* customview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                          owner:self
                                        options:nil] objectAtIndex:0];
     
      [commonUtils setRoundedRectView:customview.view withCornerRadius:customview.view.frame.size.height/20];
    [commonUtils setRoundedRectView:customview.roundView1 withCornerRadius:customview.roundView1.frame.size.height/2];
    [commonUtils setRoundedRectView:customview.roundView2 withCornerRadius:customview.roundView2.frame.size.height/2];
    [commonUtils setRoundedRectView:customview.roundView3 withCornerRadius:customview.roundView3.frame.size.height/2];
    [commonUtils setRoundedRectBorderButton:customview.btn_submit withBorderWidth:1 withBorderColor:[UIColor clearColor] withBorderRadius:customview.btn_submit.frame.size.height/2];
    
        return customview;
}

@end
