//
//  GollumEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GollumEvent.h"

@implementation GollumEvent

- (NSMutableAttributedString *)toString
{
    return [self toActorRepoString:@"created wiki for"];
}

- (NSString *)toHTMLString
{
    return [self toActorRepoHTMLString:@"created wiki for"];
}

- (NSString *)getURLPrefixForObject:(NSObject *)object
{
    return GOLLUM_EVENT_PREFIX;
}

@end
