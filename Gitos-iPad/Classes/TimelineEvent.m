//
//  TimelineEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "TimelineEvent.h"

@implementation TimelineEvent

@synthesize eventId, type, createdAt, actor, payload, repo, todayDate, relativeDateDescriptor, fontAwesomeIcon, descriptionText;

- (id)initWithOptions:(NSDictionary *)options
{
    self = [super init];
    
    self.eventId        = [[options valueForKey:@"id"] intValue];
    self.type           = [options valueForKey:@"type"];
    self.actor          = [options valueForKey:@"actor"];
    self.payload        = [options valueForKey:@"payload"];
    self.createdAt      = [options valueForKey:@"created_at"];
    self.repo           = [options valueForKey:@"repo"];
    self.dateFormatter  = [[NSDateFormatter alloc] init];
    self.todayDate      = [NSDate date];
    self.relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    [self stringify];
    return self;
}

- (void)stringify
{
    NSString *eventType = self.type;
    NSString *actorName = [self.actor valueForKey:@"login"];
    NSString *repoName  = [self.repo valueForKey:@"name"];
    
    // REFACTOR
    if ([eventType isEqualToString:@"ForkEvent"]) {
        // Fork Event
        self.descriptionText = [NSString stringWithFormat:@"%@ forked %@", actorName, repoName];
        self.fontAwesomeIcon = @"icon-sitemap";
    } else if ([eventType isEqualToString:@"WatchEvent"]) {
        // Watch Event
        self.descriptionText = [NSString stringWithFormat:@"%@ starred %@", actorName, repoName];
        self.fontAwesomeIcon = @"icon-star";
    } else if ([eventType isEqualToString:@"CreateEvent"]) {
        // Create Event
        self.descriptionText = [NSString stringWithFormat:@"%@ created %@", actorName, repoName];
        self.fontAwesomeIcon = @"icon-plus";
    } else if ([eventType isEqualToString:@"FollowEvent"]) {
        // Follow Event
        NSString *target = [[self.payload valueForKey:@"target"] valueForKey:@"login"];
        self.descriptionText = [NSString stringWithFormat:@"%@ started following %@", actorName, target];
        self.fontAwesomeIcon = @"icon-user";
    } else if ([eventType isEqualToString:@"GistEvent"]) {
        // Gist Event
        NSString *action = [self.payload valueForKey:@"action"];
        NSString *gist = [[self.payload valueForKey:@"gist"] valueForKey:@"id"];
        self.descriptionText = [NSString stringWithFormat:@"%@ %@ gist:%@", actorName, action, gist];
        self.fontAwesomeIcon = @"icon-file-alt";
    } else if ([eventType isEqualToString:@"IssuesEvent"]) {
        // Issues Event
        NSDictionary *issue = [self.payload valueForKey:@"issue"];
        NSString *action = [self.payload valueForKey:@"action"];
        NSInteger issueNumber = [[issue valueForKey:@"number"] intValue];
        NSString *issueName = [NSString stringWithFormat:@"%@#%d", repoName, issueNumber];
        self.descriptionText = [NSString stringWithFormat:@"%@ %@ issue %@", actorName, action, issueName];
        self.fontAwesomeIcon = @"icon-warning-sign";
    } else if ([eventType isEqualToString:@"MemberEvent"]) {
        // Member Event
        NSString *member = [[self.payload valueForKey:@"member"] valueForKey:@"login"];
        self.descriptionText = [NSString stringWithFormat:@"%@ added %@ to %@", actorName, member, repoName];
        self.fontAwesomeIcon = @"icon-user-md";
    } else if ([eventType isEqualToString:@"IssueCommentEvent"]) {
        // IssueCommentEvent
        NSString *user = [[[self.payload valueForKey:@"comment"] valueForKey:@"user"] valueForKey:@"login"];
        NSDictionary *issue = [self.payload valueForKey:@"issue"];
        //NSString *action = [self.payload valueForKey:@"action"];
        NSInteger issueNumber = [[issue valueForKey:@"number"] intValue];
        NSString *issueName = [NSString stringWithFormat:@"%@#%d", repoName, issueNumber];
        self.descriptionText = [NSString stringWithFormat:@"%@ commented on issue %@", user, issueName];
        self.fontAwesomeIcon = @"icon-comment-alt";
    } else if ([eventType isEqualToString:@"PushEvent"]) {
        // Push Event
        NSArray *ref = [[self.payload valueForKey:@"ref"] componentsSeparatedByString:@"/"];
        NSString *branch = [ref lastObject];
        self.descriptionText = [NSString stringWithFormat:@"%@ pushed to %@ at %@", actorName, branch, repoName];
        self.fontAwesomeIcon = @"icon-upload-alt";
    } else if ([eventType isEqualToString:@"PullRequestEvent"]) {
        // Pull Request Event
        NSString *action = [self.payload valueForKey:@"action"];
        NSInteger pullRequestNumber = [[self.payload valueForKey:@"number"] integerValue];
        self.descriptionText = [NSString stringWithFormat:@"%@ %@ pull request %@/%i", actorName, action, repoName, pullRequestNumber];
        self.fontAwesomeIcon = @"icon-retweet";
    } else if ([eventType isEqualToString:@"PublicEvent"]) {
        // Public Event
        self.descriptionText = [NSString stringWithFormat:@"%@ open sourced %@", actorName, repoName];
        self.fontAwesomeIcon = @"icon-folder-open-alt";
    } else {
        self.descriptionText = @"";
        self.fontAwesomeIcon = @"icon-bullhorn";
    }
}

- (NSString *)toDateString
{
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    NSDate *date  = [self.dateFormatter dateFromString:self.createdAt];
    return [self.relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

@end
