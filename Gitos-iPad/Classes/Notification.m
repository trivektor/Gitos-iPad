//
//  Notification.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Notification.h"

@implementation Notification

- (id)initWithData:(NSDictionary *)notificationData
{
    self = [super init];
    self.data = notificationData;
    self.relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZ";
    return self;
}

- (NSDictionary *)getSubjectData
{
    return [self.data valueForKey:@"subject"];
}

- (NSString *)getTitle
{
    NSDictionary *subjectData = [self getSubjectData];
    return [subjectData valueForKey:@"title"];
}

- (Repo *)getRepo
{
    return [[Repo alloc] initWithData:[self.data valueForKey:@"repository"]];
}

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDate *date  = [self.dateFormatter dateFromString:originalDateString];
    return [self.relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

- (NSString *)getUpdatedAt
{
    return [self convertToRelativeDate:[self.data valueForKey:@"updated_at"]];
}

- (BOOL)isUnread
{
    return [[self.data valueForKey:@"unread"] integerValue] == 1;
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
    NSDictionary *repository = [self.data valueForKey:@"repository"];
    return [[User alloc] initWithData:[repository valueForKey:@"owner"]];
}

@end
