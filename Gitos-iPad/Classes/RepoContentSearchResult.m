//
//  RepoContentSearchResult.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 11/19/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoContentSearchResult.h"

@implementation RepoContentSearchResult

@synthesize data;

- (id)initWithData:(NSDictionary *)resultData
{
    self = [super init];
    data = resultData;
    return self;
}

- (NSString *)getName
{
    return [data valueForKey:@"name"];
}

- (NSString *)getPath
{
    return [data valueForKey:@"path"];
}

- (double)getScore
{
    return [[data valueForKey:@"score"] doubleValue];
}

- (NSDictionary *)getTextMatches
{
    return [data valueForKey:@"text_matches"];
}

@end
