//
//  PullRequest.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/24/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "PullRequest.h"

@implementation PullRequest

- (id)initWithData:(NSDictionary *)pullRequestData
{
    self = [super init];
    self.data = pullRequestData;
    return self;
}

- (Repo *)getRepo
{
    return [[Repo alloc] initWithData:[self.data valueForKey:@"repository"]];
}

- (NSDictionary *)getSubjet
{
    return [self.data valueForKey:@"subject"];
}

- (NSString *)getTitle
{
    NSDictionary *subject = [self getSubjet];
    return [subject valueForKey:@"title"];
}

- (NSString *)getCommentUrl
{
    NSDictionary *subject = [self getSubjet];
    return [subject valueForKey:@"latest_comment_url"];
}

@end
