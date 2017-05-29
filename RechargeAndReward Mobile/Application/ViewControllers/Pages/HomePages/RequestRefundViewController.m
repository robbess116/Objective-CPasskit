//
//  RequestRefundViewController.m
//  Recharge Reward
//
//  Created by RichMan on 10/1/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import "RequestRefundViewController.h"
#import "RequestRefundTableViewCell.h"
@interface RequestRefundViewController ()<VSDropdownDelegate>{
    VSDropdown *dropdownReason;
    NSMutableArray *refundReasonMutArr, *disputeItems;
    NSNumber *transactionAmounts;
    NSMutableDictionary *paramDic;
    NSString *disputeURL, *reasonStr;
    BOOL selectedAllItemsFlag;
}
@property (weak, nonatomic) IBOutlet UIView *refundReasonDropDownBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *otherReasonTextFieldBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *purchaseSelectImageView;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UILabel *purchaseAmountsLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *otherReasonTextField;
@property (weak, nonatomic) IBOutlet UILabel *transactionType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *reasonDropdownButton;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation RequestRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initData];
    [self initPage];
}
-(void)initView{
    [commonUtils setRoundedRectView:_refundReasonDropDownBackgroundView withCornerRadius:_refundReasonDropDownBackgroundView.frame.size.height / 2];
    [commonUtils setRoundedRectView:_otherReasonTextFieldBackgroundView withCornerRadius:_otherReasonTextFieldBackgroundView.frame.size.height / 2];
    
    [commonUtils setRoundedRectBorderButton:_cancelButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_cancelButton.frame.size.height / 2 ];
    [commonUtils setRoundedRectBorderButton:_submitButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_submitButton.frame.size.height / 2 ];
    

}
-(void)initData{
    
    refundReasonMutArr = [[NSMutableArray alloc]init];
    [refundReasonMutArr addObject:@{@"name":@"Product Not Delivered"}];
    [refundReasonMutArr addObject:@{@"name":@"Duplicate Charge"}];
    [refundReasonMutArr addObject:@{@"name":@"Unknown Transaction"}];
    [refundReasonMutArr addObject:@{@"name":@"Product Quality"}];
    [refundReasonMutArr addObject:@{@"name":@"Other"}];
    
    // Dispute request param
    disputeItems = [[NSMutableArray alloc]init];
    paramDic = [[NSMutableDictionary alloc] init];
    reasonStr = @"";
    
    //Dispute Url
    disputeURL = [[SERVER_URL stringByAppendingString:_selectedAccountUrl] stringByAppendingString:@"/dispute/"];
    NSLog(@"Dispute URL===>%@",disputeURL);
    NSLog(@"transaction====>%@",_selectedTransaction);
    NSLog(@"transaction items====>%@",_selectedItems);

    
    selectedAllItemsFlag = NO;
    
    //OAN Dropdownlist init
    dropdownReason = [[VSDropdown alloc]initWithDelegate:self];
    [dropdownReason setAdoptParentTheme:YES];
    [dropdownReason setShouldSortItems:NO];
    dropdownReason.separatorType = UITableViewCellSeparatorStyleSingleLine;
    [_reasonDropdownButton setTitle:@"Product Not Delivered" forState:UIControlStateNormal];
    reasonStr = @"Product Not Delivered";

}
-(void)initPage{
    _transactionType.text = [_selectedTransaction objectForKey:@"transaction_type"
                             ];
    transactionAmounts = [_selectedTransaction objectForKey:@"transaction_amount"];
    
    if([transactionAmounts floatValue] < 0.0){
        _purchaseAmountsLabel.text = [NSMutableString stringWithFormat:@"-$%.02f",fabs([transactionAmounts floatValue])];
        
        
    }else{
        _purchaseAmountsLabel.text = [@"$" stringByAppendingString:[transactionAmounts stringValue]];
    }
}

// Function for getting Name array of OAN Dropdown list
- (NSMutableArray *)getNameArray:(NSMutableArray *)arr {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for(NSMutableDictionary *dic in arr) {
        [names addObject:[@"" stringByAppendingString:[dic objectForKey:@"name"]]];
    }
    NSLog(@"%@", names);
    return names;
}


