//
//  AddValueViewController.m
//  Recharge Reward
//
//  Created by RichMan on 9/29/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import "AddValueViewController.h"
#import "AddFundingSourceViewController.h"

@interface AddValueViewController ()<VSDropdownDelegate>{
    AddFundingSourceViewController *addFundingSourceVC;
    VSDropdown *dropdownFundingSources;
    NSMutableArray *fundingSources, *selectedFundingSource;
    NSDictionary *selectedFundingSourceDetails;
    BOOL recurringActionFlag;
    UITextField *currentTextField;

}
@property (weak, nonatomic) IBOutlet UIImageView *plusUIImageView;
@property (weak, nonatomic) IBOutlet UIView *fundingSourceDropDownBackgroudUIView;
@property (weak, nonatomic) IBOutlet UIButton *fundingSourceDropDownButton;
@property (weak, nonatomic) IBOutlet UILabel *fundingSourceLabel;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIView *amountTextFieldBackgroundUIView;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *oneTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *reccurringButton;
@property (weak, nonatomic) IBOutlet UIImageView *reccurringIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *oneTimeIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *reccurringActionButton;
@property (weak, nonatomic) IBOutlet UIImageView *reccrringActionImageView;
@property (weak, nonatomic) IBOutlet UITextField *reccurringTextField;
@property (weak, nonatomic) IBOutlet UIView *reccurringTextFieldBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *belowTextFieldBackgroudImageView;
@property (weak, nonatomic) IBOutlet UITextField *belowTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation AddValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self initView];
   
    

}
- (void)initView{

    [commonUtils setRoundedRectView:_fundingSourceDropDownBackgroudUIView withCornerRadius:_fundingSourceDropDownBackgroudUIView.frame.size.height / 2];
    [commonUtils setRoundedRectView:_amountTextFieldBackgroundUIView withCornerRadius:_amountTextFieldBackgroundUIView.frame.size.height / 2];
    [commonUtils setRoundedRectView:_reccurringTextFieldBackgroundImageView withCornerRadius:_reccurringTextFieldBackgroundImageView.frame.size.height / 2];
    [commonUtils setRoundedRectView:_belowTextFieldBackgroudImageView withCornerRadius:_belowTextFieldBackgroudImageView.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_cancelButton withBorderWidth:1.0 withBorderColor:[UIColor clearColor] withBorderRadius:_cancelButton.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_submitButton withBorderWidth:1.0 withBorderColor:[UIColor clearColor] withBorderRadius:_submitButton.frame.size.height / 2];

    self.fundingSourceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.fundingSourceLabel.numberOfLines = 0;
    // Url for user details
    NSString * url = [appController.loggedinUserData objectForKey:@"url"];
    NSString* requestUserDetailsUrl = [SERVER_URL stringByAppendingString:url];
    //request User Details
    if(self.isLoading)return;
    if(appController.dataChanged){
       [self requestUserDetails:requestUserDetailsUrl];
    }else{
        [self initData];
    }
    

}
#pragma mark - Request Logged in User Details
-(void)requestUserDetails:(NSString *)url{
    self.isLoading = YES;
    NSLog(@" User Info ==>\n%@", url);
    
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] getDetails:url onSuccess:^(id response){

    NSLog(@"response Data : %@", response);
    self.isLoading = NO;
    [JSWaiter HideWaiter];
    [self requestUserDetailsOver:response];
    
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        
        self.isLoading = NO;
    }];
    
    
    
}
-(void)requestUserDetailsOver:(NSDictionary *)param{
        appController.loggedinUserDetailsData = param;
        appController.loggedinUserAccounts = [param objectForKey:@"accounts"];
        [self initData];
    
}


