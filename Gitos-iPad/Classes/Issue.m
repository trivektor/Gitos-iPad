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

@end
