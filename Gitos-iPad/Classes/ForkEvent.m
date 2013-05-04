//
//  ForkEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "ForkEvent.h"

@implementation ForkEvent

- (NSMutableAttributedString *)toString
{
    return [self toActorRepoString:@"forked"];
}

- (NSString *)toHTMLString
{
    return [self toActorRepoHTMLString:@"forked"];
}

- (NSString *)getURLPrefix
{
    return REPO_EVENT_PREFIX;
}

@end
