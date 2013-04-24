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

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDate *date  = [dateFormatter dateFromString:originalDateString];
    return [relativeDateDescriptor describeDate:date
                                     relativeTo:[NSDate date]];
}

+ (void)fetchGistsForUser:(NSString *)username andPage:(int)page
{
    NSString *userGistsUrl = [[AppConfig getConfigValue:@"GithubApiHost"] stringByAppendingFormat:@"/users/%@/gists", username];

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
