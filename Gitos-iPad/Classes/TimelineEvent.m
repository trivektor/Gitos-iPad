//
//  TimelineEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "TimelineEvent.h"

@implementation TimelineEvent

@synthesize eventId, type, createdAt, actor, payload, repo, todayDate, relativeDateDescriptor;

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
    return self;
}

- (NSString *)toString
{
    NSString *eventType = self.type;
    NSString *actorName = [self.actor valueForKey:@"login"];
    NSString *repoName  = [self.repo valueForKey:@"name"];
    
    
    if ([eventType isEqualToString:@"ForkEvent"]) {
        // Fork Event
        return [NSString stringWithFormat:@"%@ forked %@", actorName, repoName];
    } else if ([eventType isEqualToString:@"WatchEvent"]) {
        // Watch Event
        return [NSString stringWithFormat:@"%@ starred %@", actorName, repoName];
    } else if ([eventType isEqualToString:@"CreateEvent"]) {
        // Create Event
        return [NSString stringWithFormat:@"%@ created %@", actorName, repoName];
    } else if ([eventType isEqualToString:@"FollowEvent"]) {
        // Follow Event
        NSString *target = [[self.payload valueForKey:@"target"] valueForKey:@"login"];
        return [NSString stringWithFormat:@"%@ started following %@", actorName, target];
    } else if ([eventType isEqualToString:@"GistEvent"]) {
        // Gist Event
        NSString *action = [self.payload valueForKey:@"action"];
        NSString *gist = [[self.payload valueForKey:@"gist"] valueForKey:@"id"];
        return [NSString stringWithFormat:@"%@ %@ gist:%@", actorName, action, gist];
    } else if ([eventType isEqualToString:@"IssuesEvent"]) {
        // Issues Event
        NSDictionary *issue = [self.payload valueForKey:@"issue"];
        NSString *action = [self.payload valueForKey:@"action"];
        NSInteger issueNumber = [[issue valueForKey:@"number"] intValue];
        NSString *issueName = [NSString stringWithFormat:@"%@#%d", repoName, issueNumber];
        
        return [NSString stringWithFormat:@"%@ %@ issue %@", actorName, action, issueName];
    } else if ([eventType isEqualToString:@"MemberEvent"]) {
        // Member Event
        NSString *member = [[self.payload valueForKey:@"member"] valueForKey:@"login"];
        return [NSString stringWithFormat:@"%@ added %@ to %@", actorName, member, repoName];
    } else if ([eventType isEqualToString:@"IssueCommentEvent"]) {
        // IssueCommentEvent
        
        NSString *user = [[[self.payload valueForKey:@"comment"] valueForKey:@"user"] valueForKey:@"login"];
        NSDictionary *issue = [self.payload valueForKey:@"issue"];
        //NSString *action = [self.payload valueForKey:@"action"];
        NSInteger issueNumber = [[issue valueForKey:@"number"] intValue];
        NSString *issueName = [NSString stringWithFormat:@"%@#%d", repoName, issueNumber];
        return [NSString stringWithFormat:@"%@ commented on issue %@", user, issueName];
    } else if ([eventType isEqualToString:@"PushEvent"]) {
        // Push Event
        NSArray *ref = [[self.payload valueForKey:@"ref"] componentsSeparatedByString:@"/"];
        NSString *branch = [ref lastObject];
        return [NSString stringWithFormat:@"%@ pushed to %@ at %@", actorName, branch, repoName];
    } else if ([eventType isEqualToString:@"PullRequestEvent"]) {
        // Pull Request Event
        NSString *action = [self.payload valueForKey:@"action"];
        NSInteger pullRequestNumber = [[self.payload valueForKey:@"number"] integerValue];
        return [NSString stringWithFormat:@"%@ %@ pull request %@/%i", actorName, action, repoName, pullRequestNumber];
    } else if ([eventType isEqualToString:@"PublicEvent"]) {
        // Public Event
        return [NSString stringWithFormat:@"%@ open sourced %@", actorName, repoName];
    }
    
    return @"";
}

- (NSString *)toDateString
{
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    NSDate *date  = [self.dateFormatter dateFromString:self.createdAt];
    return [self.relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

@end
