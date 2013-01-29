//
//  StarredViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "StarredViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SSKeychain.h"
#import "RepoCell.h"
#import "SpinnerView.h"
#import "SVPullToRefresh.h"
#import "Repo.h"
#import "RepoViewController.h"
#import "AppConfig.h"

@interface StarredViewController ()

@end

@implementation StarredViewController

@synthesize accessToken, user, starredRepos, currentPage, spinnerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentPage = 1;
        self.starredRepos = [[NSMutableArray alloc] initWithCapacity:0];
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"Starred Repositories"];
    
    UINib *nib = [UINib nibWithNibName:@"RepoCell" bundle:nil];
    [starredReposTable registerNib:nib forCellReuseIdentifier:@"RepoCell"];
    [starredReposTable setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [starredReposTable setBackgroundView:nil];
    [starredReposTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [starredReposTable setSeparatorColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:0.8]];
    [self.view setBackgroundColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0]];
    
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    
    [self setupPullToRefresh];
    [self getUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInfo
{
    NSURL *userUrl = [NSURL URLWithString:[[AppConfig getConfigValue:@"GithubApiHost"] stringByAppendingString:@"/user"]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:userUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   @"bearer", @"token_type",
                                   nil];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:userUrl.absoluteString parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         self.user = [[User alloc] initWithOptions:json];
         [self getStarredReposForPage:self.currentPage++];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"error 1");
                                     }];
    
    [operation start];
}

- (void)getStarredReposForPage:(NSInteger)page
{
    NSURL *starredReposUrl = [NSURL URLWithString:self.user.starredUrl];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:starredReposUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithFormat:@"%i", page], @"page",
                                   self.accessToken, @"access_token",
                                   @"bearer", @"token_type",
                                   nil];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:starredReposUrl.absoluteString parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         Repo *r;
         
         for (int i=0; i < json.count; i++) {
             r = [[Repo alloc] initWithData:[json objectAtIndex:i]];
             [self.starredRepos addObject:r];
         }
         
         [starredReposTable.pullToRefreshView stopAnimating];
         [starredReposTable reloadData];
         
         [self.spinnerView setHidden:YES];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"%@", error.localizedDescription);
                                         [self.spinnerView setHidden:YES];
                                     }];
    
    [operation start];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.starredRepos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RepoCell";
    
    RepoCell *cell = [starredReposTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[RepoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.repo = [self.starredRepos objectAtIndex:indexPath.row];
    [cell render];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepoViewController *repoController = [[RepoViewController alloc] init];
    repoController.repo = [self.starredRepos objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:repoController animated:YES];
}

// https://github.com/stephenjames/ContinuousTableview/blob/master/Classes/RootViewController.m
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) == scrollView.contentSize.height) {
        [self.spinnerView setHidden:NO];
        [self getStarredReposForPage:self.currentPage++];
    }
}

- (void)setupPullToRefresh
{
    self.currentPage = 1;
    [starredReposTable addPullToRefreshWithActionHandler:^{
        [self getStarredReposForPage:self.currentPage++];
    }];
}

@end
