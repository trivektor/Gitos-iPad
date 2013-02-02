//
//  AppInitialization.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "AppInitialization.h"
#import "NewsfeedViewController.h"
#import "ReposViewController.h"
#import "GistsViewController.h"
#import "StarredViewController.h"
#import "OthersViewController.h"
#import "MasterViewController.h"
#import "DetailsViewController.h"

@implementation AppInitialization

+ (void)run:(UIWindow *)window
{
    UISplitViewController *splitController = [[UISplitViewController alloc] init];

    DetailsViewController *detailsController = [[DetailsViewController alloc] init];
    UINavigationController *detailsNavController = [[UINavigationController alloc] initWithRootViewController:detailsController];
    
    MasterViewController *masterController = [[MasterViewController alloc] init];
    masterController.detailsViewController = detailsController;
    masterController.parentViewController = splitController;

    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithObjects:masterController, detailsNavController, nil];
    
    [splitController setViewControllers:viewControllers];
    [window setRootViewController:splitController];
}

@end
