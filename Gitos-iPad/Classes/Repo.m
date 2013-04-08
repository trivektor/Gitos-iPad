//
//  Repo.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Repo.h"

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
    if ([self.data valueForKey:@"language"] == (id)[NSNull null]) return @"n/a";
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
    if ([self.data valueForKey:@"description"] == (id)[NSNull null]) return @"n/a";
    return [self.data valueForKey:@"description"];
}

- (NSString *)getHomepage
{
    if ([self.data valueForKey:@"homepage"] == (id)[NSNull null]) return @"n/a";
    if ([[self.data valueForKey:@"homepage"] length] == 0) return @"n/a";
    return [self.data valueForKey:@"homepage"];
}

- (NSInteger)getOpenIssues
{
    return [[self.data valueForKey:@"open_issues"] integerValue];
}

- (NSString *)getIssuesUrl
{
    return [[self.data valueForKey:@"issues_url"] stringByReplacingOccurrencesOfString:@"{/number}" withString:@""];
}

- (NSString *)getCommitsUrl
{
    return [[self.data valueForKey:@"commits_url"] stringByReplacingOccurrencesOfString:@"{/sha}" withString:@""];
}

- (NSString *)getAuthorName
{
    if ([self.data valueForKey:@"owner"] != (id)[NSNull null]) {
        if ([[self.data valueForKey:@"owner"] isKindOfClass:[NSDictionary class]]) {
            return [[self.data valueForKey:@"owner"] valueForKey:@"login"];
        } else {
            return [self.data valueForKey:@"owner"];
        }
    } else if ([self.data valueForKey:@"username"]) {
        return [self.data valueForKey:@"username"];
    } else {
        return @"";
    }
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

- (NSString *)getOwner
{
    return [self.data valueForKey:@"owner"];
}

- (BOOL)isForked
{
    return [[self.data valueForKey:@"fork"] integerValue] == 1;
}

- (NSString *)getSubscriptionUrl
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
    return [githubApiHost stringByAppendingFormat:@"/user/subscriptions/%@", [self getFullName]];
}

- (NSString *)getStarredUrl
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
    return [githubApiHost stringByAppendingFormat:@"/user/starred/%@", [self getFullName]];
}

- (NSString *)getGithubUrl
{
    NSString *githubHost = [AppConfig getConfigValue:@"GithubHost"];
    return [githubHost stringByAppendingFormat:@"/%@", [self getFullName]];
}

- (void)checkStar
{
    NSURL *starredUrl = [NSURL URLWithString:[self getStarredUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:starredUrl];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:starredUrl.absoluteString parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSNumber *statusCode = [NSNumber numberWithInt:operation.response.statusCode];

        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:statusCode forKey:@"Code"];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"StarChecked" object:self userInfo:userInfo];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSNumber *statusCode = [NSNumber numberWithInt:operation.response.statusCode];

        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:statusCode forKey:@"Code"];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"StarChecked" object:self userInfo:userInfo];
    }];

    [operation start];
}

- (void)fetchBranches
{
    NSURL *branchesUrl = [NSURL URLWithString:[self getBranchesUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:branchesUrl];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:branchesUrl.absoluteString parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSMutableArray *branches = [[NSMutableArray alloc] initWithCapacity:0];

         for (int i=0; i < json.count; i++) {
             [branches addObject:[[Branch alloc] initWithData:[json objectAtIndex:i]]];
         }

         NSDictionary *userInfo = [NSDictionary dictionaryWithObject:branches forKey:@"Branches"];

         [[NSNotificationCenter defaultCenter] postNotificationName:@"BranchesFetched" object:self userInfo:userInfo];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    [operation start];
}

+ (void)fetchReposForUser:(NSString *)username andPage:(int)page
{
    NSString *userReposURL = [[AppConfig getConfigValue:@"GithubApiHost"] stringByAppendingFormat:@"/users/%@/repos", username];

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

        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:repos forKey:@"Repos"];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserReposFetched" object:self userInfo:userInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];

    [operation start];
}

+ (void)fetchStarredReposForUser:(NSString *)username andPage:(int)page
{
    NSString *userStarredReposURL = [[AppConfig getConfigValue:@"GithubApiHost"] stringByAppendingFormat:@"/users/%@/starred", username];

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

         NSDictionary *userInfo = [NSDictionary dictionaryWithObject:repos forKey:@"StarredRepos"];

         [[NSNotificationCenter defaultCenter] postNotificationName:@"StarredReposFetched" object:self userInfo:userInfo];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

- (void)fetchTopLayerForBranch:(Branch *)branch
{
    NSString *treeUrl = [[self getTreeUrl] stringByAppendingString:[branch getName]];

    NSURL *repoTreeUrl = [NSURL URLWithString:treeUrl];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:repoTreeUrl];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:repoTreeUrl.absoluteString parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSArray *treeNodes = [json valueForKey:@"tree"];

         NSMutableArray *nodes = [[NSMutableArray alloc] initWithCapacity:0];

         for (int i=0; i < treeNodes.count; i++) {
             [nodes addObject:[[RepoTreeNode alloc] initWithData:[treeNodes objectAtIndex:i]]];
         }

         NSDictionary *userInfo = [NSDictionary dictionaryWithObject:nodes forKey:@"Nodes"];

         [[NSNotificationCenter defaultCenter] postNotificationName:@"TreeFetched" object:nil userInfo:userInfo];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

@end
