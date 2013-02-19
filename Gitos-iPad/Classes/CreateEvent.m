//
//  CreateEvent.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "CreateEvent.h"

@implementation CreateEvent

- (NSString *)toString
{
    User *actor = [self getActor];
    Repo *repo = [self getRepo];

    return [NSString stringWithFormat:@"%@ created %@", [actor getLogin], [repo getName]];
}

@end
