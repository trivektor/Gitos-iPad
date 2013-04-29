//
//  Gist.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Gist.h"
#import "GistFile.h"

@implementation Gist

@synthesize data, details, dateFormatter, relativeDateDescriptor;

- (id)initWithData:(NSDictionary *)gistData
{
    self = [super init];
    data = gistData;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    return self;
}

- (NSString *)getId
{
    return [data valueForKey:@"id"];
}

- (NSString *)getName
{
    return [NSString stringWithFormat:@"gist:%@", [self getId]];
}

- (NSString *)getDescription
{
    if ([data valueForKey:@"description"] != [NSNull null]) {
        return [data valueForKey:@"description"];
    } else {
        return @"n/a";
    }
}

- (NSString *)getCreatedAt
{
    return [self convertToRelativeDate:[data valueForKey:@"created_at"]];
}

- (NSInteger)getNumberOfFiles
{
    NSArray *files = [data valueForKey:@"files"];
    return [files count];
}

- (NSDictionary *)getFiles
{
    return [details valueForKey:@"files"];
}

- (NSArray *)getGistFiles
{
    NSDictionary *gistFiles = [self getFiles];

    NSMutableArray *_gistFiles = [[NSMutableArray alloc] initWithCapacity:0];

    for (NSString *key in [gistFiles allKeys]) {
        [_gistFiles addObject:[[GistFile alloc] initWithData:[gistFiles valueForKey:key]]];
    }

    return _gistFiles;
}

- (NSInteger)getNumberOfForks
{
    NSArray *forks = [details valueForKey:@"forks"];
    return [forks count];
}

- (NSInteger)getNumberOfComments
{
    return [[details valueForKey:@"comments"] integerValue];
}

- (NSString *)getUrl
{
    return [data valueForKey:@"url"];
}

- (NSString *)getStarredUrl
{
    return [[self getUrl] stringByAppendingFormat:@"/%@", @"starred"];
}

- (NSString *)getHtmlUrl
{
    return [data valueForKey:@"html_url"];
}

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDate *date  = [dateFormatter dateFromString:originalDateString];
    return [relativeDateDescriptor describeDate:date
                                     relativeTo:[NSDate date]];
}

- (void)checkStar
{
    NSURL *starredUrl = [NSURL URLWithString:[self getStarredUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:starredUrl];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                               path:starredUrl.absoluteString
                                                         parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GistStarringChecked" object:operation];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GistStarringChecked" object:operation];
     }];

    [operation start];
}

- (void)fetchStats
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];

    NSURL *gistDetailsUrl = [NSURL URLWithString:[githubApiHost stringByAppendingFormat:@"/gists/%@", [self getId]]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:gistDetailsUrl];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                               path:gistDetailsUrl.absoluteString
                                                         parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [operation responseString];

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

        details = json;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GistStatsFetched" object:nil userInfo:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    [operation start];
}

+ (void)save:(NSDictionary *)data
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];

    NSURL *gistsUrl = [NSURL URLWithString:[githubApiHost stringByAppendingFormat:@"/gists?access_token=%@", [AppHelper getAccessToken]]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:gistsUrl];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];

    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST"
                                                               path:gistsUrl.absoluteString
                                                         parameters:data];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GistSubmitted"
                                                            object:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];

    [operation start];
}

@end
