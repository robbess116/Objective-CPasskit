//
//  TransactionHistoryHeaderView.h
//  Recharge Reward
//
//  Created by RichMan on 10/8/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionHistoryHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnShowDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblTransactionDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTransactionComment;
@property (weak, nonatomic) IBOutlet UILabel *lblTransactionTotalAmount;
@property (weak, nonatomic) IBOutlet UIImageView *showDetailUIImageView;

@end
