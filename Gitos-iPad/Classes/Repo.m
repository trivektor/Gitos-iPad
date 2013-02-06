//
//  Repo.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Repo.h"
#import "AppConfig.h"
#import "RelativeDateDescriptor.h"

@interface Repo()

- (NSString *)convertToRelativeDate:(NSString *)originalDateString;

@end

@implementation Repo

@synthesize data, relativeDateDescriptor, dateFormatter;

- (id)initWithData:(NSDictionary *)_data
{
    self = [super init];
    
    self.data = _data;
    self.relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZ";

    return self;
}

- (NSString *)getName
{
    return [self.data valueForKey:@"name"];
}

- (NSString *)getFullName
{
    NSString *fullName = [self.data valueForKey:@"full_name"];
    
    if (fullName == (id)[NSNull null] || fullName.length == 0) {
        NSString *owner = [self.data valueForKey:@"owner"];
        return [owner stringByAppendingString:[self getName]];
    }
    
    return fullName;
}

- (NSInteger)getForks
{
    return [[self.data valueForKey:@"forks"] integerValue];
}

- (NSInteger)getWatchers
{
    return [[self.data valueForKey:@"watchers"] integerValue];
}

- (NSString *)getLanguage
{
    if ([self.data valueForKey:@"language"] == nil) return @"n/a";
    return [self.data valueForKey:@"language"];
}

- (NSString *)getBranchesUrl
{
    NSString *url = [self.data valueForKey:@"url"];
    
    if (url == (id)[NSNull null] || url.length == 0) {
        NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
        NSString *owner = [self.data valueForKey:@"owner"];
        url = [githubApiHost stringByAppendingFormat:@"/repos/%@/%@", owner, [self getName]];
    }
    
    return [url stringByAppendingFormat:@"/branches"];
}

- (NSString *)getTreeUrl
{
    NSString *url = [self.data valueForKey:@"url"];
    
    if (url == (id)[NSNull null] || url.length == 0) {
        NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
        NSString *owner = [self.data valueForKey:@"owner"];
        url = [githubApiHost stringByAppendingFormat:@"/repos/%@/%@", owner, [self getName]];
    }
    
    return [url stringByAppendingFormat:@"/git/trees/"];
}

- (NSInteger)getSize
{
    return [[self.data valueForKey:@"size"] integerValue];
}

- (NSString *)getPushedAt
{
    return [self.data valueForKey:@"pushed_at"];
}

- (NSString *)getDescription
{
    return [self.data valueForKey:@"description"];
}

- (NSString *)getHomepage
{
    if ([[self.data valueForKey:@"homepage"] length] == 0) return @"n/a";
    return [self.data valueForKey:@"homepage"];
}

- (NSInteger)getOpenIssues
{
    return [self.data valueForKey:@"open_issues"];
}

- (NSString *)getIssuesUrl
{
    return [self.data valueForKey:@"issues_url"];
}

- (NSString *)getCreatedAt
{
    return [self convertToRelativeDate:[self.data valueForKey:@"created_at"]];
}

- (NSString *)getUpdatedAt
{
    return [self convertToRelativeDate:[self.data valueForKey:@"updated_at"]];
}

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDate *date  = [self.dateFormatter dateFromString:originalDateString];
    return [self.relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

@end
