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
#import "NewRepoViewController.h"
#import "MasterControllerCell.h"
#import "ProfileViewController.h"
#import "RepoSearchViewController.h"
#import "LoginViewController.h"
#import "SearchViewController.h"
#import "FeedbackViewController.h"
#import "NotificationsViewController.h"
#import "AttributionsViewController.h"
#import "UIColor+FlatUI.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

@synthesize user, menuTable, parentViewController, avatar, usernameLabel, profileCell;

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
    [menuTable setScrollEnabled:NO];

    UINib *nib = [UINib nibWithNibName:@"MasterControllerCell" bundle:nil];

    [menuTable registerNib:nib forCellReuseIdentifier:@"MasterControllerCell"];
    [menuTable setBackgroundColor:[UIColor clearColor]];
    [menuTable setSeparatorColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"side_menu_bg.png"]]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;

    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = 1;
            break;
        case 2:
            rows = 3;
            break;
        case 3:
            rows = 6;
            break;
        default:
            rows = 0;
            break;
    }

    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 1, 300, 25)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = [[self tableView:tableView titleForHeaderInSection:section] uppercaseString];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    headerLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    headerLabel.shadowOffset = CGSizeMake(1, 1);

    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 25)];

    [backgroundView addSubview:headerLabel];

    return backgroundView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle;

    switch (section) {
        case 0:
            headerTitle = @"Profile";
            break;
        case 1:
            headerTitle = @"News Feed";
            break;
        case 2:
            headerTitle = @"Repositories";
            break;
        case 3:
            headerTitle = @"Others";
            break;
    }

    return headerTitle;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self displayAvatarAndUsername];
        return profileCell;
    } else {
        static NSString *cellIdentifier = @"MasterControllerCell";
        MasterControllerCell *cell = [menuTable dequeueReusableCellWithIdentifier:cellIdentifier];

        if (!cell) {
            cell = [[MasterControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }

        [cell renderForIndexPath:indexPath withNumRows:[tableView numberOfRowsInSection:indexPath.section]];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *selectedController;

    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                ProfileViewController *profileController = [ProfileViewController new];
                profileController.user = user;
                profileController.hideOptionsButton = YES;
                selectedController = [[UINavigationController alloc] initWithRootViewController:profileController];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                NewsfeedViewController *newsfeedController = [NewsfeedViewController new];
                selectedController = [[UINavigationController alloc] initWithRootViewController:newsfeedController];
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                ReposViewController *reposController = [ReposViewController new];
                reposController.user = user;
                reposController.hideBackButton = YES;
                selectedController = [[UINavigationController alloc] initWithRootViewController:reposController];
            } else if (indexPath.row == 1) {
                StarredViewController *starredController = [StarredViewController new];
                starredController.user = user;
                selectedController = [[UINavigationController alloc] initWithRootViewController:starredController];
            } else if (indexPath.row == 2) {
                NewRepoViewController *newRepoController = [NewRepoViewController new];
                selectedController = [[UINavigationController alloc] initWithRootViewController:newRepoController];
            }
            break;
        case 3:
            if (indexPath.row == 0) {
                GistsViewController *gistsController = [GistsViewController new];
                gistsController.user = user;
                gistsController.hideBackButton = YES;
                selectedController = [[UINavigationController alloc] initWithRootViewController:gistsController];
            } else if (indexPath.row == 1) {
                SearchViewController *searchController = [SearchViewController new];
                searchController.user = user;
                selectedController = [[UINavigationController alloc] initWithRootViewController:searchController];
            } else if (indexPath.row == 2) {
                selectedController = [[UINavigationController alloc] initWithRootViewController:[NotificationsViewController new]];
            } else if (indexPath.row == 3) {
                selectedController = [[UINavigationController alloc] initWithRootViewController:[FeedbackViewController new]];
            } else if (indexPath.row == 4) {
                [self signout];
                return;
            } else if (indexPath.row == 5) {
                selectedController = [[UINavigationController alloc] initWithRootViewController:[AttributionsViewController new]];
            }
            break;
    }

    [self navigateToSelectedController:selectedController];
}

- (void)navigateToSelectedController:(UINavigationController *)selectedController
{
    [self.sideMenuViewController setContentViewController:selectedController];
    [self.sideMenuViewController hideMenuViewController];
}

- (void)signout
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                     destructiveButtonTitle:@"Sign out"
                                          otherButtonTitles:nil];
    self.actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [self.actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 'OK' was clicked
    if (buttonIndex == 0) {
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:NO];
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

- (void)displayAvatarAndUsername
{
    User *currentUser = [CurrentUserManager getUser];
    NSData *userImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[currentUser getAvatarUrl]]];
    avatar.image = [UIImage imageWithData:userImageData];

    usernameLabel.text = [currentUser getLogin];
    usernameLabel.textColor = [UIColor whiteColor];
    usernameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    usernameLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    usernameLabel.shadowOffset = CGSizeMake(1, 1);
    profileCell.backgroundColor = [UIColor clearColor];
    profileCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
