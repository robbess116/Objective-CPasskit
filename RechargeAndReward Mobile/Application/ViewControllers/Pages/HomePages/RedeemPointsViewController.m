//
//  RedeemPointsViewController.m
//  Recharge Reward
//
//  Created by RichMan on 9/30/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import "RedeemPointsViewController.h"

@interface RedeemPointsViewController ()<VSDropdownDelegate>{
    VSDropdown *dropdownOAN;
    
    NSString *selectedAccountUrl, *redemptionUrl, *promotionUrl;
    NSNumber *availablePoints;
    NSDictionary *redeem_level, *redeem_level2,*redeem_level3,*redeem_level4;
    NSInteger redeemFlag;
    
}
@property (nonatomic, assign) NSUInteger oanCounts;


@property (weak, nonatomic) IBOutlet UIView *OANBackgroudUIView;
@property (weak, nonatomic) IBOutlet UILabel *OANLabel;
@property (weak, nonatomic) IBOutlet UIButton *OANDropDownButton;
@property (weak, nonatomic) IBOutlet UILabel *availablePointsLabel;
@property (weak, nonatomic) IBOutlet UIView *promocodeBackgroundView;
@property (weak, nonatomic) IBOutlet UITextField *promocodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *redeemButton;
@property (weak, nonatomic) IBOutlet UIButton *xPointsButton1;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *xPointsButton2;
@property (weak, nonatomic) IBOutlet UIButton *xPointsButton3;
@property (weak, nonatomic) IBOutlet UIButton *xPointsButton4;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation RedeemPointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
}

- (void)initView{
    [commonUtils setRoundedRectView:_OANBackgroudUIView withCornerRadius:_OANBackgroudUIView.frame.size.height / 2];
    [commonUtils setRoundedRectView:_promocodeBackgroundView withCornerRadius:_promocodeBackgroundView.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_xPointsButton1 withBorderWidth:1.0 withBorderColor:[UIColor clearColor] withBorderRadius:_xPointsButton1.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_xPointsButton2 withBorderWidth:1.0 withBorderColor:[UIColor clearColor] withBorderRadius:_xPointsButton2.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_xPointsButton3 withBorderWidth:1.0 withBorderColor:[UIColor clearColor] withBorderRadius:_xPointsButton3.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_xPointsButton4 withBorderWidth:1.0 withBorderColor:[UIColor clearColor] withBorderRadius:_xPointsButton4.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_redeemButton withBorderWidth:1.0 withBorderColor:[UIColor clearColor] withBorderRadius:_redeemButton.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_cancelButton withBorderWidth:1.0 withBorderColor:[UIColor clearColor] withBorderRadius:_cancelButton.frame.size.height / 2];
    

    [self initData];
}

- (void)initData{
    
    
    if(_selectedAccountDetails != nil){
        availablePoints = [_selectedAccountDetails objectForKey:@"points_balance"];
        selectedAccountUrl = [_selectedAccountDetails objectForKey:@"url"];
        redemptionUrl = [[SERVER_URL stringByAppendingString:selectedAccountUrl] stringByAppendingString:@"/redemption/"];
        promotionUrl = [[SERVER_URL stringByAppendingString:selectedAccountUrl] stringByAppendingString:@"/instant-promotion/"];
        
    }else{
        
        availablePoints = [[NSNumber alloc] initWithLong:0.00];
        selectedAccountUrl = @"";
        redemptionUrl = nil;
        promotionUrl = nil;
               
    }
    
    
    
    //OAN Dropdownlist init
    dropdownOAN = [[VSDropdown alloc]initWithDelegate:self];
    [dropdownOAN setAdoptParentTheme:YES];
    [dropdownOAN setShouldSortItems:NO];
    dropdownOAN.separatorType = UITableViewCellSeparatorStyleSingleLine;
    
    
    
    _oanCounts = 0;
    [self initPage];
    
    
}

