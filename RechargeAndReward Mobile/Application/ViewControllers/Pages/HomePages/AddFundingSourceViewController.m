//
//  AddFundingSourceViewController.m
//  Recharge Reward
//
//  Created by RichMan on 9/30/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import "AddFundingSourceViewController.h"
#import "CardIO.h"
#import "HpsTokenService.h"
@interface AddFundingSourceViewController () <CardIOPaymentViewControllerDelegate, UITextFieldDelegate,VSDropdownDelegate>{
    NSString *nickNameStr, *cardNumberStr, *cardTypeStr, *expireStr, *cvvStr, *zipStr,*expireMonth, *expireYear,*last_four;
     VSDropdown *dropdownCardType;
    NSMutableArray *cardTypeMutArr;
    
}
@property (weak, nonatomic) IBOutlet UIView *nickNameTextFieldBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *scanButtonBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *cardTypeDropdownButton;

@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *cvvTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic, assign) BOOL isLoading;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@end

@implementation AddFundingSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CardIOUtilities preload];
}
- (void) initView{
    [commonUtils setRoundedRectView:_nickNameTextFieldBackgroundView withCornerRadius:_nickNameTextFieldBackgroundView.frame.size.height / 2];
    [commonUtils setRoundedRectView:_scanButtonBackgroundView withCornerRadius:_scanButtonBackgroundView.frame.size.height/2];
    [commonUtils setRoundedRectBorderButton:_submitButton withBorderWidth:1 withBorderColor:[UIColor clearColor] withBorderRadius:_submitButton.frame.size.height/2];
    [commonUtils setRoundedRectBorderButton:_cancelButton withBorderWidth:1 withBorderColor:[UIColor clearColor] withBorderRadius:_cancelButton.frame.size.height / 2];
    [_dateTextField addTarget:self
                   action:@selector(dateTextFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
}
-(void)initData{
    cardTypeMutArr = [[NSMutableArray alloc]init];
    [cardTypeMutArr addObject:@{@"name":@"American Express",@"card_type":@"amex"}];
    [cardTypeMutArr addObject:@{@"name":@"Discover",@"card_type":@"discover"}];
    [cardTypeMutArr addObject:@{@"name":@"Mastercard",@"card_type":@"mc"}];
    [cardTypeMutArr addObject:@{@"name":@"Visa",@"card_type":@"visa"}];
    
    
    
    //CardType Dropdownlist init
    dropdownCardType = [[VSDropdown alloc]initWithDelegate:self];
    [dropdownCardType setAdoptParentTheme:YES];
    [dropdownCardType setShouldSortItems:NO];
    dropdownCardType.separatorType = UITableViewCellSeparatorStyleSingleLine;
}
// Function for getting Name array of Reason Dropdown list
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
    
    [dropdownCardType setDrodownAnimation:rand() % 2];
    [dropdownCardType setAllowMultipleSelection:multipleSelection];
    [dropdownCardType setupDropdownForView:sender];
    [dropdownCardType setShouldSortItems:NO];
    [dropdownCardType setTextColor:appController.appBackgroundColor];
    [dropdownCardType setBackgroundColor:[UIColor whiteColor]];
    
    
    if (dropdownCardType.allowMultipleSelection) {
        [dropdownCardType reloadDropdownWithContents:contents andSelectedItems:[sender.titleLabel.text componentsSeparatedByString:@";"]];
    } else {
        [dropdownCardType reloadDropdownWithContents:contents andSelectedItems:@[@"asf"]];
        
    }
    
}
#pragma mark - VSDropdown Delegate methods.

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];
    cardTypeStr = [[cardTypeMutArr objectAtIndex:index] objectForKey:@"card_type"];
    
        
    
}
- (IBAction)onClickCardTypeDropdownButton:(id)sender {
     [self showDropDownForButton:sender adContents:[self getNameArray:cardTypeMutArr] multipleSelection:NO];}

