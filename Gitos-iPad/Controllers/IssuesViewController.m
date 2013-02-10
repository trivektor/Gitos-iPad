//
//  IssuesViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "IssuesViewController.h"
#import "Issue.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SSKeychain.h"
#import "IssueCell.h"

@interface IssuesViewController ()

@end

@implementation IssuesViewController

@synthesize issuesTable, repo, hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.issues = [[NSMutableArray alloc] initWithCapacity:0];
        self.currentPage = 1;
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self fetchIssues:self.currentPage++];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Issues";
    [self registerNib];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = @"Loading";
}

- (void)registerNib
{
    UINib *nib = [UINib nibWithNibName:@"IssueCell" bundle:nil];
    [issuesTable registerNib:nib forCellReuseIdentifier:@"IssueCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.issues count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"IssueCell";
    IssueCell *cell = [issuesTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[IssueCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    cell.issue = [self.issues objectAtIndex:indexPath.row];
    [cell render];

    return cell;
}

- (void)fetchIssues:(NSInteger)page
{
    NSURL *issuesUrl = [NSURL URLWithString:[self.repo getIssuesUrl]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:issuesUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   nil];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:issuesUrl.absoluteString parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         for (int i=0; i < json.count; i++) {
             [self.issues addObject:[[Issue alloc] initWithData:[json objectAtIndex:i]]];
         }
         [issuesTable reloadData];
         [self.hud hide:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [self.hud hide:YES];
     }];
    
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
