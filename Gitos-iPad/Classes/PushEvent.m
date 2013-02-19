//
//  PushEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "PushEvent.h"

@implementation PushEvent

- (NSString *)toString
{
    NSDictionary *payload = [self getPayload];
    User *actor = [self getActor];
    Repo *repo = [self getRepo];
    NSArray *ref = [[payload valueForKey:@"ref"] componentsSeparatedByString:@"/"];
    NSString *branch = [ref lastObject];
    return [NSString stringWithFormat:@"%@ pushed to %@ at %@", [actor getLogin], branch, [repo getName]];
}

@end
