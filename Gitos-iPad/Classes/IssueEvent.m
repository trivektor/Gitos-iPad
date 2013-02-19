//
//  IssueEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "IssueEvent.h"

@implementation IssueEvent

- (NSString *)toString
{
    NSDictionary *payload = [self getPayload];
    Issue *issue = [[Issue alloc] initWithData:[payload valueForKey:@"issue"]];
    User *actor = [self getActor];
    NSString *action = [payload valueForKey:@"action"];
    NSInteger issueNumber = [issue getNumber];
    Repo *repo = [self getRepo];
    NSString *issueName = [NSString stringWithFormat:@"%@#%d", [repo getName], issueNumber];
    return [NSString stringWithFormat:@"%@ %@ issue %@", [actor getLogin], action, issueName];
}

@end
