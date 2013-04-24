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
    Repo *repo = [self getRepo];
    NSDictionary *payload = [self getPayload];

    NSMutableAttributedString *actorLogin = [self decorateEmphasizedText:[actor getLogin]];

    NSMutableAttributedString *action = [self toAttributedString:[NSString stringWithFormat:@" %@", [payload valueForKey:@"action"]]];

    NSMutableAttributedString *pullRequest = [self toAttributedString:@" pull request "];

    NSMutableAttributedString *pullRequestId = [self decorateEmphasizedText:[NSString stringWithFormat:@"%@/#%i",
                                                                             [repo getName],
                                                                             [[payload valueForKey:@"number"] integerValue]]];

    [actorLogin insertAttributedString:action atIndex:actorLogin.length];
    [actorLogin insertAttributedString:pullRequest atIndex:actorLogin.length];
    [actorLogin insertAttributedString:pullRequestId atIndex:actorLogin.length];

    return actorLogin;
}

- (NSString *)toHTMLString
{
    User *actor = [self getActor];
    Repo *repo = [self getRepo];
    NSDictionary *payload = [self getPayload];
    NSString *pullRequestId = [NSString stringWithFormat:@"%@/#%i", [repo getName], [[payload valueForKey:@"number"] integerValue]];

    return [super toHTMLStringForObject1WithName:[actor getLogin]
                                      AndAvatar1:[actor getAvatarUrl]
                                         Object2:pullRequestId
                                      AndAvatar2:GITHUB_OCTOCAT
                                      andAction1:[payload valueForKey:@"action"]
                                         Object3:pullRequestId AndAvatar3:GITHUB_OCTOCAT
                                      andAction2:[repo getName]];
}

@end
