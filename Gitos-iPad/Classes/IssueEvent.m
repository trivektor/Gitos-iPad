//
//  IssueEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "IssueEvent.h"

@implementation IssueEvent

- (NSMutableAttributedString *)toString
{
    NSDictionary *payload = [self getPayload];
    Issue *issue = [[Issue alloc] initWithData:[payload valueForKey:@"issue"]];
    User *actor = [self getActor];

    Repo *repo = [self getRepo];

    NSMutableAttributedString *actorLogin = [self decorateEmphasizedText:[actor getLogin]];

    NSMutableAttributedString *action = [self toAttributedString:[payload valueForKey:@"action"]];

    NSMutableAttributedString *issueLabel = [self toAttributedString:@" issue "];
    NSMutableAttributedString *issueName = [self decorateEmphasizedText:[NSString stringWithFormat:@"%@#%d", [repo getName], [issue getNumber]]];

    [actorLogin insertAttributedString:action atIndex:actorLogin.length];
    [actorLogin insertAttributedString:issueLabel atIndex:actorLogin.length];
    [actorLogin insertAttributedString:issueName atIndex:actorLogin.length];

    return actorLogin;
}

@end
