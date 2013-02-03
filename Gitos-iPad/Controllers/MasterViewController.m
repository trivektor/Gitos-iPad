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

@synthesize menuTable, parentViewController;

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
    self.navigationItem.title = @"Gitos";
    [menuTable setScrollEnabled:NO];
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
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [menuTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

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
    if (indexPath.row == 0) {
        [self.delegate didSelectViewController:[[NewsfeedViewController alloc] init]];
    } else if (indexPath.row == 1) {
        [self.delegate didSelectViewController:[[ReposViewController alloc] init]];
    } else if (indexPath.row == 2) {
        [self.delegate didSelectViewController:[[StarredViewController alloc] init]];
    } else if (indexPath.row == 3) {
        [self.delegate didSelectViewController:[[GistsViewController alloc] init]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
