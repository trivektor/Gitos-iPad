//
//  StarredViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "StarredViewController.h"
#import "RepoCell.h"
#import "Repo.h"
#import "RepoViewController.h"

@interface StarredViewController ()

@end

@implementation StarredViewController

@synthesize user, starredRepos, currentPage, starredReposTable, hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentPage = 1;
        starredRepos = [[NSMutableArray alloc] initWithCapacity:0];
        user = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super performHousekeepingTasks];

    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"Starred Repositories"];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = LOADING_MESSAGE;

    [self registerNib];
    [self registerEvents];
    [self setupPullToRefresh];
    [user fetchStarredReposForPage:currentPage++];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerNib
{
    UINib *nib = [UINib nibWithNibName:@"RepoCell" bundle:nil];
    [starredReposTable registerNib:nib forCellReuseIdentifier:@"RepoCell"];
    [starredReposTable setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [starredReposTable setBackgroundView:nil];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayStarredRepos:)
                                                 name:@"StarredReposFetched"
                                               object:nil];
}

- (void)displayStarredRepos:(NSNotification *)notification
{
    [starredRepos addObjectsFromArray:notification.object];
    [starredReposTable reloadData];
    [starredReposTable.pullToRefreshView stopAnimating];
    [hud hide:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return starredRepos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RepoCell";
    
    RepoCell *cell = [starredReposTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[RepoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    cell.repo = [starredRepos objectAtIndex:indexPath.row];
    [cell render];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepoViewController *repoController = [[RepoViewController alloc] init];
    repoController.repo = [starredRepos objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:repoController animated:YES];
}

// https://github.com/stephenjames/ContinuousTableview/blob/master/Classes/RootViewController.m
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) == scrollView.contentSize.height) {
        [hud show:YES];
        [user fetchStarredReposForPage:currentPage++];
    }
}

- (void)setupPullToRefresh
{
    self.currentPage = 1;
    [starredReposTable addPullToRefreshWithActionHandler:^{
        [user fetchStarredReposForPage:currentPage++];
    }];
}

@end
