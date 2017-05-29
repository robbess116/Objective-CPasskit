//
//  SelectGroupViewController.m
//  RechargeAndReward Mobile
//
//  Created by RichMan on 12/14/16.
//  Copyright © 2016 TommyTorvalds. All rights reserved.
//

#import "SelectGroupViewController.h"
#import "LoginViewController.h"

@interface SelectGroupViewController ()<VSDropdownDelegate>{
    VSDropdown  *dropdownGroup;
    NSDictionary *selectedGroup;
    LoginViewController *loginVC;
}
@property (nonatomic, assign) BOOL isLoading;
@property (weak, nonatomic) IBOutlet UIView *groupDropdownView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation SelectGroupViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

-(void) initView {
    [commonUtils setRoundedRectView:_groupDropdownView withCornerRadius:_groupDropdownView.frame.size.height / 2];
    
    
    [commonUtils setRoundedRectBorderButton:_cancelButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_cancelButton.frame.size.height / 2];
    [commonUtils setRoundedRectBorderButton:_submitButton withBorderWidth:0.0 withBorderColor:[UIColor clearColor] withBorderRadius:_submitButton.frame.size.height / 2];
    
    dropdownGroup = [[VSDropdown alloc]initWithDelegate:self];
    [dropdownGroup setAdoptParentTheme:YES];
    [dropdownGroup setShouldSortItems:NO];
    dropdownGroup.separatorType = UITableViewCellSeparatorStyleSingleLine;
    
    NSString *url;
    if([appController.firstOAN  isEqual: @"virtual card"]){
        url = [[SERVER_URL stringByAppendingString:[appController.loggedinUserData objectForKey:@"url"]] stringByAppendingString:@"/group?use-virtual-card=yes"];
    }else{
        url= [[[SERVER_URL stringByAppendingString:[appController.loggedinUserData objectForKey:@"url"]] stringByAppendingString:@"/group?alias="] stringByAppendingString:appController.firstOAN];
        
    }
    [self requestGroupList:url];

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
       
    
}
- (IBAction)onClickGroupDropButton:(id)sender {
    [self showDropDownForButton:sender adContents:[self getGroupNameArray:(NSMutableArray *)[appController.groupList objectForKey:@"groups"]] multipleSelection:NO];
}

- (IBAction)onClickSubmitButton:(id)sender {
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
        [paramDic setObject:[appController.loggedinUserData objectForKey:@"user_id"] forKey:@"user_id"];
        [paramDic setObject:[selectedGroup objectForKey:@"code" ] forKey:@"group"];
        
    }else{
        [paramDic setObject:appController.firstOAN forKey:@"alias"];
        [paramDic setObject:[appController.loggedinUserData objectForKey:@"user_id"] forKey:@"user_id"];
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
    loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginVC animated:YES];
}


- (IBAction)onClickCancelButton:(id)sender {
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
#pragma mark - VSDropdown Delegate methods.

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];

    selectedGroup = [[appController.groupList objectForKey:@"groups"] objectAtIndex:index];
    
    
}

@end
