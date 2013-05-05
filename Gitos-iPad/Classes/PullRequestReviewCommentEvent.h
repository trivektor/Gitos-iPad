//
//  PullRequestReviewCommentEvent.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/5/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "TimelineEvent.h"

@interface PullRequestReviewCommentEvent : TimelineEvent

- (NSMutableAttributedString *)toString;
- (NSString *)toHTMLString;

@end
