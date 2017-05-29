//
//  AddGroupAndOANUIView.h
//  RechargeReward
//
//  Created by RichMan on 10/26/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddGroupAndOANUIView : UIView
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *groupButton;
@property (weak, nonatomic) IBOutlet UIView *goupButtonBackgroudView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
+(id)customView;
@end
