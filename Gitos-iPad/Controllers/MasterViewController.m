//
//  MasterViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/1/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "MasterViewController.h"
#import "NewsfeedViewController.h"
#import "ReposViewController.h"
#import "GistsViewController.h"
#import "StarredViewController.h"
#import "OthersViewController.h"


@interface MasterViewController ()

@end

@implementation MasterViewController

@synthesize menuTable, detailsViewController, parentViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [menuTable dequeueReusableCellWithIdentifier:@"Cell"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"News Feed";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Repositories";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Watched";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"Gists";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:[self.parentViewController viewControllers]];
    UINavigationController *navController;

    if (indexPath.row == 0) {
        NewsfeedViewController *newsfeedController = [[NewsfeedViewController alloc] init];
        navController = [[UINavigationController alloc] initWithRootViewController:newsfeedController];
    } else if (indexPath.row == 1) {
        ReposViewController *reposController = [[ReposViewController alloc] init];
        navController = [[UINavigationController alloc] initWithRootViewController:reposController];
    } else if (indexPath.row == 2) {
        StarredViewController *starredController = [[StarredViewController alloc] init];
        navController = [[UINavigationController alloc] initWithRootViewController:starredController];
    } else if (indexPath.row == 3) {
        GistsViewController *gistsController = [[GistsViewController alloc] init];
        navController = [[UINavigationController alloc] initWithRootViewController:gistsController];
    }
    [viewControllers replaceObjectAtIndex:1 withObject:navController];
    [self.parentViewController setViewControllers:viewControllers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
