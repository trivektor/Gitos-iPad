//
//  MemberEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "MemberEvent.h"

@implementation MemberEvent

- (NSMutableAttributedString *)toString
{
    NSDictionary *payload = [self getPayload];
    User *actor = [self getActor];
    Repo *repo = [self getRepo];
    NSDictionary *member = [payload valueForKey:@"member"];

    NSMutableAttributedString *actorLogin = [self decorateEmphasizedText:[actor getLogin]];

    NSMutableAttributedString *added = [self toAttributedString:@" added "];

    NSMutableAttributedString *memberLogin = [self decorateEmphasizedText:[member valueForKey:@"login"]];

    NSMutableAttributedString *to = [self toAttributedString:@" to "];

    NSMutableAttributedString *repoName = [self decorateEmphasizedText:[repo getName]];

    [actorLogin insertAttributedString:added atIndex:actorLogin.length];
    [actorLogin insertAttributedString:memberLogin atIndex:actorLogin.length];
    [actorLogin insertAttributedString:to atIndex:actorLogin.length];
    [actorLogin insertAttributedString:repoName atIndex:actorLogin.length];

    return actorLogin;
}

@end
