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

@implementation AppInitialization

+ (void)run:(UIWindow *)window withUser:(User *)user
{
    MasterViewController *masterController = [MasterViewController new];
    masterController.user = user;

    UINavigationController *mainNavController = [[UINavigationController alloc] initWithRootViewController:[NewsfeedViewController new]];

    RESideMenu *sideMenuController = [[RESideMenu alloc] initWithContentViewController:mainNavController
                                                                    menuViewController:masterController];
    [sideMenuController setParallaxEnabled:NO];
    [sideMenuController setPanGestureEnabled:NO];
    [sideMenuController setContentViewScaleValue:0.9f];
    [sideMenuController setContentViewInLandscapeOffsetCenterX:800];

    [window setRootViewController:sideMenuController];
}

@end
