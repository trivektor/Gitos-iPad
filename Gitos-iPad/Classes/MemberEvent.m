//
//  MemberEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "MemberEvent.h"

@implementation MemberEvent

- (NSString *)toString
{
    NSDictionary *payload = [self getPayload];
    User *actor = [self getActor];
    Repo *repo = [self getRepo];
    NSDictionary *member = [payload valueForKey:@"member"];
    NSString *memberLogin = [member valueForKey:@"login"];
    return [NSString stringWithFormat:@"%@ added %@ to %@", [actor getName], memberLogin, [repo getName]];
}

@end
