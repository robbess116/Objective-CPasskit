//
//  BarcodeUIView.h
//  Recharge Reward
//
//  Created by RichMan on 10/13/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarcodeUIView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *barcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *barcodeNumberLabel;
+(id)customView;
@end
