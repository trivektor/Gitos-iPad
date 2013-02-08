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
#import "MasterControllerCell.h"
#import "ProfileViewController.h"
#import "RepoSearchViewController.h"
#import "LoginViewController.h"
#import "SSKeychain.h"

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
    [self performHouseKeepingTasks];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Gitos";
    [menuTable setScrollEnabled:NO];

    UINib *nib = [UINib nibWithNibName:@"MasterControllerCell" bundle:nil];

    [menuTable registerNib:nib forCellReuseIdentifier:@"MasterControllerCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MasterControllerCell";
    MasterControllerCell *cell = [menuTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[MasterControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [cell renderForIndexPath:indexPath];

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
    } else if (indexPath.row == 4) {
        ProfileViewController *profileController = [[ProfileViewController alloc] init];
        profileController.hideBackButton = YES;
        [self.delegate didSelectViewController:profileController];
    } else if (indexPath.row == 5) {
        [self.delegate didSelectViewController:[[RepoSearchViewController alloc] init]];
    } else if (indexPath.row == 6) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Go ahead, make my day" otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 'OK' was clicked
    if (buttonIndex == 0) {
        [SSKeychain deletePasswordForService:@"access_token" account:@"gitos"];
        LoginViewController *loginController = [[LoginViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
        [self.view.window setRootViewController:navController];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
