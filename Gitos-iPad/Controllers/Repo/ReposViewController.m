//
//  ReposViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "ReposViewController.h"
#import "RepoCell.h"
#import "RepoViewController.h"

@interface ReposViewController ()

@end

@implementation ReposViewController

@synthesize user, reposTable, repos, hud, currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        repos = [[NSMutableArray alloc] initWithCapacity:0];
        currentPage = 1;
        user = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super performHousekeepingTasks];

    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Repositories";

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = LOADING_MESSAGE;

    [self registerNib];
    [self registerEvents];
    [self getUserRepos];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.hideBackButton) {
        self.navigationItem.hidesBackButton = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerNib
{
    UINib *nib = [UINib nibWithNibName:@"RepoCell" bundle:nil];
    [reposTable registerNib:nib forCellReuseIdentifier:@"RepoCell"];
    [reposTable setDelegate:self];
    [reposTable setDataSource:self];
    [reposTable setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [reposTable setBackgroundView:nil];
    [reposTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [reposTable setSeparatorColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayUserRepos:)
                                                 name:@"UserReposFetched"
                                               object:nil];
}

- (void)getUserRepos
{
    [user fetchReposForPage:currentPage++];
}

- (void)displayUserRepos:(NSNotification *)notification
{
    repos = notification.object;
    [reposTable reloadData];
    [hud hide:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return repos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RepoCell";
    
    RepoCell *cell = [reposTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[RepoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.repo = [repos objectAtIndex:indexPath.row];
    [cell render];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepoViewController *repoController = [[RepoViewController alloc] init];
    repoController.repo = [repos objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:repoController animated:YES];
}

@end