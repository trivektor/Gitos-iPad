//
//  TextMatch.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 11/19/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "TextMatch.h"

@implementation TextMatch

@synthesize data;

- (id)initWithData:(NSDictionary *)textMatchData
{
    self = [super init];
    data = textMatchData;
    return self;
}

- (NSString *)getFragment
{
    return [data valueForKey:@"fragment"];
}

- (NSArray *)getMatches
{
    return [data valueForKey:@"matches"];
}

@end
