//
//  GistEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GistEvent.h"

@implementation GistEvent

- (NSString *)toString
{
    NSDictionary *payload = [self getPayload];
    User *actor = [self getActor];
    Gist *gist = [[Gist alloc] initWithData:payload];
    NSString *action = [payload valueForKey:@"action"];
    return [NSString stringWithFormat:@"%@ %@ gist:%@", [actor getLogin], action, [gist getId]];
}

@end
