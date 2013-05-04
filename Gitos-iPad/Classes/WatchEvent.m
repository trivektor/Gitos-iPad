//
//  WatchEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "WatchEvent.h"

@implementation WatchEvent

- (NSMutableAttributedString *)toString
{
    return [self toActorRepoString:@"watched"];
}

- (NSString *)toHTMLString
{
    return [self toActorRepoHTMLString:@"watched"];
}

- (NSString *)getURLPrefixForObject:(NSObject *)object
{
    return REPO_EVENT_PREFIX;
}

@end
