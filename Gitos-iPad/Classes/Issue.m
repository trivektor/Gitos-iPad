//
//  Issue.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Issue.h"

@implementation Issue

@synthesize data, dateFormatter, relativeDateDescriptor;

- (id)initWithData:(NSDictionary *)issueData
{
    self = [super init];
    data = issueData;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];

    return self;
}

- (NSString *)getLabelsUrl
{
    return [data valueForKey:@"labels_url"];
}

- (NSString *)getCommentsUrl
{
    return [data valueForKey:@"comments_url"];
}

- (NSString *)getHtmlUrl
{
    return [data valueForKey:@"html_url"];
}

- (NSInteger)getNumber
{
    return [[data valueForKey:@"number"] integerValue];
}

- (NSString *)getTitle
{
    return [data valueForKey:@"title"];
}

- (User *)getUser
{
    return [[User alloc] initWithData:[data valueForKey:@"user"]];
}

- (NSString *)getState
{
    return [data valueForKey:@"state"];
}

- (User *)getAssignee
{
    return [[User alloc] initWithData:[data valueForKey:@"assignee"]];
}

- (NSInteger)getNumberOfComments
{
    return [[data valueForKey:@"comments"] integerValue];
}

- (NSString *)getCreatedAt
{
    return [self convertToRelativeDate:[data valueForKey:@"created_at"]];
}

- (NSString *)getUpdatedAt
{
    return [self convertToRelativeDate:[data valueForKey:@"updated_at"]];
}

- (NSString *)getClosedAt
{
    return [data valueForKey:@"closed_at"];
}

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDate *date  = [dateFormatter dateFromString:originalDateString];
    return [relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

- (NSString *)getBody
{
    return [data valueForKey:@"body"];
}

- (void)fetchCommentsForPage:(int)page
{
    NSURL *commentsUrl = [NSURL URLWithString:[self getCommentsUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:commentsUrl];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                               path:commentsUrl.absoluteString
                                                         parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:0];

         for (NSDictionary *commentData in json) {
             [comments addObject:[[Comment alloc] initWithData:commentData]];
         }

         [[NSNotificationCenter defaultCenter] postNotificationName:@"IssueCommentsFetched"
                                                             object:comments];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

- (void)createComment:(NSString *)comment
{
    NSURL *newCommentUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?access_token=%@",
                                                 [self getCommentsUrl],
                                                 [AppHelper getAccessToken]]];

    NSDictionary *params = @{@"body": comment};

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:newCommentUrl];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];

    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST"
                                                               path:newCommentUrl.absoluteString
                                                         parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         [[NSNotificationCenter defaultCenter] postNotificationName:@"IssueCommentSubmitted"
                                                             object:operation];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

@end
