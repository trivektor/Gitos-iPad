//
//  IssuesViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "IssuesViewController.h"
#import "IssueDetailsViewController.h"
#import "Issue.h"
#import "IssueCell.h"

@interface IssuesViewController ()

@end

@implementation IssuesViewController

@synthesize issuesTable, repo, hud, issues, currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        issues = [[NSMutableArray alloc] initWithCapacity:0];
        currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self registerNib];
    [self registerEvents];
    [repo fetchIssuesForPage:currentPage++];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Issues";
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"Loading";
}

- (void)registerNib
{
    UINib *nib = [UINib nibWithNibName:@"IssueCell" bundle:nil];
    [issuesTable registerNib:nib forCellReuseIdentifier:@"IssueCell"];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayIssues:)
                                                 name:@"IssuesFetched"
                                               object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [issues count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"IssueCell";
    IssueCell *cell = [issuesTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[IssueCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    cell.issue = [issues objectAtIndex:indexPath.row];
    [cell render];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IssueDetailsViewController *issueDetailsController = [[IssueDetailsViewController alloc] init];
    issueDetailsController.issue = [issues objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:issueDetailsController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) == scrollView.contentSize.height) {
        [hud show:YES];
        [repo fetchIssuesForPage:currentPage++];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayIssues:(NSNotification *)notification
{
    issues = notification.object;
    [issuesTable reloadData];
    [hud hide:YES];
}

@end
