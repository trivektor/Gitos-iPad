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
    NSString *fontAwesome = @"icon-bullhorn";
    NSString *text = @"";
    
    // REFACTOR
    if ([eventType isEqualToString:@"ForkEvent"]) {
        // Fork Event
        text = [NSString stringWithFormat:@"%@ forked %@", actorName, repoName];
        fontAwesome = @"icon-sitemap";
    } else if ([eventType isEqualToString:@"WatchEvent"]) {
        // Watch Event
        text = [NSString stringWithFormat:@"%@ starred %@", actorName, repoName];
        fontAwesome = @"icon-star";
    } else if ([eventType isEqualToString:@"CreateEvent"]) {
        // Create Event
        text = [NSString stringWithFormat:@"%@ created %@", actorName, repoName];
        fontAwesome = @"icon-plus";
    } else if ([eventType isEqualToString:@"FollowEvent"]) {
        // Follow Event
        NSString *target = [[self.payload valueForKey:@"target"] valueForKey:@"login"];
        text = [NSString stringWithFormat:@"%@ started following %@", actorName, target];
        fontAwesome = @"icon-user";
    } else if ([eventType isEqualToString:@"GistEvent"]) {
        // Gist Event
        NSString *action = [self.payload valueForKey:@"action"];
        NSString *gist = [[self.payload valueForKey:@"gist"] valueForKey:@"id"];
        text = [NSString stringWithFormat:@"%@ %@ gist:%@", actorName, action, gist];
        fontAwesome = @"icon-file-alt";
    } else if ([eventType isEqualToString:@"IssuesEvent"]) {
        // Issues Event
        NSDictionary *issue = [self.payload valueForKey:@"issue"];
        NSString *action = [self.payload valueForKey:@"action"];
        NSInteger issueNumber = [[issue valueForKey:@"number"] intValue];
        NSString *issueName = [NSString stringWithFormat:@"%@#%d", repoName, issueNumber];
        text = [NSString stringWithFormat:@"%@ %@ issue %@", actorName, action, issueName];
        fontAwesome = @"icon-warning-sign";
    } else if ([eventType isEqualToString:@"MemberEvent"]) {
        // Member Event
        NSString *member = [[self.payload valueForKey:@"member"] valueForKey:@"login"];
        text = [NSString stringWithFormat:@"%@ added %@ to %@", actorName, member, repoName];
        fontAwesome = @"icon-user-md";
    } else if ([eventType isEqualToString:@"IssueCommentEvent"]) {
        // Issue Comment Event
        NSString *user = [[[self.payload valueForKey:@"comment"] valueForKey:@"user"] valueForKey:@"login"];
        NSDictionary *issue = [self.payload valueForKey:@"issue"];
        NSInteger issueNumber = [[issue valueForKey:@"number"] intValue];
        NSString *issueName = [NSString stringWithFormat:@"%@#%d", repoName, issueNumber];
        text = [NSString stringWithFormat:@"%@ commented on issue %@", user, issueName];
        fontAwesome = @"icon-comment-alt";
    } else if ([eventType isEqualToString:@"PushEvent"]) {
        // Push Event
        NSArray *ref = [[self.payload valueForKey:@"ref"] componentsSeparatedByString:@"/"];
        NSString *branch = [ref lastObject];
        text = [NSString stringWithFormat:@"%@ pushed to %@ at %@", actorName, branch, repoName];
        fontAwesome = @"icon-upload-alt";
    } else if ([eventType isEqualToString:@"PullRequestEvent"]) {
        // Pull Request Event
        NSString *action = [self.payload valueForKey:@"action"];
        NSInteger pullRequestNumber = [[self.payload valueForKey:@"number"] integerValue];
        text = [NSString stringWithFormat:@"%@ %@ pull request %@/%i", actorName, action, repoName, pullRequestNumber];
        fontAwesome = @"icon-retweet";
    } else if ([eventType isEqualToString:@"PublicEvent"]) {
        // Public Event
        text = [NSString stringWithFormat:@"%@ open sourced %@", actorName, repoName];
        fontAwesome = @"icon-folder-open-alt";
    } else if ([eventType isEqualToString:@"CommitCommentEvent"]) {
        // Commit Comment Event
        NSDictionary *comment = [payload valueForKey:@"comment"];
        NSString *commitId    = [comment valueForKey:@"commit_id"];
        text  = [NSString stringWithFormat:@"%@ commented on commit %@@%@", actorName, repoName, [commitId substringToIndex:9]];
        fontAwesome = @"icon-comments";
    }

    self.fontAwesomeIcon = fontAwesome;
    self.descriptionText = text;
}

- (NSString *)toDateString
{
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    NSDate *date  = [self.dateFormatter dateFromString:self.createdAt];
    return [self.relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

@end
