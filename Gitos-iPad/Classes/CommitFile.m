//
//  CommitFile.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/14/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "CommitFile.h"

@implementation CommitFile

- (id)initWithData:(NSDictionary *)fileData
{
    self = [super init];
    self.data = fileData;
    return self;
}

- (NSString *)getSha
{
    return [self.data valueForKey:@"sha"];
}

- (NSString *)getFileName
{
    return [self.data valueForKey:@"filename"];
}

- (NSString *)getStatus
{
    return [self.data valueForKey:@"status"];
}

- (NSInteger)getAdditions
{
    return [[self.data valueForKey:@"additions"] integerValue];
}

- (NSInteger)getDeletions
{
    return [[self.data valueForKey:@"deletions"] integerValue];
}

- (NSInteger)getChanges
{
    return [[self.data valueForKey:@"changes"] integerValue];
}

- (NSString *)getPatch
{
    return [self.data valueForKey:@"patch"];
}

@end
