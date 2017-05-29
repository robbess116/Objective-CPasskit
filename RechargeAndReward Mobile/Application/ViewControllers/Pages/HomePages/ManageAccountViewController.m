//
//  ManageAccountViewController.m
//  Recharge Reward
//
//  Created by RichMan on 9/30/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import "ManageAccountViewController.h"
#import "TransactionHistoryHeaderView.h"
#import "TransactionHistoryTableViewCell.h"
#import "ManageProfileViewController.h"
#import "AddFundingSourceViewController.h"
#import "RequestRefundViewController.h"
#import "AddAccountViewController.h"

@interface ManageAccountViewController ()<VSDropdownDelegate>{
    VSDropdown *dropdownOAN;
    NSInteger selectedIndex;
    Boolean imageViewflag ;
    NSArray *sectionViews;
    ManageProfileViewController* manageProfileVC;
    AddAccountViewController* addAccountVC;
    RequestRefundViewController *requestRefundVC;
    NSMutableArray *purchases;
    NSDictionary *selectedTransaction;
    NSString *selectedAccountUrl;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *accountPulsButton;
@property (weak, nonatomic) IBOutlet UILabel *accountFullNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *OANDropDownButton;
@property (weak, nonatomic) IBOutlet UIView *OANDropDownBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *noTransactionAlertLable;
@property (strong, nonatomic)NSString *currentUserFullNameStr, *currentUserFirstOANName;
@property (strong, nonatomic)NSMutableDictionary *selectedAccountTransactions, *selectedTransactionPurchases, *selectedTransactionRefund;
@property (nonatomic, assign) BOOL isLoading;



@end

@implementation ManageAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_OANDropDownButton setTitle:_currentUserSelectedOANName forState:UIControlStateNormal];
    //OAN Dropdownlist init
    dropdownOAN = [[VSDropdown alloc]initWithDelegate:self];
    [dropdownOAN setAdoptParentTheme:YES];
    [dropdownOAN setShouldSortItems:NO];
    dropdownOAN.separatorType = UITableViewCellSeparatorStyleSingleLine;
    
}
-(void)viewWillAppear:(BOOL)animated{
    selectedIndex = -1;
    [self initView];
    [self initData];
    [self initPage];
    

}

- (void)initView{
    [commonUtils setRoundedRectBorderButton:_editProfileButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_editProfileButton.frame.size.height / 2 ];
    [commonUtils setRoundedRectView:_OANDropDownBackgroundView withCornerRadius:_OANDropDownBackgroundView.frame.size.height/2.0];
    [commonUtils setRoundedRectBorderButton:_cancelButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_cancelButton.frame.size.height / 2 ];

}
- (void)initData{
    imageViewflag = NO;
    _currentUserAccountsMutArr = appController.loggedinUserAccounts;
    _currentUserFullNameStr =[[[appController.loggedinUserDetailsData objectForKey:@"first_name"] stringByAppendingString:@" "] stringByAppendingString:[appController.loggedinUserDetailsData objectForKey:@"last_name"]];
    _selectedAccountTransactions = nil;
//    if(appController.firstAccountDetails != nil){
//        _currentUserFirstOANName = [appController. objectForKey:@"name"];
//        
//    }else{
//        _currentUserFirstOANName = nil;
//        
//    }
    
}