- (IBAction)onClickSubmitButton:(id)sender {
    if(self.isLoading)return;
    nickNameStr = _nickNameTextField.text;
    cardNumberStr = _cardNumberTextField.text;
    if([commonUtils isEmptyString:cardTypeStr])return;
    cardNumberStr = _cardNumberTextField.text;
    
    last_four = [cardNumberStr substringFromIndex:cardNumberStr.length - 4];
    NSLog(@"Last Four===>%@", last_four);
        
    
    expireStr = _dateTextField.text;
    NSArray *items = [expireStr componentsSeparatedByString:@"/"];   //take the one array for split the string
    
    expireMonth=[items objectAtIndex:0];   //shows Description
    expireYear=[@"20" stringByAppendingString:[items objectAtIndex:1]];
    cvvStr = _cvvTextField.text;
    zipStr = _zipTextField.text;
    
    if(nickNameStr.length > 20){
        [commonUtils showVAlertSimple:@"Alert" body:@"Nickname should be 20 at max." duration:1.8f];
    
    }else{
        [self getHeartlandToken];

        
    }

    
}
#pragma mark - Request Add Fundign Source
-(void) requestAddFundingSource:(NSDictionary *)params url:(NSString *)url{
    self.isLoading = YES;
    NSLog(@"User Info==>\n%@", url);

    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] postData:params url:url onSuccess:^(id response){

    [JSWaiter HideWaiter];
    NSLog(@"response Data : %@", response);
    self.isLoading = NO;

    [self requestAddFundingSourceOver:response];
    
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        
        self.isLoading = NO;
    }];
    
    
}

-(void) requestAddFundingSourceOver:(NSDictionary *)param{
    [commonUtils showVAlertSimple:@"message" body:@"Added funding source successfully!" duration:1.8f];
    appController.dataChanged = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)onClickCardScanButton:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.collectPostalCode = YES;
    scanViewController.collectExpiry = YES;
    scanViewController. collectCVV = YES;
    scanViewController.useCardIOLogo = YES;
    scanViewController.hideCardIOLogo = YES;
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:scanViewController animated:YES completion:nil];

    
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    if(self.isLoading)return
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    _cardNumberTextField.text = info.cardNumber;
    _dateTextField.text = [[[@(info.expiryMonth) stringValue] stringByAppendingString:@"/"] stringByAppendingString:[[@(info.expiryYear) stringValue] substringFromIndex:2]];
    _cvvTextField.text = info.cvv;
    _zipTextField.text = info.postalCode;
}
-(void) getHeartlandToken{
    self.isLoading = YES;
    //NSLog(@" User Info ==>\n%@", url);
    
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];

    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:@"pkapi_cert_xXgWdXg6pp9Td1aryg"];
    
    [service getTokenWithCardNumber:cardNumberStr
                                cvc:cvvStr
                           expMonth:expireMonth
                            expYear:expireYear
                   andResponseBlock:^(HpsTokenData *tokenResponse) {
                       
                       if([tokenResponse.type isEqualToString:@"error"]) {
                           [JSWaiter HideWaiter];
                           NSLog(@"response Data : %@", tokenResponse.type);
                           self.isLoading = NO;

                           NSLog(@"%@", tokenResponse.code);
                           NSLog(@"Message=>%@", tokenResponse.message);
                           [commonUtils showVAlertSimple:@"Error!" body:tokenResponse.message duration:1.8f];
                       }
                       else {
                           
                           NSLog(@"Token==>%@", tokenResponse.tokenValue);
                           self.isLoading = NO;
                           NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
                           if(![commonUtils isEmptyString:nickNameStr]){
                                [paramDic setObject:nickNameStr forKey:@"name"];
                           }
                           
                           [paramDic setObject:tokenResponse.tokenValue forKey:@"token"];
                           [paramDic setObject:cardTypeStr forKey:@"card_type"];
                           [paramDic setObject:expireStr forKey:@"expiration"];
                           [paramDic setObject:zipStr forKey:@"zip_code"];
                           [paramDic setObject:last_four forKey:@"last_four"];
                            NSString *addFundUrl = [[appController.loggedinUserData objectForKey:@"url"] stringByAppendingString:@"/funding-source/"];
                           NSString *url = [SERVER_URL stringByAppendingString:addFundUrl];
                           [self requestAddFundingSource:paramDic url:url];
                          
                       }
                       
                   }];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickCancelButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}
#pragma mark - TextField Delegate
- (void) dateTextFieldDidChange: (UITextField *)theTextField {
    
    NSString *string = theTextField.text;
    if(string.length == 1){
        if([string intValue] > 1){
            theTextField.text = [[@"0" stringByAppendingString:string] stringByAppendingString:@"/"];
        }
    }else if (string.length == 2) {
        
        theTextField.text = [string stringByAppendingString:@"/"];
        
    } else if (string.length > 5) {
        
        theTextField.text = [string substringToIndex:5];
        
    }
    
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == _dateTextField){
        if ([string isEqualToString:@""] && textField.text.length == 3) {
            
            NSString *dateString = textField.text;
            textField.text =
            [dateString stringByReplacingOccurrencesOfString:@"/" withString:@""];
            
        }

    }
    
    
    return YES;
}
@end
