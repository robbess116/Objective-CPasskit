//
//  DatabaseController.h
//  RechargeReward
//
//  Created by Tommy on 12/27/15.
//  Copyright © 2015 Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking.h"
#import <AFNetworking.h>
#import "Reachability.h"
#import "SHAlertHelper.h"



#define API_URL_HG_TEST (SERVER_URL @"/api/test")
#define API_URL_USER_SOCIAL_SIGNUP (SERVER_URL @"/api/user_social_signup")
#define API_URL_USER_MANUAL_SIGNUP (SERVER_URL @"/api/user_manual_signup")
#define API_URL_USER_CHECK_NAME_EXIST (SERVER_URL @"/api/user_check_name_exist")
#define API_URL_USER_MANUAL_SIGNIN (SERVER_URL @"/login/")
#define API_URL_USER_LOGOUT (SERVER_URL @"/api/user_logout")
#define API_URL_USER_FORGOT_PASSWORD (SERVER_URL @"/api/user_forgot_password")
#define API_URL_USER_VERIFY_CODE (SERVER_URL @"/api/user_verify_code")
#define API_URL_USER_SET_NEW_PASSWORD (SERVER_URL @"/api/user_set_new_password")
#define API_URL_USER_CHANGE_PASSWORD (SERVER_URL @"/api/user_change_password")
#define API_URL_UPDATE_MY_LOCATION (SERVER_URL @"/api/update_my_location")
#define API_URL_GET_FEED (SERVER_URL @"/api/get_feed")
#define API_URL_GET_RESTAURANT_DETAIL (SERVER_URL @"/api/get_restaurant_detail")
#define API_URL_FAVORITE_RESTAURANT (SERVER_URL @"/api/favorite_restaurant")
#define API_URL_IGNORE_RESTAURANT (SERVER_URL @"/api/ignore_restaurant")
#define API_URL_RATE (SERVER_URL @"/api/rate")
#define API_URL_USER_PROFILE_UPDATE (SERVER_URL @"/api/user_profile_update")
#define API_URL_USER_PROFILE_PHOTO_UPDATE (SERVER_URL @"/api/user_profile_photo_update")
#define API_URL_USER_SETTINGS_UPDATE (SERVER_URL @"/api/user_settings_update")
#define API_URL_CONTACT (SERVER_URL @"/api/contact")
#define API_URL_FEEDBACK (SERVER_URL @"/api/feedback")
#define API_URL_ADD_RES_PHOTO (SERVER_URL @"/api/add_res_photo")



typedef void (^SuccessBlock)(id json);
typedef void (^FailureBlock)(id json);

@interface DatabaseController : AFHTTPRequestOperationManager 
{

}

+ (DatabaseController *)sharedManager;
+ (DatabaseController *)sharedManager2;


-(void)userSocialSignup:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)userManualSignup:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)userCheckNameExist:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)userManualSignin:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)userLogout:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)userForgotPswd:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)userVerifyCode:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)userSetNewPswd:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)userChangePswd:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)updateMyLocation:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)getFeed:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)getRestaurantDetail:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)favoriteRestaurant:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)ignoreRestaurant:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)rate:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)userProfileUpdate:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)userProfilePhotoUpdate:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)userSettingsUpdate:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)contact:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)feedback:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;
-(void)addResPhoto:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;
//-----------------------new func---------------------
-(void)getDetails:(NSString*)url  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;
-(void)patchData:(NSDictionary *)params url:(NSString *)url onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;
-(void)postData:(NSDictionary *)params url:(NSString *)url onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;
-(void)postDataPass:(NSDictionary *)params url:(NSString *)url onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;
- (void) httpJsonRequest:(NSString *) urlStr withJSON:(NSMutableDictionary *)params;

-(void)test:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

/* POST */
-(void)POST:(NSString *)url
 parameters:(NSMutableDictionary*)parameters
      onSuccess:(SuccessBlock)completionBlock
  onFailure:(FailureBlock)failureBlock;
/* POSTPASS */
-(void)POSTPASS:(NSString *)url
 parameters:(NSMutableDictionary*)parameters
  onSuccess:(SuccessBlock)completionBlock
  onFailure:(FailureBlock)failureBlock;

/* POST WITH IMAGE */
-(void)POST:(NSString *)url
  parameters:(NSMutableDictionary*)parameters
      vImage:(NSData*)vImage
   onSuccess:(SuccessBlock)completionBlock
   onFailure:(FailureBlock)failureBlock;

/* GET */
- (void)GET:(NSString *)url
parameters:(NSMutableDictionary*)parameters
onSuccess:(SuccessBlock)completionBlock
  onFailure:(FailureBlock)failureBlock;
/* PATCH */
- (void)PATCH:(NSString *)url
 parameters:(NSMutableDictionary*)parameters
  onSuccess:(SuccessBlock)completionBlock
  onFailure:(FailureBlock)failureBlock;



@end