- (void)initPage{
    
    // code here
    
    _availablePointsLabel.text = [availablePoints stringValue];
    if(_redemption_levels != nil){
        redeem_level = [_redemption_levels objectAtIndex:0];
        
        NSString *buttonTitle1 = [[[@"Redeem " stringByAppendingString:[[redeem_level objectForKey:@"points"] stringValue]] stringByAppendingString:@" points for $"] stringByAppendingString:[[redeem_level objectForKey:@"amount"]stringValue]];
        [_xPointsButton1 setTitle:buttonTitle1 forState:UIControlStateNormal];
        
        redeem_level2 = [_redemption_levels objectAtIndex:1];
        NSString *buttonTitle2 = [[[@"Redeem " stringByAppendingString:[[redeem_level2 objectForKey:@"points"]stringValue]] stringByAppendingString:@" points for $"] stringByAppendingString:[[redeem_level2 objectForKey:@"amount"]stringValue]];
        [_xPointsButton2 setTitle:buttonTitle2 forState:UIControlStateNormal];
        
        redeem_level3 = [_redemption_levels objectAtIndex:2];
        NSString *buttonTitle3 = [[[@"Redeem " stringByAppendingString:[[redeem_level3 objectForKey:@"points"]stringValue]] stringByAppendingString:@" points for $"] stringByAppendingString:[[redeem_level3 objectForKey:@"amount"]stringValue]];
        [_xPointsButton3 setTitle:buttonTitle3 forState:UIControlStateNormal];
        
        redeem_level4 = [_redemption_levels objectAtIndex:3];
        NSString *buttonTitle4 = [[[@"Redeem " stringByAppendingString:[[redeem_level4 objectForKey:@"points"]stringValue]] stringByAppendingString:@" points for $"] stringByAppendingString:[[redeem_level4 objectForKey:@"amount"]stringValue]];
        [_xPointsButton4 setTitle:buttonTitle4 forState:UIControlStateNormal];

        
    }
    
    [_OANDropDownButton setTitle:_currentUserSelectedOANName forState:UIControlStateNormal];
    
    
    
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
    
    
    [dropdownOAN setTextColor:appController.appBackgroundColor];
    [dropdownOAN setBackgroundColor:[UIColor whiteColor]];
    
    
    if (dropdownOAN.allowMultipleSelection) {
        [dropdownOAN reloadDropdownWithContents:contents andSelectedItems:[sender.titleLabel.text componentsSeparatedByString:@";"]];
    } else {
        [dropdownOAN reloadDropdownWithContents:contents andSelectedItems:@[@"asf"]];
        
    }
    
}
#pragma mark - VSDropdown Delegate methods.

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];
    appController.oanSelectedCount = index;
    //Call selected account details
    
    _currentUserSelectedOANName = [[_currentUserAccountsMutArr objectAtIndex:index] objectForKey:@"name"];
    selectedAccountUrl = [[_currentUserAccountsMutArr objectAtIndex:index] objectForKey:@"url"];
    redemptionUrl = [[SERVER_URL stringByAppendingString:selectedAccountUrl] stringByAppendingString:@"/redemption/"];
    promotionUrl = [[SERVER_URL stringByAppendingString:selectedAccountUrl] stringByAppendingString:@"/instant-promotion/"];
    NSString *url = [SERVER_URL stringByAppendingString: selectedAccountUrl];
    if(self.isLoading)return;
    [self requestSelectedAccountDetails: url];
    
    
}
#pragma mark - Request Selected Account Details
- (void) requestSelectedAccountDetails:(NSString *)url{
    
    self.isLoading = YES;
    NSLog(@" User Info ==>\n%@", url);
    
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] getDetails:url onSuccess:^(id response){
        
        [JSWaiter HideWaiter];
        NSLog(@"response Data : %@", response);
        self.isLoading = NO;
        
        [self requestSelectedAccountDetailsOver:response];
        
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        
        self.isLoading = NO;
    }];
    
}
- (void)requestSelectedAccountDetailsOver:(NSDictionary *)param{
    if([param objectForKey:@"message"] != nil){
        [commonUtils showVAlertSimple:@"Warning!" body:[param objectForKey:@"message"] duration:1.2f];
    }else{
        _redemption_levels = [param objectForKey:@"redemption_levels"];
        [self reloadAccountDetails:param];
    }
    
    
}

// Function for reloading selected account details
- (void)reloadAccountDetails:(NSDictionary *)selectedAccountDetails{
    
    
    availablePoints = [selectedAccountDetails objectForKey:@"points_balance"];
    
    
    _availablePointsLabel.text = [availablePoints stringValue];
    
    redeem_level = [_redemption_levels objectAtIndex:0];
    NSString *buttonTitle1 = [[[@"Redeem " stringByAppendingString:[[redeem_level objectForKey:@"points"] stringValue]] stringByAppendingString:@" points for $"] stringByAppendingString:[[redeem_level objectForKey:@"amount"]stringValue]];
    [_xPointsButton1 setTitle:buttonTitle1 forState:UIControlStateNormal];
    
    redeem_level2 = [_redemption_levels objectAtIndex:1];
    NSString *buttonTitle2 = [[[@"Redeem " stringByAppendingString:[[redeem_level2 objectForKey:@"points"]stringValue]] stringByAppendingString:@" points for $"] stringByAppendingString:[[redeem_level2 objectForKey:@"amount"]stringValue]];
    [_xPointsButton2 setTitle:buttonTitle2 forState:UIControlStateNormal];
    
    redeem_level3 = [_redemption_levels objectAtIndex:2];
    NSString *buttonTitle3 = [[[@"Redeem " stringByAppendingString:[[redeem_level3 objectForKey:@"points"]stringValue]] stringByAppendingString:@" points for $"] stringByAppendingString:[[redeem_level3 objectForKey:@"amount"]stringValue]];
    [_xPointsButton3 setTitle:buttonTitle3 forState:UIControlStateNormal];
    
    redeem_level4 = [_redemption_levels objectAtIndex:3];
    NSString *buttonTitle4 = [[[@"Redeem " stringByAppendingString:[[redeem_level4 objectForKey:@"points"]stringValue]] stringByAppendingString:@" points for $"] stringByAppendingString:[[redeem_level4 objectForKey:@"amount"]stringValue]];
    [_xPointsButton4 setTitle:buttonTitle4 forState:UIControlStateNormal];
    
    
}
- (IBAction)onClickOANDropdownButton:(id)sender {
    [self showDropDownForButton:sender adContents:[self getNameArray:_currentUserAccountsMutArr] multipleSelection:NO];
}

