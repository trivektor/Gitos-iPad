//
//  User.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "User.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@implementation User

@synthesize name, login, url, receivedEventsUrl, followingUrl, avatarUrl, htmlUrl, starredUrl, reposUrl, gistsUrl,
location, publicGists, privateGists, email, followers, following, blog, createdAt, company, bio, publicRepos;

- (id)initWithOptions:(NSDictionary *)options
{
    self.name               = [options valueForKey:@"name"];
    self.login              = [options valueForKey:@"login"];
    self.url                = [options valueForKey:@"url"];
    self.followingUrl       = [options valueForKey:@"follwowing_url"];
    self.receivedEventsUrl  = [options valueForKey:@"received_events_url"];
    self.avatarUrl          = [options valueForKey:@"avatar_url"];
    self.starredUrl         = [self.url stringByAppendingString:@"/starred"];
    self.gistsUrl           = [self.url stringByAppendingString:@"/gists"];
    self.htmlUrl            = [options valueForKey:@"html_url"];
    self.reposUrl           = [options valueForKey:@"repos_url"];
    self.location           = [options valueForKey:@"location"];
    self.publicGists        = [options valueForKey:@"public_gists"];
    self.privateGists       = [options valueForKey:@"private_gists"];
    self.email              = [options valueForKey:@"email"];
    self.followers          = [[options valueForKey:@"followers"] integerValue];
    self.following          = [[options valueForKey:@"following"] integerValue];
    self.publicRepos        = [[options valueForKey:@"public_repos"] integerValue];
    self.createdAt          = [options valueForKey:@"created_at"];
    self.blog               = [options valueForKey:@"blog"];
    self.company            = [options valueForKey:@"company"];
    [self handleNullValues];
    
    return self;
}

- (void)handleNullValues
{
    if (self.email == (id)[NSNull null] || self.email.length == 0) self.email = @"n/a";
    if (self.blog == (id)[NSNull null]) self.blog = @"n/a";
    if (self.location == (id)[NSNull null]) self.location = @"n/a";
    if (self.company == (id)[NSNull null]) self.company = @"n/a";
}

@end
