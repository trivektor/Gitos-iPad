//
//  IssueCommentEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "IssueCommentEvent.h"

@implementation IssueCommentEvent

- (NSMutableAttributedString *)toString
{
    NSDictionary *payload = [self getPayload];
    NSDictionary *comment = [payload valueForKey:@"comment"];
    User *user = [[User alloc] initWithData:[comment valueForKey:@"user"]];
    Issue *issue = [[Issue alloc] initWithData:[payload valueForKey:@"issue"]];
    Repo *repo = [self getRepo];

    NSMutableAttributedString *actorLogin = [self decorateEmphasizedText:[user getLogin]];

    NSMutableAttributedString *commented = [self toAttributedString:@" commented on issue "];

    NSMutableAttributedString *issueName = [self decorateEmphasizedText:[NSString stringWithFormat:@"%@#%d", [repo getName], [issue getNumber]]];

    [actorLogin insertAttributedString:commented atIndex:actorLogin.length];
    [actorLogin insertAttributedString:issueName atIndex:actorLogin.length];

    return actorLogin;
}

- (NSString *)toHTMLString
{
    return @"";
}

@end
