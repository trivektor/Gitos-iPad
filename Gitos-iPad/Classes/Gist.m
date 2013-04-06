//
//  Gist.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Gist.h"

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
    if ([self.data valueForKey:@"description"] != [NSNull null]) {
        return [self.data valueForKey:@"description"];
    } else {
        return @"n/a";
    }
}

- (NSString *)getCreatedAt
{
    return [self convertToRelativeDate:[self.data valueForKey:@"created_at"]];
}

- (NSInteger)getNumberOfFiles
{
    NSArray *files = [self.data valueForKey:@"files"];
    return [files count];
}

- (NSDictionary *)getFiles
{
    return [self.details valueForKey:@"files"];
}

- (NSInteger)getNumberOfForks
{
    NSArray *forks = [self.details valueForKey:@"forks"];
    return [forks count];
}

- (NSInteger)getNumberOfComments
{
    return [[self.details valueForKey:@"comments"] integerValue];
}

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDate *date  = [self.dateFormatter dateFromString:originalDateString];
    return [self.relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
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

         NSDictionary *userInfo = [NSDictionary dictionaryWithObject:gists forKey:@"Gists"];

         [[NSNotificationCenter defaultCenter] postNotificationName:@"UserGistsFetched" object:nil userInfo:userInfo];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

@end
