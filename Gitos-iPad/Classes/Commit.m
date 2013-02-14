//
//  Commit.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Commit.h"

@implementation Commit

- (id)initWithData:(NSDictionary *)commitData
{
    self = [super init];
    self.data = commitData;
    return self;
}

- (NSString *)getSha
{
    return [self.data valueForKey:@"sha"];
}

- (NSString *)getUrl
{
    return [self.data valueForKey:@"url"];
}

- (NSString *)getCommentsUrl
{
    return [self.data valueForKey:@"url"];
}

- (NSDictionary *)getDetails
{
    return [self.data valueForKey:@"commit"];
}

- (NSString *)getMessage
{
    NSDictionary *details = [self getDetails];
    return [details valueForKey:@"message"];
}

- (NSDictionary *)getParent
{
    return [self.data valueForKey:@"parents"];
}

- (NSString *)getParentSha
{
    NSDictionary *parent = [self getParent];
    return [parent valueForKey:@"sha"];
}

- (NSString *)getParentUrl
{
    NSDictionary *parent = [self getParent];
    return [parent valueForKey:@"parent"];
}

- (NSDictionary *)getStats
{
    return [self.data valueForKey:@"status"];
}

- (NSArray *)getFiles
{
    return [self.data valueForKey:@"files"];
}

@end
