//
//  CommitCommentEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "CommitCommentEvent.h"

@implementation CommitCommentEvent

- (NSMutableAttributedString *)toString
{
    User *actor = [self getActor];
    NSDictionary *payload = [self getPayload];
    NSDictionary *comment = [payload valueForKey:@"comment"];
    NSString *commitId    = [[comment valueForKey:@"commit_id"] substringToIndex:9];

    NSMutableAttributedString *actorLogin = [self decorateEmphasizedText:[actor getLogin]];

    NSMutableAttributedString *commented = [self toAttributedString:@" commented on commit "];

    NSMutableAttributedString *commitLabel = [self decorateEmphasizedText:commitId];

    [actorLogin insertAttributedString:commented atIndex:actorLogin.length];
    [actorLogin insertAttributedString:commitLabel atIndex:actorLogin.length];

    return actorLogin;
}

- (NSString *)toHTMLString
{
    return @"";
}

@end
