//
//  LandingPageViewController.m
//  Recharge Reward
//
//  Created by RichMan on 9/28/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import "LandingPageViewController.h"
#import "BarcodeUIView.h"
#import "ManageAccountViewController.h"
#import "AddValueViewController.h"
#import "RedeemPointsViewController.h"
#import "AddGroupAndOANUIView.h"
#import <PassKit/PassKit.h>
@interface LandingPageViewController ()<VSDropdownDelegate, PKAddPassesViewControllerDelegate,NSURLConnectionDataDelegate>{
    VSDropdown *dropdownOAN, *dropdownGroup;
    BarcodeUIView *barcodeView;
    ManageAccountViewController *manageAccountVC;
    AddValueViewController *addValueVC;
    RedeemPointsViewController *redeemVC;
    AddGroupAndOANUIView *customView;
    NSString *selectedAccountUrl;
    NSDictionary *selectedAccountDetails,*selectedGroup;
    NSDictionary  *currentUserDetails;
    NSMutableArray *currentUserAccountsMutArr, *redemption_levels;
    NSString *currentUserFirstNameStr, *currentUserFirstOANName,*currentUserSelectedOANName;
    NSNumber *availableBalance, *currentBalance, *availablePoints;
    
    
    NSMutableData * mdata;
    NSURLConnection *connection;
    PKPassLibrary *_passLib;
    PKPass *pass;
 

    
}


@property (nonatomic, assign) NSUInteger oanCounts;

@property (weak, nonatomic) IBOutlet UILabel *welcomLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *manageButton;
@property (weak, nonatomic) IBOutlet UIView *OANBackgroudUIView;
@property (weak, nonatomic) IBOutlet UIButton *OANDropdownButton;
@property (weak, nonatomic) IBOutlet UILabel *availableBalancePriceLabel;
@property (weak, nonatomic) IBOutlet UIView *tapOnCardUIView;
@property (weak, nonatomic) IBOutlet UIView *addToAppleWalletUIView;
@property (weak, nonatomic) IBOutlet UILabel *currentBalancePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *availablePointsValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *addValueButton;
@property (weak, nonatomic) IBOutlet UIButton *redeemButton;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UIButton *addToAppleWalletButton;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation LandingPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dropdownOAN = [[VSDropdown alloc]initWithDelegate:self];
    [dropdownOAN setAdoptParentTheme:YES];
    [dropdownOAN setShouldSortItems:NO];
    dropdownOAN.separatorType = UITableViewCellSeparatorStyleSingleLine;
    //Group Dropdownlist init
    dropdownGroup = [[VSDropdown alloc]initWithDelegate:self];
    [dropdownGroup setAdoptParentTheme:YES];
    [dropdownGroup setShouldSortItems:NO];
    dropdownGroup.separatorType = UITableViewCellSeparatorStyleSingleLine;
     appController.oanSelectedCount = 0;

    
}
-(void)viewWillAppear:(BOOL)animated{
    [self initView];
    
}
- (void)initView{
    

    [commonUtils setRoundedRectBorderButton:_logoutButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_logoutButton.frame.size.height / 2.0];
    [commonUtils setRoundedRectBorderButton:_manageButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_manageButton.frame.size.height / 2.0];
    [commonUtils setRoundedRectView:_OANBackgroudUIView withCornerRadius:_OANBackgroudUIView.frame.size.height / 2.0];
    [commonUtils setRoundedRectBorderButton:_addValueButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_addValueButton.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_redeemButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_redeemButton.frame.size.height / 2];
    customView = [AddGroupAndOANUIView customView];
    [customView.groupButton addTarget:self action:@selector(onClickDropDownGroupButton:) forControlEvents:UIControlEventTouchUpInside];
    [customView.submitButton addTarget:self action:@selector(onClickAddGroupAndOAN:) forControlEvents:UIControlEventTouchUpInside];
    
    availableBalance = [[NSNumber alloc] initWithDouble:0.00];
    currentBalance =  [[NSNumber alloc] initWithDouble:0.00];
    availablePoints = [[NSNumber alloc] initWithLong:0.00];
    currentUserFirstOANName = nil;

    // Url for user details
    NSString * url = [appController.loggedinUserData objectForKey:@"url"];
    NSString* requestUserDetailsUrl = [SERVER_URL stringByAppendingString:url];
   
    //request User Details
    if(self.isLoading)return;
    if(appController.dataChanged){
        [self requestUserDetails:requestUserDetailsUrl];
        
    }else{
        
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
        
        [self requestUserDetailsOver:response];
        
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        
        self.isLoading = NO;
    }];
    
    
    
}
-(void)requestUserDetailsOver:(NSDictionary *)param{
    
        appController.loggedinUserDetailsData = param;
        currentUserFirstNameStr = [param objectForKey:@"first_name"];
        appController.loggedinUserAccounts = [param objectForKey:@"accounts"];
        
        if(appController.loggedinUserAccounts != nil){
            
            NSDictionary *firstAccount = [appController.loggedinUserAccounts objectAtIndex:appController.oanSelectedCount];
            NSString *firstAccountUrl = [firstAccount objectForKey:@"url"];
            if(firstAccountUrl != nil){
                NSString *requestFirstAccountDetailsUrl = [SERVER_URL stringByAppendingString:firstAccountUrl];
                [_OANDropdownButton setTitle:[firstAccount objectForKey:@"name"] forState:UIControlStateNormal];
                //request User Details
                currentUserAccountsMutArr = appController.loggedinUserAccounts;
                if(self.isLoading)return;
                [self requestSelectedAccountDetails:requestFirstAccountDetailsUrl];
            }else{
                [JSWaiter HideWaiter];
                
            }
            
            
        }else{
            //[self initData];

            [JSWaiter HideWaiter];
            
        }
        
        
    
    
}

