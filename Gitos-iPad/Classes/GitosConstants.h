//
//  GitosConstants.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 3/23/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitosConstants : NSObject

extern const NSString *CLIENT_ID;
extern const NSString *CLIENT_SECRET;
extern NSString * const LOADING_MESSAGE;
extern const float HIDE_AFTER;
extern const int REPO_DETAILS_MAX_CHARS;
extern NSString * const GITHUB_OCTOCAT;

extern NSString * const EVENT_ACTOR_PREFIX;
extern NSString * const EVENT_TARGET_ACTOR_PREFIX;
extern NSString * const REPO_EVENT_PREFIX;
extern NSString * const GIST_EVENT_PREFIX;
extern NSString * const ISSUE_EVENT_PREFIX;
extern NSString * const FOLLOW_EVENT_PREFIX;
extern NSString * const MEMBER_EVENT_PREFIX;
extern NSString * const GOLLUM_EVENT_PREFIX;
extern NSString * const PULL_REQUEST_EVENT_PREFIX;
extern NSString * const COMMIT_COMMENT_EVENT_PREFIX;
extern NSString * const ISSUE_COMMENT_EVENT_PREFIX;

@end
