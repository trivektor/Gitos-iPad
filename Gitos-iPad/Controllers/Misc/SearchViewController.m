//
//  SearchViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/16/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "SearchViewController.h"
#import "RepoSearchResultCell.h"
#import "UserSearchResultCell.h"
#import "RepoViewController.h"
#import "ProfileViewController.h"
#import "User.h"
#import "Repo.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize hud, user, results, searchCriteria, searchBar, resultsTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        results = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    //[self prepareSearchBar];
    //http://stackoverflow.com/questions/17074365/status-bar-and-navigation-bar-appear-over-my-views-bounds-in-ios-7
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}

- (void)performHouseKeepingTasks
{
    [super performHousekeepingTasks];

    self.navigationItem.title = @"Search";
    NSArray *criteria = [[NSArray alloc] initWithObjects:@"Repo", @"User", nil];

    searchCriteria = [[UISegmentedControl alloc] initWithItems:criteria];
    searchCriteria.momentary = NO;
    searchCriteria.selectedSegmentIndex = 0;
    [searchCriteria addTarget:self
                       action:nil
             forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *criteriaButton = [[UIBarButtonItem alloc] initWithCustomView:searchCriteria];
    self.navigationItem.rightBarButtonItem = criteriaButton;
}

- (BOOL)isUserSearch
{
    return searchCriteria.selectedSegmentIndex == 1;
}

- (BOOL)isRepoSearch
{
    return searchCriteria.selectedSegmentIndex == 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return results.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [resultsTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.font       = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:13.0];
    [cell defineAccessoryType];
    [cell defineHighlightedColorsForLabels:@[]];

    NSObject *object = [results objectAtIndex:indexPath.row];

    if ([object isKindOfClass:[Repo class]]) {
        Repo *repo = (Repo *) object;
        cell.textLabel.text = [repo getName];
        cell.detailTextLabel.text = [repo getDescription];
    } else if ([object isKindOfClass:[User class]]) {
        User *_user = (User *) object;
        if ([_user getName] != (id)[NSNull null]) {
            cell.textLabel.text = [_user getName];
        }
        cell.detailTextLabel.text = [_user getLogin];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRepoSearch) {
        [self fetchRepoAtIndexPath:indexPath];
    } else {
        [self fetchUserAtIndexPath:indexPath];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    [_searchBar resignFirstResponder];
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];

    NSString *term = [searchBar text];

    if ([self isRepoSearch]) {
        [self searchRepos:term];
    } else if ([self isUserSearch]) {
        [self searchUsers:term];
    }
}

- (void)searchUsers:(NSString *)term
{
    NSURL *searchUrl = [NSURL URLWithString:[AppConfig getConfigValue:@"GithubApiHost"]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:searchUrl];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                       path:[NSString stringWithFormat:@"legacy/user/search/%@", term]
                 parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSArray *users = [json valueForKey:@"users"];

         [results removeAllObjects];

         for (int i=0; i < users.count; i++) {
             [results addObject:[[User alloc] initWithData:[users objectAtIndex:i]]];
         }

         [searchBar resignFirstResponder];
         [resultsTable reloadData];
         [resultsTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
     }];
    
    [operation start];
}

- (void)searchRepos:(NSString *)term
{
    NSURL *searchUrl = [NSURL URLWithString:[AppConfig getConfigValue:@"GithubApiHost"]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:searchUrl];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
               path:[NSString stringWithFormat:@"legacy/repos/search/%@", term]
         parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSArray *repos = [json valueForKey:@"repositories"];

         [results removeAllObjects];

         for (int i=0; i < repos.count; i++) {
             [results addObject:[[Repo alloc] initWithData:[repos objectAtIndex:i]]];
         }

         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
         [resultsTable reloadData];
         [resultsTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
         [searchBar resignFirstResponder];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
     }];

    [operation start];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)_searchBar
{
    _searchBar.showsCancelButton = YES;
    for (UIView *v in searchBar.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton *)v;
            [cancelButton setTintColor:[UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1]];
            break;
        }
    }
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)_searchBar
{
    _searchBar.showsCancelButton = NO;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
    [_searchBar resignFirstResponder];
}

- (void)fetchRepoAtIndexPath:(NSIndexPath *)indexPath
{
    Repo *repo = [self.results objectAtIndex:indexPath.row];

    NSURL *searchUrl = [NSURL URLWithString:[AppConfig getConfigValue:@"GithubApiHost"]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:searchUrl];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                           path:[NSString stringWithFormat:@"repos/%@/%@", [repo getOwner], [repo getName]]
                     parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         RepoViewController *repoController = [[RepoViewController alloc] init];
         repoController.repo = [[Repo alloc] initWithData:json];
         [self.navigationController pushViewController:repoController animated:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
     }];

    [operation start];
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
}

- (void)fetchUserAtIndexPath:(NSIndexPath *)indexPath
{
    User *_user = [self.results objectAtIndex:indexPath.row];

    NSURL *searchUrl = [NSURL URLWithString:[AppConfig getConfigValue:@"GithubApiHost"]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:searchUrl];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                       path:[NSString stringWithFormat:@"/users/%@", [_user getLogin]]
                 parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         ProfileViewController *profileController = [[ProfileViewController alloc] init];
         profileController.user = [[User alloc] initWithData:json];
         [self.navigationController pushViewController:profileController animated:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
     }];

    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
