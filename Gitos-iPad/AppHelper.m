//
//  AppHelper.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/2/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "AppHelper.h"

@implementation AppHelper

+ (NSString *)getAccessToken
{
    return [SSKeychain passwordForService:@"access_token" account:@"gitos"];
}

+ (NSDictionary *)getAccessTokenParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:[self getAccessToken], @"access_token", nil];
}

+ (NSString *)getAccountUsername
{
    return [SSKeychain passwordForService:@"username" account:@"gitos"];
}

+ (NSString *)getAccountPassword
{
    return [SSKeychain passwordForService:@"password" account:@"gitos"];
}

+ (NSString *)getDateFormat
{
    return @"yyyy-MM-dd'T'HH:mm:ssZZ";
}

+ (void)flashAlert:(NSString *)message inView:(UIView *)view
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void)flashError:(NSString *)message inView:(UIView *)view
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (NSURL *)prepUrlForApiCall:(NSString *)endpoint
{
    return [NSURL URLWithString:[[AppConfig getConfigValue:@"GithubApiHost"] stringByAppendingString:endpoint]];
}

+ (MBProgressHUD *)loadHudInView:(UIView *)view withAnimation:(BOOL)animation
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animation];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"Loading";

    return hud;
}

@end
