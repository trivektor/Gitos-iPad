//
//  ReposViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "ReposViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SSKeychain.h"
#import "RepoCell.h"
#import "Repo.h"
#import "RepoViewController.h"

@interface ReposViewController ()

@end

@implementation ReposViewController

@synthesize user, reposTable, repos, hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.repos = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Repositories";
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = @"Loading";
    [self registerNib];
    [self getUserInfoAndRepos];
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
    [reposTable registerNib:nib forCellReuseIdentifier:@"RepoCell"];
    [reposTable setDelegate:self];
    [reposTable setDataSource:self];
    [reposTable setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [reposTable setBackgroundView:nil];
    [reposTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [reposTable setSeparatorColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:0.8]];
    [self.view setBackgroundColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0]];
}

- (void)getUserInfoAndRepos
{
    // Revisit the code below. It's awkward that this has to be done in every controller
    // In the future when I'm getting better with iOS/Objective-C, I should figure out how to share
    // the user's information application wide
    NSString *accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
    
    NSURL *userUrl = [NSURL URLWithString:@"https://api.github.com/user"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:userUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   accessToken, @"access_token",
                                   @"bearer", @"token_type",
                                   nil];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:userUrl.absoluteString parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         self.user = [[User alloc] initWithData:json];
         [self getUserRepos];
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [operation start];
}

- (void)getUserRepos
{
    NSURL *reposURL = [NSURL URLWithString:[self.user getReposUrl]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:reposURL];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:reposURL.absoluteString parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [operation responseString];
        
        NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        for (int i=0; i < [json count]; i++) {
            [self.repos addObject:[[Repo alloc] initWithData:[json objectAtIndex:i]]];
        }
        
        [reposTable reloadData];
        [self.hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.hud hide:YES];
        NSLog(@"%@", error);
    }];
    
    [operation start];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RepoCell";
    
    RepoCell *cell = [self.reposTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[RepoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.repo = [self.repos objectAtIndex:indexPath.row];
    [cell render];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepoViewController *repoController = [[RepoViewController alloc] init];
    repoController.repo = [self.repos objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:repoController animated:YES];
}

@end