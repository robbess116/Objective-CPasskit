//
//  ManageProfileViewController.m
//  Recharge Reward
//
//  Created by RichMan on 9/29/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import "ManageProfileViewController.h"

#import "ChangePassView.h"
@interface ManageProfileViewController ()<UITextFieldDelegate,VSDropdownDelegate>{
   
    NSDictionary * currentUserDetails;
    NSMutableArray *charites;
    VSDropdown *dropdownCharities;
    ChangePassView* customView;
    
}

@property (nonatomic, assign) NSUInteger charitiesCounts;

@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTestField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *charitiesButton;

@property (weak, nonatomic) IBOutlet UIButton *groupDropButton;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;

@property (nonatomic, assign) BOOL isLoading;
@end

@implementation ManageProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initData];
    
}
- (void)initView{
    [commonUtils setRoundedRectBorderButton:_changePasswordButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_changePasswordButton.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_submitButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_submitButton.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_cancelButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_cancelButton.frame.size.height / 2];
    
    // Get Charities
    NSString *url = [SERVER_URL stringByAppendingString:@"/charity/"];
    [self requestCharities:url];
//    [_firstNameTextField addTarget:self
//                       action:@selector(firstNameTextFieldDidChange:)
//             forControlEvents:UIControlEventEditingChanged];
//    [_lastNameTestField addTarget:self
//                       action:@selector(firstNameTextFieldDidChange:)
//             forControlEvents:UIControlEventEditingChanged];

    

}
- (void)initData{
    currentUserDetails = appController.loggedinUserDetailsData;
    [self initPage];
    
}
- (void)initPage{
    _fullNameLabel.text = [[[appController.loggedinUserDetailsData objectForKey:@"first_name"] stringByAppendingString:@" "] stringByAppendingString:[appController.loggedinUserDetailsData objectForKey:@"last_name"]];
    _firstNameTextField.text = [currentUserDetails objectForKey:@"first_name"];
    _lastNameTestField.text = [currentUserDetails objectForKey:@"last_name"];
    _emailTextField.text = [currentUserDetails objectForKey:@"email"];
    _mobilePhoneNumberTextField.text = [currentUserDetails objectForKey:@"mobile_phone"];

    [_groupDropButton setTitle:[[currentUserDetails objectForKey:@"group"] objectForKey:@"name"]  forState:UIControlStateNormal];
    [_charitiesButton setTitle:[[currentUserDetails objectForKey:@"charity"] objectForKey:@"name"] forState:UIControlStateNormal];

    
}
#pragma mark - Request Selected Account Details
- (void) requestCharities:(NSString *)url{
    
    self.isLoading = YES;
    NSLog(@" Charities Info ==>\n%@", url);
    
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] getDetails:url onSuccess:^(id response){
        
        [JSWaiter HideWaiter];
        NSLog(@"response Data : %@", response);
        self.isLoading = NO;
        
        [self requestCharitiesOver:response];
        
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        
        self.isLoading = NO;
    }];
    
}
- (void)requestCharitiesOver:(NSDictionary *)param{
    
        charites = [param objectForKey:@"charities"];
    //Charities Dropdownlist init
    dropdownCharities = [[VSDropdown alloc]initWithDelegate:self];
    [dropdownCharities setAdoptParentTheme:YES];
    [dropdownCharities setShouldSortItems:NO];
    dropdownCharities.separatorType = UITableViewCellSeparatorStyleSingleLine;
    _charitiesCounts = 0;
    
    
    
}

// Function for getting Name array of CharitiesDropdown list
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
    
    [dropdownCharities setDrodownAnimation:rand() % 2];
    
    [dropdownCharities setAllowMultipleSelection:multipleSelection];
    
    [dropdownCharities setupDropdownForView:sender];
    
    [dropdownCharities setShouldSortItems:NO];
    
    
    [dropdownCharities setTextColor:appController.appBackgroundColor];
    [dropdownCharities setBackgroundColor:[UIColor whiteColor]];
    
    
    if (dropdownCharities.allowMultipleSelection) {
        [dropdownCharities reloadDropdownWithContents:contents andSelectedItems:[sender.titleLabel.text componentsSeparatedByString:@";"]];
    } else {
        [dropdownCharities reloadDropdownWithContents:contents andSelectedItems:@[@"asf"]];
        
    }
    
}
#pragma mark - VSDropdown Delegate methods.

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];
    
}
- (IBAction)onClickDropdownCharities:(id)sender {
    if([[currentUserDetails objectForKey:@"edit_charity"] boolValue]){
        [self showDropDownForButton:sender adContents:[self getNameArray:charites] multipleSelection:NO];
    }
        else{
        _charitiesButton.enabled = NO;
         
    }

    }



