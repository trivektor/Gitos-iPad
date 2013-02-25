//
//  PullRequest.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/24/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "PullRequest.h"

@implementation PullRequest

- (id)initWithData:(NSDictionary *)pullRequestData
{
    self = [super init];
    self.data = pullRequestData;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    self.relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    return self;
}

- (Repo *)getRepo
{
    return [[Repo alloc] initWithData:[self.data valueForKey:@"repository"]];
}

- (NSDictionary *)getSubject
{
    return [self.data valueForKey:@"subject"];
}

- (NSString *)getTitle
{
    return [self.data valueForKey:@"title"];
}

- (NSString *)getCommentsUrl
{
    return [self.data valueForKey:@"comments_url"];
}

- (User *)getOwner
{
    return [[User alloc] initWithData:[self.data valueForKey:@"user"]];
}

- (NSString *)getState
{
    return [self.data valueForKey:@"state"];
}

- (NSString *)getBody
{
    return [self.data valueForKey:@"body"];
}

- (NSString *)getCreatedAt
{
    return [self convertToRelativeDate:[self.data valueForKey:@"created_at"]];
}

- (NSString *)getUpdatedAt
{
    return [self convertToRelativeDate:[self.data valueForKey:@"updated_at"]];
}

- (NSString *)getClosedAt
{
    return [self.data valueForKey:@"closed_at"];
}

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDate *date  = [self.dateFormatter dateFromString:originalDateString];
    return [self.relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

@end
