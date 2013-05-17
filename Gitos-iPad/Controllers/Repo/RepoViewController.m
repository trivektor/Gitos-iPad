//
//  RepoViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoViewController.h"
#import "WebsiteViewController.h"
#import "IssuesViewController.h"
#import "RepoDetailsCell.h"
#import "RepoTreeViewController.h"
#import "RepoLanguagesViewController.h"
#import "ReadmeViewController.h"
#import "Branch.h"
#import "NSTimer+Blocks.h"

@interface RepoViewController ()

@end

@implementation RepoViewController

@synthesize repo, hud, repoScrollView, detailsTable, branchesTable, repoBranches, actionOptions, isWatching, deleteConfirmation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        repoBranches = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self registerNib];
    [self registerNotifications];
    [repo fetchFullInfo];
}

- (void)adjustFrameHeight
{
    [repoScrollView setContentSize:self.view.frame.size];
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in repoScrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [repoScrollView setContentSize:(CGSizeMake(self.view.frame.size.width, scrollViewHeight + 35))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    [self.navigationItem setTitle:[self.repo getName]];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = LOADING_MESSAGE;

    deleteConfirmation = [[UIAlertView alloc]
                          initWithTitle:@"Confirm"
                          message:@"Are you sure you want to delete this repo? This action cannot be undone."
                          delegate:self
                          cancelButtonTitle:@"Never mind"
                          otherButtonTitles:@"Go ahead", nil];
}

- (void)registerNib
{
    UINib *repoDetailsCellNib = [UINib nibWithNibName:@"RepoDetailsCell" bundle:nil];
    [detailsTable registerNib:repoDetailsCellNib forCellReuseIdentifier:@"RepoDetailsCell"];

    NSArray *tables = [[NSArray alloc] initWithObjects:detailsTable, branchesTable, nil];
    
    UITableView *table;
    
    for (int i=0; i < [tables count]; i++) {
        table = [tables objectAtIndex:i];
        [table setScrollEnabled:NO];
        [table setBackgroundView:nil];
        [table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [table setSeparatorColor:[UIColor colorWithRed:200/255.0
                                                 green:200/255.0
                                                  blue:200/255.0
                                                 alpha:1.0]];
    }
}

- (void)registerNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    [center addObserver:self
               selector:@selector(prepareActionOptionsForStatus:)
                   name:@"StarChecked"
                 object:nil];

    [center addObserver:self
               selector:@selector(populateBranches:)
                   name:@"BranchesFetched"
                 object:nil];

    [center addObserver:self
               selector:@selector(updateStarredStatus)
                   name:@"RepoStarringUpdated"
                 object:nil];

    [center addObserver:self
               selector:@selector(displayRepoInfo:)
                   name:@"RepoInfoFetched"
                 object:nil];

    [center addObserver:self
               selector:@selector(showReadme:)
                   name:@"ReadmeFetched"
                 object:nil];
    
    [center addObserver:self
               selector:@selector(handlePostDestroyEvent:)
                   name:@"RepoDestroyed"
                 object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == detailsTable) {
        return 10;
    } else if (tableView == branchesTable) {
        return [repoBranches count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == detailsTable) {
        return [self cellForDetailsTableAtIndexPath:indexPath];
    } else {
        return [self cellForBranchesTableAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)cellForDetailsTableAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RepoDetailsCell";
    RepoDetailsCell *cell = [detailsTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[RepoDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setRepo:self.repo];
    [cell renderForIndexPath:indexPath];
    
    return cell;
}

- (UITableViewCell *)cellForBranchesTableAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [branchesTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    Branch *branch = [repoBranches objectAtIndex:indexPath.row];

    cell.textLabel.font  = [UIFont fontWithName:@"Arial" size:14.0];
    cell.textLabel.text  = [branch getName];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;

    UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
    backgroundView.backgroundColor = [UIColor peterRiverColor];

    cell.selectedBackgroundView = backgroundView;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == branchesTable) {
        RepoTreeViewController *repoTreeController = [[RepoTreeViewController alloc] init];
        repoTreeController.branch = [repoBranches objectAtIndex:indexPath.row];
        repoTreeController.repo   = repo;

        [self.navigationController pushViewController:repoTreeController
                                             animated:YES];
    } else if (tableView == detailsTable) {
        if (indexPath.row == 1) {
            NSString *url = [repo getHomepage];
            if (url != nil) {
                WebsiteViewController *websiteController = [[WebsiteViewController alloc] init];
                websiteController.requestedUrl = url;
                [self.navigationController pushViewController:websiteController
                                                     animated:YES];
            }
        } else if (indexPath.row == 4) {
            RepoLanguagesViewController *repoLanguagesController = [[RepoLanguagesViewController alloc] init];
            repoLanguagesController.repo = repo;
            [self.navigationController pushViewController:repoLanguagesController
                                                 animated:YES];
        } else if (indexPath.row == 8) {
            IssuesViewController *issuesController = [[IssuesViewController alloc] init];
            issuesController.repo = repo;
            [self.navigationController pushViewController:issuesController
                                                 animated:YES];
        } else if (indexPath.row == 9) {
            [hud show:YES];
            [repo fetchReadme];
        }
    }
}

- (void)populateBranches:(NSNotification *)notification
{
    repoBranches = [notification.userInfo valueForKey:@"Branches"];

    [branchesTable setFrame:CGRectMake(0, detailsTable.frame.size.height + 46, self.view.frame.size.width, [self.repoBranches count]*44 + 155)];
    [branchesTable reloadData];
    [hud hide:YES];
    [self adjustFrameHeight];
    
}

- (void)prepareActionOptionsForStatus:(NSNotification *)notification
{
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *) notification.object;

    int statusCode = [operation.response statusCode];

    NSString *starOption = nil;

    if (statusCode == 204) {
        starOption = @"Unstar";
        isWatching = YES;
    } else if (statusCode == 404) {
        starOption = @"Star";
        isWatching = NO;
    }

    actionOptions = [[UIActionSheet alloc] initWithTitle:@"Actions"
                                                delegate:self
                                       cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:starOption, @"View on Github", nil];

    if ([repo isDestroyable]) {
        [actionOptions addButtonWithTitle:@"Delete"];
    }

    UIBarButtonItem *actionsButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(showAvailableActions)];
    actionsButton.image = [UIImage imageNamed:@"211-action.png"];
    self.navigationItem.rightBarButtonItem = actionsButton;
}

- (void)updateStarredStatus
{
    NSString *starOption = nil;

    isWatching = !isWatching;

    if (isWatching) {
        starOption = @"Unstar";
        [AppHelper flashAlert:@"Repository starred" inView:self.view];
    } else {
        starOption = @"Star";
        [AppHelper flashAlert:@"Repository unstarred" inView:self.view];
    }

    actionOptions = [[UIActionSheet alloc] initWithTitle:@"Actions"
                                                delegate:self
                                       cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:starOption, @"View on Github", nil];

    if ([repo isDestroyable]) {
        [actionOptions addButtonWithTitle:@"Delete"];
    }
}

- (void)showAvailableActions
{
    [actionOptions showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    User *currentUser = [CurrentUserManager getUser];

    if (buttonIndex == 0) {
        if (isWatching) {
            // Star a repo
            [currentUser unstarRepo:repo];
        } else {
            // Unstar a repo
            [currentUser starRepo:repo];
        }
    } else if (buttonIndex != -1) {
        if ([[actionOptions buttonTitleAtIndex:buttonIndex] isEqualToString:@"View on Github"]) {
            WebsiteViewController *websiteController = [[WebsiteViewController alloc] init];
            websiteController.requestedUrl = [repo getGithubUrl];
            [self.navigationController pushViewController:websiteController animated:YES];
        } else if ([[actionOptions buttonTitleAtIndex:buttonIndex] isEqualToString:@"Delete"]) {
            [deleteConfirmation show];
        }
    }
}

- (void)displayRepoInfo:(NSNotification *)notification
{
    repo = [[Repo alloc] initWithData:notification.object];
    [detailsTable reloadData];
    [repo fetchBranches];
    [repo checkStar];
}

- (void)showReadme:(NSNotification *)notification
{
    [hud hide:YES];
    if (notification.object) {
        ReadmeViewController *readmeController = [[ReadmeViewController alloc] init];
        readmeController.readme = (Readme *) notification.object;

        [self.navigationController pushViewController:readmeController animated:YES];
    } else {
        [AppHelper flashError:@"Repo doesn't seem to have a README" inView:self.view];
    }
}

 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[deleteConfirmation buttonTitleAtIndex:buttonIndex] isEqualToString:@"Go ahead"]) {
        [repo destroy];
    }
}

- (void)handlePostDestroyEvent:(NSNotification *)notification
{
    [AppHelper flashAlert:@"Repo has been deleted" inView:self.view];
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                      block:^{
                                          [self.navigationController popViewControllerAnimated:YES];
                                      }
                                    repeats:NO];
}

@end