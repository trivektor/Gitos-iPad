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
#import "Branch.h"

@interface RepoViewController ()

@end

@implementation RepoViewController

@synthesize repo, hud, repoScrollView, detailsTable, branchesTable, repoBranches;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.repoBranches = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];

    [repo fetchBranches];
    [repo checkStar];
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

    [self registerNib];
    [self registerNotifications];
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
        [table setSeparatorColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]];
    }
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareActionOptionsForStatus:) name:@"StarChecked" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateBranches:) name:@"BranchesFetched" object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == detailsTable) {
        return 9;
    } else if (tableView == branchesTable) {
        return [self.repoBranches count];
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
    
    Branch *branch = [self.repoBranches objectAtIndex:indexPath.row];
    
    cell.textLabel.font  = [UIFont fontWithName:@"Arial" size:14.0];
    cell.textLabel.text  = [branch getName];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == branchesTable) {
        RepoTreeViewController *repoTreeController = [[RepoTreeViewController alloc] init];
        repoTreeController.branch = [self.repoBranches objectAtIndex:indexPath.row];
        repoTreeController.repo = self.repo;
        repoTreeController.node = (id)[NSNull null];
        
        [self.navigationController pushViewController:repoTreeController animated:YES];
    } else if (tableView == detailsTable) {
        if (indexPath.row == 1) {
            NSString *url = [self.repo getHomepage];
            if (url != nil) {
                WebsiteViewController *websiteController = [[WebsiteViewController alloc] init];
                websiteController.requestedUrl = url;
                [self.navigationController pushViewController:websiteController animated:YES];
            }
        } else if (indexPath.row == 8) {
            IssuesViewController *issuesController = [[IssuesViewController alloc] init];
            issuesController.repo = self.repo;
            [self.navigationController pushViewController:issuesController animated:YES];
        }
    }
}

- (void)populateBranches:(NSNotification *)notification
{
    repoBranches = [notification.userInfo valueForKey:@"Branches"];

    [branchesTable setFrame:CGRectMake(0, self.detailsTable.frame.size.height + 46, self.view.frame.size.width, [self.repoBranches count]*44 + 155)];
    [branchesTable reloadData];
    [hud hide:YES];
    [self adjustFrameHeight];
    
}

- (void)prepareActionOptionsForStatus:(NSNotification *)notification
{
    int statusCode = [[notification.userInfo valueForKey:@"Code"] intValue];

    if (statusCode == 204) {
        self.actionOptions = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:@"Unstar", @"View on Github", nil];
    } else if (statusCode == 404) {
        self.actionOptions = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:@"Star", @"View on Github", nil];
    }

    UIBarButtonItem *actionsButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(showAvailableActions)];
    actionsButton.image = [UIImage imageNamed:@"211-action.png"];
    self.navigationItem.rightBarButtonItem = actionsButton;
}

- (void)showAvailableActions
{
    [self.actionOptions showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {

    } else if (buttonIndex == 1) {
        WebsiteViewController *websiteController = [[WebsiteViewController alloc] init];
        websiteController.requestedUrl = [self.repo getGithubUrl];
        [self.navigationController pushViewController:websiteController animated:YES];
    }
}

@end
