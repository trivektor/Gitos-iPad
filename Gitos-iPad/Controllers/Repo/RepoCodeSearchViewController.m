//
//  RepoCodeSearchViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 11/19/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoCodeSearchViewController.h"
#import "RepoContentSearchResult.h"

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
    NSLog(@"searching");
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [resultsTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }

    RepoContentSearchResult *result = [searchResults objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    cell.textLabel.text = [result getName];

    return cell;
}

- (void)displaySearchResults:(NSNotification *)notification
{
    searchResults = notification.object;
    [resultsTable reloadData];
}

@end
