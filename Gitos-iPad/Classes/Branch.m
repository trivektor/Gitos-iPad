//
//  Branch.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Branch.h"
#import "AppHelper.h"
#import "Commit.h"

@implementation Branch

@synthesize name, data, repo;

static int PER_PAGE = 30;

- (id)initWithData:(NSDictionary *)branchData
{
    self = [super init];
    data = branchData;
    return self;
}

- (NSString *)getName
{
    return [data valueForKey:@"name"];
}

- (NSString *)getSha
{
    NSDictionary *commit = [self getCommit];
    return [commit valueForKey:@"sha"];
}

- (NSDictionary *)getCommit
{
    return [data valueForKey:@"commit"];
}

- (NSString *)getCommitsUrl
{
    NSDictionary *commit = [self getCommit];
    return [commit valueForKey:@"url"];
}

- (NSString *)getCommitsIndexUrl
{
    return [[self getCommitsUrl]
            stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@", [self getSha]]
            withString:@""];
}

- (void)fetchCommits
{
    NSURL *commitsUrl = [NSURL URLWithString:[self getCommitsIndexUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:commitsUrl];

    NSString *sha;
    NSInteger *startIndex;

    if (self.endSha == (id)[NSNull null] || self.endSha == nil) {
        sha = [self getSha];
        startIndex = 0;
    } else {
        sha = self.endSha;
        startIndex = 1;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   sha, @"sha",
                                   [NSString stringWithFormat:@"%i", PER_PAGE], @"per_page",
                                   [AppHelper getAccessToken], @"access_token",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                               path:commitsUrl.absoluteString
                                                         parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSMutableArray *commits = [[NSMutableArray alloc] initWithCapacity:0];

         for (int i=startIndex; i < json.count; i++) {
             [commits addObject:[[Commit alloc] initWithData:[json objectAtIndex:i]]];
         }

         self.endSha = [[commits lastObject] getSha];

         NSDictionary *userInfo = [NSDictionary dictionaryWithObject:commits forKey:@"Commits"];

         [[NSNotificationCenter defaultCenter] postNotificationName:@"CommitsFetched" object:nil userInfo:userInfo];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

@end