- (void)initPage{
    _accountFullNameLabel.text = _currentUserFullNameStr;
    //[_OANDropDownButton setTitle:_currentUserFirstOANName forState:UIControlStateNormal];
    if(_selectedAccountDetails !=nil){
        selectedAccountUrl = [_selectedAccountDetails objectForKey:@"url"];
        NSString *url =[[SERVER_URL stringByAppendingString:selectedAccountUrl] stringByAppendingString:@"/transactions"];
        //if(appController.dataChanged)
        [self requestSelectedAccountTransactions:url];
    }else{
        _selectedAccountTransactions = nil;
    }

}
#pragma mark - Request Selected Account Transactions
- (void) requestSelectedAccountTransactions:(NSString *)url{
    
    self.isLoading = YES;
    NSLog(@" User Info ==>\n%@", url);
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] getDetails:url onSuccess:^(id response){
    [JSWaiter HideWaiter];
    NSLog(@"response Data : %@", response);
    self.isLoading = NO;
    [self requestSelectedAccountTransactionsOver:response];

    
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        self.isLoading = NO;
    }];
    
}
- (void)requestSelectedAccountTransactionsOver:(NSDictionary *)param{
    
    _selectedAccountTransactions = (NSMutableDictionary*)param;
    NSMutableArray *transactions = [_selectedAccountTransactions objectForKey:@"transactions"];
    if(transactions.count > 0){
        [_noTransactionAlertLable setHidden:YES];
    }else{
        [_noTransactionAlertLable setHidden:NO];
    }
        [appController.accountsTransactions addObject:_selectedAccountTransactions];
        [self.tableView reloadData];

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
    
    [dropdownOAN setDrodownAnimation:rand() % 2];
    
    [dropdownOAN setAllowMultipleSelection:multipleSelection];
    
    [dropdownOAN setupDropdownForView:sender];
    
    [dropdownOAN setShouldSortItems:NO];
    
    [dropdownOAN setBackgroundColor:[UIColor whiteColor]];
    [dropdownOAN setTextColor:appController.appBackgroundColor];
    
    
    if (dropdownOAN.allowMultipleSelection) {
        [dropdownOAN reloadDropdownWithContents:contents andSelectedItems:[sender.titleLabel.text componentsSeparatedByString:@";"]];
    } else {
        [dropdownOAN reloadDropdownWithContents:contents andSelectedItems:@[@"asf"]];
        
    }
    
}
//#pragma mark - VSDropdown Delegate methods.

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
     if(self.isLoading) return;
     UIButton *btn = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];
    
    //Call selected account details
    Boolean flag =  NO;
    for (NSMutableDictionary *dic in appController.accountsTransactions){
        
        if([[dic objectForKey:@"account_id"]isEqualToString:[[_currentUserAccountsMutArr objectAtIndex:index] objectForKey:@"account_id"] ]){
            flag = YES;
            _selectedAccountTransactions = [appController.accountsTransactions objectAtIndex:index];
            break;
        }else{
            continue;
        }
        
    }

    selectedAccountUrl = [[_currentUserAccountsMutArr objectAtIndex:index] objectForKey:@"url"];
    NSString *url = [[SERVER_URL stringByAppendingString: selectedAccountUrl] stringByAppendingString:@"/transactions"];
    [self requestSelectedAccountTransactions: url];
 
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableArray *transactions = [_selectedAccountTransactions objectForKey:@"transactions"];
    return transactions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    
    if (selectedIndex == section) {
        return   purchases.count;
        //[[_selectedTransactionPurchases objectForKey:@"items"] count];
    } else {
        return 0;
    }
}

