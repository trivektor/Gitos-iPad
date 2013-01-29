//
//  RepoViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoViewController.h"
#import "RepoDetailsCell.h"
#import "AppConfig.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SSKeychain.h"
#import "RepoTreeViewController.h"
#import "Branch.h"

@interface RepoViewController ()

@end

@implementation RepoViewController

@synthesize repo, spinnerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.repoBranches = [[NSMutableArray alloc] initWithCapacity:0];
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:[self.repo getName]];
    [self performHouseKeepingTasks];
    [self adjustFrameHeight];
    [self getRepoBranches];
}

- (void)adjustFrameHeight
{
    [repoScrollView setContentSize:self.view.frame.size];
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in repoScrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [repoScrollView setContentSize:(CGSizeMake(320, scrollViewHeight + 35))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    UINib *repoDetailsCellNib = [UINib nibWithNibName:@"RepoDetailsCell" bundle:nil];
    [detailsTable registerNib:repoDetailsCellNib forCellReuseIdentifier:@"RepoDetailsCell"];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0]];
    
    NSArray *tables = [[NSArray alloc] initWithObjects:detailsTable, branchesTable, nil];
    
    UITableView *table;
    
    for (int i=0; i < [tables count]; i++) {
        table = [tables objectAtIndex:i];
        [table setDelegate:self];
        [table setDataSource:self];
        [table setScrollEnabled:NO];
        [table setBackgroundView:nil];
        [table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [table setSeparatorColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:0.8]];
    }
    
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    self.spinnerView.hidden = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == detailsTable) {
        return 4;
    } else if (tableView == branchesTable) {
        return [self.repoBranches count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == detailsTable) {
        return [self cellForDetailsTableAtIndexPath:indexPath];
    } else {
        return [self cellForBranchesTableAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)cellForDetailsTableAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RepoDetailsCell";
    RepoDetailsCell *cell = [detailsTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[RepoDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setRepo:self.repo];
    [cell renderForIndexPath:indexPath];
    
    return cell;
}

- (UITableViewCell *)cellForBranchesTableAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [detailsTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Branch *branch = [self.repoBranches objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    cell.textLabel.text = [branch name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == branchesTable) {
        RepoTreeViewController *repoTreeController = [[RepoTreeViewController alloc] init];
        repoTreeController.branch = [self.repoBranches objectAtIndex:indexPath.row];
        repoTreeController.repo = self.repo;
        repoTreeController.node = (id)[NSNull null];
        
        [self.navigationController pushViewController:repoTreeController animated:YES];
    }
}

- (void)getRepoBranches
{
    NSURL *branchesUrl = [NSURL URLWithString:[self.repo getBranchesUrl]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:branchesUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   @"bearer", @"token_type",
                                   nil];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:branchesUrl.absoluteString parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         Branch *branch;
         
         for (int i=0; i < json.count; i++) {
             branch = [[Branch alloc] initWithData:[json objectAtIndex:i]];
             [self.repoBranches addObject:branch];
         }
         
         [branchesTable setFrame:CGRectMake(0, 228, 320, self.repoBranches.count * 44 + 10)];
         [branchesTable reloadData];
         [self.spinnerView setHidden:YES];
         [self adjustFrameHeight];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"%@", error);
                                         [self.spinnerView setHidden:YES];
                                     }];    
    [operation start];
}

@end