-(void)initData{
    
    fundingSources = [appController.loggedinUserDetailsData objectForKey:@"funding_sources"];
    selectedFundingSource = nil;
    recurringActionFlag = NO;
    
    //Funding Source Dropdownlist init
    dropdownFundingSources = [[VSDropdown alloc]initWithDelegate:self];
    [dropdownFundingSources setAdoptParentTheme:YES];
    [dropdownFundingSources setShouldSortItems:NO];
    dropdownFundingSources.separatorType = UITableViewCellSeparatorStyleSingleLine;
    [self initPage];

    
}
-(void)initPage{
    [_fundingSourceDropDownButton setTitle:[[fundingSources objectAtIndex:0] objectForKey:@"name"]  forState:UIControlStateNormal];
    _oneTimeIconImageView.highlighted =YES;
    _reccurringIconImageView.highlighted = NO;
    _reccrringActionImageView.highlighted = recurringActionFlag;

    if([fundingSources objectAtIndex:0] != nil){
       
//        NSString *url =[SERVER_URL stringByAppendingString:[[fundingSources objectAtIndex:0] objectForKey:@"url"]];        
//        [self requestSelectedFundingSourceDetails:url];
        selectedFundingSourceDetails = [fundingSources objectAtIndex:0];
        [appController.fundingSourcesDetails addObject:selectedFundingSourceDetails];

    }else{
        selectedFundingSourceDetails = nil;
    }
    
}

#pragma mark - Request Selected Funding Source Details
- (void) requestSelectedFundingSourceDetails:(NSString *)url{
    
    self.isLoading = YES;
    NSLog(@" User Info ==>\n%@", url);
    
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] getDetails:url onSuccess:^(id response){
        
        [JSWaiter HideWaiter];
        NSLog(@"response Data : %@", response);
        self.isLoading = NO;
        
        [self requestSelectedFundingSourceDetailsOver:response];
        
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        self.isLoading = NO;
    }];
    
}
- (void)requestSelectedFundingSourceDetailsOver:(NSDictionary *)param{
    selectedFundingSourceDetails = param;
    [appController.fundingSourcesDetails addObject:selectedFundingSourceDetails];
   
    
}
// Function for getting Name array of Funding Source list
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
    
    [dropdownFundingSources setDrodownAnimation:rand() % 2];
    
    [dropdownFundingSources setAllowMultipleSelection:multipleSelection];
    
    [dropdownFundingSources setupDropdownForView:sender];
    
    [dropdownFundingSources setShouldSortItems:NO];
    
    [dropdownFundingSources setBackgroundColor:[UIColor whiteColor]];
    [dropdownFundingSources setTextColor:appController.appBackgroundColor];
    
    
    if (dropdownFundingSources.allowMultipleSelection) {
        [dropdownFundingSources reloadDropdownWithContents:contents andSelectedItems:[sender.titleLabel.text componentsSeparatedByString:@";"]];
    } else {
        [dropdownFundingSources reloadDropdownWithContents:contents andSelectedItems:@[@"asf"]];
        
    }
    
}
//#pragma mark - VSDropdown Delegate methods.

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    if(self.isLoading) return;
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];
    
//    NSString *selectedAccountUrl = [[fundingSources objectAtIndex:index] objectForKey:@"url"];
//    NSString *url = [SERVER_URL stringByAppendingString: selectedAccountUrl];
//    
//    [self requestSelectedFundingSourceDetails: url];
    selectedFundingSourceDetails = [fundingSources objectAtIndex:index];
    [appController.fundingSourcesDetails addObject:selectedFundingSourceDetails];
    
    
    
}

- (IBAction)onClickDropdownFundingSourceButton:(id)sender {
    [self showDropDownForButton:sender adContents:[self getNameArray:fundingSources] multipleSelection:NO];
}
- (IBAction)onClickOneTimeButton:(id)sender {
    _oneTimeIconImageView.highlighted =YES;
    _reccurringIconImageView.highlighted = NO;
}
- (IBAction)onClickRecurringButton:(id)sender {
    _oneTimeIconImageView.highlighted =NO;
    _reccurringIconImageView.highlighted = YES;
}

