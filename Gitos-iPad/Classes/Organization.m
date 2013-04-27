//
//  Organization.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Organization.h"

@implementation Organization

@synthesize data, relativeDateDescriptor, dateFormatter;

- (id)initWithData:(NSDictionary *)organizationData
{
    self = [super init];
    data = organizationData;

    relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [AppHelper getDateFormat];

    return self;
}

- (NSString *)getName
{
    return [data valueForKey:@"name"];
}

- (NSString *)getLocation
{
    return [data valueForKey:@"location"];
}

- (NSString *)getEventsUrl
{
    return [data valueForKey:@"events_url"];
}

- (NSString *)getUrl
{
    return [data valueForKey:@"url"];
}

- (NSString *)getMembersUrl
{
    return [data valueForKey:@"members_url"];
}

- (NSString *)getAvatarUrl
{
    return [data valueForKey:@"avatar_url"];
}

- (NSString *)getReposUrl
{
    return [data valueForKey:@"repos_url"];
}

- (NSString *)getLogin
{
    return [data valueForKey:@"login"];
}

- (NSString *)getCreatedAt
{
    return [self convertToRelativeDate:[data valueForKey:@"created_at"]];
}

- (NSString *)getUpdatedAt
{
    return [self convertToRelativeDate:[data valueForKey:@"updated_at"]];
}

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDate *date  = [dateFormatter dateFromString:originalDateString];
    return [relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

- (NSString *)getWebsite
{
    return [data valueForKey:@"blog"];
}

- (NSInteger)getNumberOfRepos
{
    return [[data valueForKey:@"public_repos"] integerValue];
}

- (NSInteger)getNumberOfFollowers
{
    return [[data valueForKey:@"followers"] integerValue];
}

- (NSInteger)getNumberOfFollowing
{
    return [[data valueForKey:@"following"] integerValue];
}

@end
