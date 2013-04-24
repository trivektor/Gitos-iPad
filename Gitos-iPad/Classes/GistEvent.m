//
//  GistEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GistEvent.h"

@implementation GistEvent

- (NSMutableAttributedString *)toString
{
    NSDictionary *payload = [self getPayload];
    User *actor = [self getActor];
    Gist *gist = [[Gist alloc] initWithData:[payload valueForKey:@"gist"]];

    NSMutableAttributedString *actorLogin = [self decorateEmphasizedText:[actor getLogin]];

    NSMutableAttributedString *gistName = [self decorateEmphasizedText:[gist getName]];

    NSMutableAttributedString *action = [self toAttributedString:[NSString stringWithFormat:@" %@ ", [payload valueForKey:@"action"]]];

    [actorLogin insertAttributedString:action atIndex:actorLogin.length];
    [actorLogin insertAttributedString:gistName atIndex:actorLogin.length];
    return actorLogin;
}

- (NSString *)toHTMLString
{
    NSDictionary *payload = [self getPayload];

    User *actor = [self getActor];
    Gist *gist = [[Gist alloc] initWithData:[payload valueForKey:@"gist"]];

    return [super toHTMLStringForObject1WithName:[actor getLogin]
                                      AndAvatar1:[actor getAvatarUrl]
                                         Object2:[gist getName]
                                      AndAvatar2:GITHUB_OCTOCAT
                                       andAction:[payload valueForKey:@"action"]];
}

@end
