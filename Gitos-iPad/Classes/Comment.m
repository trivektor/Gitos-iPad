//
//  Comment.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@synthesize data, relativeDateDescriptor, dateFormatter;

- (id)initWithData:(NSDictionary *)commentData
{
    self = [super init];
    data = commentData;
    relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZ";
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
    return [self convertToRelativeDate:[data valueForKey:@"created_at"]];
}

- (NSString *)getUpdatedAt
{
    return [self convertToRelativeDate:[data valueForKey:@"updated_at"]];
}

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDate *date  = [dateFormatter dateFromString:originalDateString];
    return [relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

@end
