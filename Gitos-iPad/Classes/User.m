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

- (BOOL)isMyself
{
    return [[AppHelper getAccountUsername] isEqualToString:[self getLogin]];
}

- (void)fetchNewsFeedForPage:(int)page
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];

    NSURL *userReceivedEventsUrl = [NSURL URLWithString:[githubApiHost stringByAppendingFormat:@"/users/%@", [self getLogin]]];

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
         NSDictionary *_data;

         for (int i=0; i < json.count; i++) {
             _data = [json objectAtIndex:i];
             id klass = [NSClassFromString([_data valueForKey:@"type"]) alloc];
             id obj = objc_msgSend(klass, sel_getUid("initWithData:"), _data);
             [newsFeed addObject:obj];
         }

         [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsFeedFetched" object:newsFeed];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

- (void)fetchRecentActivityForPage:(int)page
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];

    NSURL *recentActivitysUrl = [NSURL URLWithString:[githubApiHost stringByAppendingFormat:@"/users/%@", [self getLogin]]];

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

         NSDictionary *_data;

         NSMutableArray *activities = [[NSMutableArray alloc] initWithCapacity:0];

         for (int i=0; i < json.count; i++) {
             _data = [json objectAtIndex:i];
             id klass = [NSClassFromString([_data valueForKey:@"type"]) alloc];
             id obj = objc_msgSend(klass, sel_getUid("initWithData:"), _data);
             [activities addObject:obj];
         }

         [[NSNotificationCenter defaultCenter] postNotificationName:@"RecentActivityFetched" object:activities];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

- (void)fetchProfileInfo
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];

    NSURL *userUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@", githubApiHost, [self getLogin]]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:userUrl];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:userUrl.absoluteString parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         User *user = [[User alloc] initWithData:json];

         [[NSNotificationCenter defaultCenter] postNotificationName:@"ProfileInfoFetched" object:user];
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

- (void)fetchReposForPage:(int)page
{
    NSString *userReposURL = [[AppConfig getConfigValue:@"GithubApiHost"] stringByAppendingFormat:@"/users/%@/repos", [self getLogin]];

    NSURL *reposURL = [NSURL URLWithString:userReposURL];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:reposURL];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:[AppHelper getAccessTokenParams]];
    [params addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i", page], @"page", nil]];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:reposURL.absoluteString parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [operation responseString];

        NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

        NSMutableArray *repos = [[NSMutableArray alloc] initWithCapacity:0];

        for (int i=0; i < [json count]; i++) {
            [repos addObject:[[Repo alloc] initWithData:[json objectAtIndex:i]]];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserReposFetched" object:repos];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];

    [operation start];
}

- (void)fetchStarredReposForPage:(int)page
{
    NSString *userStarredReposURL = [[AppConfig getConfigValue:@"GithubApiHost"] stringByAppendingFormat:@"/users/%@/starred", [self getLogin]];

    NSURL *starredReposUrl = [NSURL URLWithString:userStarredReposURL];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:starredReposUrl];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:[AppHelper getAccessTokenParams]];
    [params addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%i", page], @"page", nil]];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:starredReposUrl.absoluteString parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSMutableArray *repos = [[NSMutableArray alloc] initWithCapacity:0];

         for (int i=0; i < json.count; i++) {
             [repos addObject:[[Repo alloc] initWithData:[json objectAtIndex:i]]];
         }

         [[NSNotificationCenter defaultCenter] postNotificationName:@"StarredReposFetched" object:repos];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

- (void)fetchGistsForPage:(int)page
{
    NSString *userGistsUrl = [[AppConfig getConfigValue:@"GithubApiHost"] stringByAppendingFormat:@"/users/%@/gists", [self getLogin]];

    NSURL *gistsUrl = [NSURL URLWithString:userGistsUrl];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:gistsUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[AppHelper getAccessTokenParams]];
    [params addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i", page],  @"page", nil]];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:gistsUrl.absoluteString parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSArray *gistsArray = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSMutableArray *gists = [[NSMutableArray alloc] initWithCapacity:0];

         for (int i=0; i < [gistsArray count]; i++) {
             [gists addObject:[[Gist alloc] initWithData:[gistsArray objectAtIndex:i]]];
         }

         [[NSNotificationCenter defaultCenter] postNotificationName:@"UserGistsFetched" object:gists];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

- (void)fetchRelatedUsersWithUrl:(NSString *)url forPage:(int)page
{
    NSURL *fetchUrl = [NSURL URLWithString:url];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:fetchUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [AppHelper getAccessToken], @"access_token",
                                   [NSString stringWithFormat:@"%i", page], @"page",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                               path:fetchUrl.absoluteString
                                                         parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSMutableArray *users = [[NSMutableArray alloc] initWithCapacity:0];

         for (int i=0; i < json.count; i++) {
             [users addObject:[[User alloc] initWithData:[json objectAtIndex:i]]];
         }

         [[NSNotificationCenter defaultCenter] postNotificationName:@"FollowUsersFetched" object:users];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

- (void)fetchFollowersForPage:(int)page
{
    [self fetchRelatedUsersWithUrl:[self getFollowersUrl] forPage:page];
}

- (void)fetchFollowingUsersForPage:(int)page
{
    [self fetchRelatedUsersWithUrl:[self getFollowingUrl] forPage:page];
}

- (void)fetchOrganizationsForPage:(int)page
{
    NSURL *organizationsUrl = [NSURL URLWithString:[self getOrganizationsUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:organizationsUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [AppHelper getAccessToken], @"access_token",
                                   [NSString stringWithFormat:@"%i", page], @"page",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                               path:organizationsUrl.absoluteString
                                                         parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSMutableArray *organizations = [[NSMutableArray alloc] initWithCapacity:0];

         for (int i=0; i < json.count; i++) {
             [organizations addObject:[[Organization alloc] initWithData:[json objectAtIndex:i]]];
         }

         [[NSNotificationCenter defaultCenter] postNotificationName:@"OrganizationsFetched"
                                                             object:organizations];
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
