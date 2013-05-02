//
//  CommitFile.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/14/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "CommitFile.h"

@implementation CommitFile

@synthesize data;

- (id)initWithData:(NSDictionary *)fileData
{
    self = [super init];
    data = fileData;
    return self;
}

- (NSString *)getSha
{
    return [data valueForKey:@"sha"];
}

- (NSString *)getFileName
{
    return [data valueForKey:@"filename"];
}

- (NSString *)getStatus
{
    return [data valueForKey:@"status"];
}

- (NSInteger)getAdditions
{
    return [[data valueForKey:@"additions"] integerValue];
}

- (NSInteger)getDeletions
{
    return [[data valueForKey:@"deletions"] integerValue];
}

- (NSInteger)getChanges
{
    return [[data valueForKey:@"changes"] integerValue];
}

- (NSString *)getPatch
{
    return [data valueForKey:@"patch"];
}

@end
