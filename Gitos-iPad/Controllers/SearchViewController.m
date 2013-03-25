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

@synthesize hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.results = [[NSMutableArray alloc] initWithCapacity:0];
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self prepareSearchBar];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = LOADING_MESSAGE;
    [hud hide:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Search";
    NSArray *criteria = [[NSArray alloc] initWithObjects:@"Repo", @"User", nil];
    self.searchCriteria = [[UISegmentedControl alloc] initWithItems:criteria];
    self.searchCriteria.segmentedControlStyle = UISegmentedControlStyleBar;
    self.searchCriteria.momentary = NO;
    self.searchCriteria.selectedSegmentIndex = 0;
    [self.searchCriteria addTarget:self action:nil forControlEvents:UIControlEventValueChanged];

    UIBarButtonItem *criteriaButton = [[UIBarButtonItem alloc] initWithCustomView:self.searchCriteria];
    self.navigationItem.rightBarButtonItem = criteriaButton;
}

- (void)prepareSearchBar
{
    [self.searchBar setTintColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]];

    for (UIView *v in self.searchBar.subviews) {
        if ([v isKindOfClass:[UITextField class]]) {
            UITextField *searchField = (UITextField *)v;
            [searchField setBorderStyle:UITextBorderStyleNone];
            [searchField.layer setBorderWidth:1.0f];
            [searchField.layer setBorderColor:[[UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1] CGColor]];
            [searchField.layer setCornerRadius:3.0f];
            [searchField.layer setShadowOpacity:0.0f];
            [searchField.layer setMasksToBounds:YES];
            [searchField setBackgroundColor:[UIColor whiteColor]];
            [searchField setBackground:nil];
            break;
        }
    }
}

- (BOOL)isUserSearch
{
    return self.searchCriteria.selectedSegmentIndex == 1;
}

- (BOOL)isRepoSearch
{
    return self.searchCriteria.selectedSegmentIndex == 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [self.resultsTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.font       = [UIFont fontWithName:@"Arial-BoldMT" size:14.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
    cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;

    NSObject *object = [self.results objectAtIndex:indexPath.row];

    if ([object isKindOfClass:[Repo class]]) {
        Repo *repo = (Repo *) object;
        cell.textLabel.text = [repo getName];
        cell.detailTextLabel.text = [repo getDescription];
    } else if ([object isKindOfClass:[User class]]) {
        User *user = (User *) object;
        if ([user getName] != (id)[NSNull null]) {
            cell.textLabel.text = [user getName];
        }
        cell.detailTextLabel.text = [user getLogin];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [hud show:YES];

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

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   @"bearer", @"token_type",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                       path:[NSString stringWithFormat:@"legacy/user/search/%@", term]
                 parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSArray *users = [json valueForKey:@"users"];

         [self.results removeAllObjects];

         for (int i=0; i < users.count; i++) {
             [self.results addObject:[[User alloc] initWithData:[users objectAtIndex:i]]];
         }

         [self.searchBar resignFirstResponder];
         [self.resultsTable reloadData];
         [self.resultsTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
         [hud hide:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [hud hide:YES];
     }];
    
    [operation start];

}

- (void)searchRepos:(NSString *)term
{
    NSURL *searchUrl = [NSURL URLWithString:[AppConfig getConfigValue:@"GithubApiHost"]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:searchUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   @"bearer", @"token_type",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
               path:[NSString stringWithFormat:@"legacy/repos/search/%@", term]
         parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSArray *repos = [json valueForKey:@"repositories"];

         [self.results removeAllObjects];

         for (int i=0; i < repos.count; i++) {
             [self.results addObject:[[Repo alloc] initWithData:[repos objectAtIndex:i]]];
         }

         [self.resultsTable reloadData];
         [self.resultsTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
         [self.searchBar resignFirstResponder];
         [hud hide:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [hud hide:YES];
     }];

    [operation start];
    [hud show:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    for (UIView *v in searchBar.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton *)v;
            [cancelButton setTintColor:[UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1]];
            break;
        }
    }
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)fetchRepoAtIndexPath:(NSIndexPath *)indexPath
{
    Repo *repo = [self.results objectAtIndex:indexPath.row];

    NSURL *searchUrl = [NSURL URLWithString:[AppConfig getConfigValue:@"GithubApiHost"]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:searchUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   nil];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                           path:[NSString stringWithFormat:@"repos/%@/%@", [repo getOwner], [repo getName]]
                     parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         [hud hide:YES];
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         RepoViewController *repoController = [[RepoViewController alloc] init];
         repoController.repo = [[Repo alloc] initWithData:json];
         [self.navigationController pushViewController:repoController animated:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [hud hide:YES];
     }];

    [operation start];
    [hud show:YES];
}

- (void)fetchUserAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = [self.results objectAtIndex:indexPath.row];

    NSURL *searchUrl = [NSURL URLWithString:[AppConfig getConfigValue:@"GithubApiHost"]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:searchUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                       path:[NSString stringWithFormat:@"/users/%@", [user getLogin]]
                 parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         [hud hide:YES];
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         ProfileViewController *profileController = [[ProfileViewController alloc] init];
         profileController.user = [[User alloc] initWithData:json];
         [self.navigationController pushViewController:profileController animated:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [hud hide:YES];
     }];

    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