- (IBAction)onClickRecurringActionButton:(id)sender {
    recurringActionFlag = !recurringActionFlag;
    _reccrringActionImageView.highlighted = recurringActionFlag;
    _oneTimeIconImageView.highlighted = NO;
    _reccurringIconImageView.highlighted = YES;
}

- (IBAction)onClickPlusButton:(id)sender {
    addFundingSourceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFundingSourceViewController"];
    appController.dataChanged = NO;
    [self.navigationController pushViewController:addFundingSourceVC animated:true];

    
}
- (IBAction)onClickCancelButton:(id)sender {
    appController.dataChanged = NO;
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)onClickSubmitButton:(id)sender {
    if(self.isLoading)return;
    if(_selectedAccountUrl == nil){
        [commonUtils showVAlertSimple:@"Warning!" body:@"Please add an account." duration:1.8f];
    }else{
        //NSDecimalNumber *oneTimeAmount = [NSDecimalNumber decimalNumberWithString:_amountTextField.text];
      
        if(selectedFundingSourceDetails.count > 0){
            if(_oneTimeIconImageView.highlighted){
                NSString *oneTimeAmount = _amountTextField.text;
                NSString * fungingUrl = [[SERVER_URL stringByAppendingString:_selectedAccountUrl] stringByAppendingString:@"/load/"];
                NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
                [param setObject:oneTimeAmount forKey:@"amount"];
                [param setObject:[selectedFundingSourceDetails objectForKey:@"funding_source_id" ] forKey:@"funding_source_id"];
                [self requestAddValue:param url:fungingUrl];
                
            }else{
                NSString *recurringActionStr = @"";
                if(_reccrringActionImageView.highlighted){
                    recurringActionStr = @"top-off";
                }else{
                    recurringActionStr = @"add";
                }
                
                NSString *recuringActionAmount = _reccurringTextField.text;
                NSString *belowAmount = _belowTextField.text;
                NSString *recurringUrl = [[SERVER_URL stringByAppendingString:_selectedAccountUrl] stringByAppendingString:@"/recurring-load/"];
                NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
                [param setObject:recurringActionStr forKey:@"action"];
                [param setObject:recuringActionAmount forKey:@"amount"];
                [param setObject:belowAmount forKey:@"trigger_balance"];
                [param setObject:[selectedFundingSourceDetails objectForKey:@"funding_source_id" ] forKey:@"funding_source_id"];
                [self requestAddValue:param url:recurringUrl];
                
            }

        }else {
            [commonUtils showVAlertSimple:@"Warning!" body:@"Please add a funding source." duration:1.8f];

        }
        
    }
    
}

#pragma mark - Request Add Value
- (void) requestAddValue:(NSDictionary *)param url:(NSString *)url{
    
    self.isLoading = YES;
    NSLog(@" Add Value Info ==>\n%@", param);
    NSLog(@" Add Value URL ==>\n%@", url);


    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] postData:param url:url onSuccess:^(id response){

    [JSWaiter HideWaiter];
    NSLog(@"response Data : %@", response);
    self.isLoading = NO;
    [[KGModal sharedInstance] hide];
    [self requestAddValueOver:response];
    
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        self.isLoading = NO;
    }];
    
}
- (void)requestAddValueOver:(NSDictionary *)param{
        
    [commonUtils showVAlertSimple:@"Alert" body:@"Funds were successfully added to your account." duration:1.8];
    appController.dataChanged = YES;
    appController.transactionChanged = YES;
    [self.navigationController popViewControllerAnimated:true];
    
}
#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([textField isEqual:_amountTextField]){
        _oneTimeIconImageView.highlighted = YES;
        _reccurringIconImageView.highlighted = NO;
    }else if([textField isEqual:_reccurringTextField] || [textField isEqual:_belowTextField]){
        _oneTimeIconImageView.highlighted = NO;
        _reccurringIconImageView.highlighted = YES;
    }
    return YES;
}


@end
