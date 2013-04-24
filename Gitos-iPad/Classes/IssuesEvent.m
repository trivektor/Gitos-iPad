//
//  IssueEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "IssuesEvent.h"

@implementation IssuesEvent

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

- (NSString *)toHTMLString
{
    NSDictionary *payload = [self getPayload];

    Issue *issue = [[Issue alloc] initWithData:[payload valueForKey:@"issue"]];
    User *actor = [self getActor];

    Repo *repo = [self getRepo];

    NSString *action = [payload valueForKey:@"action"];

    NSString *issueName = [NSString stringWithFormat:@"%@#%d", [repo getName], [issue getNumber]];

    return [self toHTMLStringForObject1WithName:[actor getLogin] AndAvatar1:[actor getAvatarUrl] Object2:issueName AndAvatar2:[NSString string] andAction:action];
}

@end
