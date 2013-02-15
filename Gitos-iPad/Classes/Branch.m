//
//  Branch.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Branch.h"
#import "AppConfig.h"

@implementation Branch

@synthesize name;

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    self.name = [data valueForKey:@"name"];
    self.sha = [data valueForKey:@"sha"];
    return self;
}

- (NSString *)getUrl
{
    return @"";
}

- (NSString *)getSha
{
    return self.sha;
}

@end