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

+ (void)flashAlertInView:(UIView *)view
{
    [YRDropdownView showDropdownInView:view
                                 title:@"Alert"
                                detail:@"Profile updated successfully"
                                 image:[UIImage imageNamed:@"glyphicons_198_ok.png"]
                             textColor:[UIColor whiteColor]
                       backgroundColor:[UIColor colorWithRed:87/255.0 green:153/255.0 blue:38/255.0 alpha:1.0]
                              animated:YES
                             hideAfter:HIDE_AFTER];
}

+ (void)flashErrorInView:(UIView *)view
{
    [YRDropdownView showDropdownInView:view
                                 title:@"Error"
                                detail:@"Please enter your username and password"
                                 image:[UIImage imageNamed:@"glyphicons_078_warning_sign.png"]
                             textColor:[UIColor colorWithRed:186/255.0 green:12/255.0 blue:12/255.0 alpha:1.0] backgroundColor:[UIColor whiteColor]
                              animated:YES
                             hideAfter:HIDE_AFTER];
}

@end