- (IBAction)onClickCancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)onClickSubmitButton:(id)sender {
    if(self.isLoading)return;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *firstName = _firstNameTextField.text;
    NSString *lastName = _lastNameTestField.text;
    NSString *email = _emailTextField.text;
    NSString *userUrl =  [currentUserDetails objectForKey:@"url"];
    NSString *url = [SERVER_URL stringByAppendingString:userUrl];
    NSString *mobilePhone = _mobilePhoneNumberTextField.text;
    if(![commonUtils validateEmail:email]){
        [commonUtils showVAlertSimple:@"Warnning" body:@"Email address is not in a vaild format" duration:1.8];
        return;
    }
        
       
    if([firstName isEqualToString:[appController.loggedinUserDetailsData objectForKey:@"first_name"]]){
        
    }else {
        [paramDic setObject:firstName forKey:@"first_name"];
    }
    if([lastName isEqualToString:[appController.loggedinUserDetailsData objectForKey:@"last_name"]]){
        
    }else {
        [paramDic setObject:lastName forKey:@"last_name"];
    }
    if([email isEqualToString:[appController.loggedinUserDetailsData objectForKey:@"email"]]){
        
    }else {
        [paramDic setObject:email forKey:@"email"];
    }
    if([commonUtils isEmptyString:mobilePhone]){
        
    } else if (![mobilePhone isEqualToString:[appController.loggedinUserData objectForKey:@"mobile_phone"]]){
        [paramDic setObject:mobilePhone forKey:@"mobile_phone"];
    }
    
    

    if([paramDic count] != 0   ){
        [self requestEditProfile:paramDic url:url];
    }else{
        [commonUtils showVAlertSimple:@"Warnning!" body:@"No changed user data!" duration:1.8f];
    }
        
            
    
    
   
}
#pragma mark - Request EditProfile
- (void) requestEditProfile:(NSDictionary *)param url:(NSString *)url{
    
    self.isLoading = YES;
    NSLog(@" User Info ==>\n%@", param);
    
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] patchData:param url:url onSuccess:^(id response){

    
    NSLog(@"response Data : %@", response);
    self.isLoading = NO;

    [self requestEditProfileOver:response];

    
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];

        self.isLoading = NO;
    }];
    
}
- (void)requestEditProfileOver:(NSDictionary *)param{
    if([param objectForKey:@"message"] != nil){
        [commonUtils showVAlertSimple:@"Warning!" body:[param objectForKey:@"message"] duration:1.8f];
    }else{
        //appController.loggedinUserData = param;
       
        
        NSString * url = [param objectForKey:@"url"];
        NSString* requestUserDetailsUrl = [SERVER_URL stringByAppendingString:url];
        //request User Details
        if(self.isLoading)return;
        [self requestUserDetails:requestUserDetailsUrl];
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
    [self initData];
    [commonUtils showVAlertSimple:@"Alert" body:@"Profile has been modified successfully!" duration:1.8];
    
}

- (IBAction)onClickChangePassword:(id)sender {
    customView = [ChangePassView customView];
    [customView.btn_submit addTarget:self action:@selector(changepasssubmit) forControlEvents:UIControlEventTouchUpInside];
     [[KGModal sharedInstance] showWithContentView:customView andAnimated:YES];
}
-(void)changepasssubmit{
    NSLog(@"%@",customView.oldpasstextfield);
    NSString *oldPassword = customView.oldpasstextfield.text;
    NSString *newPassword = customView.newpasstextfield.text;
    NSString *confirmPassword = customView.confirmpasstextfield.text;
    if(self.isLoading)return;
    if([newPassword isEqualToString:oldPassword]){
        [commonUtils showAlert:@"Warning" withMessage:@"New and old password should not be the same!"];
    }else{
        
        if([newPassword isEqualToString:confirmPassword]){
            if(newPassword.length > 8){
                NSMutableDictionary* paramDic = [[NSMutableDictionary alloc] init];
                [paramDic setObject:oldPassword forKey: @"old_password"];
                [paramDic setObject:newPassword forKey: @"new_password"];
                NSString *changePasswordUrl =  [[currentUserDetails objectForKey:@"url"] stringByAppendingString:@"/change-password/"];
                NSString *url = [SERVER_URL stringByAppendingString:changePasswordUrl];

                [self requestChangePassword: paramDic url:url];
                
                
            }else{
                [commonUtils showAlert:@"Warning!" withMessage:@"Password should be longer than 8 characters!"];
            }
        }else{
            [commonUtils showAlert:@"Warning!" withMessage:@"Password Invalid!"];
        }

    }
    }

#pragma mark - Request ChangePassword
- (void) requestChangePassword:(NSDictionary *)param url:(NSString *)url{
    
    self.isLoading = YES;
    NSLog(@" User Info ==>\n%@", param);


    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] postData:param url:url onSuccess:^(id response){

    [JSWaiter HideWaiter];
    NSLog(@"response Data : %@", response);
    self.isLoading = NO;
    [[KGModal sharedInstance] hide];
    [self requestChangePasswordOver:response];

    
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        self.isLoading = NO;
    }];
    
}
- (void)requestChangePasswordOver:(NSDictionary *)param{
    if([param objectForKey:@"message"] != nil){
        [commonUtils showVAlertSimple:@"Warning!" body:[param objectForKey:@"message"] duration:1.8f];
    }else{
        appController.loggedinUserData = param;
        
        [commonUtils showVAlertSimple:@"Alert" body:@"Password has been changed successfully!" duration:1.8];
        
    }
    
    
}
//#pragma mark - TextField Delegate
//- (void)firstNameTextFieldDidChange:(UITextField *)textField{
//    NSString *string = textField.text;
//
//    if(![commonUtils isEmptyString:string]){
//        string = [NSString stringWithFormat:@"%@%@",[[string substringToIndex:1] uppercaseString],[string substringFromIndex:1] ];
//        textField.text = string;
//    }
//}



@end
