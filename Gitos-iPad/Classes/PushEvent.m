//
//  PushEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "PushEvent.h"

@implementation PushEvent

- (NSMutableAttributedString *)toString
{
    NSDictionary *payload = [self getPayload];
    User *actor = [self getActor];
    Repo *repo = [self getRepo];
    NSArray *ref = [[payload valueForKey:@"ref"] componentsSeparatedByString:@"/"];
    NSString *branch = [ref lastObject];

    NSMutableAttributedString *actorLogin = [self decorateEmphasizedText:[actor getLogin]];

    NSMutableAttributedString *pushedTo = [self toAttributedString:@" pushed to "];

    NSMutableAttributedString *repoName = [self decorateEmphasizedText:[repo getName]];

    NSMutableAttributedString *branchName = [self decorateEmphasizedText:branch];

    NSMutableAttributedString *at = [self toAttributedString:@" at "];

    [actorLogin insertAttributedString:pushedTo atIndex:actorLogin.length];
    [actorLogin insertAttributedString:branchName atIndex:actorLogin.length];
    [actorLogin insertAttributedString:at atIndex:actorLogin.length];
    [actorLogin insertAttributedString:repoName atIndex:actorLogin.length];

    return actorLogin;
}

- (NSString *)toHTMLString
{
    return @"";
}

@end
