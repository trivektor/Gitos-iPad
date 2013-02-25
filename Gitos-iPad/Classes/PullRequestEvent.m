//
//  PullRequestEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "PullRequestEvent.h"

@implementation PullRequestEvent

- (NSMutableAttributedString *)toString
{
    User *actor = [self getActor];
    NSDictionary *payload = [self getPayload];

    NSInteger pullRequestNumber = [[payload valueForKey:@"number"] integerValue];

    NSMutableAttributedString *actorLogin = [self decorateEmphasizedText:[actor getLogin]];

    NSMutableAttributedString *action = [self toAttributedString:[payload valueForKey:@"action"]];

    NSMutableAttributedString *pullRequest = [self toAttributedString:@" pull request "];

    NSMutableAttributedString *pullRequestId = [self decorateEmphasizedText:[NSString stringWithFormat:@"%i", pullRequestNumber]];

    [actorLogin insertAttributedString:action atIndex:actorLogin.length];
    [actorLogin insertAttributedString:pullRequest atIndex:actorLogin.length];
    [actorLogin insertAttributedString:pullRequestId atIndex:actorLogin.length];

    return actorLogin;
}

@end
