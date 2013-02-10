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
    self.data = issueData;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    self.relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];

    return self;
}

- (NSString *)getLabelsUrl
{
    return [self.data valueForKey:@"labels_url"];
}

- (NSString *)getCommentsUrl
{
    return [self.data valueForKey:@"comments_url"];
}

- (NSString *)getHtmlUrl
{
    return [self.data valueForKey:@"html_url"];
}

- (NSInteger)getNumber
{
    return [[self.data valueForKey:@"number"] integerValue];
}

- (NSString *)getTitle
{
    return [self.data valueForKey:@"title"];
}

- (User *)getUser
{
    return [[User alloc] initWithData:[self.data valueForKey:@"user"]];
}

- (NSString *)getState
{
    return [self.data valueForKey:@"state"];
}

- (User *)getAssignee
{
    return [[User alloc] initWithData:[self.data valueForKey:@"assignee"]];
}

- (NSInteger)getNumberOfComments
{
    return [[self.data valueForKey:@"comments"] integerValue];
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

- (NSString *)getBody
{
    return [self.data valueForKey:@"body"];
}

@end
