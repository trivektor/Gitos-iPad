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

@end
