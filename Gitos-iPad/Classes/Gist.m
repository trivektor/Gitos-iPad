//
//  Gist.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Gist.h"

@implementation Gist

@synthesize data, details;

- (id)initWithData:(NSDictionary *)gistData
{
    self = [super init];
    self.data = gistData;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    self.relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    return self;
}

- (NSString *)getId
{
    return [self.data valueForKey:@"id"];
}

- (NSString *)getName
{
    return [NSString stringWithFormat:@"gist:%@", [self getId]];
}

- (NSString *)getDescription
{
    if ([self.data valueForKey:@"description"] != [NSNull null]) {
        return [self.data valueForKey:@"description"];
    } else {
        return @"n/a";
    }
}

- (NSString *)getCreatedAt
{
    return [self convertToRelativeDate:[self.data valueForKey:@"created_at"]];
}

- (NSInteger)getNumberOfFiles
{
    NSArray *files = [self.data valueForKey:@"files"];
    return [files count];
}

- (NSDictionary *)getFiles
{
    return [self.details valueForKey:@"files"];
}

- (NSInteger)getNumberOfForks
{
    NSArray *forks = [self.details valueForKey:@"forks"];
    return [forks count];
}

- (NSInteger)getNumberOfComments
{
    return [[self.details valueForKey:@"comments"] integerValue];
}

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDate *date  = [self.dateFormatter dateFromString:originalDateString];
    return [self.relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

@end
