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

@end