#pragma mark - Request First Account Details
-(void)requestFirstAccountDetails:(NSString *)url{
    self.isLoading = YES;
    NSLog(@" User Info ==>\n%@", url);
    
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] getDetails:url onSuccess:^(id response){
        
        [JSWaiter HideWaiter];
        NSLog(@"response Data : %@", response);
        self.isLoading = NO;
        
        [self requestFirstAccountDetailsOver:response];
        
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        
        self.isLoading = NO;
    }];
    
    
    
}
-(void)requestFirstAccountDetailsOver:(NSDictionary *)param{
    if([param objectForKey:@"message"] != nil){
        [commonUtils showVAlertSimple:@"Warning!" body:[param objectForKey:@"message"] duration:1.2f];
    }else{
        appController.firstAccountDetails = param;
        appController.selectedAccountDetails = param;
        redemption_levels = [param objectForKey:@"redemption_levels"];
        [self initData];
        
        
    }
    
    
}

- (void)initData{
    currentUserDetails = appController.loggedinUserDetailsData;
    currentUserFirstNameStr = [currentUserDetails objectForKey:@"first_name"];
    currentUserAccountsMutArr = appController.loggedinUserAccounts;
    selectedAccountUrl = [appController.firstAccountDetails objectForKey:@"url"];
    //appController.firstOAN = @"22210000000011";
    if(appController.firstAccountDetails != nil){
        availableBalance = [appController.firstAccountDetails objectForKey:@"available_balance"];
        currentBalance = [appController.firstAccountDetails objectForKey:@"current_balance"];
        availablePoints = [appController.firstAccountDetails objectForKey:@"points_balance"];
        currentUserFirstOANName = [appController.firstAccountDetails objectForKey:@"name"];
        currentUserSelectedOANName =currentUserFirstOANName;
        
    }else{
        availableBalance = [[NSNumber alloc] initWithDouble:0.00];
        currentBalance =  [[NSNumber alloc] initWithDouble:0.00];
        availablePoints = [[NSNumber alloc] initWithLong:0.00];
        currentUserFirstOANName = nil;

    }
    
    
    
//OAN Dropdownlist init
    
    
    
    [self initPage];

    
}

- (void)initPage{
   
        // code here
 
        _welcomLabel.text = [@"Welcome, " stringByAppendingString:currentUserFirstNameStr];
    
    if([availableBalance floatValue] < 0.0){
        _availableBalancePriceLabel.text = [NSMutableString stringWithFormat:@"-$%.02f",fabs([availableBalance floatValue])];
        
        
    }else{
        _availableBalancePriceLabel.text = [@"$" stringByAppendingString:[availableBalance stringValue]];
    }
    
    
    if([currentBalance floatValue] < 0.0){
        _currentBalancePriceLabel.text = [NSMutableString stringWithFormat:@"-$%.02f",fabs([currentBalance floatValue])];
        
        
    }else{
        _currentBalancePriceLabel.text = [@"$" stringByAppendingString:[currentBalance stringValue] ];
    }
            _availablePointsValueLabel.text = [availablePoints stringValue];

//        [_OANDropdownButton setTitle:currentUserFirstOANName forState:UIControlStateNormal];
    
    //get group list
    NSDictionary *group =[currentUserDetails objectForKey:@"group"];
    if(group == nil){
        NSString *url;
        if([appController.firstOAN  isEqual: @"virtual card"]){
            url = [[SERVER_URL stringByAppendingString:[currentUserDetails objectForKey:@"url"]] stringByAppendingString:@"/group?use-virtual-card=yes"];
        }else{
             url= [[[SERVER_URL stringByAppendingString:[currentUserDetails objectForKey:@"url"]] stringByAppendingString:@"/group?alias="] stringByAppendingString:appController.firstOAN];
            [self requestGroupList:url];
        }
       
        
    }
   
    
}

