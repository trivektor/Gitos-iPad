//
//  RepoContentSearchResult.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 11/19/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoContentSearchResult.h"
#import "TextMatch.h"

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

- (NSArray *)getTextMatches
{
    NSArray *textMatches = [data valueForKey:@"text_matches"];
    NSMutableArray *textMatchesArray = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i < textMatches.count; i++) {
        [textMatchesArray addObject:[[TextMatch alloc] initWithData:[textMatches objectAtIndex:i]]];
    }
    return textMatchesArray;
}

- (NSString *)getHtmlUrl
{
    return [data valueForKey:@"html_url"];
}

@end
