//
//  RepoCodeSearchViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 11/19/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoCodeSearchViewController.h"
#import "RepoContentSearchResult.h"
#import "RepoContentSearchResultCell.h"

@interface RepoCodeSearchViewController ()

@end

@implementation RepoCodeSearchViewController

@synthesize repo, searchBar, resultsTable, searchResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        searchResults = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = [NSString stringWithFormat:@"Search within %@", [repo getName]];
    [resultsTable setTableHeaderView:searchBar];
    UINib *nib = [UINib nibWithNibName:@"RepoContentSearchResultCell" bundle:nil];
    [resultsTable registerNib:nib forCellReuseIdentifier:@"RepoContentSearchResultCell"];
    [self registerEvents];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displaySearchResults:)
                                                 name:@"RepoCodeSearchCompleted"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    NSString *term = [searchBar text];
    if (term.length == 0) return;
    [searchBar resignFirstResponder];
    [repo searchFor:term];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepoContentSearchResultCell *cell = [resultsTable dequeueReusableCellWithIdentifier:@"RepoContentSearchResultCell"];

    if (!cell) {
        cell = [[RepoContentSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"RepoContentSearchResultCell"];
    }

    cell.result = [searchResults objectAtIndex:indexPath.row];
    [cell render];

    return cell;
}

- (void)displaySearchResults:(NSNotification *)notification
{
    searchResults = notification.object;
    [resultsTable reloadData];
}

@end