#pragma mark - Request Selected Account Details
- (void) requestGroupList:(NSString *)url{
    
    self.isLoading = YES;
    NSLog(@" Group List Info ==>\n%@", url);
    
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] getDetails:url onSuccess:^(id response){
        
        [JSWaiter HideWaiter];
        NSLog(@"response Data : %@", response);
        self.isLoading = NO;
        
        [self requestGroupListOver:response];
        
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        
        self.isLoading = NO;
    }];
    
}
- (void)requestGroupListOver:(NSDictionary *)param{
    
        appController.groupList = param;
    
        [[KGModal sharedInstance] showWithContentView:customView andAnimated:YES];
   
    
    
    
}
- (void) onClickDropDownGroupButton: (UIButton *) sender{
    [self showDropDownForButton:sender adContents:[self getGroupNameArray:(NSMutableArray *)[appController.groupList objectForKey:@"groups"]] multipleSelection:NO];
     }

-(void) onClickAddGroupAndOAN: (UIButton *) sender{
    if(self.isLoading)return;
    if(selectedGroup == nil){
        [commonUtils showVAlertSimple:@"Message" body:@"Please select your group!" duration:1.8f];
        return;
    }
    //    NSString *url =  [SERVER_URL stringByAppendingString:[currentUserDetails objectForKey:@"url"]];
    NSString *addAccountUrl = [SERVER_URL stringByAppendingString:@"/account/"];

    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    //    [paramDic setObject:[selectedGroup objectForKey:@"needs_auth" ] forKey:@"group"];
    //    [paramDic setObject:[selectedGroup objectForKey:@"code"] forKey:@"auth_code"] ;
    //    [self requestAddGroup:paramDic url:url];
    if([appController.firstOAN isEqualToString:@"virtual card"]){
        [paramDic setObject:[currentUserDetails objectForKey:@"user_id"] forKey:@"user_id"];
        [paramDic setObject:[selectedGroup objectForKey:@"code" ] forKey:@"group"];

    }else{
        [paramDic setObject:appController.firstOAN forKey:@"alias"];
        [paramDic setObject:[currentUserDetails objectForKey:@"user_id"] forKey:@"user_id"];
        [paramDic setObject:[selectedGroup objectForKey:@"code" ] forKey:@"group"];
    }
    
    //[paramDic setObject:[selectedGroup objectForKey:@"code"] forKey:@"auth_code"] ;

    [self requestAddAccount:paramDic url:addAccountUrl];



}


#pragma mark - Request Add Account:
- (void) requestAddAccount:(NSDictionary *)param url:(NSString *)url{
    
    self.isLoading = YES;
    NSLog(@" Add Group URL ==>\n%@", url);
    
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] postData:param url:url onSuccess:^(id response){
        
        [JSWaiter HideWaiter];
        NSLog(@"response Data : %@", response);
        self.isLoading = NO;
        
        [self requestAddAccountOver:response];
        
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        
        self.isLoading = NO;
    }];
    
}

