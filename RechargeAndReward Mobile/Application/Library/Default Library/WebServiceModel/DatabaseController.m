//
//  DatabaseController.m
//  Recharge Reward
//
//  Created by RichMan on 9/27/16.
//  Copyright © 2016 Tommy. All rights reserved.
//

#import "DatabaseController.h"
#import "AppDelegate.h"

@implementation DatabaseController{
   
}
+ (DatabaseController *)sharedManager {
    static DatabaseController *sharedManager = nil;
       static dispatch_once_t onceToken=0;
    dispatch_once(&onceToken, ^{
        sharedManager = [DatabaseController manager];
        [sharedManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [sharedManager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [sharedManager.requestSerializer setValue:API_KEY forHTTPHeaderField:@"api-key"];
        [sharedManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        
        
        
    });
    return sharedManager;
}
+ (DatabaseController *)sharedManager2 {
    static DatabaseController *sharedManager2 = nil;
    static dispatch_once_t onceToken=0;
    dispatch_once(&onceToken, ^{
        sharedManager2 = [DatabaseController manager];
        [sharedManager2 setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [sharedManager2.requestSerializer setValue:@"application/json; version= 1.0" forHTTPHeaderField:@"Content-Type"];
        [sharedManager2.requestSerializer setValue:@"application/vnd.apple.pkpass" forHTTPHeaderField:@"Accept"];
        [sharedManager2.requestSerializer setValue:API_KEY forHTTPHeaderField:@"api-key"];
        [sharedManager2 setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        
        
        
    });
    return sharedManager2;
}


#pragma mark - User APIs

-(void)userSocialSignup:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_SOCIAL_SIGNUP;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userManualSignup:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_MANUAL_SIGNUP;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userCheckNameExist:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_CHECK_NAME_EXIST;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userManualSignin:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_MANUAL_SIGNIN;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}
//-----------------------------new func------------------------------------------
-(void)getDetails:(NSString*)url  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock{
    NSString *urlStr = url;
   
    [self GET:urlStr parameters:nil onSuccess:completionBlock onFailure:failureBlock];
}
-(void)patchData:(NSDictionary *)params url:(NSString *)url onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock{
    NSString *urlStr = url;
    
    [self PATCH:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}
-(void)postData:(NSDictionary *)params url:(NSString *)url onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock{
    NSString *urlStr = url;
    
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)postDataPass:(NSDictionary *)params url:(NSString *)url onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock{
    NSString *urlStr = url;
    
    [self POSTPASS:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

//-----------------------------------------------------------------------------------
-(void)userLogout:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_LOGOUT;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}


-(void)userForgotPswd:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_FORGOT_PASSWORD;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userVerifyCode:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_VERIFY_CODE;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userSetNewPswd:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_SET_NEW_PASSWORD;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userChangePswd:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_CHANGE_PASSWORD;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)updateMyLocation:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_UPDATE_MY_LOCATION;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)getFeed:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_GET_FEED;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)getRestaurantDetail:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_GET_RESTAURANT_DETAIL;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)favoriteRestaurant:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_FAVORITE_RESTAURANT;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)ignoreRestaurant:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_IGNORE_RESTAURANT;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)rate:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_RATE;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userProfileUpdate:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_PROFILE_UPDATE;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userProfilePhotoUpdate:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_PROFILE_PHOTO_UPDATE;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userSettingsUpdate:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_USER_SETTINGS_UPDATE;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)contact:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_CONTACT;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)feedback:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_FEEDBACK;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)addResPhoto:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_ADD_RES_PHOTO;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}



-(void)test:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock
{
    NSString *urlStr = API_URL_HG_TEST;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

#pragma mark - Post and Get Function

- (void)POST:(NSString *)url
  parameters:(NSMutableDictionary*)parameters
   onSuccess:(SuccessBlock)completionBlock
   onFailure:(FailureBlock)failureBlock
{
    // Check out network connection
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [SHAlertHelper showOkAlertWithTitle:@"Error" message:@"We are unable to connect to our servers.\rPlease check your connection."];
        failureBlock(nil);
        return;
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary * tempDic;
    if (parameters == nil) {
        tempDic = [NSMutableDictionary dictionary];
    }else{
        tempDic= [NSMutableDictionary dictionaryWithDictionary:parameters];
    }
    
    parameters = tempDic;
    
    
    [self POST:url
          parameters:parameters
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
              NSData* data = (NSData*)responseObject;
              NSError* error = nil;
              NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                          completionBlock(dict);
              
        
          }failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error){
              
              NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                            NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
              id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
              switch ([operation.response statusCode]) {
                  case 400:
                      json = @{@"message":@"Invalid request!"};
                      break;
                  case 401:
                       json = @{@"message":@"Invalid email or password!"};
                      break;
                  case 403:
                      json = @{@"message":@"Forbidden 403!"};
                      break;
                  case 404:
                      json = @{@"message":@"Server not founded!"};
                      break;
                  case 406:
                      json = @{@"message":@"Not Acceptable 406!"};
                      break;

                  default:
                      
                      break;
              }
              if(json == nil){
                  json = @{@"message":@"Server Connection Error!"};
              }
              
              failureBlock(json);

          }
    ];
    
  }





