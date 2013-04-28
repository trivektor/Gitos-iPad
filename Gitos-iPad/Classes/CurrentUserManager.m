//
//  CurrentUserManager.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "CurrentUserManager.h"

@implementation CurrentUserManager

static User *userSingleton = nil;

+ (void)initializeWithUser:(User *)user
{
    userSingleton = user;
}

+ (id)getUser
{
    return userSingleton;
}

@end
