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

- (NSString *)toHTMLString
{
    User *actor  = [self getActor];
    User *target = [[User alloc] initWithData:[self getTarget]];

    return [self toHTMLStringForObject1WithName:[actor getLogin]
                                      AndAvatar1:[actor getAvatarUrl]
                                         Object2:[target getLogin]
                                      AndAvatar2:[target getAvatarUrl]
                                       andAction:@" started following "];
}

- (NSString *)getURLPrefixForObject:(NSObject *)object
{
    return FOLLOW_EVENT_PREFIX;
}

- (NSString *)toHTMLStringForObject1WithName:(NSString *)name1 AndAvatar1:(NSString *)avatar1 Object2:(NSString *)name2 AndAvatar2:(NSString *)avatar2 andAction:(NSString *)actionName
{
    NSString *eventActorPath = [[NSBundle mainBundle] pathForResource:@"eventActor"
                                                               ofType:@"html"];
    
    NSString *actorHTML = [NSString stringWithContentsOfFile:eventActorPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    
    NSString *eventActionPath = [[NSBundle mainBundle] pathForResource:@"eventAction"
                                                                ofType:@"html"];
    
    NSString *actionHTML = [NSString stringWithContentsOfFile:eventActionPath
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];

    NSString *actoHTMLString = [NSString stringWithFormat:actorHTML, EVENT_ACTOR_PREFIX, avatar1, name1];

    NSString *targetActorHTMLString = [NSString stringWithFormat:actorHTML, EVENT_TARGET_ACTOR_PREFIX, avatar2, name2];

    NSString *actionHTMLString = [NSString stringWithFormat:actionHTML, actionName];

    NSArray *strings = @[actoHTMLString, actionHTMLString, targetActorHTMLString];
    
    return [strings componentsJoinedByString:@""];
}


@end
