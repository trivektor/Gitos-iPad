//
//  CommitActivity.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 7/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "CommitActivity.h"

@implementation CommitActivity

@synthesize data;

- (id)initWithCommitActivityData:(NSDictionary *)commitActivityData
{
    self = [super init];
    data = commitActivityData;
    return self;
}

- (int)getTotal
{
    return [data valueForKey:@"total"];
}

- (int)getWeek
{
    return [data valueForKey:@"week"];
}

@end
