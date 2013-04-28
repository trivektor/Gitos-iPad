//
//  CurrentUserManager.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentUserManager : NSObject

+ (void)initializeWithUser:(User *)user;
+ (id)getUser;

@end
