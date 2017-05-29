//
//  RegisterNewUserViewController.m
//  Recharge Reward
//
//  Created by RichMan on 9/28/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import "RegisterNewUserViewController.h"
#import "VerifyRegisterUserViewController.h"
#import "LoginViewController.h"

@interface RegisterNewUserViewController (){
    VerifyRegisterUserViewController *verifyRegisterUserVC;
    LoginViewController *loginVC;
    NSString *oanStr;
    BOOL oanFlag;
}

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *oanTextField;
@property (weak, nonatomic) IBOutlet UIButton *oanSelectedButton;
@property (weak, nonatomic) IBOutlet UIImageView *oanImageView;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneTextField;
@property (weak, nonatomic) IBOutlet UIView *oanBackgroudView;

@property (nonatomic, assign) BOOL isLoading;
@end

@implementation RegisterNewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];

}
-(void)initView{
    [commonUtils setRoundedRectView:_oanBackgroudView withCornerRadius:_oanBackgroudView.frame.size.height / 2];
    
    
    [commonUtils setRoundedRectBorderButton:_cancelButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_cancelButton.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_submitButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_submitButton.frame.size.height / 2];
        oanFlag = NO;
    _oanImageView.highlighted = oanFlag;
    oanStr = @"virtual card";
    
}
- (IBAction)onClickSubmitButton:(id)sender {
    if(self.isLoading)return;
    if(!oanFlag){
        oanStr = _oanTextField.text;
        
     if(oanStr.length != 14 ){
        [commonUtils showVAlertSimple:@"message" body:@"OAN lenth should be 14 digits!" duration:1.8f];
        return;
    }else if([[oanStr substringToIndex:1] isEqualToString:@"1"] || [[oanStr substringToIndex:1] isEqualToString:@"2"]){
        appController.firstOAN = oanStr;

    }else{
        [commonUtils showVAlertSimple:@"message" body:@"First digit should be 1 or 2!" duration:1.8f];
        return;
    }
    }
    if([commonUtils isEmptyString:_firstNameTextField.text]){
        [commonUtils showVAlertSimple:@"Warning" body:@"Please enter first name!" duration:1.8f];
        return;
    }else if([commonUtils isEmptyString:_lastNameTextField.text]){
        [commonUtils showVAlertSimple:@"Warning" body:@"Please enter last name!" duration:1.8f];
        return;
    }else if(![commonUtils validateEmail:_emailTextFiled.text]){
        [commonUtils showVAlertSimple:@"Warning" body:@"Please enter email correctly!" duration:1.8f];
        return;
    }else if(_passwordTextField.text.length < 8){
        [commonUtils showVAlertSimple:@"Warning" body:@"Password must contain at least 8 characters!" duration:1.8f];
        return;
    }else if(![_confirmPasswordTextField.text isEqualToString:_passwordTextField.text]){
        [commonUtils showVAlertSimple:@"Warning" body:@"Confirm password invalid!" duration:1.8f];
        return;
    }if([commonUtils isEmptyString:_mobilePhoneTextField.text]){
         [commonUtils showVAlertSimple:@"Warning" body:@"Please enter mobile phone number!" duration:1.8f];
        return;
    }else {
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:_firstNameTextField.text forKey:@"first_name"];
        [paramDic setObject:_lastNameTextField.text forKey:@"last_name"];
        [paramDic setObject:_emailTextFiled.text forKey:@"email"];
        [paramDic setObject:_passwordTextField.text forKey:@"password"];
        [paramDic setObject:_mobilePhoneTextField.text forKey:@"mobile_phone"];
        
        
        NSMutableDictionary* paramDicLogin = [[NSMutableDictionary alloc] init];
        [paramDicLogin setObject:_emailTextFiled.text forKey: @"username"];
        [paramDicLogin setObject:_passwordTextField.text forKey: @"password"];
        appController.userLoginData = paramDicLogin;
        
        NSString *url = [SERVER_URL stringByAppendingString:@"/registration/"];
        [self requestRegisterNewUser:paramDic url:url];
        
       
        
    }
    
   
}

#pragma mark - Request Register New User
-(void)requestRegisterNewUser:(NSDictionary *)param url:(NSString *)url{
    self.isLoading = YES;
    NSLog(@" Register Url ==>\n%@", url);
     NSLog(@" Register Params ==>\n%@", param);
    
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] postData:param url:url onSuccess:^(id response){
        
        NSLog(@"response Data : %@", response);
        self.isLoading = NO;
        [JSWaiter HideWaiter];
        [self requestRegisterNewUserOver:response];
        
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        
        self.isLoading = NO;
    }];
    
    
    
}
-(void)requestRegisterNewUserOver:(NSDictionary *)param{
    NSLog(@"Register Response===>%@",param);
    [commonUtils setUserDefault:@"phonenumber" withFormat:_mobilePhoneTextField.text];
        verifyRegisterUserVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyRegisterUserViewController"];
        [self.navigationController pushViewController:verifyRegisterUserVC animated:YES ];

       
    
    
    
}
- (IBAction)onClickOANSelectedButton:(id)sender {
    oanFlag = !oanFlag;
    _oanImageView.highlighted = oanFlag;
    if(oanFlag){
        [_oanTextField setEnabled:NO];
    }else{
        [_oanTextField setEnabled:YES];
        [_oanTextField isFirstResponder];
    }
}
- (IBAction)onClickCancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


//#pragma mark - TextField Delegate
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if(textField == _firstNameTextField){
//        NSString *temp = _firstNameTextField.text;
//        if(![commonUtils isEmptyString:temp]){
//            temp = [NSString stringWithFormat:@"%@%@",[[temp substringToIndex:1] uppercaseString],[temp substringFromIndex:1] ];
//            _firstNameTextField.text = temp;
//        }
//        
//        
//    }else if (textField == _lastNameTextField){
//        NSString *temp = _lastNameTextField.text;
//        if(![commonUtils isEmptyString:temp]){
//            temp = [NSString stringWithFormat:@"%@%@",[[temp substringToIndex:1] uppercaseString],[temp substringFromIndex:1] ];
//            _lastNameTextField.text = temp;
//        }
//       
//    }
//    
//}

@end
