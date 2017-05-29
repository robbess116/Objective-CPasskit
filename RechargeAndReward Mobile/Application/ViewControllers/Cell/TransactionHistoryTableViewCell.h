//
//  TransactionHistoryTableViewCell.h
//  Recharge Reward
//
//  Created by RichMan on 9/30/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageview;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseLabel;

@end
