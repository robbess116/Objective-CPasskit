//
//  AddAccountViewController.m
//  RechargeReward
//
//  Created by RichMan on 10/27/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import "AddAccountViewController.h"

@interface AddAccountViewController ()<VSDropdownDelegate>{
    VSDropdown *dropdownGroup,*oanDropdown;
    NSDictionary *selectedGroup;
    NSString *oanStr, *nickNameStr;
    NSMutableArray *currentUserAccountsMutArr;
    NSDictionary *userDetails,*selectedAccoutDic;
    NSString *selectedAccount;
}
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *oanTextField;
@property (weak, nonatomic) IBOutlet UIButton *groupDropdownbutton;
@property (weak, nonatomic) IBOutlet UIButton *cancellButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *nickNameBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *oanBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *groupDropdownBackgroundView;
@property (nonatomic, assign) BOOL isLoading;
@property (weak, nonatomic) IBOutlet UIImageView *cardFlagImageView;
@property (weak, nonatomic) IBOutlet UIButton *cardFlagButton;
@property (weak, nonatomic) IBOutlet UIButton *replaceAccountFlagButton;
@property (weak, nonatomic) IBOutlet UIImageView *replaceFlag;
@property (weak, nonatomic) IBOutlet UIView *oanView;
@property (weak, nonatomic) IBOutlet UIButton *oanButton;
@property (weak, nonatomic) IBOutlet UIView *addAccountView;
@property (weak, nonatomic) IBOutlet UIImageView *addAccountFlagImageView;
@property (weak, nonatomic) IBOutlet UIView *addBackgroudView;
@property (weak, nonatomic) IBOutlet UIView *replaceAccountBacgroundView;
@property (weak, nonatomic) IBOutlet UIView *preBackgroundView;

@end

