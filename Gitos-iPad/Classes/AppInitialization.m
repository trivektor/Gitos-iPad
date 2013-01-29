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

@implementation AppInitialization

+ (void)run:(UIWindow *)window
{
    NewsfeedViewController *newsfeedController  = [[NewsfeedViewController alloc] init];
    ReposViewController *reposController        = [[ReposViewController alloc] init];
    GistsViewController *gistsController        = [[GistsViewController alloc] init];
    StarredViewController *starredController    = [[StarredViewController alloc] init];
    OthersViewController *othersController      = [[OthersViewController alloc] init];
    
    UINavigationController *newsfeedNavController = [[UINavigationController alloc] initWithRootViewController:newsfeedController];
    newsfeedNavController.tabBarItem.title = @"News Feed";
    UIImage *newsIconImage = [UIImage imageNamed:@"275-broadcast.png"];
    
    UINavigationController *reposNavController = [[UINavigationController alloc] initWithRootViewController:reposController];
    reposNavController.tabBarItem.title = @"Repos";
    UIImage *reposIconImage = [UIImage imageNamed:@"33-cabinet.png"];
    
    UINavigationController *gistsNavController = [[UINavigationController alloc] initWithRootViewController:gistsController];
    gistsNavController.tabBarItem.title = @"Gists";
    UIImage *gistsIconImage = [UIImage imageNamed:@"179-notepad.png"];
    
    UINavigationController *starredNavController = [[UINavigationController alloc] initWithRootViewController:starredController];
    starredNavController.tabBarItem.title = @"Starred";
    UIImage *starredIconImage = [UIImage imageNamed:@"28-star_w.png"];
    
    UINavigationController *othersNavController = [[UINavigationController alloc] initWithRootViewController:othersController];
    othersNavController.tabBarItem.title = @"More";
    UIImage *othersIconImage = [UIImage imageNamed:@"256-box2.png"];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:
                                newsfeedNavController,
                                reposNavController,
                                starredNavController,
                                gistsNavController,
                                othersNavController,
                                nil];
    UITabBarController *tabController = [[UITabBarController alloc] init];
    [tabController setViewControllers:viewControllers];
    [tabController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    
    UITabBarItem *item0 = [tabController.tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabController.tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabController.tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabController.tabBar.items objectAtIndex:3];
    UITabBarItem *item4 = [tabController.tabBar.items objectAtIndex:4];
    
    [item0 setFinishedSelectedImage:newsIconImage withFinishedUnselectedImage:newsIconImage];
    [item1 setFinishedSelectedImage:reposIconImage withFinishedUnselectedImage:reposIconImage];
    [item2 setFinishedSelectedImage:starredIconImage withFinishedUnselectedImage:starredIconImage];
    [item3 setFinishedSelectedImage:gistsIconImage withFinishedUnselectedImage:gistsIconImage];
    [item4 setFinishedSelectedImage:othersIconImage withFinishedUnselectedImage:othersIconImage];
    
    [window setRootViewController:tabController];
}

@end
