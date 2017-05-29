//
//  ViewController.m
//  Recharge Reward
//
//  Created by RichMan on 9/27/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import "LoginViewController.h"
#import "LandingPageViewController.h"
#import "RegisterNewUserViewController.h"
#import "ForgotPasswordUIView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SelectGroupViewController.h"
#import "AddAccountViewController.h"

@interface LoginViewController () <UITextFieldDelegate>{
    LandingPageViewController *landingPageVC;
    RegisterNewUserViewController *newAccountVC;
    ForgotPasswordUIView *forgotPasswordView;
    SelectGroupViewController *selectGroupVC;
    AddAccountViewController *addAccountVC;
   
}
  
   
@property (nonatomic, strong) IBOutlet UITextField *emailUITextField;
@property (nonatomic, strong) IBOutlet UIView *emailInputBackgroundUIView;
@property (nonatomic, strong) IBOutlet UIView *passwordInputBackgroundUIView;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UITextField *passwordUITextField;

@property (nonatomic, strong) IBOutlet UIButton *forgortPasswordButton;
@property (nonatomic, strong) IBOutlet UIButton *userNewButton;

@property (nonatomic, strong) IBOutlet UIButton *submitButton;

@property (nonatomic, assign) BOOL isLoading;



    

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //initView();
   [self initView];
   

    
}

- (void)initView{
   
        // Do UI stuff here
        // set rounded corner of emailTextField
    //_scrollView.contentSize = [UIScreen mainScreen].bounds.size;
    [commonUtils setRoundedRectView:self.emailInputBackgroundUIView withCornerRadius:self.emailInputBackgroundUIView.frame.size.height/2.0];
        // set rounded corner of passwordTextField
    
    [commonUtils setRoundedRectView:self.passwordInputBackgroundUIView withCornerRadius:self.passwordInputBackgroundUIView.frame.size.height/2.0];

        // set rounded corner of newUserButton
    [commonUtils setRoundedRectBorderButton:_userNewButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_userNewButton.frame.size.height / 2.0 ];
        // set rounded corner of submitButton
    [commonUtils setRoundedRectBorderButton:_submitButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_submitButton.frame.size.height / 2.0 ];
    NSString *lastLoaginEmail = [commonUtils getUserDefault:@"email"];
    _emailUITextField.text = lastLoaginEmail;

        if([[commonUtils getUserDefault:@"login_flag"] isEqualToString:@"1"]){
            appController.loggedinUserData = (NSDictionary*)[commonUtils getUserDefaultDicByKey:@"current_user"];
            landingPageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingPageViewController"];
            [self.navigationController pushViewController:landingPageVC animated:YES];
        }


   
    }

- (IBAction)onClickLoginSubmitButton:(id)sender {
    if(self.isLoading)return;
    
    // Set Cookie
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    if([commonUtils isFormEmpty:[@[_emailUITextField.text, _passwordUITextField.text] mutableCopy]]){
        [commonUtils showVAlertSimple:@"Warning" body:@"Please complete entire form" duration:1.2];
    }else if(![commonUtils validateEmail:_emailUITextField.text]){
        [commonUtils showVAlertSimple:@"Warnning" body:@"Email address is not in a vaild format" duration:1.8];
    }else if([_passwordUITextField.text length] < 8 || [_passwordUITextField.text length] >30){
        [commonUtils showVAlertSimple:@"Warning" body:@"Password length must be between 8 and 30 characters" duration:1.8];
    } else {
        NSMutableDictionary* paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:_emailUITextField.text forKey: @"username"];
        [paramDic setObject:_passwordUITextField.text forKey: @"password"];
        [self requestLogin: paramDic];
    }
}
- (IBAction)onClickRegisterNewUserButton:(id)sender {
   
    newAccountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterNewUserViewController"];
    [self.navigationController pushViewController:newAccountVC animated:YES];

}

