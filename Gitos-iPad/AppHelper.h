//
//  AppHelper.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/2/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppHelper : NSObject

+ (NSString *)getAccessToken;
+ (NSDictionary *)getAccessTokenParams;
+ (NSString *)getAccountUsername;
+ (NSString *)getAccountPassword;
+ (NSString *)getDateFormat;
+ (void)flashAlert:(NSString *)message inView:(UIView *)view;
+ (void)flashError:(NSString *)message inView:(UIView *)view;

+ (NSURL *)prepUrlForApiCall:(NSString *)endpoint;

@end
