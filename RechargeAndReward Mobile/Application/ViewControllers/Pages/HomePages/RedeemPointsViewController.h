//
//  RedeemPointsViewController.h
//  Recharge Reward
//
//  Created by RichMan on 9/30/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedeemPointsViewController : UIViewController
    @property (nonatomic, assign) NSString *currentUserSelectedOANName;
    @property (nonatomic, assign) NSDictionary *selectedAccountDetails;
    @property (nonatomic, assign) NSMutableArray *currentUserAccountsMutArr;
    @property (nonatomic, assign) NSMutableArray * redemption_levels;
@end
