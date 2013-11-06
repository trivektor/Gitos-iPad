//
//  CommitsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "CommitsViewController.h"
#import "CommitViewController.h"
#import "CommitCell.h"

@interface CommitsViewController ()

@end

@implementation CommitsViewController

@synthesize branch, hud, commitsTable, commits;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        commits = [[NSMutableArray alloc] initWithCapacity:0];
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
    [self fetchCommits];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Commits";
}

- (void)registerNib
{
    UINib *nib = [UINib nibWithNibName:@"CommitCell" bundle:nil];
    [commitsTable registerNib:nib forCellReuseIdentifier:@"CommitCell"];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayCommits:) name:@"CommitsFetched" object:nil];
}

- (void)displayCommits:(NSNotification *)notification
{
    [commits addObjectsFromArray:notification.object];
    [commitsTable reloadData];
    [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commits count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CommitCell";

    CommitCell *cell = [commitsTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[CommitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.commit = [commits objectAtIndex:indexPath.row];
    [cell render];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommitViewController *commitController = [[CommitViewController alloc] init];
    commitController.commit = [commits objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:commitController animated:YES];
}

- (void)fetchCommits
{
    [branch fetchCommits];
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) == scrollView.contentSize.height) {
        [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];
        [self fetchCommits];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