#pragma mark - Request Selected Account Transaction Purchases
- (void) requestSelectedTransactionPurchases:(NSString *)url{
    
    self.isLoading = YES;
    NSLog(@" User Info ==>\n%@", url);
    
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] getDetails:url onSuccess:^(id response){

    [JSWaiter HideWaiter];
    NSLog(@"response Data : %@", response);
    self.isLoading = NO;

    [self requestSelectedTransactionPurchasesOver:response];
    
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];

        self.isLoading = NO;
    }];
    
}
- (void)requestSelectedTransactionPurchasesOver:(NSDictionary *)param{
    if([param objectForKey:@"message"] != nil){
        [commonUtils showVAlertSimple:@"Warning!" body:[param objectForKey:@"message"] duration:1.8f];
    }else{
         _selectedTransactionPurchases = (NSMutableDictionary*)param;
        purchases = [_selectedTransactionPurchases objectForKey:@"items"] ;
        [self.tableView reloadData];
    }

}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionHistoryTableViewCell* cell = (TransactionHistoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TransactionHistoryTableViewCell"];

    cell.dateLabel.text = [[[_selectedTransactionPurchases objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"description"];
    if([[[[_selectedTransactionPurchases objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue] < 0.0){
        
       cell.priceLabel.text = [NSMutableString stringWithFormat:@"-$%.02f",fabs([[[[_selectedTransactionPurchases objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue])];
        
    }else{
        cell.priceLabel.text = [@"$" stringByAppendingString:[[[[_selectedTransactionPurchases objectForKey:@"items"] objectAtIndex:indexPath.row] objectForKey:@"price"] stringValue]];
    }

    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSMutableArray *transactions = [_selectedAccountTransactions objectForKey:@"transactions"];
    sectionViews = [[NSBundle mainBundle] loadNibNamed:@"TransactionHistoryHeaderView" owner:self options:nil];
    TransactionHistoryHeaderView *headerView = [sectionViews objectAtIndex:0];
    headerView.tag = 10000 + section;
    NSString *date = [[transactions objectAtIndex:section] objectForKey:@"created"];
    headerView.lblTransactionDate.text = [[date componentsSeparatedByString:@" "] objectAtIndex:0];
    headerView.lblTransactionComment.text = [[transactions objectAtIndex:section] objectForKey:@"transaction_type"];
    if([[[transactions objectAtIndex:section] objectForKey:@"transaction_amount"] floatValue] < 0.0){
        
        headerView.lblTransactionTotalAmount.text = [NSMutableString stringWithFormat:@"-$%.02f",fabs([[[transactions objectAtIndex:section] objectForKey:@"transaction_amount"] floatValue])];
        
    }else{
        headerView.lblTransactionTotalAmount.text = [@"$" stringByAppendingString:[[[transactions objectAtIndex:section] objectForKey:@"transaction_amount"] stringValue]];
    }
    if (section == selectedIndex) {
        headerView.showDetailUIImageView.highlighted = YES;
    } else {
        headerView.showDetailUIImageView.highlighted = NO;
    }
    if (![headerView.lblTransactionComment.text isEqualToString:@"Purchase"]){
        headerView.showDetailUIImageView.hidden = YES;
        headerView.btnShowDetail.hidden = YES;
    }
    headerView.btnShowDetail.tag = section;
    [headerView.btnShowDetail addTarget:self action: @selector(onClickedDetailButton:) forControlEvents: UIControlEventTouchUpInside];
    return headerView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSMutableArray *transactions = [_selectedAccountTransactions objectForKey:@"transactions"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    CGRect rect = CGRectMake(130, 5, 150, 30);
    UIButton *btnRefound = [[UIButton alloc] initWithFrame:rect];
    btnRefound.layer.cornerRadius = 15.0;
    btnRefound.clipsToBounds = YES;
    
    [btnRefound setTitle:@"Dispute transaction" forState:UIControlStateNormal];
    btnRefound.backgroundColor = appController.refundButtonColor;
    btnRefound.titleLabel.font = [UIFont fontWithName:@"Malayalam Sangam MN" size:15];
    [btnRefound setTitleColor:appController.appTextColor forState:UIControlStateNormal];
    btnRefound.tag = section;
    [btnRefound addTarget:self action: @selector(onClickRequestRefundButton:) forControlEvents: UIControlEventTouchUpInside];
    
    if(_selectedTransactionPurchases.count > 0){
        if ([[[transactions objectAtIndex:section] objectForKey:@"transaction_type"] isEqualToString: @"Purchase"]){
            if([_selectedTransactionPurchases objectForKey:@"dispute_status"] == nil && [_selectedTransactionPurchases objectForKey:@"refund_transaction_id"] == nil && [_selectedTransactionPurchases objectForKey:@"reversal_transaction_id"] == nil){
//                NSLog(@"dispute===>%@",[_selectedTransactionPurchases objectForKey:@"dispute_status"]);
//                NSLog(@"dispute===>%@",[_selectedTransactionPurchases objectForKey:@"refund_transaction_id"]);
//                NSLog(@"dispute===>%@",[_selectedTransactionPurchases objectForKey:@"reversal_transaction_id"]);
                [view addSubview:btnRefound];
                
            }else{
                CGRect rect = CGRectMake(100, 5, 220, 30);
                UILabel *disputedLabel = [[UILabel alloc] initWithFrame:rect];
                if([_selectedTransactionPurchases objectForKey:@"dispute_status"] != nil){
                    [disputedLabel setText:[@"Dispute " stringByAppendingString:[_selectedTransactionPurchases objectForKey:@"dispute_status"]]];
                }else if([_selectedTransactionPurchases objectForKey:@"refund_transaction_id"] != nil){
                    [disputedLabel setText:@"Transaction has been refunded."];
                }else if([_selectedTransactionPurchases objectForKey:@"reversal_transaction_id"] != nil){
                    [disputedLabel setText:@"Transaction has been reversed."];
                }
                disputedLabel.clipsToBounds = YES;
                [disputedLabel setTextColor:appController.appTextColor];
//                disputedLabel.backgroundColor = appController.refundButtonColor;
                view.backgroundColor = appController.refundButtonColor;
                [view addSubview:disputedLabel];

                
                
            }
            
        }

    }
    
        view.clipsToBounds = YES;
    return view;
}
-(void) onClickRequestRefundButton:(UIButton *) sender{
    
    requestRefundVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestRefundViewController"];
    requestRefundVC.selectedTransaction = selectedTransaction;
    requestRefundVC.selectedItems = purchases;
    requestRefundVC.selectedAccountUrl = selectedAccountUrl;
    
    [self.navigationController pushViewController:requestRefundVC animated:true];
    
    
    
}
#pragma mark - Request Selected Account Transaction Purchases
- (void) requestSelectedTransactionRefund:(NSString *)url{
    
    self.isLoading = YES;
    NSLog(@" User Info ==>\n%@", url);


    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] getDetails:url onSuccess:^(id response){

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
    if([param objectForKey:@"message"] != nil){
        [commonUtils showVAlertSimple:@"Warning!" body:[param objectForKey:@"message"] duration:1.8f];
    }else{
        _selectedTransactionPurchases = (NSMutableDictionary*)param;
    }
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == selectedIndex && imageViewflag) {
        return 45.0;
    } else {
        return 0;
    }
}

- (void) onClickedDetailButton: (UIButton *) sender {
    if(self.isLoading)return;
    selectedIndex = sender.tag;
    TransactionHistoryHeaderView *selectedHeaderView = (TransactionHistoryHeaderView *)[self.view viewWithTag:10000 + selectedIndex];
    if(selectedHeaderView.showDetailUIImageView.highlighted){
 
    selectedIndex = -1;
    [_tableView reloadData];
    }else{
    
        imageViewflag = YES;
        NSMutableArray *transactions = [_selectedAccountTransactions objectForKey:@"transactions"];
        selectedTransaction = [transactions objectAtIndex:selectedIndex];
        NSString *purchaseUrl = [[transactions objectAtIndex:selectedIndex] objectForKey:@"url"];
        NSString *url = [SERVER_URL stringByAppendingString:purchaseUrl];
        [self requestSelectedTransactionPurchases:url];

    }
}

- (IBAction)onClickOANDropdownButton:(id)sender {
    
    [self showDropDownForButton:sender adContents:[self getNameArray:_currentUserAccountsMutArr] multipleSelection:NO];
}


- (IBAction)onClickCancelButton:(id)sender {
    appController.dataChanged = NO;
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)onClickEditProfileButton:(id)sender {
    manageProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ManageProfileViewController"];
    [self.navigationController pushViewController:manageProfileVC animated:true];
}
- (IBAction)onClickAddAccountButton:(id)sender {
    //    [commonUtils showVAlertSimple:@"Warning!" body:@"NO Adding Account Design" duration:1.8f];
    addAccountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
    [self.navigationController pushViewController:addAccountVC animated:true];
}
- (IBAction)onClickRefreshButton:(id)sender {
    NSString *url = [[SERVER_URL stringByAppendingString: selectedAccountUrl] stringByAppendingString:@"/transactions"];
    [self requestSelectedAccountTransactions: url];
}


@end
