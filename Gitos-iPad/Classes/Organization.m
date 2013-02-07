//
//  Organization.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Organization.h"

@implementation Organization

@synthesize data;

- (id)initWithData:(NSDictionary *)organizationData
{
    self = [super init];
    self.data = organizationData;
    return self;
}

- (NSString *)getName
{
    return [self.data valueForKey:@"name"];
}

- (NSString *)getEventsUrl
{
    return [self.data valueForKey:@"events_url"];
}

- (NSString *)getUrl
{
    return [self.data valueForKey:@"url"];
}

- (NSString *)getMembersUrl
{
    return [self.data valueForKey:@"members_url"];
}

- (NSString *)getAvatarUrl
{
    return [self.data valueForKey:@"avatar_url"];
}

- (NSString *)getReposUrl
{
    return [self.data valueForKey:@"repos_url"];
}

- (NSString *)getLogin
{
    return [self.data valueForKey:@"login"];
}

@end
