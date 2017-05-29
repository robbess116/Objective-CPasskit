//
//  VerifyRegisterUserViewController.m
//  RechargeReward
//
//  Created by RichMan on 10/25/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import "VerifyRegisterUserViewController.h"
#import "SelectGroupViewController.h"

@interface VerifyRegisterUserViewController (){
    SelectGroupViewController *selectedGroupVC;
    
}
@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIView *mobilePhoneNumberBacgroundView;
@property (weak, nonatomic) IBOutlet UITextField *mobilePinTextField;
@property (weak, nonatomic) IBOutlet UIView *mobilePinBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation VerifyRegisterUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

-(void) initView{
    [commonUtils setRoundedRectView:_mobilePhoneNumberBacgroundView withCornerRadius:_mobilePhoneNumberBacgroundView.frame.size.height / 2];
    [commonUtils setRoundedRectView:_mobilePinBackgroundView withCornerRadius:_mobilePinBackgroundView.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_cancelButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_cancelButton.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_submitButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_submitButton.frame.size.height / 2];
    NSString *phoneNumber = [commonUtils getUserDefault:@"phonenumber"];
    self.mobilePhoneNumberTextField.text = phoneNumber;

        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.descriptionLabel.numberOfLines = 0;

}
- (IBAction)onClickSubmitButton:(id)sender {
    if(self.isLoading)return;
    NSMutableDictionary *paramDic= [[NSMutableDictionary alloc] init];
    [paramDic setObject:_mobilePhoneNumberTextField.text forKey:@"mobile_phone"];
    [paramDic setObject:_mobilePinTextField.text forKey:@"mobile_pin"];
    NSString *url = [SERVER_URL stringByAppendingString:@"/user/"];
    [self requestVerifyRegister:paramDic url:url];
    
}
#pragma mark - Request Verify Register New User
-(void)requestVerifyRegister:(NSDictionary *)param url:(NSString *)url{
    self.isLoading = YES;
    NSLog(@" Register Url ==>\n%@", url);
    NSLog(@" Register Params ==>\n%@", param);
    
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [[DatabaseController sharedManager] postData:param url:url onSuccess:^(id response){
        
        NSLog(@"response Data : %@", response);
        self.isLoading = NO;
        [JSWaiter HideWaiter];
        [self requestVerifyRegisterOver:response];
        
        
    } onFailure:^(id error){
        
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Warnning!" body:[error objectForKey:@"message"] duration:1.8f];
        
        self.isLoading = NO;
    }];
    
    
    
}
-(void) requestVerifyRegisterOver:(NSDictionary *)param{
    NSLog(@"Register Response===>%@",param);
    //[commonUtils showVAlertSimple:@"Message" body:@"Please check your email!" duration:1.8f];
    
//    loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//    [self.navigationController pushViewController:loginVC animated:YES ];
    [self requestLogin:appController.userLoginData];
    
    
    
    
}
#pragma mark - Request Manual Sign In
- (void) requestLogin:(NSDictionary *)param{
    
    self.isLoading = YES;
    NSLog(@" User Info ==>\n%@", param);
    
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];
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
        [commonUtils showVAlertSimple:@"Warning!" body:[param objectForKey:@"message"] duration:1.8f];
    }else{
        appController.loggedinUserData = param;
        selectedGroupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectGroupViewController"];
        [self.navigationController pushViewController:selectedGroupVC animated:YES ];
        
    }
    
    
    
}







- (IBAction)onClickCancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
