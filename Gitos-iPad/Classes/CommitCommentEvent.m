//
//  CommitCommentEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "CommitCommentEvent.h"

@implementation CommitCommentEvent

- (NSString *)toString
{
    User *actor = [self getActor];
    Repo *repo = [self getRepo];
    NSDictionary *payload = [self getPayload];
    NSDictionary *comment = [payload valueForKey:@"comment"];
    NSString *commitId    = [comment valueForKey:@"commit_id"];
    return [NSString stringWithFormat:@"%@ commented on commit %@@%@", [actor getLogin], [repo getName], [commitId substringToIndex:9]];
}

@end
