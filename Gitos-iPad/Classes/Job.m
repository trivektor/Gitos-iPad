//
//  Job.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 12/4/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Job.h"

@implementation Job

@synthesize data, relativeDateDescriptor, dateFormatter;

- (id)initWithData:(NSDictionary *)jobData
{
    self = [super init];
    data = jobData;
    relativeDateDescriptor = [[RelativeDateDescriptor alloc]
                              initWithPriorDateDescriptionFormat:@"%@ ago"
                              postDateDescriptionFormat:@"in %@"];

    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[AppHelper getDateFormat]];

    return self;
}

- (NSString *)getTitle
{
    return [data valueForKey:@"title"];
}

- (NSString *)getLocation
{
    return [data valueForKey:@"location"];
}

- (NSString *)getType
{
    return [data valueForKey:@"type"];
}

- (NSString *)getDescription
{
    return [data valueForKey:@"description"];
}

- (NSString *)getHowToApply
{
    return [data valueForKey:@"how_to_apply"];
}

- (NSString *)getCompany
{
    return [data valueForKey:@"company"];
}

- (NSString *)getCompanyLogo
{
    return [data valueForKey:@"company_logo"];
}

- (NSString *)getCompanyUrl
{
    return [data valueForKey:@"company_url"];
}

- (NSString *)getUrl
{
    return [data valueForKey:@"url"];
}

@end
