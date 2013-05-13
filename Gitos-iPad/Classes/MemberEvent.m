//
//  MemberEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "MemberEvent.h"

@implementation MemberEvent

- (NSMutableAttributedString *)toString
{
    User *actor = [self getActor];
    Repo *repo = [self getRepo];
    User *member = [self getMember];

    NSMutableAttributedString *actorLogin = [self decorateEmphasizedText:[actor getLogin]];

    NSMutableAttributedString *added = [self toAttributedString:@" added "];

    NSMutableAttributedString *memberLogin = [self decorateEmphasizedText:[member getLogin]];

    NSMutableAttributedString *to = [self toAttributedString:@" to "];

    NSMutableAttributedString *repoName = [self decorateEmphasizedText:[repo getName]];

    [actorLogin insertAttributedString:added atIndex:actorLogin.length];
    [actorLogin insertAttributedString:memberLogin atIndex:actorLogin.length];
    [actorLogin insertAttributedString:to atIndex:actorLogin.length];
    [actorLogin insertAttributedString:repoName atIndex:actorLogin.length];

    return actorLogin;
}

- (NSString *)toHTMLString
{
    User *actor = [self getActor];
    Repo *repo = [self getRepo];
    User *member = [self getMember];

    NSString *repoName = [repo getName];

    return [super toHTMLStringForObject1WithName:[actor getLogin]
                                      AndAvatar1:[actor getAvatarUrl]
                                         Object2:[member getLogin]
                                      AndAvatar2:[member getAvatarUrl]
                                      andAction1:@" added "
                                         Object3:repoName
                                      AndAvatar3:GITHUB_OCTOCAT
                                      andAction2:@" to "];
}

- (NSString *)getURLPrefixForObject:(NSObject *)object
{
    return MEMBER_EVENT_PREFIX;
}

@end
