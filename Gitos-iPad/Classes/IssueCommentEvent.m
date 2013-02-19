//
//  IssueCommentEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "IssueCommentEvent.h"

@implementation IssueCommentEvent

- (NSString *)toString
{
    NSDictionary *payload = [self getPayload];
    NSDictionary *comment = [payload valueForKey:@"comment"];
    User *user = [[User alloc] initWithData:[comment valueForKey:@"user"]];
    Issue *issue = [[Issue alloc] initWithData:[payload valueForKey:@"issue"]];
    Repo *repo = [self getRepo];
    [payload valueForKey:@"issue"];
    NSString *issueName = [NSString stringWithFormat:@"%@#%d", [repo getName], [issue getNumber]];
    return [NSString stringWithFormat:@"%@ commented on issue %@", [user getLogin], issueName];
}

@end