- (void)requestAddAccountOver:(NSDictionary *)param{
    [[KGModal sharedInstance] hideAnimated:YES];
    [self initView];
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

// Function for getting Name array of OAN Dropdown list
- (NSMutableArray *)getGroupNameArray:(NSMutableArray *)arr {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for(NSMutableDictionary *dic in arr) {
        [names addObject:[@"" stringByAppendingString:[dic objectForKey:@"code"]]];
    }
    NSLog(@"%@", names);
    return names;
}
// Function for setting dropdown button
- (void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection {
    if([sender isEqual:_OANDropdownButton]){
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

    }else if([sender isEqual:customView.groupButton]){
        [dropdownGroup setDrodownAnimation:rand() % 2];
        
        [dropdownGroup setAllowMultipleSelection:multipleSelection];
        
        [dropdownGroup setupDropdownForView:sender];
        
        [dropdownGroup setShouldSortItems:NO];
        
        
        [dropdownGroup setTextColor:appController.appBackgroundColor];
        [dropdownGroup setBackgroundColor:[UIColor whiteColor]];
        
        
        if (dropdownGroup.allowMultipleSelection) {
            [dropdownGroup reloadDropdownWithContents:contents andSelectedItems:[sender.titleLabel.text componentsSeparatedByString:@";"]];
        } else {
            [dropdownGroup reloadDropdownWithContents:contents andSelectedItems:@[@"asf"]];
            
        }

    }
    
    
}
#pragma mark - VSDropdown Delegate methods.

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];

    if([dropDown isEqual:dropdownOAN]){
        
        //Call selected account details
        
        currentUserSelectedOANName = [[currentUserAccountsMutArr objectAtIndex:index] objectForKey:@"name"];
        selectedAccountUrl = [[currentUserAccountsMutArr objectAtIndex:index] objectForKey:@"url"];
        NSString *url = [SERVER_URL stringByAppendingString: selectedAccountUrl];
        appController.oanSelectedCount = index;
        if(self.isLoading)return;
        [self requestSelectedAccountDetails: url];
        

    }else if([dropDown isEqual:dropdownGroup]){
        selectedGroup = [[appController.groupList objectForKey:@"groups"] objectAtIndex:index];
    }
    
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
        [commonUtils showVAlertSimple:@"Warning!" body:[param objectForKey:@"message"] duration:1.8f];
            }else{
                selectedAccountDetails = param;
                appController.selectedAccountDetails = param;
                redemption_levels = [param objectForKey:@"redemption_levels"];
       
        [self reloadAccountDetails:param];
    }
    
    
}

// Function for reloading selected account details
- (void)reloadAccountDetails:(NSDictionary *)param{
    _welcomLabel.text = [@"Welcome, " stringByAppendingString:currentUserFirstNameStr];
    availableBalance = [param objectForKey:@"available_balance"];
    currentBalance = [param objectForKey:@"current_balance"];
    availablePoints = [param objectForKey:@"points_balance"];
    
    if([availableBalance floatValue] < 0.0){
        _availableBalancePriceLabel.text = [NSMutableString stringWithFormat:@"-$%.02f",fabs([availableBalance floatValue])];

        
    }else{
          _availableBalancePriceLabel.text = [NSMutableString stringWithFormat:@"$%.02f",fabs([availableBalance floatValue])];
    }
    
    
    if([currentBalance floatValue] < 0.0){
         _currentBalancePriceLabel.text = [NSMutableString stringWithFormat:@"-$%.02f",fabs([currentBalance floatValue])];
        
        
    }else{
         _currentBalancePriceLabel.text = [NSMutableString stringWithFormat:@"$%.02f",fabs([currentBalance floatValue])];
    }
    currentUserFirstOANName = [param objectForKey:@"name"];
    currentUserSelectedOANName =currentUserFirstOANName;
    selectedAccountUrl = [param objectForKey:@"url"];
    _availablePointsValueLabel.text = [availablePoints stringValue];
//    [_OANDropdownButton setTitle:[param objectForKey:@"name"] forState:UIControlStateNormal];
    
}
- (IBAction)onClickOANDropdownButton:(id)sender {
       [self showDropDownForButton:sender adContents:[self getNameArray:currentUserAccountsMutArr] multipleSelection:NO];
}