//- (void)POST:(NSString *)url
//  parameters:(NSMutableDictionary*)parameters
//      vImage:(NSData*)vImage
//   onSuccess:(SuccessBlock)completionBlock
//   onFailure:(FailureBlock)failureBlock
//{
//    // Check out network connection
//    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
//    if (networkStatus == NotReachable) {
//        NSLog(@"There IS NO internet connection");
//        [SHAlertHelper showOkAlertWithTitle:@"Error" message:@"We are unable to connect to our servers.\rPlease check your connection."];
//        failureBlock(nil);
//        return;
//    }
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSLog(@"POST url : %@", url);
//    NSLog(@"POST param : %@", parameters);
//    NSLog(@"Debug____________POST_____________!pause");
//    
//    [self POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        if (vImage != nil) {
//            [formData appendPartWithFormData:vImage name:@"vImage"];
//        }
//    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSData* data = (NSData*)responseObject;
//        NSError* error = nil;
//        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//        NSLog(@"POST success : %@", dict);
//        
//       completionBlock(dict);
//        
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        NSLog(@"POST Error  %@", error);
//        //[SHAlertHelper showOkAlertWithTitle:@"Connection Error" andMessage:@"Error occurs while connecting to web-service. Please try again!" andOkBlock:nil];
//        failureBlock(nil);
//    }];
//}


- (void)GET:(NSString *)url
 parameters:(NSMutableDictionary*)parameters
  onSuccess:(SuccessBlock)completionBlock
  onFailure:(FailureBlock)failureBlock
{
    // Check out network connection
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [SHAlertHelper showOkAlertWithTitle:@"Error" message:@"We are unable to connect to our servers.\rPlease check your connection."];
        
        failureBlock(nil);
        return;
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"GET url : %@", url);
    NSLog(@"GET param : %@", parameters);
    

    [self GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData* data = (NSData*)responseObject;
        NSError* error = nil;
        
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"GET success : %@", dict);
        completionBlock(dict);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        switch ([operation.response statusCode]) {
            case 400:
                json = @{@"message":@"Invalid request!"};
                break;
            case 401:
                json = @{@"message":@"Invalid email or password!"};
                break;
            case 403:
                json = @{@"message":@"Forbidden 403!"};
                break;
            case 404:
                json = @{@"message":@"Server not founded!"};
                break;
            case 406:
                json = @{@"message":@"Not Acceptable 406!"};
                break;
                
            default:
                
                break;
        }
        if(json == nil){
            json = @{@"message":@"Server Connection Error!"};
        }
        
        failureBlock(json);

    }];
}
- (void)PATCH:(NSString *)url
  parameters:(NSMutableDictionary*)parameters
   onSuccess:(SuccessBlock)completionBlock
   onFailure:(FailureBlock)failureBlock
{
    // Check out network connection
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [SHAlertHelper showOkAlertWithTitle:@"Error" message:@"We are unable to connect to our servers.\rPlease check your connection."];
        failureBlock(nil);
        return;
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary * tempDic;
    if (parameters == nil) {
        tempDic = [NSMutableDictionary dictionary];
    }else{
        tempDic= [NSMutableDictionary dictionaryWithDictionary:parameters];
    }
    
    //    [tempDic setObject:[User sharedInstance].strToken forKey:@"token"];
    parameters = tempDic;
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        // Here I see the correct rails session cookie
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        NSLog(@"cookie: %@", cookie);
    }
    

    
    [self PATCH:url
    parameters:parameters
       success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
           NSData* data = (NSData*)responseObject;
           NSError* error = nil;
           
           NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
           //              NSLog(@"POST success : %@", dict);
           
           completionBlock(dict);
           
           
       }failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error){
           
           NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
           NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
           id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
           switch ([operation.response statusCode]) {
               case 400:
                   json = @{@"message":@"Invalid request!"};
                   break;
               case 401:
                   json = @{@"message":@"Invalid email or password!"};
                   break;
               case 403:
                   json = @{@"message":@"Forbidden 403!"};
                   break;
               case 404:
                   json = @{@"message":@"Server not founded!"};
                   break;
               case 406:
                   json = @{@"message":@"Not Acceptable 406!"};
                   break;
                   
               default:
                   
                   break;
           }
           if(json == nil){
               json = @{@"message":@"Server Connection Error!"};
           }
           
           failureBlock(json);
       }
     ];
}
@end
