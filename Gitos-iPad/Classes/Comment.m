//
//  Comment.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (id)initWithData:(NSDictionary *)commentData
{
    self = [super init];
    self.data = commentData;
    self.relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZ";
    return self;
}

- (User *)getUser
{
    return [[User alloc] initWithData:[self.data valueForKey:@"user"]];
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

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDate *date  = [self.dateFormatter dateFromString:originalDateString];
    return [self.relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

@end