#pragma mark - Request Manual Sign In
- (void) requestLogin:(NSDictionary *)param{
    
    self.isLoading = YES;
    NSLog(@" User Info ==>\n%@", param);
    
    
    [JSWaiter ShowWaiter:self.view title:@"Log in..." type:0];
    [[DatabaseController sharedManager] userManualSignin:param onSuccess:^(id response){
        
        [JSWaiter HideWaiter];
        NSLog(@"response Data : %@", response);
        self.isLoading = NO;
        
        [self requestLoginOver:response];
        
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];

        self.isLoading = NO;
    }];
    
}
- (void)requestLoginOver:(NSDictionary *)param{
    if([param objectForKey:@"message"] != nil){
        [commonUtils showVAlertSimple:@"Warning!" body:[param objectForKey:@"message"] duration:1.2f];
    }else{
        appController.loggedinUserData = param;
        [commonUtils setUserDefaultDic:@"current_user" withDic:(NSMutableDictionary* )param];
//        [commonUtils setUserDefault:@"login_flag" withFormat:@"1"];
//        [commonUtils setUserDefault:@"email" withFormat:_emailUITextField.text];
        // Url for user details
//        landingPageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingPageViewController"];
//        [self.navigationController pushViewController:landingPageVC animated:YES];
        
        NSArray *arr = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        
        if (arr.count > 0) {
            NSHTTPCookie *cookie = arr[0];
            
            NSMutableDictionary *cookieInfo = [[NSMutableDictionary alloc] init];
            [cookieInfo setObject:(cookie.name ? cookie.name : @"") forKey:NSHTTPCookieName];
            [cookieInfo setObject:(cookie.value ? cookie.value : @"") forKey:NSHTTPCookieValue];
            [cookieInfo setObject:(cookie.domain ? cookie.domain : @"") forKey:NSHTTPCookieDomain];
            [cookieInfo setObject:(cookie.path ? cookie.path : @"") forKey:NSHTTPCookiePath];
            
            [[NSUserDefaults standardUserDefaults] setObject:cookieInfo forKey:@"COOKIE"];
        }
        
        NSLog(@"%@", arr);
        NSString * url = [appController.loggedinUserData objectForKey:@"url"];
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
    if(appController.loggedinUserAccounts.count > 0){
        [commonUtils setUserDefault:@"login_flag" withFormat:@"1"];
        [commonUtils setUserDefault:@"email" withFormat:_emailUITextField.text];
        landingPageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingPageViewController"];
        [self.navigationController pushViewController:landingPageVC animated:YES];

    }else {
        appController.selectGroupFlag = @"1";
        addAccountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
        [self.navigationController pushViewController:addAccountVC animated:YES];
        [JSWaiter HideWaiter];


    }
    
}

- (IBAction)onClickForgotPasswordButton:(id)sender {
    forgotPasswordView = [ForgotPasswordUIView customView];
    [forgotPasswordView.submitButton addTarget:self action:@selector(forgotPassSubmit) forControlEvents:UIControlEventTouchUpInside];
    forgotPasswordView.emailTextField.text = self.emailUITextField.text;

    [[KGModal sharedInstance] showWithContentView:forgotPasswordView andAnimated:YES];
    
}
-(void)forgotPassSubmit{
    if(self.isLoading)return;
    NSString *emailStr = forgotPasswordView.emailTextField.text;
    if([commonUtils validateEmail:emailStr]){
        NSString *url =  [SERVER_URL stringByAppendingString:@"/login/reset-password/"];
        NSMutableDictionary* paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:emailStr forKey: @"email"];
        [self requestForgotPassword: paramDic url:url];

    }else{
        [commonUtils showVAlertSimple:@"Warning!" body:@"Invalid Email!" duration:1.8f];
    }
}
#pragma mark - Request Forgot Password
- (void) requestForgotPassword:(NSDictionary *)param url:(NSString *)url{
    
    self.isLoading = YES;
    NSLog(@" User Info ==>\n%@", param);
    
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] postData:param url:url onSuccess:^(id response){
        
        [JSWaiter HideWaiter];
        NSLog(@"response Data : %@", response);
        self.isLoading = NO;
        [[KGModal sharedInstance] hide];
        [self requestForgotPasswordOver:response];
        
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        self.isLoading = NO;
    }];
    
}
- (void)requestForgotPasswordOver:(NSDictionary *)param{
    
        [commonUtils showVAlertSimple:@"Alert" body:@"Please check your email!" duration:1.8];
}



@end
