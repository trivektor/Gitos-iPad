//
//  PullRequest.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/24/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "PullRequest.h"

@implementation PullRequest

@synthesize data, dateFormatter, relativeDateDescriptor;

- (id)initWithData:(NSDictionary *)pullRequestData
{
    self = [super init];
    data = pullRequestData;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    return self;
}

- (Repo *)getRepo
{
    return [[Repo alloc] initWithData:[data valueForKey:@"repository"]];
}

- (NSDictionary *)getSubject
{
    return [data valueForKey:@"subject"];
}

- (NSString *)getTitle
{
    return [data valueForKey:@"title"];
}

- (NSString *)getCommentsUrl
{
    return [data valueForKey:@"comments_url"];
}

- (User *)getOwner
{
    return [[User alloc] initWithData:[data valueForKey:@"user"]];
}

- (NSString *)getState
{
    return [data valueForKey:@"state"];
}

- (NSString *)getBody
{
    return [data valueForKey:@"body"];
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

@end
