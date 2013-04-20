//
//  AppInitialization.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "AppInitialization.h"
#import "NewsfeedViewController.h"
#import "MasterViewController.h"
#import "IIViewDeckController.h"

@implementation AppInitialization

+ (void)run:(UIWindow *)window
{
    MasterViewController *masterController = [[MasterViewController alloc] init];

    NewsfeedViewController *newsfeedController = [[NewsfeedViewController alloc] init];

    UINavigationController *mainNavController = [[UINavigationController alloc] initWithRootViewController:newsfeedController];

    IIViewDeckController *deckController = [[IIViewDeckController alloc] initWithCenterViewController:mainNavController leftViewController:masterController];

    [window setRootViewController:deckController];
}

@end