// Function for setting dropdown button
- (void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection {
    
    [dropdownReason setDrodownAnimation:rand() % 2];
    
    [dropdownReason setAllowMultipleSelection:multipleSelection];
    
    [dropdownReason setupDropdownForView:sender];
    
    [dropdownReason setShouldSortItems:NO];
    
    [dropdownReason setBackgroundColor:[UIColor whiteColor]];
    [dropdownReason setTextColor:appController.appBackgroundColor];
    
    
    if (dropdownReason.allowMultipleSelection) {
        [dropdownReason reloadDropdownWithContents:contents andSelectedItems:[sender.titleLabel.text componentsSeparatedByString:@";"]];
    } else {
        [dropdownReason reloadDropdownWithContents:contents andSelectedItems:@[@"asf"]];
        
    }
    
}
//#pragma mark - VSDropdown Delegate methods.

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    if(self.isLoading) return;
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];
    if([[[refundReasonMutArr objectAtIndex:index] objectForKey:@"name"] isEqualToString:@"Other"]){
        _otherReasonTextFieldBackgroundView.hidden = NO;
        [_otherReasonTextField becomeFirstResponder];
    }else{
        _otherReasonTextFieldBackgroundView.hidden = YES;
        _otherReasonTextField.text = nil;
       
    }
    reasonStr = [[refundReasonMutArr objectAtIndex:index] objectForKey:@"name"];

    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _selectedItems.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RequestRefundTableViewCell * cell = (RequestRefundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"RequestRefundTableViewCell"];
    cell.brandLabel.text = [[_selectedItems objectAtIndex:indexPath.row] objectForKey:@"description"];
    cell.itemPricelabel.text = [@"$" stringByAppendingString:[[[_selectedItems objectAtIndex:indexPath.row] objectForKey:@"price"] stringValue]];
    cell.itemIconImageView.highlighted = selectedAllItemsFlag;
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   RequestRefundTableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
    cell.itemIconImageView.highlighted = YES;
    [disputeItems addObject:[[_selectedItems objectAtIndex:indexPath.row] objectForKey:@"purchase_item_id"] ];
    
   }
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    RequestRefundTableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
    cell.itemIconImageView.highlighted = NO;
   
    [disputeItems removeObject:[[_selectedItems objectAtIndex:indexPath.row] objectForKey:@"purchase_item_id"]];
   }

- (IBAction)onClickDropdowReasonButton:(id)sender {
    [self showDropDownForButton:sender adContents:[self getNameArray:refundReasonMutArr] multipleSelection:NO];
}
- (IBAction)onClickSubmitButton:(id)sender {
    if(self.isLoading)return;
    if([reasonStr isEqualToString:@"Other"]){
        reasonStr = _otherReasonTextField.text;
        if([commonUtils isEmptyString:reasonStr]){
            [commonUtils showVAlertSimple:@"Message" body:@"Please type refund reason!" duration:1.8f
                ];
            return;
        }
            
    }
    if([commonUtils isEmptyString:reasonStr]){
        [commonUtils showVAlertSimple:@"message" body:@"Please select refund reason!" duration:1.8f];
        return;
        
    }else{
        
        if(_purchaseSelectImageView.highlighted){
            [paramDic setObject:[_selectedTransaction objectForKey:@"transaction_id"] forKey:@"transaction_id"];
            [paramDic setObject:reasonStr forKey:@"reason"];
        }else{
            [paramDic setObject:[_selectedTransaction objectForKey:@"transaction_id"] forKey:@"transaction_id"];
            if(disputeItems.count == 0){
                [commonUtils showVAlertSimple:@"message" body:@"No selected items!" duration:1.8f];
                return;
            }else{
                [paramDic setObject:disputeItems forKey:@"items"];
            }
            
                [paramDic setObject:reasonStr forKey:@"reason"];
          
        }
      
    }
    
    [self requestSelectedTransactionRefund:paramDic url:disputeURL];
    

}

#pragma mark - Request Selected Account Transaction Purchases
- (void) requestSelectedTransactionRefund:(NSMutableDictionary*) param url:(NSString *)url{
    
    self.isLoading = YES;
    NSLog(@" Dispute Url ==>\n%@", url);
    NSLog(@" Parameter ==>\n%@", param);


    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] postData:param url:url onSuccess:^(id response){

        [JSWaiter HideWaiter];
        NSLog(@"response Data : %@", response);
        self.isLoading = NO;

        [self requestSelectedTransactionRefundOver:response];


    } onFailure:^(id error){

        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];

    self.isLoading = NO;
    }];
    
}

- (void)requestSelectedTransactionRefundOver:(NSDictionary *)param{
    
    [commonUtils showVAlertSimple:@"Warnning!" body:@"Refund request has been sent." duration:1.8f];
    appController.dataChanged = YES;
    [self.navigationController popViewControllerAnimated:true];
    
    
}

- (IBAction)onClickTransactionButton:(id)sender {
    selectedAllItemsFlag = !selectedAllItemsFlag;
    _purchaseSelectImageView.highlighted = selectedAllItemsFlag;
    
      [_tableView reloadData];

    
    
}


- (IBAction)onClickCancelButton:(id)sender {
        appController.dataChanged = NO;
        [self.navigationController popViewControllerAnimated:true];
}

@end
