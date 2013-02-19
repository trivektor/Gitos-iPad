//
//  PullRequestEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "PullRequestEvent.h"

@implementation PullRequestEvent

- (NSString *)toString
{
    User *actor = [self getActor];
    Repo *repo = [self getRepo];
    NSDictionary *payload = [self getPayload];
    NSString *action = [payload valueForKey:@"action"];
    NSInteger pullRequestNumber = [[payload valueForKey:@"number"] integerValue];
    return [NSString stringWithFormat:@"%@ %@ pull request %@/%i", [actor getName], action, [repo getName], pullRequestNumber];
}

@end
