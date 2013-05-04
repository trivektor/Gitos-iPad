//
//  GitosConstants.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 3/23/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GitosConstants.h"

@implementation GitosConstants

const NSString *CLIENT_ID = @"75f198a854031c317e62";
const NSString *CLIENT_SECRET = @"07d3e053d06132245799f4afe45b90d2780a89a8";
NSString * const LOADING_MESSAGE = @"Loading";
const float HIDE_AFTER = 2.0f;
const int REPO_DETAILS_MAX_CHARS = 65;
NSString * const GITHUB_OCTOCAT = @"http://octodex.github.com/images/original.jpg";

NSString * const EVENT_ACTOR_PREFIX           = @"actor:";
NSString * const EVENT_TARGET_ACTOR_PREFIX    = @"targetactor:";
NSString * const REPO_EVENT_PREFIX            = @"repo:";
NSString * const GIST_EVENT_PREFIX            = @"gist:";
NSString * const MEMBER_EVENT_PREFIX          = @"targetactor:";
NSString * const ISSUE_EVENT_PREFIX           = @"issue:";
NSString * const FOLLOW_EVENT_PREFIX          = @"targetactor:";
NSString * const GOLLUM_EVENT_PREFIX          = @"gollum:";
NSString * const PULL_REQUEST_EVENT_PREFIX    = @"pullrequest:";
NSString * const COMMIT_COMMENT_EVENT_PREFIX  = @"commit:";
NSString * const ISSUE_COMMENT_EVENT_PREFIX   = @"issuecomment:";


@end
