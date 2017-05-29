//
//  JSWaiter.h
//  PhotoSauce
//
//  Created by NOVNUS LLC on 1/7/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface JSWaiter : NSObject<MBProgressHUDDelegate>
{

}

+(void)ShowWaiter:(UIView*)vw title:(NSString*)text type:(int)typ;
+(void)HideWaiter;
+(void)SetProgress:(float)perent;
@end
