//
//  User.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "User.h"
#import "Underscore.h"

@implementation User

@synthesize data;

- (id)initWithData:(NSDictionary *)userData
{
    self = [super init];
    self.data = userData;
    return self;
}

- (NSString *)getAvatarUrl
{
    return [self.data valueForKey:@"avatar_url"];
}

- (NSString *)getGravatarId
{
    return [self.data valueForKey:@"gravatar_id"];
}

- (NSString *)getGistsUrl
{
    NSString *gistsUrl = [self.data valueForKey:@"gists_url"];
    return [gistsUrl stringByReplacingOccurrencesOfString:@"{/gist_id}" withString:@""];
}

- (NSString *)getReceivedEventsUrl
{
    return [self.data valueForKey:@"received_events_url"];
}

- (NSString *)getEventsUrl
{
    NSString *eventsUrl = [self.data valueForKey:@"events_url"];
    return [eventsUrl stringByReplacingOccurrencesOfString:@"{/privacy}" withString:@""];
}

- (NSString *)getStarredUrl
{
    NSString *starredUrl = [self.data valueForKey:@"starred_url"];
    return [starredUrl stringByReplacingOccurrencesOfString:@"{/owner}{/repo}" withString:@""];
}

- (NSString *)getFollowingUrl
{
    return [self.data valueForKey:@"following_url"];
}

- (NSString *)getFollowersUrl
{
    return [self.data valueForKey:@"followers_url"];
}

- (NSString *)getReposUrl
{
    return [self.data valueForKey:@"repos_url"];
}

- (NSString *)getOrganizationsUrl
{
    return [self.data valueForKey:@"organizations_url"];
}

- (NSString *)getSubscriptionsUrl
{
    return [self.data valueForKey:@"subscriptions_url"];
}

- (NSString *)getLogin
{
    return [self.data valueForKey:@"login"];
}

- (NSString *)getName
{
    return [self.data valueForKey:@"name"];
}

- (NSString *)getLocation
{
    if ([self.data valueForKey:@"location"] == nil) return @"n/a";
    return [self.data valueForKey:@"location"];
}

- (NSString *)getWebsite
{
    if ([self.data valueForKey:@"blog"] == nil) return @"n/a";
    return [self.data valueForKey:@"blog"];
}

- (NSString *)getEmail
{
    if ([self.data valueForKey:@"email"] == nil) return @"n/a";
    if ([self.data valueForKey:@"email"] == (id)[NSNull null]) return @"n/a";
    if ([[self.data valueForKey:@"email"] isEqualToString:@""]) return @"n/a";
    return [self.data valueForKey:@"email"];
}

- (NSInteger)getFollowers
{
    return [[self.data valueForKey:@"followers"] integerValue];
}

- (NSInteger)getFollowing
{
    return [[self.data valueForKey:@"following"] integerValue];
}

- (NSString *)getCompany
{
    if ([self.data valueForKey:@"company"] == nil) return @"n/a";
    return [self.data valueForKey:@"company"];
}

- (NSInteger)getNumberOfRepos
{
    return [[self.data valueForKey:@"public_repos"] integerValue];
}

- (NSInteger)getNumberOfGists
{
    return [[self.data valueForKey:@"public_gists"] integerValue];
}

- (NSString *)getCreatedAt
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    NSDate *date  = [dateFormatter dateFromString:[self.data valueForKey:@"created_at"]];

    RelativeDateDescriptor *relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];

    return [relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

- (NSString *)getHtmlUrl
{
    return [self.data valueForKey:@"html_url"];
}

- (BOOL)isEditable
{
    return [[AppHelper getAccountUsername] isEqualToString:[self getLogin]];
}

+ (void)fetchNewsFeedForUser:(NSString *)username andPage:(int)page
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];

    NSURL *userReceivedEventsUrl = [NSURL URLWithString:[githubApiHost stringByAppendingFormat:@"/users/%@", username]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:userReceivedEventsUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[AppHelper getAccessTokenParams]];
    [params addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%i", page], @"page", nil]];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:@"received_events" parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSMutableArray *newsFeed = [[NSMutableArray alloc] initWithCapacity:0];

         for (int i=0; i < json.count; i++) {
             [newsFeed addObject:[[TimelineEvent alloc] initWithData:[json objectAtIndex:i]]];
         }

         [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsFeedFetched" object:newsFeed];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

+ (void)fetchInfoForUser:(NSString *)username
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];

    NSURL *userUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@", githubApiHost, username]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:userUrl];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:userUrl.absoluteString parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         User *user = [[User alloc] initWithData:json];

         [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoFetched" object:user];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

- (void)update:(NSDictionary *)updatedInfo
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];

    NSURL *userUrl = [NSURL URLWithString:[githubApiHost stringByAppendingFormat:@"/user?access_token=%@", [AppHelper getAccessToken]]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:userUrl];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];

    NSMutableURLRequest *patchRequest = [httpClient requestWithMethod:@"PATCH"
                                                               path:userUrl.absoluteString
                                                         parameters:updatedInfo];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:patchRequest];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
         [[NSNotificationCenter defaultCenter] postNotificationName:@"ProfileUpdated" object:operation.response];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"ProfileUpdated" object:operation.response];
     }];

    [operation start];
}

@end
