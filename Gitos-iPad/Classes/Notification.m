//
//  Notification.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Notification.h"

@implementation Notification

@synthesize data, relativeDateDescriptor, dateFormatter;

- (id)initWithData:(NSDictionary *)notificationData
{
    self = [super init];
    data = notificationData;
    relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZ";
    return self;
}

- (NSDictionary *)getSubjectData
{
    return [data valueForKey:@"subject"];
}

- (NSString *)getTitle
{
    NSDictionary *subjectData = [self getSubjectData];
    return [subjectData valueForKey:@"title"];
}

- (Repo *)getRepo
{
    return [[Repo alloc] initWithData:[data valueForKey:@"repository"]];
}

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDate *date  = [dateFormatter dateFromString:originalDateString];
    return [relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

- (NSString *)getUpdatedAt
{
    return [self convertToRelativeDate:[data valueForKey:@"updated_at"]];
}

- (BOOL)isUnread
{
    return [[data valueForKey:@"unread"] integerValue] == 1;
}

- (NSString *)getSubjectUrl
{
    NSDictionary *subjectData = [self getSubjectData];
    return [subjectData valueForKey:@"url"];
}

- (NSString *)getSubjectType
{
    NSDictionary *subjectData = [self getSubjectData];
    return [subjectData valueForKey:@"type"];
}

- (NSString *)getLatestCommentUrl
{
    NSDictionary *subjectData = [self getSubjectData];
    return [subjectData valueForKey:@"latest_comment_url"];
}

- (User *)getOwner
{
    NSDictionary *repository = [data valueForKey:@"repository"];
    return [[User alloc] initWithData:[repository valueForKey:@"owner"]];
}

- (BOOL)isIssue
{
    return [[self getSubjectType] isEqualToString:@"Issue"];
}

- (BOOL)isPullRequest
{
    return [[self getSubjectType] isEqualToString:@"PullRequest"];
}

@end
