//
//  FollowEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "FollowEvent.h"

@implementation FollowEvent

- (NSString *)toString
{
    User *actor = [self getActor];
    User *target = [[User alloc] initWithData:[self getTarget]];
    return [NSString stringWithFormat:@"%@ started following %@", [actor getLogin], [target getLogin]];
}

@end
