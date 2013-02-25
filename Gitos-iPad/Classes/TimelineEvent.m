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
    // First refactoring effort on Feb 18 (create sub-classes of TimelineEvent)
    // Next: try to figure out how to initialize these classes dynamically
    if ([eventType isEqualToString:@"ForkEvent"]) {
        ForkEvent *forkEvent = [[ForkEvent alloc] initWithData:self.data];
        return [forkEvent toString];
    } else if ([eventType isEqualToString:@"WatchEvent"]) {
        WatchEvent *watchEvent = [[WatchEvent alloc] initWithData:self.data];
        return [watchEvent toString];
    } else if ([eventType isEqualToString:@"CreateEvent"]) {
        CreateEvent *createEvent = [[CreateEvent alloc] initWithData:self.data];
        return [createEvent toString];
    } else if ([eventType isEqualToString:@"DeleteEvent"]) {
        DeleteEvent *deleteEvent = [[DeleteEvent alloc] initWithData:self.data];
        return [deleteEvent toString];
    } else if ([eventType isEqualToString:@"FollowEvent"]) {
        FollowEvent *followEvent = [[FollowEvent alloc] initWithData:self.data];
        return [followEvent toString];
    } else if ([eventType isEqualToString:@"GistEvent"]) {
        GistEvent *gistEvent = [[GistEvent alloc] initWithData:self.data];
        return [gistEvent toString];
    } else if ([eventType isEqualToString:@"IssuesEvent"]) {
        IssueEvent *issueEvent = [[IssueEvent alloc] initWithData:self.data];
        return [issueEvent toString];
    } else if ([eventType isEqualToString:@"MemberEvent"]) {
        MemberEvent *memberEvent = [[MemberEvent alloc] initWithData:self.data];
        return [memberEvent toString];
    } else if ([eventType isEqualToString:@"IssueCommentEvent"]) {
        IssueCommentEvent *issueCommentEvent = [[IssueCommentEvent alloc] initWithData:self.data];
        return [issueCommentEvent toString];
    } else if ([eventType isEqualToString:@"PushEvent"]) {
        PushEvent *pushEvent = [[PushEvent alloc] initWithData:self.data];
        return [pushEvent toString];
    } else if ([eventType isEqualToString:@"PullRequestEvent"]) {
        PullRequestEvent *pullRequestEvent = [[PullRequestEvent alloc] initWithData:self.data];
        return [pullRequestEvent toString];
    } else if ([eventType isEqualToString:@"PublicEvent"]) {
        PublicEvent *publicEvent = [[PublicEvent alloc] initWithData:self.data];
        return [publicEvent toString];
    } else if ([eventType isEqualToString:@"CommitCommentEvent"]) {
        CommitCommentEvent *commitCommentEvent = [[CommitCommentEvent alloc] initWithData:self.data];
        return [commitCommentEvent toString];
    } else if ([eventType isEqualToString:@"GollumEvent"]) {
        GollumEvent *gollumEvent = [[GollumEvent alloc] initWithData:self.data];
        return [gollumEvent toString];
    } else {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
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
