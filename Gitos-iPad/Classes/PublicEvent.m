//
//  PublicEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "PublicEvent.h"

@implementation PublicEvent

- (NSMutableAttributedString *)toString
{
    return [self toActorRepoString:@"open sourced"];
}

- (NSString *)toHTMLString
{
    return [self toActorRepoHTMLString:@"open sourced"];
}

@end