- (IBAction)onClickLogoutButton:(id)sender {

    appController.currentUser = nil;
    appController.loggedinUserAccounts = nil;
    appController.currentUserAccountsDetails = nil;
    appController.accountsTransactions = nil;
    appController.fundingSourcesDetails = nil;
    appController.loggedinUserData =nil;
    appController.loggedinUserDetailsData =nil;
    appController.firstAccountDetails = nil;
    appController.groupList = nil;
    appController.firstOAN = @"virtual card";
    appController.dataChanged = YES;
    appController.transactionChanged = NO;
    appController.oanSelectedCount = 0;
    appController.selectedAccountTransactions = nil;
    appController.selectedAccountDetails = nil;
    [commonUtils removeUserDefault:@"login_flag"];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onClickManageButton:(id)sender {
    manageAccountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ManageAccountViewController"];
    manageAccountVC.currentUserAccountsMutArr = currentUserAccountsMutArr;
    manageAccountVC.currentUserSelectedOANName = currentUserSelectedOANName;
    manageAccountVC.selectedAccountDetails = appController.selectedAccountDetails;
    NSLog(@"selectedAccountDetails===>%@", appController.selectedAccountDetails);
    [self.navigationController pushViewController:manageAccountVC animated:YES];
}
- (IBAction)onClickCardButton:(id)sender {
    UIImage *barcodeImage=[[UIImage alloc] init];
    NSString *str = currentUserSelectedOANName;
    if(str !=nil ){
        barcodeImage = [commonUtils generateBarcode128:currentUserSelectedOANName];
    }else{
        str = nil;
        barcodeImage = [commonUtils generateBarcode128:nil];
    }
    [self showBarcodeImage:barcodeImage];
}
-(void)showBarcodeImage:(UIImage *)image{
    barcodeView = [BarcodeUIView customView];
    barcodeView.barcodeImageView.image = image;
    barcodeView.barcodeNumberLabel.text = currentUserSelectedOANName;
    
    [[KGModal sharedInstance] showWithContentView:barcodeView andAnimated:YES];
}

- (IBAction)onClickAddToAppleWalletButton:(id)sender {
    if(self.isLoading)return;
    if(selectedAccountUrl == nil){
        [commonUtils showVAlertSimple:@"Warning!" body:@"Please add your account!" duration:1.8f];
       return;
    }
    NSString *url = [[SERVER_URL stringByAppendingString:selectedAccountUrl] stringByAppendingString:@"/wallet/"];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
    [paramDic setObject:@"apple" forKey:@"wallet_type"];
    [paramDic setObject:@"false" forKey:@"send_email"];
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [self httpJsonRequest:url withJSON:paramDic];
   
    
    
}

- (void) httpJsonRequest:(NSString *) urlStr withJSON:(NSMutableDictionary *)params {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *body = [[SBJsonWriter new] stringWithObject:params];
    NSData *requestData = [body dataUsingEncoding:NSASCIIStringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/vnd.apple.pkpass" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; version=1.0" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES ];
    
   }
// NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    mdata = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mdata appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{   [JSWaiter HideWaiter];
    self.isLoading = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"filename"];
    NSLog(@"file path===>%@", filePath);
   
    [mdata writeToFile:filePath atomically:YES];
    [self showPassBook:filePath];
}



- (void)showPassBook:(NSString *)param{
    
        if(![PKPassLibrary isPassLibraryAvailable]) {
                [commonUtils showAlert:@"Pass Library Error" withMessage:@"The Pass Library is not available."];
            return;
        }
    
        //load  boardingPass.pkpass from resource bundle
        NSString *passPath = param;
        NSData *data = [NSData dataWithContentsOfFile:passPath];
        NSError *error;
    
        pass = [[PKPass alloc] initWithData:data error:&error];
    
        if (error!=nil) {
    
            [commonUtils showAlert:@"Passes error" withMessage:[error localizedDescription]];
            return;
        }
    
        if(pass){
            //init a pass library
            _passLib = [[PKPassLibrary alloc] init];
    
            //check if pass library contains this pass already
            if([_passLib containsPass:pass]) {
    
                //pass already exists in library, show an error message
    
                [commonUtils showAlert:@"Pass Exists" withMessage:@"The pass you are trying to add to Passbook is already present."];
    
            } else {
    
                //present view controller to add the pass to the library
                PKAddPassesViewController *addPassViewController = [[PKAddPassesViewController alloc] initWithPass:pass];
                [addPassViewController setDelegate:(id)self];
                [self presentViewController:addPassViewController animated:YES completion:nil];
            }
        }
    

    
        
}

#pragma mark - PKAddPassesViewController delegate
-(void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller {
    
    [controller dismissViewControllerAnimated:YES completion:^{
        if([_passLib containsPass:pass]) {

            [commonUtils showAlert:@"Pass Added" withMessage:@"Your pass added to wallet successfully."];
        }
    }];
    
}

- (IBAction)onClickAddValueButton:(id)sender {

       
    addValueVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddValueViewController"];
    addValueVC.selectedAccountUrl = selectedAccountUrl;
    appController.dataChanged = NO;
    
    [self.navigationController pushViewController:addValueVC animated:YES];
}
- (IBAction)onClickRedeemButton:(id)sender {
    redeemVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RedeemPointsViewController"];
    redeemVC.currentUserAccountsMutArr = currentUserAccountsMutArr;
    redeemVC.currentUserSelectedOANName = currentUserSelectedOANName;
    redeemVC.selectedAccountDetails = selectedAccountDetails;
    redeemVC.redemption_levels = redemption_levels;
    [self.navigationController pushViewController:redeemVC animated:YES];
}
@end
