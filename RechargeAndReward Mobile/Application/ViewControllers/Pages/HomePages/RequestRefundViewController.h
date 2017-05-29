//
//  RequestRefundViewController.h
//  Recharge Reward
//
//  Created by RichMan on 10/1/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestRefundViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSDictionary *selectedTransaction;
@property (nonatomic, assign) NSMutableArray *selectedItems;
@property (nonatomic, assign) NSString *selectedAccountUrl;


@end
