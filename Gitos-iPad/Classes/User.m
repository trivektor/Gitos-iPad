//
//  User.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "User.h"
#import "Underscore.h"
#import <objc/message.h>

@implementation User

@synthesize data;

- (id)initWithData:(NSDictionary *)userData
{
    self = [super init];
    data = userData;
    return self;
}

- (NSString *)getAvatarUrl
{
    return [data valueForKey:@"avatar_url"];
}

- (NSString *)getGravatarId
{
    return [data valueForKey:@"gravatar_id"];
}

- (NSString *)getGistsUrl
{
    NSString *gistsUrl = [data valueForKey:@"gists_url"];
    return [gistsUrl stringByReplacingOccurrencesOfString:@"{/gist_id}" withString:@""];
}

- (NSString *)getReceivedEventsUrl
{
    return [data valueForKey:@"received_events_url"];
}

- (NSString *)getEventsUrl
{
    NSString *eventsUrl = [data valueForKey:@"events_url"];
    return [eventsUrl stringByReplacingOccurrencesOfString:@"{/privacy}" withString:@""];
}

- (NSString *)getStarredUrl
{
    NSString *starredUrl = [data valueForKey:@"starred_url"];
    return [starredUrl stringByReplacingOccurrencesOfString:@"{/owner}{/repo}" withString:@""];
}

- (NSString *)getFollowingUrl
{
    return [data valueForKey:@"following_url"];
}

- (NSString *)getFollowersUrl
{
    return [data valueForKey:@"followers_url"];
}

- (NSString *)getReposUrl
{
    return [data valueForKey:@"repos_url"];
}

- (NSString *)getOrganizationsUrl
{
    return [data valueForKey:@"organizations_url"];
}

- (NSString *)getSubscriptionsUrl
{
    return [data valueForKey:@"subscriptions_url"];
}

- (NSString *)getLogin
{
    return [data valueForKey:@"login"];
}

- (NSString *)getName
{
    if ([data valueForKey:@"name"] == (id)[NSNull null]) return @"n/a";
    return [data valueForKey:@"name"];
}

- (NSString *)getLocation
{
    if ([data valueForKey:@"location"] == (id)[NSNull null]) return @"n/a";
    return [data valueForKey:@"location"];
}

- (NSString *)getWebsite
{
    if ([data valueForKey:@"blog"] == (id)[NSNull null]) return @"n/a";
    return [data valueForKey:@"blog"];
}

- (NSString *)getEmail
{
    if ([data valueForKey:@"email"] == nil) return @"n/a";
    if ([data valueForKey:@"email"] == (id)[NSNull null]) return @"n/a";
    if ([[data valueForKey:@"email"] isEqualToString:@""]) return @"n/a";
    return [data valueForKey:@"email"];
}

- (NSInteger)getFollowers
{
    return [[data valueForKey:@"followers"] integerValue];
}

- (NSInteger)getFollowing
{
    return [[data valueForKey:@"following"] integerValue];
}

- (NSString *)getCompany
{
    if ([data valueForKey:@"company"] == (id)[NSNull null]) return @"n/a";
    return [data valueForKey:@"company"];
}

- (NSInteger)getNumberOfRepos
{
    return [[data valueForKey:@"public_repos"] integerValue];
}

- (NSInteger)getNumberOfGists
{
    return [[data valueForKey:@"public_gists"] integerValue];
}

- (NSString *)getCreatedAt
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    NSDate *date  = [dateFormatter dateFromString:[data valueForKey:@"created_at"]];

    RelativeDateDescriptor *relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];

    return [relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

- (NSString *)getHtmlUrl
{
    return [data valueForKey:@"html_url"];
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
         NSDictionary *data;

         for (int i=0; i < json.count; i++) {
             data = [json objectAtIndex:i];

             id klass = [NSClassFromString([data valueForKey:@"type"]) alloc];

             id obj = objc_msgSend(klass, sel_getUid("initWithData:"), data);

             [newsFeed addObject:obj];
         }

         [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsFeedFetched" object:newsFeed];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

+ (void)fetchRecentActivityForUser:(NSString *)username andPage:(int)page;
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];

    NSURL *recentActivitysUrl = [NSURL URLWithString:[githubApiHost stringByAppendingFormat:@"/users/%@", username]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:recentActivitysUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [AppHelper getAccessToken], @"access_token",
                                   [NSString stringWithFormat:@"%i", page], @"page",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                               path:@"events"
                                                         parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSDictionary *data;

         NSMutableArray *activities = [[NSMutableArray alloc] initWithCapacity:0];

         for (int i=0; i < json.count; i++) {
             data = [json objectAtIndex:i];
             id klass = [NSClassFromString([data valueForKey:@"type"]) alloc];
             id obj = objc_msgSend(klass, sel_getUid("initWithData:"), data);
             [activities addObject:obj];
         }

         [[NSNotificationCenter defaultCenter] postNotificationName:@"RecentActivityFetched" object:activities];
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

+ (void)fetchInfoForUserWithToken:(NSString *)accessToken
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];

    NSURL *userUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user", githubApiHost]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:userUrl];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                               path:userUrl.absoluteString
                                                         parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         User *user = [[User alloc] initWithData:json];

         [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthenticatedUserFetched" object:user];
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
