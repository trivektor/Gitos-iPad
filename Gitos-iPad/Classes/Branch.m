//
//  Branch.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Branch.h"

@implementation Branch

@synthesize name;

- (id)initWithData:(NSDictionary *)branchData
{
    self = [super init];
    self.data = branchData;
    return self;
}

- (NSString *)getName
{
    return [self.data valueForKey:@"name"];
}

- (NSString *)getSha
{
    NSDictionary *commit = [self getCommit];
    return [commit valueForKey:@"sha"];
}

- (NSDictionary *)getCommit
{
    return [self.data valueForKey:@"commit"];
}

@end