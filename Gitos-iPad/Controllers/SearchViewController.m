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
#import "User.h"
#import "Repo.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

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
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Search";
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
    return self.searchCriteria.selectedSegmentIndex == 0;
}

- (BOOL)isRepoSearch
{
    return self.searchCriteria.selectedSegmentIndex == 1;
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
    NSLog(@"constructing cells");
    if ([self isRepoSearch]) {
        RepoSearchResultCell *cell = [self.resultsTable dequeueReusableCellWithIdentifier:@"RepoSearchResultCell"];

        if (!cell) {
            cell = [[RepoSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RepoSearchResultCell"];
        }

        return cell;
    } else {
        UserSearchResultCell *cell = [self.resultsTable dequeueReusableCellWithIdentifier:@"UserSearchResultCell"];

        if (!cell) {
            cell = [[UserSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserSearchResultCell"];
        }

        return cell;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];

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

         User *u;

         for (int i=0; i < users.count; i++) {
             u = [[User alloc] initWithData:[users objectAtIndex:i]];
             [self.results addObject:u];
         }

         [self.resultsTable reloadData];
         [self.searchBar resignFirstResponder];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
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

         Repo *r;

         for (int i=0; i < repos.count; i++) {
             r = [[Repo alloc] initWithData:[repos objectAtIndex:i]];
             [self.results addObject:r];
         }

         [self.resultsTable reloadData];
         [self.searchBar resignFirstResponder];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
