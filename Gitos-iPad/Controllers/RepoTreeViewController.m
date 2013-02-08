//
//  RepoTreeViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoTreeViewController.h"
#import "RawFileViewController.h"
#import "RepoTreeCell.h"
#import "AppConfig.h"
#import "SSKeychain.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "RepoTreeNode.h"
#import "RepoTreeCell.h"

@interface RepoTreeViewController ()

@end

@implementation RepoTreeViewController

@synthesize accessToken, accessTokenParams, treeTable, branchUrl, branch, repo, node;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.treeNodes = [[NSMutableArray alloc] initWithCapacity:0];
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
        self.accessTokenParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  self.accessToken, @"access_token",
                                  @"bearer", @"token_type",
                                  nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self fetchData];
}

- (void)performHouseKeepingTasks
{
    if (self.node == (id)[NSNull null]) {
        self.navigationItem.title = [self.branch name];
    } else if ([self.node isTree]) {
        self.navigationItem.title = self.node.path;
    }
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
}

- (void)fetchData
{
    if (self.node == (id)[NSNull null]) {
        [self fetchTopLayer];
    } else if ([self.node isTree]) {
        [self fetchTree];
    }
}

- (void)fetchTopLayer
{
    NSString *treeUrl = [[self.repo getTreeUrl] stringByAppendingString:self.branch.name];
    
    NSURL *repoTreeUrl = [NSURL URLWithString:treeUrl];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:repoTreeUrl];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:repoTreeUrl.absoluteString parameters:self.accessTokenParams];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         NSArray *treeNodes = [json valueForKey:@"tree"];
         
         RepoTreeNode *treeNode;
         
         for (int i=0; i < treeNodes.count; i++) {
             treeNode = [[RepoTreeNode alloc] initWithData:[treeNodes objectAtIndex:i]];
             [self.treeNodes addObject:treeNode];
         }
         [treeTable reloadData];
         [self.spinnerView setHidden:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [self.spinnerView setHidden:YES];
     }];
    
    [operation start];
}

- (void)fetchTree
{
    NSURL *treeNodeUrl = [NSURL URLWithString:self.node.url];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:treeNodeUrl];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:treeNodeUrl.absoluteString parameters:self.accessTokenParams];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         NSArray *treeNodes = [json valueForKey:@"tree"];
         
         RepoTreeNode *treeNode;
         
         for (int i=0; i < treeNodes.count; i++) {
             treeNode = [[RepoTreeNode alloc] initWithData:[treeNodes objectAtIndex:i]];
             [self.treeNodes addObject:treeNode];
         }
         [treeTable reloadData];
         [self.spinnerView setHidden:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [self.spinnerView setHidden:YES];
     }];
    
    [operation start];
}

- (void)fetchBlob
{
    RawFileViewController *rawFileController = [[RawFileViewController alloc] init];
    rawFileController.repo = self.repo;
    rawFileController.branch = self.branch;
    rawFileController.fileName = self.node.path;
    [self.navigationController pushViewController:rawFileController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.treeNodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    RepoTreeCell *cell = [treeTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[RepoTreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setNode:[self.treeNodes objectAtIndex:indexPath.row]];
    [cell render];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepoTreeNode *selectedNode = [self.treeNodes objectAtIndex:indexPath.row];
    
    if ([selectedNode isBlob]) {
        RawFileViewController *rawFileController = [[RawFileViewController alloc] init];
        rawFileController.repo = self.repo;
        rawFileController.branch = self.branch;
        rawFileController.fileName = [selectedNode path];
        [self.navigationController pushViewController:rawFileController animated:YES];
    } else if ([selectedNode isTree]) {
        RepoTreeViewController *repoTreeController = [[RepoTreeViewController alloc] init];
        repoTreeController.branch = self.branch;
        repoTreeController.repo = self.repo;
        repoTreeController.node = selectedNode;
        [self.navigationController pushViewController:repoTreeController animated:YES];
    }
}

@end
