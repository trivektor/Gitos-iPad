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

@end
