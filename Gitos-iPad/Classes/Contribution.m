//
//  Contribution.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 7/4/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Contribution.h"

@implementation Contribution

@synthesize data;

- (id)initWithData:(NSDictionary *)contributionData
{
    self = [super init];
    data = contributionData;
    return self;
}

- (User *)getAuthor
{
    return [[User alloc] initWithData:[data valueForKey:@"author"]];
}

@end
