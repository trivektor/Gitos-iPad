//
//  CreateEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "CreateEvent.h"

@implementation CreateEvent

- (NSMutableAttributedString *)toString
{
    return [self toActorRepoString:@"created"];
}

- (NSString *)toHTMLString
{
    return [self toActorRepoHTMLString:@"created"];
}

@end
