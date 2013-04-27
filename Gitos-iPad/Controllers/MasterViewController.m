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
#import "MasterControllerCell.h"
#import "ProfileViewController.h"
#import "RepoSearchViewController.h"
#import "LoginViewController.h"
#import "SearchViewController.h"
#import "FeedbackViewController.h"
#import "NotificationsViewController.h"
#import "IIViewDeckController.h"

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
    self.navigationItem.title = @"Gitos";
    [menuTable setScrollEnabled:NO];

    UINib *nib = [UINib nibWithNibName:@"MasterControllerCell" bundle:nil];

    [menuTable registerNib:nib forCellReuseIdentifier:@"MasterControllerCell"];
    [menuTable setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"magma"]]];
    [menuTable setSeparatorColor:[UIColor clearColor]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleViewDeck) name:@"ToggleViewDeck" object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"magma_border.png"]]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
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

    if (indexPath.row == 0 || indexPath.row == 5) {

        ProfileViewController *profileController = [[ProfileViewController alloc] init];
        profileController.hideBackButton = YES;
        profileController.hideOptionsButton = YES;
        selectedController = [[UINavigationController alloc] initWithRootViewController:profileController];

    } else if (indexPath.row == 1) {

        NewsfeedViewController *newsfeedController = [[NewsfeedViewController alloc] init];
        newsfeedController.user = user;
        selectedController = [[UINavigationController alloc] initWithRootViewController:newsfeedController];

    } else if (indexPath.row == 2) {

        ReposViewController *reposController = [[ReposViewController alloc] init];
        reposController.user = user;
        reposController.hideBackButton = YES;
        selectedController = [[UINavigationController alloc] initWithRootViewController:reposController];

    } else if (indexPath.row == 3) {

        StarredViewController *starredController = [[StarredViewController alloc] init];
        starredController.user = user;
        selectedController = [[UINavigationController alloc] initWithRootViewController:starredController];

    } else if (indexPath.row == 4) {

        GistsViewController *gistsController = [[GistsViewController alloc] init];
        gistsController.user = user;
        gistsController.hideBackButton = YES;
        selectedController = [[UINavigationController alloc] initWithRootViewController:gistsController];

    } else if (indexPath.row == 6) {

        selectedController = [[UINavigationController alloc] initWithRootViewController:[[SearchViewController alloc] init]];

    } else if (indexPath.row == 7) {

        selectedController = [[UINavigationController alloc] initWithRootViewController:[[NotificationsViewController alloc] init]];

    } else if (indexPath.row == 8) {

        selectedController = [[UINavigationController alloc] initWithRootViewController:[[FeedbackViewController alloc] init]];

    } else if (indexPath.row == 9) {
        [self signout];
        return;
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
    NSData *userImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[user getAvatarUrl]]];
    avatar.image = [UIImage imageWithData:userImageData];
    avatar.layer.masksToBounds  = YES;
    avatar.layer.borderColor    = [[UIColor blackColor] CGColor];
    avatar.layer.borderWidth    = 1;
    avatar.layer.cornerRadius   = 3;

    usernameLabel.text = [user getLogin];
    usernameLabel.textColor = [UIColor whiteColor];

    UIView *selectedBackgroundView  = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"selected_cell_bg.png"]]];
    profileCell.selectedBackgroundView = selectedBackgroundView;

}

@end
