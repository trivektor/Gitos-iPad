//
//  GistComment.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/12/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GistComment.h"

@implementation GistComment

@synthesize data, createdAt, relativeDateDescriptor, dateFormatter;

- (id)initWithData:(NSDictionary *)gistData
{
    self = [super init];
    data = gistData;
    relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZ";
    createdAt = [self convertToRelativeDate:[data valueForKey:@"created_at"]];
    return self;
}

- (User *)getUser
{
    return [[User alloc] initWithData:[data valueForKey:@"user"]];
}

- (NSString *)getBody
{
    return [data valueForKey:@"body"];
}

- (NSString *)getCreatedAt
{
    return createdAt;
}

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDate *date  = [dateFormatter dateFromString:originalDateString];
    return [relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

@end
