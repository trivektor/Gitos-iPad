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
#import "IIViewDeckController.h"
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
    [menuTable setBackgroundColor:[UIColor colorWithRed:55/255.0
                                                  green:55/255.0
                                                   blue:55/255.0
                                                  alpha:1.0]];
    [menuTable setSeparatorColor:[UIColor clearColor]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toggleViewDeck)
                                                 name:@"ToggleViewDeck" object:nil];
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
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 1, 300, 25)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = [self tableView:tableView titleForHeaderInSection:section];

    headerLabel.textColor = [UIColor colorWithRed:179/255.0
                                            green:179/255.0
                                             blue:179/255.0
                                            alpha:1.0];

    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];

    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 25)];

    backgroundView.backgroundColor = [UIColor colorWithRed:49/255.0
                                                     green:49/255.0
                                                      blue:49/255.0
                                                     alpha:0.9];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"magma_border.png"]]];
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

        [cell renderForIndexPath:indexPath];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *selectedController;

    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                ProfileViewController *profileController = [[ProfileViewController alloc] init];
                profileController.user = user;
                profileController.hideOptionsButton = YES;
                selectedController = [[UINavigationController alloc] initWithRootViewController:profileController];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                NewsfeedViewController *newsfeedController = [[NewsfeedViewController alloc] init];
                selectedController = [[UINavigationController alloc] initWithRootViewController:newsfeedController];
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                ReposViewController *reposController = [[ReposViewController alloc] init];
                reposController.user = user;
                reposController.hideBackButton = YES;
                selectedController = [[UINavigationController alloc] initWithRootViewController:reposController];
            } else if (indexPath.row == 1) {
                StarredViewController *starredController = [[StarredViewController alloc] init];
                starredController.user = user;
                selectedController = [[UINavigationController alloc] initWithRootViewController:starredController];
            } else if (indexPath.row == 2) {
                NewRepoViewController *newRepoController = [[NewRepoViewController alloc] init];
                selectedController = [[UINavigationController alloc] initWithRootViewController:newRepoController];
            }
            break;
        case 3:
            if (indexPath.row == 0) {
                GistsViewController *gistsController = [[GistsViewController alloc] init];
                gistsController.user = user;
                gistsController.hideBackButton = YES;
                selectedController = [[UINavigationController alloc] initWithRootViewController:gistsController];
            } else if (indexPath.row == 1) {
                SearchViewController *searchController = [[SearchViewController alloc] init];
                searchController.user = user;
                selectedController = [[UINavigationController alloc] initWithRootViewController:searchController];
            } else if (indexPath.row == 2) {
                selectedController = [[UINavigationController alloc] initWithRootViewController:[[NotificationsViewController alloc] init]];
            } else if (indexPath.row == 3) {
                selectedController = [[UINavigationController alloc] initWithRootViewController:[[FeedbackViewController alloc] init]];
            } else if (indexPath.row == 4) {
                [self signout];
                return;
            } else if (indexPath.row == 5) {
                selectedController = [[UINavigationController alloc] initWithRootViewController:[[AttributionsViewController alloc] init]];
            }
            break;
    }

    [self navigateToSelectedController:selectedController];
}

- (void)navigateToSelectedController:(UINavigationController *)selectedController
{
    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        controller.centerController = selectedController;
    }];
}

- (void)signout
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Sign out" otherButtonTitles:nil];
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

- (void)toggleViewDeck
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (void)displayAvatarAndUsername
{
    User *currentUser = [CurrentUserManager getUser];
    NSData *userImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[currentUser getAvatarUrl]]];
    avatar.image = [UIImage imageWithData:userImageData];
    avatar.layer.masksToBounds  = YES;
    avatar.layer.cornerRadius   = 3;

    usernameLabel.text = [currentUser getLogin];
    usernameLabel.textColor = [UIColor whiteColor];

    UIView *backgroundView = [[UIView alloc] initWithFrame:profileCell.frame];
    backgroundView.backgroundColor = [UIColor alizarinColor];

    profileCell.selectedBackgroundView = backgroundView;
}

@end
