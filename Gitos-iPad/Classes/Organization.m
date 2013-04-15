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
    self.data = organizationData;
    self.relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZ";
    return self;
}

- (NSString *)getName
{
    return [self.data valueForKey:@"name"];
}

- (NSString *)getLocation
{
    return [self.data valueForKey:@"location"];
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

- (NSString *)getWebsite
{
    return [self.data valueForKey:@"blog"];
}

- (NSInteger)getNumberOfRepos
{
    return [[self.data valueForKey:@"public_repos"] integerValue];
}

- (NSInteger)getNumberOfFollowers
{
    return [[self.data valueForKey:@"followers"] integerValue];
}

- (NSInteger)getNumberOfFollowing
{
    return [[self.data valueForKey:@"following"] integerValue];
}

+ (void)fetchUserOrganizations:(User *)user
{
    NSURL *organizationsUrl = [NSURL URLWithString:[user getOrganizationsUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:organizationsUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [AppHelper getAccessToken], @"access_token",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:organizationsUrl.absoluteString parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSMutableArray *organizations = [[NSMutableArray alloc] initWithCapacity:0];

         for (int i=0; i < json.count; i++) {
             [organizations addObject:[[Organization alloc] initWithData:[json objectAtIndex:i]]];
         }

         NSDictionary *userInfo = [NSDictionary dictionaryWithObject:organizations forKey:@"Organizations"];

         [[NSNotificationCenter defaultCenter] postNotificationName:@"OrganizationsFetched"
                                                             object:nil
                                                           userInfo:userInfo];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

@end
