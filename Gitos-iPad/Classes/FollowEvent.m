//
//  FollowEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "FollowEvent.h"

@implementation FollowEvent

- (NSMutableAttributedString *)toString
{
    User *actor  = [self getActor];
    User *target = [[User alloc] initWithData:[self getTarget]];

    NSMutableAttributedString *actorLogin = [self decorateEmphasizedText:[actor getLogin]];

    NSMutableAttributedString *targetLogin = [self decorateEmphasizedText:[target getLogin]];

    NSMutableAttributedString *action = [self toAttributedString:@" started following "];

    [actorLogin insertAttributedString:action atIndex:actorLogin.length];
    [actorLogin insertAttributedString:targetLogin atIndex:actorLogin.length];

    return actorLogin;
}

@end
