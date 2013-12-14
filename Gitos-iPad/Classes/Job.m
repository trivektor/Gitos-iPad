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
    [dateFormatter setDateFormat:@"EEE LLL d HH:mm:ss zzz yyy"];

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

- (NSString *)getRelativeCreatedAt
{
    NSDate *date  = [dateFormatter dateFromString:[data valueForKey:@"created_at"]];
    return [relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

+ (void)fetchAll
{
    NSURL *positionsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/positions.json", [AppConfig getConfigValue:@"GithubJobsApiHost"]]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:positionsUrl];

    NSMutableURLRequest *positionsRequest = [httpClient requestWithMethod:@"GET"
                                                                  path:positionsUrl.absoluteString
                                                            parameters:nil];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:positionsRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSArray *json = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSMutableArray *jobs = [NSMutableArray arrayWithCapacity:0];

         for (int i=0; i < json.count; i++) {
             [jobs addObject:[[Job alloc] initWithData:[json objectAtIndex:i]]];
         }

         [[NSNotificationCenter defaultCenter] postNotificationName:@"JobsFetched"
                                                             object:jobs];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

@end
