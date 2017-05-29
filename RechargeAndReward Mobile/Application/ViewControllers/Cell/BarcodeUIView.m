//
//  BarcodeUIView.m
//  Recharge Reward
//
//  Created by RichMan on 10/13/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import "BarcodeUIView.h"

@implementation BarcodeUIView

+(id)customView{
    BarcodeUIView* barcodeView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                                owner:self
                                                              options:nil] objectAtIndex:0];
    //barcodeView.barcodeImageView = [[UIImageView alloc]init];
    [commonUtils setRoundedRectView:barcodeView withCornerRadius:barcodeView.frame.size.height / 20];
    return barcodeView;
}

@end