- (IBAction)onClickRedeemButton:(id)sender {
    if(self.isLoading)return;
    if( promotionUrl != nil){
        if([commonUtils isEmptyString:_promocodeTextField.text]){
            [commonUtils showVAlertSimple:@"Warnning!" body:@"Please enter promocode!" duration:1.8f];
        }else{
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
            [paramDic setObject:_promocodeTextField.text forKey:@"promotion_code"];
            redeemFlag = 2;

            [self requestRedeem:paramDic url:promotionUrl];
            
        }

    }else{
        [commonUtils showVAlertSimple:@"Warnning!" body:@"Please add an account." duration:1.8f];

    }
    
}

- (IBAction)onClickRedeem1Button:(id)sender {
    if(self.isLoading)return;
    if (redemptionUrl != nil ){
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:[redeem_level objectForKey:@"points"] forKey:@"points"];
                [self requestRedeem:paramDic url:redemptionUrl];
    }else{
        [commonUtils showVAlertSimple:@"Warnning!" body:@"Please add an account." duration:1.8f];
    }
    
    
}
- (IBAction)onClickRedeem2Button:(id)sender {
    if(self.isLoading)return;
    if ( redemptionUrl != nil){
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:[redeem_level2 objectForKey:@"points"] forKey:@"points"];
        [self requestRedeem:paramDic url:redemptionUrl];
    }else{
        [commonUtils showVAlertSimple:@"Warnning!" body:@"Please add an account." duration:1.8f];

    }
    
}
- (IBAction)onClickRedeem3Button:(id)sender {
    if(self.isLoading)return;
    if ( redemptionUrl != nil){
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:[redeem_level3 objectForKey:@"points"] forKey:@"points"];
        [self requestRedeem:paramDic url:redemptionUrl];

    }else{
        [commonUtils showVAlertSimple:@"Warnning!" body:@"Please add an account." duration:1.8f];

    }
    
    }
- (IBAction)onClickRedeem4Button:(id)sender {
    if(self.isLoading)return;
    if ( redemptionUrl != nil){
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:[redeem_level4 objectForKey:@"points"] forKey:@"points"];
        [self requestRedeem:paramDic url:redemptionUrl];
    }else{
        [commonUtils showVAlertSimple:@"Warnning!" body:@"Please add an account." duration:1.8f];
        
    }
   
}

#pragma mark - Request Redeem
- (void) requestRedeem:(NSDictionary *)param url:(NSString *)url{
    if(url == nil){
        [commonUtils showVAlertSimple:@"Warnning!" body:@"Please add an account." duration:1.8f];
        return;
    }
    
    self.isLoading = YES;
    NSLog(@" url ==>\n%@", url);
    NSLog(@" request param ==>\n%@", param);


    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] postData:param url:url onSuccess:^(id response){

    [JSWaiter HideWaiter];
    NSLog(@"response Data : %@", response);
    self.isLoading = NO;

    [self requestRedeemOver:response];
    
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        
        self.isLoading = NO;
    }];
    
}
- (void)requestRedeemOver:(NSDictionary *)param{

    NSNumber *newPointsBalance = [param objectForKey:@"new_points_balance"];
    _availablePointsLabel.text = [newPointsBalance stringValue];
    NSString *message = [[@"$" stringByAppendingString:[[param objectForKey:@"net_transaction_amount"] stringValue]] stringByAppendingString:@" has been added to your account"];
     [commonUtils showVAlertSimple:@"Warnning!" body:message duration:1.8f];
    appController.dataChanged = YES;
    appController.transactionChanged = YES;
    [self.navigationController popViewControllerAnimated:true];
    
}

- (IBAction)onClickCancelButton:(id)sender {
    appController.dataChanged = NO;
    [self.navigationController popViewControllerAnimated:true];
}

@end
