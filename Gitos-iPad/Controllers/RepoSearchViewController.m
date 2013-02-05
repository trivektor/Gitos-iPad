//
//  RepoSearchViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoSearchViewController.h"
#import "SSKeychain.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "AppConfig.h"
#import "Repo.h"
#import "RepoSearchResultCell.h"
#import "RepoViewController.h"

@interface RepoSearchViewController ()

@end

@implementation RepoSearchViewController

@synthesize accessToken, user, searchResults, spinnerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.searchResults = [[NSMutableArray alloc] initWithCapacity:0];
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self prepareTableView];
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

- (void)performHouseKeepingTasks
{
    [self.navigationItem setTitle:@"Search"];
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    [self.spinnerView setHidden:YES];
    [searchResultsTable setContentInset:UIEdgeInsetsMake(0, 0, 48, 0)];
    [searchResultsTable setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 48, 0)];
    CGRect frame = [searchResultsTable frame];
    frame.size.height = frame.size.height - self.tabBarController.tabBar.frame.size.height - searchBar.frame.size.height - self.navigationController.navigationBar.frame.size.height + 4;
    [searchResultsTable setFrame:frame];
    [searchBar setTintColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]];
    
    for (UIView *v in searchBar.subviews) {
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

- (void)prepareTableView
{
    UINib *nib = [UINib nibWithNibName:@"RepoSearchResultCell" bundle:nil];
    
    [searchResultsTable registerNib:nib forCellReuseIdentifier:@"RepoSearchResultCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RepoSearchResultCell";
    RepoSearchResultCell *cell = [searchResultsTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[RepoSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.repo = [self.searchResults objectAtIndex:indexPath.row];
    //cell.repoDetails = [self.searchResults objectAtIndex:indexPath.row];
    [cell render];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepoViewController *repoController = [[RepoViewController alloc] init];
    repoController.repo = [self.searchResults objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:repoController animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    [self.spinnerView setHidden:NO];
    [searchBar resignFirstResponder];
    NSString *term = [_searchBar text];
    
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
             [self.searchResults addObject:r];
         }
         
         [searchResultsTable reloadData];
         [searchBar resignFirstResponder];
         [self.spinnerView setHidden:YES];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"%@", error);
                                         [self.spinnerView setHidden:YES];
                                     }];
    
    [operation start];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)_searchBar
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

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)_searchBar
{
    searchBar.showsCancelButton = NO;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
    [searchBar resignFirstResponder];
}

@end
