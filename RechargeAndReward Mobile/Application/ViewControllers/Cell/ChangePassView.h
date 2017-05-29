//
//  ChangePassView.h
//  Recharge Reward
//
//  Created by RichMan on 10/11/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePassView : UIView
@property (weak, nonatomic) IBOutlet UITextField *oldpasstextfield,*newpasstextfield,*confirmpasstextfield;
@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIButton *btn_submit;
@property (weak, nonatomic) IBOutlet UIView *roundView1,*roundView2,*roundView3;
+(id)customView;
@end
