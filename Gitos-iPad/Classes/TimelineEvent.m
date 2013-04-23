//
//  TimelineEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "TimelineEvent.h"
#import "ForkEvent.h"
#import "WatchEvent.h"
#import "CreateEvent.h"
#import "DeleteEvent.h"
#import "FollowEvent.h"
#import "GistEvent.h"
#import "IssueEvent.h"
#import "IssueCommentEvent.h"
#import "MemberEvent.h"
#import "PushEvent.h"
#import "PullRequestEvent.h"
#import "PublicEvent.h"
#import "CommitCommentEvent.h"
#import "GollumEvent.h"

@implementation TimelineEvent

- (id)initWithData:(NSDictionary *)eventData
{
    self = [super init];
    self.data = eventData;
    self.relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    self.fontAwesomeIcons = @{
        @"ForkEvent"          : @"icon-random",
        @"WatchEvent"         : @"icon-star",
        @"CreateEvent"        : @"icon-plus",
        @"FollowEvent"        : @"icon-user",
        @"GistEvent"          : @"icon-file-alt",
        @"IssuesEvent"        : @"icon-warning-sign",
        @"MemberEvent"        : @"icon-user-md",
        @"IssueCommentEvent"  : @"icon-comment-alt",
        @"PushEvent"          : @"icon-upload",
        @"PullRequestEvent"   : @"icon-retweet",
        @"PublicEvent"        : @"icon-folder-open-alt",
        @"CommitCommentEvent" : @"icon-comments",
        @"GollumnEvent"       : @"icon-book"
    };
    return self;
}

- (NSString *)getId
{
    return [self.data valueForKey:@"id"];
}

- (NSDictionary *)getPayload
{
    return [self.data valueForKey:@"payload"];
}

- (NSDictionary *)getTarget
{
    NSDictionary *payload = [self getPayload];
    return [payload valueForKey:@"target"];
}

- (NSString *)getType
{
    return [self.data valueForKey:@"type"];
}

- (User *)getActor
{
    return [[User alloc] initWithData:[self.data valueForKey:@"actor"]];
}

- (Repo *)getRepo
{
    return [[Repo alloc] initWithData:[self.data valueForKey:@"repo"]];
}

- (NSMutableAttributedString *)toString
{
    NSString *eventType = [self getType];
    id klass = [NSClassFromString(eventType) alloc];
    // Dynamically initialize class instance at runtime
    // http://stackoverflow.com/questions/2573805/using-objc-msgsend-to-call-a-objective-c-function-with-named-arguments
    id obj = objc_msgSend(klass, sel_getUid("initWithData:"), self.data);
    return [obj toString];
    // return [[NSClassFromString(eventType) alloc] ini];
}

- (NSMutableAttributedString *)toActorRepoString:(NSString *)actionName
{
    User *actor = [self getActor];
    Repo *repo = [self getRepo];

    NSMutableAttributedString *actorLogin = [self decorateEmphasizedText:[actor getLogin]];

    NSMutableAttributedString *repoName = [self decorateEmphasizedText:[repo getName]];

    NSMutableAttributedString *action = [self toAttributedString:[NSString stringWithFormat:@" %@ ", actionName]];

    [actorLogin insertAttributedString:action atIndex:actorLogin.length];
    [actorLogin insertAttributedString:repoName atIndex:actorLogin.length];
    return actorLogin;
}

- (NSString *)toActorRepoHTMLString:(NSString *)actionName
{
    User *actor = [self getActor];
    Repo *repo = [self getRepo];

    NSString *actorHTML = [NSString stringWithContentsOfFile:@"eventActor.html"
                                                    encoding:NSUTF8StringEncoding error:nil];

    NSString *actionHTML = [NSString stringWithContentsOfFile:@"eventAction"
                                                     encoding:NSUTF8StringEncoding error:nil];

    NSString *actoHTMLString = [NSString stringWithFormat:actorHTML, [actor getAvatarUrl], [actor getLogin]];
    NSString *repoHTMLString = [NSString stringWithFormat:actorHTML, [repo getName], GITHUB_OCTOCAT];
    NSString *actionHTMLString = [NSString stringWithFormat:actionHTML, actionName];

    NSArray *strings = @[actoHTMLString, repoHTMLString, actionHTMLString];

    return [strings componentsJoinedByString:@""];
}

- (NSString *)getFontAwesomeIcon
{
    return [self.fontAwesomeIcons valueForKey:[self getType]];
}

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDate *date  = [self.dateFormatter dateFromString:originalDateString];
    return [self.relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

- (NSString *)toDateString
{
    return [self convertToRelativeDate:[self.data valueForKey:@"created_at"]];
}

- (NSMutableAttributedString *)decorateEmphasizedText:(NSString *)rawString
{
    NSMutableAttributedString *decoratedString = [[NSMutableAttributedString alloc] initWithString:rawString];
    [decoratedString setAttributes:@{
               NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:13.0],
     NSForegroundColorAttributeName:[UIColor colorWithRed:63/255.0 green:114/255.0 blue:155/255.0 alpha:1.0]
     } range:NSMakeRange(0, decoratedString.length)];

    return decoratedString;
}

- (NSMutableAttributedString *)toAttributedString:(NSString *)rawString
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:rawString];
    [attributedString setAttributes:@{
                NSFontAttributeName:[UIFont fontWithName:@"Arial" size:13.0]
     } range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

@end
