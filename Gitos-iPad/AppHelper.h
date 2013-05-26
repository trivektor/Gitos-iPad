//
//  AppHelper.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/2/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface AppHelper : NSObject

+ (NSString *)getAccessToken;
+ (NSDictionary *)getAccessTokenParams;
+ (NSString *)getAccountUsername;
+ (NSString *)getAccountPassword;
+ (NSString *)getDateFormat;
+ (void)flashAlert:(NSString *)message inView:(UIView *)view;
+ (void)flashError:(NSString *)message inView:(UIView *)view;
+ (MBProgressHUD *)loadHudInView:(UIView *)view withAnimation:(BOOL)animation;

+ (NSURL *)prepUrlForApiCall:(NSString *)endpoint;

@end
