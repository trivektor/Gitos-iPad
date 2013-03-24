//
//  Authorization.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 3/23/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Authorization.h"

@implementation Authorization

- (id)initWithData:(NSDictionary *)authorizationData
{
    self = [super init];
    self.data = authorizationData;
    return self;
}

- (NSString *)getId
{
    return [NSString stringWithFormat:@"%@", [self.data valueForKey:@"id"]];
}

- (NSString *)getUrl
{
    return [self.data valueForKey:@"url"];
}

- (NSDictionary *)getApp
{
    return [self.data valueForKey:@"app"];
}

- (NSString *)getName
{
    NSDictionary *app = [self getApp];
    return [app valueForKey:@"name"];
}

- (NSString *)getToken
{
    return [self.data valueForKey:@"token"];
}

+ (NSArray *)appScopes
{
    return @[@"user", @"public_repo", @"repo", @"repo:status", @"notifications", @"gist"];
}

@end