@implementation AddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
-(void) initView{
    [commonUtils setRoundedRectView:_nickNameBackgroundView withCornerRadius:_nickNameBackgroundView.frame.size.height / 2];
    [commonUtils setRoundedRectView:_oanView withCornerRadius:_oanView.frame.size.height / 2];
    [commonUtils setRoundedRectView:_oanBackgroundView withCornerRadius:_oanBackgroundView.frame.size.height / 2];
    [commonUtils setRoundedRectView:_groupDropdownBackgroundView withCornerRadius:_groupDropdownBackgroundView.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_cancellButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_cancellButton.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_submitButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_submitButton.frame.size.height / 2];
    oanDropdown = [[VSDropdown alloc]initWithDelegate:self];
    [oanDropdown setAdoptParentTheme:YES];
    [oanDropdown setShouldSortItems:NO];
    oanDropdown.separatorType = UITableViewCellSeparatorStyleSingleLine;
    if(_replaceFlag.isHighlighted){
        _oanButton.enabled = YES;
    }else{
        _oanButton.enabled = NO;
    }
    _addAccountFlagImageView.highlighted =YES;
    _oanButton.enabled = NO;
    
    
    userDetails = appController.loggedinUserDetailsData;
    currentUserAccountsMutArr = [userDetails objectForKey:@"accounts"];
    if(currentUserAccountsMutArr.count >0){
        _replaceAccountBacgroundView.hidden = NO;
        _preBackgroundView.hidden = YES;
    }else {
        _replaceAccountBacgroundView.hidden = YES;
        _preBackgroundView.hidden = NO;
    }
    selectedAccount = @"";
    
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
            [oanDropdown setDrodownAnimation:rand() % 2];
        
        [oanDropdown setAllowMultipleSelection:multipleSelection];
        
        [oanDropdown setupDropdownForView:sender];
        
        [oanDropdown setShouldSortItems:NO];
        
        
        [oanDropdown setTextColor:appController.appBackgroundColor];
        [oanDropdown setBackgroundColor:[UIColor whiteColor]];
        
        
        if (oanDropdown.allowMultipleSelection) {
            [oanDropdown reloadDropdownWithContents:contents andSelectedItems:[sender.titleLabel.text componentsSeparatedByString:@";"]];
        } else {
            [oanDropdown reloadDropdownWithContents:contents andSelectedItems:@[@"asf"]];
            
        }
        
    
    
}
#pragma mark - VSDropdown Delegate methods.

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];
    
    selectedAccoutDic = [currentUserAccountsMutArr objectAtIndex:index];
    selectedAccount = str;
    
    
}
- (IBAction)onClickAddNewAccountButton:(id)sender {
    _addAccountFlagImageView.highlighted = YES;
    _replaceFlag.highlighted = NO;
    _cardFlagButton.enabled = YES;
    _oanButton.enabled = NO;
}
- (IBAction)onClickCardFlagButton:(id)sender {
    if(_cardFlagImageView.isHighlighted){
        _cardFlagImageView.highlighted = NO;
        _addAccountView.hidden = NO;
        
    }else{
        _cardFlagImageView.highlighted = YES;
        _addAccountView.hidden = YES;

    }
}
- (IBAction)onClickAccountReplaceButton:(id)sender {
    _addAccountFlagImageView.highlighted = NO;
    _replaceFlag.highlighted = YES;
    _cardFlagButton.enabled = NO;
    _oanButton.enabled = YES;
}
- (IBAction)onClickOANDropdownButton:(id)sender {
    [self showDropDownForButton:sender adContents:[self getNameArray:currentUserAccountsMutArr] multipleSelection:NO];
}
- (IBAction)onClickGroupDropdownbutton:(id)sender {
    if( _groupDropdownbutton.enabled){
        [self showDropDownForButton:sender adContents:[self getGroupNameArray:[appController.groupList objectForKey:@"groups"]] multipleSelection:NO];
    }
    
}
- (IBAction)onClickSubmitButton:(id)sender {
    if(self.isLoading)return;
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    if(_addAccountFlagImageView.isHighlighted){
        if(!_cardFlagImageView.isHighlighted){
            oanStr = _oanTextField.text;
            nickNameStr = _nicknameTextField.text;
            //NSLog(@"First Digits===>%@",[oanStr substringToIndex:1]);
            if(oanStr.length != 14 ){
                [commonUtils showVAlertSimple:@"message" body:@"OAN lenth should be 14 digits!" duration:1.8f];
                return;
            }else if([[oanStr substringToIndex:1] isEqualToString:@"1"] || [[oanStr substringToIndex:1] isEqualToString:@"2"]){
                
            }else{
                [commonUtils showVAlertSimple:@"message" body:@"First digit should be 1 or 2!" duration:1.8f];
                return;
            }
            if(![commonUtils isEmptyString:nickNameStr]){
                [paramDic setObject:nickNameStr forKey:@"nickname"];
            }
            NSString *addAccountUrl = [SERVER_URL stringByAppendingString:@"/account/"];
            
            [paramDic setObject:oanStr forKey:@"alias"];
                //[paramDic setObject:nickNameStr forKey:@"nickname"];
            [paramDic setObject:[appController.loggedinUserDetailsData objectForKey:@"user_id"] forKey:@"user_id"];
            if([appController.loggedinUserDetailsData objectForKey:@"group"] == nil){
                [paramDic setObject:@"randr" forKey:@"group"];
            }else{
                
            }
           
            [self requestAddAccount:paramDic url:addAccountUrl];
                
        }else{
            NSString* url = [SERVER_URL stringByAppendingString:@"/account/"];
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
            [paramDic setObject:[appController.loggedinUserData objectForKey:@"user_id"] forKey:@"user_id"];
            if([appController.loggedinUserDetailsData objectForKey:@"group"] == nil){
                [paramDic setObject:@"randr" forKey:@"group"];
            }else{
                
            }

            [self requestAddAccount:paramDic url:url];
            
        }
        
    }else{
        if(selectedAccoutDic == nil){
           [commonUtils showVAlertSimple:@"message" body:@"Please select an account." duration:1.8f];
            return;
        }else{
            NSString* url = [[SERVER_URL stringByAppendingString:[selectedAccoutDic objectForKey:@"url"]] stringByAppendingString:@"/alias/"];
            oanStr = _oanTextField.text;
            nickNameStr = _nicknameTextField.text;
            //NSLog(@"First Digits===>%@",[oanStr substringToIndex:1]);
            if(oanStr.length != 14 ){
                [commonUtils showVAlertSimple:@"message" body:@"OAN lenth should be 14 digits!" duration:1.8f];
                return;
            }else if([[oanStr substringToIndex:1] isEqualToString:@"1"] || [[oanStr substringToIndex:1] isEqualToString:@"2"]){
                
            }else{
                [commonUtils showVAlertSimple:@"message" body:@"First digit should be 1 or 2!" duration:1.8f];
                return;
            }
            
            [paramDic setObject:oanStr forKey:@"alias"];
            [self requestAddAccount:paramDic url:url];
        }
        
    }
    

}

#pragma mark - Request Add Account:
- (void) requestAddAccount:(NSDictionary *)param url:(NSString *)url{
    
    self.isLoading = YES;
    NSLog(@" Add Group URL ==>\n%@", url);
    NSLog(@"param===>: %@", param);
    
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
    NSString * url = [appController.loggedinUserData objectForKey:@"url"];
    NSString* requestUserDetailsUrl = [SERVER_URL stringByAppendingString:url];
    //request User Details
    if(self.isLoading)return;
    [self requestUserDetails:requestUserDetailsUrl];
  
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
    
    if(_replaceFlag.isHighlighted){
        [commonUtils showVAlertSimple:@"Alert" body:@"Account has been transffered successfully!" duration:1.8];
    }else{
        [commonUtils showVAlertSimple:@"Alert" body:@"Account has been added successfully!" duration:1.8];
        
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)onClickCancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
